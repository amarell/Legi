import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:legi/src/API/api.dart';
import 'package:legi/src/model/info_dompet_model.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class FormWithdraw extends StatefulWidget {
  @override
  _FormWithdrawState createState() => _FormWithdrawState();
}

class _FormWithdrawState extends State<FormWithdraw> {

  String _idUser = '';
  String _idDompet = '';
  String _emailUser = '';

  bool _formWasEdited = false;

  var datadompet = new List<InfoDompetModel>();
  var _saldoDOmpet = '';

   TextEditingController namaBank = new TextEditingController();
    TextEditingController namaPemilik = new TextEditingController();
     TextEditingController noRek = new TextEditingController();
 TextEditingController jumlahPencairan = new TextEditingController();

 final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();


 String lastSelectedValue;

 String _validateNamaBank(String value) {
   _formWasEdited = true;
    if (value.isEmpty)
      return 'Name is required.';
    // final RegExp nameExp = RegExp(r'^[A-Za-z ]+$');
    // if (!nameExp.hasMatch(value))
    //   return 'Please enter only alphabetical characters.';
    return null;
  }

  void showDemoDialog({BuildContext context, Widget child}) {
    showCupertinoDialog<String>(
      context: context,
      builder: (BuildContext context) => child,
    ).then((String value) {
      if (value != null) {
        setState(() { lastSelectedValue = value; });
      }
    });
  }

  void initState() {
    super.initState();
    _getData();
    print(_idUser);
    print(_idDompet);
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

  Future<dynamic> _withdraw() async{
    if(int.parse(jumlahPencairan.text)<=10000){
      showInSnackBar('jumlah pencairan dana anda kurang dari 10.000');
    }else if(int.parse(jumlahPencairan.text) >= int.parse(_saldoDOmpet.toString())){
      showInSnackBar('jumlah pencairan dana anda lebih besar dari saldo dompet anda');
    }else{
      final response = await http.post(
            'http://192.168.43.64/legi/API/withdraw_dompet.php', body: {
          "id_dompet": _idDompet,
          "nama_bank_tujuan": namaBank.text,
          "nama_pemilik_rek": namaPemilik.text,
          "no_rek": noRek.text,
          "jumlah_pencairan": jumlahPencairan.text,
          "status": "proses",
        });

        Map<String, dynamic> jsonResponse = convert.jsonDecode(response.body);
        //var jsonResponse= convert.jsonDecode(response.body);
        if (response.statusCode == 200) {
          var success = jsonResponse['success'];
          if (success == '1') {
            print('berhasil donasi');
            showInSnackBar('Berhasil Withdraw');
          } else if (success == '0') {
            showInSnackBar('Gagal');
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
                        showDemoDialog(
                        context: context,
                        child: CupertinoAlertDialog(
                          title: const Text('Apakah anda yakin melakukan pencairan dana?'),
                          content: const Text('Proses pencairan dana mungkin membutuhkan waktu beberapa hari. Bukti transfer akan dikirimkan melalui email anda.'),
                          actions: <Widget>[
                            CupertinoDialogAction(
                              child: const Text('Batal'),
                              onPressed: () {
                                Navigator.pop(context, 'Batal');
                              },
                            ),
                            CupertinoDialogAction(
                              child: const Text('Setuju'),
                              onPressed: () {
                                _withdraw();
                                Navigator.pop(context, 'Setuju');
                              },
                            ),
                          ],
                        ),
                      );
                      },
                      icon: Icon(Icons.launch),
                      label: Text("Withdraw"),
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
                TextFormField(
                  controller: namaBank,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    filled: true,
                    hintText: 'Masukan Nama Bank Tujuan',
                    labelText: 'Nama Bank*',
                  ),
                  validator: _validateNamaBank,
                  
                ),
                const SizedBox(height: 24.0,),
                TextFormField(
                  controller: namaPemilik,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    filled: true,
                    hintText: 'Masukan Nama Pemilik Rekening',
                    labelText: 'Nama Pemilik*',
                  ),
                   validator: _validateNamaBank,
                ),
                const SizedBox(height: 24.0,),
                TextFormField(
                  controller: noRek,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    filled: true,
                    hintText: 'Masukan No Rekening',
                    labelText: 'No Rekening*',
                  ),
                   validator: _validateNamaBank,
                ),
                const SizedBox(height: 24.0,),
                Text(
                  "Masukan Jumlah Pencairan", style: TextStyle(fontSize: 15.0),),
                const SizedBox(height: 12.0,),
                TextFormField(
                  controller: jumlahPencairan,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.attach_money),
                    border: OutlineInputBorder(),
                    labelText: 'Jumlah Pencairan',
                    prefixText: '\Rp ',
                    helperText: 'Withdraw Minimal Rp. 10.000',
                    suffixText: 'Rupiah',
                    suffixStyle: TextStyle(color: Colors.green),
                  ),
                   validator: _validateNamaBank,
                  maxLines: 1,
                ),
                const SizedBox(height: 24.0),
                Text(
                  "Pilih Metode Pembayaran", style: TextStyle(fontSize: 15.0),),
                  
                 ],
            ),
          ),
        ),
      ),
      
    );
  }
}