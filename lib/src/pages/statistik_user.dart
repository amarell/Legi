import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
  int jmlcampaign, donasiLunas, donasiTolak, donasiProses, jmlLunas, jmlProses, jmlTolak;

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
        donasiLunas=sm.donasiLunas;
        jmlcampaign=sm.jmlCampaign;
        donasiProses=sm.donasiProses;
        donasiTolak=sm.donasiTolak;
        jmlLunas=sm.jmlLunas;
        jmlProses=sm.jmlProses;
        jmlTolak=sm.jmlTolak;

        
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final NumberFormat formatter = NumberFormat.simpleCurrency(
        locale: Localizations.localeOf(context).toString(), name: 'Rp. ');
    var jumlah=[
          DataStatistik('Lunas', donasiLunas, Colors.blue),
          DataStatistik('Proses', donasiProses, Colors.green),
          DataStatistik('Ditolak', donasiTolak, Colors.red),
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
      body: SingleChildScrollView(
        child: (sm != null && jmlcampaign != null) ? 

        Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: 4.0,
                                child: SizedBox(
                    height: 400,
                    child: chart,
                  ),
                ),
              ),

              SizedBox(height: 10.0,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  elevation: 4.0,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Container(
                                    color: Colors.blue,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 30.0),
                                      child: Text('Donasi Lunas: '+donasiLunas.toString(), style: TextStyle(color: Colors.white),),
                                    ),
                                  ),
                                Spacer(),
                                Text( formatter.format(jmlLunas), style: TextStyle(fontSize: 14),)
                          ],
                        ),
                              SizedBox(height: 20.0,),

                Row(
                    children: <Widget>[
                      Container(
                                    color: Colors.green,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 30.0),
                                      child: Text('Donasi Proses: '+donasiProses.toString(), style: TextStyle(color: Colors.white),),
                                    ),
                                  ),
                                  Spacer(),
                                  Text( formatter.format(jmlProses), style: TextStyle(fontSize: 14),)
                    ],
                ),
                              SizedBox(height: 20.0,),
                              Row(
                                children: <Widget>[
                                  Container(
                                    color: Colors.red,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 30.0),
                                      child: Text('Donasi Tolak: '+donasiTolak.toString(), style: TextStyle(color: Colors.white),),
                                    ),
                                  ),
                                  Spacer(),
                                  Text( formatter.format(jmlTolak), style: TextStyle(fontSize: 14),)

                                ],
                              ),
                              SizedBox(height: 20.0,),
                              Row(
                                children: <Widget>[
                                  Container(
                                    color: Colors.indigo[100],
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 30.0),
                                      child: Text('Total Donasi: '+(donasiTolak+donasiProses+donasiLunas).toString() , style: TextStyle(color: Colors.white),),
                                    ),
                                  ),
                                  Spacer(),
                                  Text(formatter.format(jmlLunas+jmlProses+jmlTolak), style: TextStyle(fontSize: 14),)
                                  
                                ],
                              ),                   
  
                      ],
                    ),
                  ),
                ),
              )

              

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