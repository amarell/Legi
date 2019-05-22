import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:legi/src/API/api.dart';
import 'package:legi/src/model/info_dompet_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'dart:io';

import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class FormDonation extends StatefulWidget {
  FormDonation({Key key, this.idCampaign, this.dibuatOleh}) : super(key: key);
  final idCampaign;
  final dibuatOleh;
  @override
  _FormDonationState createState() =>
      _FormDonationState(
        idCampaign: this.idCampaign,
        dibuatOleh: this.dibuatOleh,
      );
}

class _FormDonationState extends State<FormDonation> {
  _FormDonationState({this.idCampaign,this.dibuatOleh});

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final idCampaign;
  final dibuatOleh;

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

  _sendEmail(String email) async {
    String username = 'buburwakhid@gmail.com';
    String password = 'tandonbanyu';
    final smtpServer = gmail(username, password);

    // Use the SmtpServer class to configure an SMTP server:
    // final smtpServer = new SmtpServer('smtp.domain.com');
    // See the named arguments of SmtpServer for further configuration
    // options.

    // Create our message.
    final message = new Message()
      ..from = new Address(username, 'Your name')
      ..recipients.add(email)
      ..subject = 'Test Dart Mailer library :: 😀 :: ${new DateTime.now()}'
      ..html = "<h1>Test</h1>\n<p>Hey! Here's some HTML content</p>";

    // Use [catchExceptions]: true to prevent [send] from throwing.
    // Note that the default for [catchExceptions] will change from true to false
    // in the future!
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


  Future<dynamic> _donasi() async {
    if (jumlah_donasi.text.isEmpty) {
      showInSnackBar('jumlah donasi tidak boleh di kosongi');
    } else if (int.parse(jumlah_donasi.text) <= 10000) {
      showInSnackBar('donasi anda harus lebih dari Rp. 10,000');
    } else if (_radioValue == '0') {
      if (int.parse(jumlah_donasi.text) >= int.parse(_saldoDOmpet.toString())) {
        showInSnackBar('saldo dompet anda tidak memenuhi');
      } else {
        final response = await http.post(
            'http://192.168.43.64/legi/API/donasi_campaign_dompet.php', body: {
          "id_user": _idUser,
          "id_campaign": idCampaign,
          "jumlah_dana": jumlah_donasi.text,
          "metode_pembayaran": 'dompet',
          "status_donasi": 'verifikasi',
          "id_dompet": _idDompet,
          "guna_pembayaran": 'donasi',

        });

        Map<String, dynamic> jsonResponse = convert.jsonDecode(response.body);
        //var jsonResponse= convert.jsonDecode(response.body);
        if (response.statusCode == 200) {
          var success = jsonResponse['success'];
          if (success == '1') {
            print('berhasil donasi');
            _sendEmail(_emailUser);
            showInSnackBar('Berhasil Donasi');
          } else if (success == '0') {
            showInSnackBar('Donasi Gagal');
            print(jsonResponse);
          }
        }

        return jsonResponse;
      }
    } else {
      final response = await http.post(
          'http://192.168.43.64/legi/API/donasi_campaig.php', body: {
        "id_user": _idUser,
        "id_campaign": idCampaign,
        "jumlah_dana": jumlah_donasi.text,
        "metode_pembayaran": 'transfer',
        "id_bank": _radioValue,
      });

      Map<String, dynamic> jsonResponse = convert.jsonDecode(response.body);
      //var jsonResponse= convert.jsonDecode(response.body);
      if (response.statusCode == 200) {
        var success = jsonResponse['success'];
        if (success == '1') {
          print('berhasil donasi');
          _sendEmail(_emailUser);
          showInSnackBar('Berhasil Donasi');
        } else if (success == '0') {
          showInSnackBar('Donasi Gagal');
          print(jsonResponse);
        }
      }

      return jsonResponse;
    }
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

  @override
  Widget build(BuildContext context) {
    final NumberFormat formatter = NumberFormat.simpleCurrency(
        locale: Localizations.localeOf(context).toString(), name: 'Rp. ');
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Lets Giving'),
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
                        print('$_idUser');
                        print('$_radioValue');
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

