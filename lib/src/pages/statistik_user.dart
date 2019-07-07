import 'package:flutter/material.dart';
import 'package:legi/src/API/api.dart';
import 'package:legi/src/model/statistik_model.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class StatistikUser extends StatefulWidget {
  @override
  _StatistikUserState createState() => _StatistikUserState();
}

class _StatistikUserState extends State<StatistikUser> {
  var data= new List<StatistikModel>();
  var _idUser='';
  int jmlcampaign, jmldonasi;

  StatistikModel sm;
  void initState(){
      super.initState();
      _getData();
      
      
    }

    _getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _idUser = (prefs.getString('id') ?? '');
    });
    _getUserDetail();
  }

  _getUserDetail() {
    //_getData()d;
    print('haha $_idUser');
    API.getStatistikUser(_idUser).then((responses) {
      setState(() {
        print('fgfdsfg $_idUser');
        final list = json.decode(responses.body);
        sm = new StatistikModel.fromJson(list);
        jmldonasi=sm.jmlDonasi;
        jmlcampaign=sm.jmlCampaign;

        
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var jumlah=[
          DataStatistik('Jumlah Donasi', jmldonasi, Colors.red),
          DataStatistik('Jumlah Campaign', jmlcampaign, Colors.yellow),
        ];
    var series=[
          charts.Series(
              domainFn: (DataStatistik target,_)=>target.total,
            measureFn: (DataStatistik target,_)=>target.jumlah,
            colorFn: (DataStatistik target,_)=>target.color,
            id: 'Pencapaian',
            data: jumlah,
            labelAccessorFn: (DataStatistik target,_)=>'${target.total} : ${target.jumlah.toString()}'
            ),
         
            
        ];   
    var chart = charts.PieChart(
          series,
          defaultRenderer: charts.ArcRendererConfig(
            arcRendererDecorators: [charts.ArcLabelDecorator()]
          ),
          
        );     
    return Scaffold(
      
       appBar: AppBar(
        title: Text('Lets Giving'),
        backgroundColor: const Color(0xFF0091EA),
      ),
      body: Card(
      child: (sm != null && jmlcampaign != null) ? 

      Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 400,
              child: chart,
            ),
  

          ],
        ),
        
      )
      
     
      
      
      : Center(child: CircularProgressIndicator(),) ,
       )

    );
  }
}

class DataStatistik{
  final String total;
  final int jumlah;
  final charts.Color color;

  DataStatistik(this.total, this.jumlah, Color color)
  :this.color=charts.Color(r: color.red, g: color.green, b: color.blue,a: color.alpha);
}