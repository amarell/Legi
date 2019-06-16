import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:legi/src/API/api.dart';
import 'package:legi/src/model/riwayat_dompet_donasi_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class RiwayatDompetDonasi extends StatefulWidget {
  @override
  _RiwayatDompetDonasiState createState() => _RiwayatDompetDonasiState();
}

class _RiwayatDompetDonasiState extends State<RiwayatDompetDonasi> {
  String _idDompet='';
  var rwDompet = new List<RiwayatDompetDonasiModel>();

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
    //_getData();l
    API.getLisRiwayatDompetDonasi(_idDompet).then((responses){
      setState(() {
        print('gsgsg $_idDompet');
        final list = json.decode(responses.body);
        print(list);
        rwDompet=(list['data'] as List).map<RiwayatDompetDonasiModel>((json)=> new RiwayatDompetDonasiModel.fromJson(json)).toList();
      });

    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      backgroundColor: const Color(0xFF0091EA),
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
                         child: Text('Guna Pembayaran: '+rwDompet[index].gunaPembayaran, style: TextStyle(
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
                         child: Text('Status: '+rwDompet[index].statusTransaksi),
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