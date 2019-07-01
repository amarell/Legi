import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:legi/src/API/api.dart';
import 'package:legi/src/model/info_dompet_model.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:flutter/gestures.dart';
import 'package:toast/toast.dart';

class Zakat extends StatefulWidget {
  @override
  _ZakatState createState() => _ZakatState();
}

class _ZakatState extends State<Zakat> {
   final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var datadompet = new List<InfoDompetModel>();
  String _idUser = '';
  String _idDompet = '';
  String _emailUser = '';
  var _saldoDOmpet = '';

  void initState() {
    super.initState();
    _getData();
    print(_idUser);
    print(_idDompet);
  }

  String _radioValue = "";

  TextEditingController jumlah_donasi = new TextEditingController();
  final _formkey= GlobalKey<FormState>();


  void _radioAction(String value) {
    setState(() {
      _radioValue = value;
    });
  }

  _getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _idUser = (prefs.getString('id') ?? '');
      _idDompet = (prefs.getString('id_dompet') ?? '');
      _emailUser = (prefs.getString('email') ?? '');
    });
    _getDataDompet();
  }

  _getDataDompet() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //_getData();
    print('haha $_idUser');
    API.getDataDompet(_idUser).then((responses) {
      setState(() {
        print('gsgsg $_idUser');
        final list = convert.jsonDecode(responses.body);
        print(list);
        datadompet = (list['data'] as List).map<InfoDompetModel>((
            json) => new InfoDompetModel.fromJson(json)).toList();

        prefs.setString('jumlah_dompet', datadompet[0].saldoDompet);
        _saldoDOmpet = datadompet[0].saldoDompet;
      });
    });
  }

  void showInSnackBar(String value) {
    FocusScope.of(context).requestFocus(new FocusNode());
    _scaffoldKey.currentState?.removeCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(
        value,
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
            fontFamily: "WorkSansSemiBold"),
      ),
      backgroundColor: Colors.blue,
      duration: Duration(seconds: 3),
    ));
  }

  _sendEmail(String email) async {
    String username = 'buburwakhid@gmail.com';
    String password = 'tandonbanyu';
    final smtpServer = gmail(username, password);

    //pesan di email.
    final message = new Message()
      ..from = new Address(username, 'Your name')
      ..recipients.add(email)
      ..subject = 'Terimakasih :: 😀 :: ${new DateTime.now()}'
      ..html = "<h1>Test</h1>\n<p>Terimakasih, anda sudah melakukan donasi zakat:)</p>";

    final sendReports = await send(message, smtpServer);

    sendReports.forEach((sr) {
      if (sr.sent)
        print('message sent');
      else {
        print('Message not sent.');
        for (var p in sr.validationProblems) {
          print('Problem: ${p.code}: ${p.msg}');
        }
      }
    });
  }

  _showProgress(BuildContext context, status){
    ProgressDialog pr = new ProgressDialog(context, ProgressDialogType.Normal);
    
    if(status=='show'){
      pr.setMessage('Please wait...');
    return pr.show();
    }else if(status=='hide'){
    return pr.hide();
    }
    
  }

  Future<dynamic> _donasi() async {
    if (_radioValue == '0') {
      if (int.parse(jumlah_donasi.text) >= int.parse(_saldoDOmpet.toString())) {
        showInSnackBar('saldo dompet anda tidak memenuhi');
      } else {
        _showProgress(context, 'show');
        final response = await http.post(
            'https://letsgiving.com/API/donasi_zakat_dompet.php', body: {
          "id_user": _idUser,
          "jumlah_dana": jumlah_donasi.text,
          "metode_pembayaran": 'dompet',
          "status_donasi": 'verifikasi',
          "id_dompet": _idDompet,
          "guna_pembayaran": 'donasi',

        });
        CircularProgressIndicator();
        Map<String, dynamic> jsonResponse = convert.jsonDecode(response.body);
        //var jsonResponse= convert.jsonDecode(response.body);
        if (response.statusCode == 200) {
          var success = jsonResponse['success'];
          if (success == '1') {
            print('berhasil donasi');
            
            _sendEmail(_emailUser);
            Navigator.of(context).pop();
            showInSnackBar('Berhasil Donasi');
            Navigator.of(context).pushReplacementNamed('/history');
          } else if (success == '0') {
            showInSnackBar('Donasi Gagal');
            Navigator.of(context).pop();
            print(jsonResponse);
          }
        }

        return jsonResponse;
      }
    } else {
       _showProgress(context, 'show');
      final response = await http.post(
          'https://letsgiving.com/API/donasi_zakat.php', body: {
        "id_user": _idUser,
        "jumlah_dana": jumlah_donasi.text,
        "metode_pembayaran": 'transfer',
        "id_bank": _radioValue,
      });
      
      CircularProgressIndicator();
      Map<String, dynamic> jsonResponse = convert.jsonDecode(response.body);
      //var jsonResponse= convert.jsonDecode(response.body);
      if (response.statusCode == 200) {
        var success = jsonResponse['success'];
        if (success == '1') {
          print('berhasil donasi');
          _sendEmail(_emailUser);
          Navigator.of(context).pop();
            showInSnackBar('Berhasil Donasi');
            Navigator.of(context).pushReplacementNamed('/history');
            Toast.show("Berhasil Donasi", context, duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
        } else if (success == '0') {
          showInSnackBar('Donasi Gagal');
          print(jsonResponse);
        }
      }

      return jsonResponse;
    }
  }


  @override
  Widget build(BuildContext context) {
    
    final NumberFormat formatter = NumberFormat.simpleCurrency(
        locale: Localizations.localeOf(context).toString(), name: 'Rp. ');
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Zakat'),
        backgroundColor: const Color(0xFF0091EA),
      ),
      bottomNavigationBar: Container(
        color: Theme
            .of(context)
            .primaryColor,
        child: Row(
          children: <Widget>[
            Expanded(
              child: Builder(
                builder: (context) =>
                    FlatButton.icon(
                      onPressed: () {
                        // print('$_idUser');
                        // print('$_radioValue');
                        // _donasi();
                        if(_formkey.currentState.validate())
                          _donasi();
                      },
                      icon: Icon(Icons.launch),
                      label: Text("CheckOut"),
                      textColor: Colors.white,
                    ),
              ),
            )
          ],
        ),
      ),
      body: SafeArea(
        top: false,
        bottom: false,
        child: Form(
          key: _formkey,
          child: SingleChildScrollView(
            dragStartBehavior: DragStartBehavior.down,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 24.0,),
                Text(
                  "Masukan Jumlah Donasi", style: TextStyle(fontSize: 15.0),),
                const SizedBox(height: 12.0,),
                TextFormField(
                  controller: jumlah_donasi,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.attach_money),
                    border: OutlineInputBorder(),
                    labelText: 'Jumlah Donasi',
                    prefixText: '\Rp ',
                    helperText: 'Donasi Minimal Rp. 10.000',
                    suffixText: 'Rupiah',
                    suffixStyle: TextStyle(color: Colors.green),
                  ),
                  validator: (value){
                    if(value.isEmpty){
                      return 'Anda belum mengisi jumlah donasi';
                    }else if(int.parse(value) < 10000){
                      return 'Donasi Minimal Rp. 10.000';
                    }
                  },
                  maxLines: 1,
                ),
                const SizedBox(height: 24.0),
                Text(
                  "Pilih Metode Pembayaran", style: TextStyle(fontSize: 15.0),),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Radio(
                          value: "0",
                          groupValue: _radioValue,
                          onChanged: _radioAction,
                        ),
                        Text('Dompet'),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Radio(
                          value: "4",
                          groupValue: _radioValue,
                          onChanged: _radioAction,
                        ),
                        Text('Bank BNI'),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Radio(
                          value: "5",
                          groupValue: _radioValue,
                          onChanged: _radioAction,
                        ),
                        Text('Bank Mandiri'),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Radio(
                          value: "7",
                          groupValue: _radioValue,
                          onChanged: _radioAction,
                        ),
                        Text('BRI'),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Radio(
                          value: "9",
                          groupValue: _radioValue,
                          onChanged: _radioAction,
                        ),
                        Text('May Bank'),
                      ],
                    ),


                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  }
