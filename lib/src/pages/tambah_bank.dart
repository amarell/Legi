import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:legi/src/constant.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

class TambahBank extends StatefulWidget {
  @override
  _TambahBankState createState() => _TambahBankState();
}

class _TambahBankState extends State<TambahBank> {
  final _formkey= GlobalKey<FormState>();
  String _idUser = '';
  String _idDompet = '';
  String _emailUser = '';

  bool _formWasEdited = false;

  var _saldoDOmpet = '';

   TextEditingController namaBank = new TextEditingController();
    TextEditingController namaPemilik = new TextEditingController();
     TextEditingController noRek = new TextEditingController();


 

 final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

 
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

  Future<dynamic> _withdraw() async{
    if(namaBank.text.isEmpty){
      showInSnackBar('jumlah pencairan dana anda kurang dari 10.000');
    }else if(namaPemilik.text.isEmpty){
      showInSnackBar('jumlah pencairan dana anda lebih besar dari saldo dompet anda');
    }else{
      _showProgress(context, 'show');
      final response = await http.post(
            URLAPI+'/API/insert_bank_user.php', body: {
          "id_user": _idUser,
          "nama_bank": namaBank.text,
          "nama_pemilik": namaPemilik.text,
          "no_rek": noRek.text,
        });

        Map<String, dynamic> jsonResponse = convert.jsonDecode(response.body);
        //var jsonResponse= convert.jsonDecode(response.body);
        if (response.statusCode == 200) {
          var success = jsonResponse['success'];
          if (success == '1') {
            print('berhasil donasi');
            Navigator.of(context).pop();
            showInSnackBar('Berhasil Withdraw');
            Navigator.of(context).pushReplacementNamed('/home');
                    Toast.show("Berhasil", context, duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);

          } else if (success == '0') {
            Navigator.of(context).pop();
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
      appBar: AppBar(
        title: Text('Lets Giving'),
        backgroundColor: const Color(0xFF0091EA),
      ),
      bottomNavigationBar: Container(
      color: Theme.of(context).primaryColor,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Builder(
              builder: (context) => FlatButton.icon(
                onPressed: (){
                  
                  if(_formkey.currentState.validate()){
                    _withdraw();
                  }
                  
                },
                icon: Icon(Icons.launch),
                label: Text("Tambah Bank"),
                textColor: Colors.white,
              ),
            )
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
                
                      SizedBox(height: 12.0,),
                TextFormField(
                  
                  controller: namaBank,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    filled: true,
                    hintText: 'Masukan Nama Bank Tujuan',
                    labelText: 'Nama Bank*',
                  ),
                  validator: (value){
                    if(value.isEmpty){
                      return 'Nama Bank tidak boleh kosong';
                    }
                  },
                  
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
                   validator: (value){
                     if(value.isEmpty)
                      return'nama pemilik tidak boleh kosong';
                   },
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
                   validator: (value){
                     if(value.isEmpty){
                       return 'No rekening tidak boleh kosong';
                     }
                   },
                ),
                const SizedBox(height: 24.0,),
                
                
                  
                 ],
            ),
          ),
        ),
      ),
      
    
    );
  }
}