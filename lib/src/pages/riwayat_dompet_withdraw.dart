import 'package:flutter/material.dart';
import 'package:legi/src/model/riwayat_dompet_withdraw_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:legi/src/API/api.dart';

class RiwayatDompetWithdraw extends StatefulWidget {
  @override
  _RiwayatDompetWithdrawState createState() => _RiwayatDompetWithdrawState();
}

class _RiwayatDompetWithdrawState extends State<RiwayatDompetWithdraw> {
  String _idDompet='';
  var rwDompet = new List<RiwayatDompetWithdrawModel>();

  void initState(){
      super.initState();
      _getData();
      //_getHistory();
      
    }
  String haha='10';
  _getData() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
     _idDompet=(prefs.getString('id_dompet') ?? '');

    });
    _getLisRiwayatDompet();
  }
  

  _getLisRiwayatDompet(){
    //_getData();
    API.getLisRiwayatDompetWithdraw(_idDompet).then((responses){
      setState(() {
        print('gsgsg $_idDompet');
        final list = json.decode(responses.body);
        print(list);
        rwDompet=(list['data'] as List).map<RiwayatDompetWithdrawModel>((json)=> new RiwayatDompetWithdrawModel.fromJson(json)).toList();
      });

    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      backgroundColor: Colors.greenAccent[400],
        title: Text('Lets Giving'),
        actions: <Widget>[
          new IconButton(icon: Icon(Icons.search, color: Colors.white,), onPressed: (){}),
        ],
    ),
    body: ListView.builder(
      itemCount: rwDompet.length,
      itemBuilder: (context, index){
        final NumberFormat formatter = NumberFormat.simpleCurrency(
      locale: Localizations.localeOf(context).toString(), name: 'Rp. ');
        return InkWell(
          onTap: (){
          },
          child: Card(
            child: Container(
              padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 5.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                         padding: EdgeInsets.all(8.0),
                         child: Text('No Rekening Tujuan: '+rwDompet[index].noRek, style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),),
                       ),
                       Divider(),
                  Padding(
                         padding: EdgeInsets.all(8.0),
                         child: Text('Jumlah Dana: '+formatter.format(rwDompet[index].jumlahDana)),
                       ),
                  Padding(
                         padding: EdgeInsets.all(8.0),
                         child: Text('Status: '+rwDompet[index].status),
                       ),     
                ],
              ),
            ),
          ),
        );
      },
    ),
    );
  }
}