import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:legi/src/API/api.dart';
import 'package:legi/src/model/info_dompet_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'package:flutter/gestures.dart';

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
