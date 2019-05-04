import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:legi/src/API/api.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:legi/src/detail_history.dart';
import 'package:legi/src/model/history_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class History extends StatefulWidget {
  @override
  _HistoryState createState() => _HistoryState();
}

class _HistoryState extends State<History> {

  String _idUser='';
  var history = new List<HistoryDonasi>();

  
  void initState(){
      super.initState();
      _getData();
      //_getHistory();
      
    }
  String haha='10';
  _getData() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
     _idUser=(prefs.getString('id') ?? '');

    });
    _getHistory();
  }
  

  _getHistory(){
    //_getData();
    print('haha $_idUser');
    API.getListHistory(_idUser).then((responses){
      setState(() {
        print('gsgsg $_idUser');
        final list = json.decode(responses.body);
        print(list);
        history=(list['data'] as List).map<HistoryDonasi>((json)=> new HistoryDonasi.fromJson(json)).toList();
      });

    });
  }

  // @override
  // void initState() {
  //   super.initState();
  //   _getData();
  //   _getHistory();
    
    
  // }
  @override
  void dispose() {
    
    super.dispose();
  }

  

  @override
  Widget build(BuildContext context) {
    final NumberFormat formatter = NumberFormat.simpleCurrency(
      locale: Localizations.localeOf(context).toString(), name: 'Rp. ');
    return Scaffold(
       appBar: AppBar(
      backgroundColor: Colors.greenAccent[400],
        title: Text('Lets Giving'),
        actions: <Widget>[
          new IconButton(icon: Icon(Icons.search, color: Colors.white,), onPressed: (){}),
        ],
    ),

    body: ListView.builder(
      itemCount: history.length,
      itemBuilder: (context, index){
        return InkWell(
          onTap: (){
            Navigator.push(context, new MaterialPageRoute(builder: (context){
                          return new DetailHistory(historys: history[index],);
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
                         child: Text(history[index].judulCampaign, style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),),
                       ),
                  Padding(
                         padding: EdgeInsets.all(8.0),
                         child: Text('Jumlah Donasi: '+formatter.format(history[index].jumlahDana)),
                       ),
                  Padding(
                         padding: EdgeInsets.all(8.0),
                         child: Text('Status: '+history[index].statusDonasi),
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