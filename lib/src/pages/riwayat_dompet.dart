import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:legi/src/API/api.dart';
import 'package:legi/src/pages/detail_riwayat_dompet.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:legi/src/model/riwayat_dompet_model.dart';
class RiwayatDompet extends StatefulWidget {
  @override
  _RiwayatDompetState createState() => _RiwayatDompetState();
}

class _RiwayatDompetState extends State<RiwayatDompet> {
  String _idDompet='';
  var rwDompet = new List<RiwayatDompetModel>();

  var warnakuning=Colors.yellow[500];
  var warnabiru= Colors.blue[300];
  var warnamerah= Colors.red[300];

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
    API.getLisRiwayatDompet(_idDompet).then((responses){
      setState(() {
        print('gsgsg $_idDompet');
        final list = json.decode(responses.body);
        print(list);
        rwDompet=(list['data'] as List).map<RiwayatDompetModel>((json)=> new RiwayatDompetModel.fromJson(json)).toList();
      });

    });
  }

  _color(status){
    if(status=="proses"){
      return warnakuning;
    }else if(status=="verifikasi"){
      return warnabiru;
    }else{
      return warnamerah;
    }
  }

  _status(status){
    if(status=="proses"){
      return 'Proses';
    }else if(status=="verifikasi"){
      return 'Lunas';
    }else{
      return 'Di tolak';
    }
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
            Navigator.push(context, new MaterialPageRoute(builder: (context){
                          return new DetailRiwayatDompet(dompet: rwDompet[index],);
                        }));
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
                  Container(
                      padding: EdgeInsets.only(left: 4.0),
                      decoration: BoxDecoration(
                        color: _color(rwDompet[index].statusTransaksi),
                        borderRadius: BorderRadius.all(const Radius.circular(40.0))
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text('Status: ' + _status(rwDompet[index].statusTransaksi), style: TextStyle(color: Colors.white)),
                      ),
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