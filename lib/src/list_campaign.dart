import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:legi/src/API/api.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart';
import 'package:legi/src/constant.dart';
import 'package:legi/src/detail_campaign.dart';
import 'package:legi/src/hero/detail_foto_profile.dart';
import 'package:legi/src/model/list_campaign_model.dart';
import 'package:percent_indicator/percent_indicator.dart';

class ListCampaign extends StatefulWidget {
  ListCampaign({Key key, this.idCampaign = "1", this.namaKategori = "2", this.judul})
      : super(key: key);
  final idCampaign;
  final namaKategori;
  final String judul;

  @override
  _ListCampaignState createState() => _ListCampaignState(
      idCampaign: this.idCampaign, namaKategori: this.namaKategori);
}

class _ListCampaignState extends State<ListCampaign> {
  _ListCampaignState({this.idCampaign, this.namaKategori});

  final idCampaign;
  final namaKategori;

  TextEditingController searchController = TextEditingController();

  var campaigns = new List<Campaign>();

  _getCampaign() async{
    API.getListCampaign(idCampaign).then((responses) {
      // Future.delayed(Duration(milliseconds: 500));
      setState(() {
        final list = json.decode(responses.body);
        print(list);
        campaigns = (list['data'] as List)
            .map<Campaign>((json) => new Campaign.fromJson(json))
            .toList();
        print(campaigns);
      });
    });
  }

  
  @override
  void initState() {
    super.initState();
    _getCampaign();
    // _getCampaign2();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void cariCampaign(String query){
    List<Campaign> dummySearchListData = List<Campaign>();
    dummySearchListData.addAll(campaigns);

    if(query.isNotEmpty){
      List<Campaign> dummyListData =List<Campaign>();
      dummySearchListData.forEach((item){
        if(item.judul_campaign.contains(query)){
          dummyListData.add(item);

        }
      });
      setState(() {
       campaigns.clear(); 
      //  _getCampaign();
      campaigns.addAll(dummyListData);
      });

      return;
    }else{
      setState(() {
       campaigns.clear();
       _getCampaign();
      });
    }
  }

  // var _tag='Foto Campaign';

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
final TextStyle titleStyle = theme.textTheme.headline.copyWith(color: Colors.black);
    final TextStyle descriptionStyle = theme.textTheme.subhead;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0091EA),
        title: Text('Lets Giving'),
        actions: <Widget>[
          new IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.white,
              ),
              onPressed: () {}),
        ],
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (value){
                  cariCampaign(value);
                },
                controller: searchController,
                decoration: InputDecoration(
                  labelText: "Search",
                  hintText: "Search",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25.0))
                  )
                ),
              ),
            ),
            Expanded(
                          child: ListView.builder(
                    itemCount: campaigns.length,
                    itemBuilder: (context, index) {
                      var tgl =DateTime.parse(campaigns[index].tanggal_mulai);
                       var  format= DateFormat('dd MMM yyyy');

                      String formatted = format.format(tgl);
                      var targetDonasi = [
                        TargetDonasi(
                            'target', campaigns[index].target_donasi, Colors.blue[200]),
                      ];

                      var pencapaianDonasi = [
                        TargetDonasi(
                            'target', campaigns[index].dana_terkumpul, Colors.blue),
                      ];
                      var average = campaigns[index].dana_terkumpul /
                          campaigns[index].target_donasi.round();
                      double average2 = num.parse(average.toStringAsFixed(2));
                      var average3 = campaigns[index].dana_terkumpul /
                          campaigns[index].target_donasi *
                          100.round();
                      String haha = average3.toStringAsFixed(2);

                      //double ave=average*100;
                      // String persen = double.parse(ave.toString());

                      var series = [
                        charts.Series(
                          domainFn: (TargetDonasi target, _) => target.target,
                          measureFn: (TargetDonasi target, _) => target.jumlah,
                          colorFn: (TargetDonasi target, _) => target.color,
                          id: 'Pencapaian',
                          data: pencapaianDonasi,
                          //labelAccessorFn: (TargetDonasi target,_)=>'${target.target} : ${target.jumlah.toString()}'
                        ),
                        charts.Series(
                          domainFn: (TargetDonasi target, _) => target.target,
                          measureFn: (TargetDonasi target, _) => target.jumlah,
                          id: 'Target',
                          data: targetDonasi,
                          //labelAccessorFn: (TargetDonasi target,_)=>'${target.target} : ${target.jumlah.toString()}',
                          colorFn: (TargetDonasi target, _) => target.color,
                        ),
                      ];

                      var chart = charts.BarChart(
                        series,
                        barGroupingType: charts.BarGroupingType.stacked,
                        vertical: false,
                        barRendererDecorator: charts.BarLabelDecorator<String>(),
                        domainAxis:
                            charts.OrdinalAxisSpec(renderSpec: charts.NoneRenderSpec()),
                      );

                      final NumberFormat formatter = NumberFormat.simpleCurrency(
                          locale: Localizations.localeOf(context).toString(), name: 'Rp. ');
                      return InkWell(
                        onTap: () {
                          print(campaigns);
                          Navigator.push(context, new MaterialPageRoute(builder: (context) {
                            return new DetailCampaign(
                              campaign: campaigns[index],
                            );
                          }));
                        },
                        child: Card(
                          child: (campaigns.length != null)
                              ? Container(
                                  padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 5.0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.only(bottom: 8.0),
                                              child: GestureDetector(
                                                child: Hero(
                                                  tag: campaigns[index].foto_campaign, 
                                                  child: CachedNetworkImage(
                                                    imageUrl: URLAPI+'/assets/uploads/artikel/'+campaigns[index].foto_campaign,
                                                    placeholder: (context, url)=>Center(child: Container(width: 32, height: 32,child: new CircularProgressIndicator())),
                                                    errorWidget: (context, url, error) => new Icon(Icons.error),
                                                    fit: BoxFit.cover,
                                                    height: 100,
                                                    width: MediaQuery.of(context).size.width
                                                    // 'https://letsgiving.com/assets/uploads/artikel/'+campaigns[index].foto_campaign, fit: BoxFit.cover, height: 100,width: MediaQuery.of(context).size.width,
                                                    )
                                                  ),
                                                  onTap: (){
                                                    Navigator.push(context, MaterialPageRoute(builder: (_) {
                                                      return DetailFotoProfile(tag: campaigns[index].foto_campaign, url: URLAPI+'/assets/uploads/artikel/'+campaigns[index].foto_campaign);
                                                    }));
                                                  },
                                                ),
                                              ),
                                              Divider(),
                                            Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Center(
                                                child: Text(
                                                  campaigns[index].judul_campaign,
                                                  style: titleStyle,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.all(0.0),
                                              child: Center(
                                                child: LinearPercentIndicator(
                                                  width:
                                                      MediaQuery.of(context).size.width - 10,
                                                  animation: true,
                                                  lineHeight: 20.0,
                                                  animationDuration: 2000,
                                                  percent: (average2 >= 1.0)
                                                      ? average2 = 1.0
                                                      : average2,
                                                  center: Text(haha + "%"),
                                                  linearStrokeCap: LinearStrokeCap.roundAll,
                                                  progressColor: Colors.blue[500],
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                children: <Widget>[
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: <Widget>[
                                                      Text(
                                                            "Dana Terkumpul: "
                                                        ),
                                                        SizedBox(height: 5.0,),
                                                        Text(
                                                          formatter.format(
                                                          campaigns[index].dana_terkumpul),
                                                          style: descriptionStyle.copyWith(color: Colors.black54),
                                                        )
                                                    ],
                                                  ),
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: <Widget>[
                                                      Text(
                                                            "Sisa Hari: "
                                                        ),
                                                        SizedBox(height: 5.0,),
                                                        Text(
                                                          campaigns[index].batas_waktu+ " hari",
                                                          style: descriptionStyle.copyWith(color: Colors.black54),
                                                        )
                                                    ],
                                                  ),
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment.end,
                                                    children: <Widget>[
                                                      Text(
                                                            "Tanggal Mulai: "
                                                        ),
                                                        SizedBox(height: 5.0,),
                                                        Text(
                                                          formatted,
                                                          style: descriptionStyle.copyWith(color: Colors.black54),
                                                        )
                                                    ],
                                                  ),
                                                ],
                                              )
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Center(
                                  child: CircularProgressIndicator(),
                                ),
                        ),
                      );
                    },
                  ),
            ),
          ],
        ),
      ),
        
    );
  }
}

class TargetDonasi {
  final String target;
  final int jumlah;
  final charts.Color color;

  TargetDonasi(this.target, this.jumlah, Color color)
      : this.color = charts.Color(
            r: color.red, g: color.green, b: color.blue, a: color.alpha);
}
