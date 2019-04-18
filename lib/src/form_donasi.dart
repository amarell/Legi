import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class FormDonation extends StatefulWidget {
  FormDonation({Key key, this.idCampaign}) : super(key: key);
  final idCampaign;
  @override
  _FormDonationState createState() => _FormDonationState(
    idCampaign: this.idCampaign,
  );
}

class _FormDonationState extends State<FormDonation> {
  _FormDonationState({this.idCampaign});

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final idCampaign;

  String _idUser='';
  void initState(){
      super.initState();
      _getData();
      print(_idUser);
    }

   String _radioValue = "";

  TextEditingController jumlah_donasi = new TextEditingController();
  
  
  void _radioAction(String value){
    setState(() {
     _radioValue=value;
    });
  }
  _getData() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
     _idUser=(prefs.getString('id') ?? '');

    });
  }

  Future<dynamic> _donasi()async{
    if(jumlah_donasi.text.isEmpty){
      showInSnackBar('jumlah donasi tidak boleh di kosongi');
    }else if(int.parse(jumlah_donasi.text) <= 10000){
      showInSnackBar('donasi anda harus lebih dari Rp. 10,000');
    }else{
      final response =await http.post('http://192.168.43.64/API/donasi_campaig.php', body: {
      "id_user": _idUser,
      "id_campaign": idCampaign,
      "jumlah_dana": jumlah_donasi.text,
      "metode_pembayaran": 'transfer',
      "id_bank": _radioValue,
    });

    Map<String, dynamic> jsonResponse = convert.jsonDecode(response.body);
    //var jsonResponse= convert.jsonDecode(response.body);
    if(response.statusCode==200){
      var success = jsonResponse['success'];
      if (success == '1') {
        print('berhasil donasi');
        showInSnackBar('Berhasil Donasi');
       
      }else if(success == '0'){
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
        backgroundColor: Colors.greenAccent[400],
      ),
      bottomNavigationBar: Container(
      color: Theme.of(context).primaryColor,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Builder(
              builder: (context) => FlatButton.icon(
                onPressed: (){
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
                Text("Masukan Jumlah Donasi", style: TextStyle(fontSize: 15.0),),
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
                Text("Pilih Metode Pembayaran", style: TextStyle(fontSize: 15.0),),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Radio(
                      value: "1",
                      groupValue: _radioValue,
                      onChanged: (value){
                        print('radio $value');
                      },
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
                      value: "6",
                      groupValue: _radioValue,
                      onChanged: _radioAction,
                    ),
                    Text('Bank BCA'),
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