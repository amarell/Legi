import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:legi/src/API/api.dart';
import 'package:legi/src/constant.dart';
import 'package:legi/src/model/detail_bank_user_model.dart';
import 'package:legi/src/model/info_dompet_model.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class FormWithdraw extends StatefulWidget {
  @override
  _FormWithdrawState createState() => _FormWithdrawState();
}

class _FormWithdrawState extends State<FormWithdraw> {

  String _idUser = '';
  String _idDompet = '';
  String _emailUser = '';

  String _namaPemilik='';

  bool _formWasEdited = false;

  var akun = new List<DetailBankUserModel>();

  var datadompet = new List<InfoDompetModel>();
  var _saldoDOmpet = '';

  bool _getStatus=false;

  var exNamabank, exnamaPemilik, exnoRek;

   TextEditingController namaBank = new TextEditingController();
    TextEditingController namaPemilik = new TextEditingController();
     TextEditingController noRek = new TextEditingController();
 var jumlahPencairan = new MoneyMaskedTextController();


 

 final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();


 String lastSelectedValue;


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
    print(_namaPemilik);
  }

  _getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _idUser = (prefs.getString('id') ?? '');
      _idDompet = (prefs.getString('id_dompet') ?? '');
      _emailUser = (prefs.getString('email') ?? '');
    });
    _getDataDompet();
    _getBankUser();
  }

  final String url = URLAPI+"/API/list_bank_user.php";
  String _mySelection;
  List data; 
   Future<String> getSWData() async {
    var res = await http
        .post(url, body: {
          "id_user": _idUser,
        });
    var resBody = convert.jsonDecode(res.body);
    //var data2 =resBody['data'][0];

    setState(() {
      data = resBody['data'];
    });

    print(resBody);

    return "Sucess";
  }

  _getBankUser(){
    API.getBankUser(_idUser).then((responses){
      setState(() {
       final list = convert.jsonDecode(responses.body); 
       print(list);
       setState(() {
        data=list['data']; 
      
       });
      //  campaigns = (list['data'] as List).map<Campaign>((json) => new Campaign.fromJson(json)).toList();
      //  print(campaigns);
      });
    });
  }

  _getUserDetail(var idRek) {
    //_getData()d;
    API.getDetailBankUser(idRek).then((responses) {
      setState(() {
        final list = convert.jsonDecode(responses.body);
        akun = (list['data'] as List)
            .map<DetailBankUserModel>((json) => new DetailBankUserModel.fromJson(json))
            .toList();

        print(akun);
        exNamabank = akun[0].namaBank;
        exnamaPemilik = akun[0].namaPemilik;
        exnoRek = akun[0].noRek;
        print(exNamabank);
      });
    });
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
    if(jumlahPencairan.numberValue.round()<=10000){
      int a = jumlahPencairan.numberValue.round();
      print(a);
      showInSnackBar('jumlah pencairan dana anda kurang dari 10.000');
    }else if(jumlahPencairan.numberValue.round() >= int.parse(_saldoDOmpet.toString())){
      showInSnackBar('jumlah pencairan dana anda lebih besar dari saldo dompet anda');
    }else{
      _showProgress(context, 'show');
      final response = await http.post(
            URLAPI+'/API/withdraw_dompet.php', body: {
          "id_dompet": _idDompet,
          "id_bank": _mySelection,
          "jumlah_pencairan": jumlahPencairan.numberValue.round().toString(),
          "status": "pengajuan",
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

  final _formkey= GlobalKey<FormState>();

   @override
  void dispose() {
    _getDataDompet();
    super.dispose();
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
                                if(_formkey.currentState.validate())
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
          key: _formkey,
          child: SingleChildScrollView(
            dragStartBehavior: DragStartBehavior.down,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Card(
                        child: ListTile(
                          leading: Icon(
                            FontAwesomeIcons.creditCard,
                            color: Colors.lightBlue,
                          ),
                          title: (_saldoDOmpet!='')? Text(formatter.format(int.parse(_saldoDOmpet))): Text('Loading...'),
                        ),
                      ),
                      SizedBox(height: 12.0,),
                (data!= null) ? DropdownButton(
                    elevation: 4,
                    hint: const Text('Pilih Bank Yang Di Tuju'),
                    items: data.map((item){
                      return DropdownMenuItem(
                        child: Text(item['nama_bank']),
                        value: item['id_rekening'],
                        
                      );
                    }).toList(),
                    onChanged: (newVal){
                      setState(() {
                       _mySelection = newVal; 
                       _getUserDetail(newVal);
                       if(newVal!='')
                        _getStatus=true;
                      });
                    },
                    value: _mySelection,
                    
                  ) : Center(child: CircularProgressIndicator(),),
                  (_getStatus==true)?
                  Column(
                    children: <Widget>[
                      
                      ListTile(
                        title: new Text('Nama Bank: '+ exNamabank.toString())
                      ),
                          
                      ListTile(
                        title: new Text('Nama Pemilik: '+exnamaPemilik),
                      ),
                      ListTile(
                        title: new Text('No Rekenin: '+exnamaPemilik),
                      )
                    ],
                  )
                  :Container(),      
                
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
                   validator: (value){
                     if(value.isEmpty){
                       return 'Jumlah pencairan tidak boleh kosong';
                     }
                   },
                  maxLines: 1,
                ),
                const SizedBox(height: 24.0),
                
                  
                 ],
            ),
          ),
        ),
      ),
      
    );
  }
}