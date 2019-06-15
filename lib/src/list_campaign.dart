import 'package:flutter/material.dart';
import 'package:legi/src/API/api.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart';
import 'package:legi/src/detail_campaign.dart';
import 'package:legi/src/model/list_campaign_model.dart';
import 'package:percent_indicator/percent_indicator.dart';

class ListCampaign extends StatefulWidget {
  ListCampaign({Key key, this.idCampaign = "1", this.namaKategori = "2"})
      : super(key: key);
  final idCampaign;
  final namaKategori;

  @override
  _ListCampaignState createState() => _ListCampaignState(
      idCampaign: this.idCampaign, namaKategori: this.namaKategori);
}

class _ListCampaignState extends State<ListCampaign> {
  _ListCampaignState({this.idCampaign, this.namaKategori});

  final idCampaign;
  final namaKategori;

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

  Future<List<Campaign>> _getCampaign2() async{
    
    var listcam=await API.getListCampaign(idCampaign).then((responses) {
      // Future.delayed(Duration(milliseconds: 500));
        final list = json.decode(responses.body);
        // print(list);
        List<Campaign> haha= (list['data'] as List)
            .map<Campaign>((json) => new Campaign.fromJson(json))
            .toList();
        print(haha);
        return haha;
    });

    return listcam;
    

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
      body: ListView.builder(
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
                                      child: Image.network('https://letsgiving.com/assets/uploads/artikel/'+campaigns[index].foto_campaign, fit: BoxFit.cover, height: 100,width: MediaQuery.of(context).size.width,),
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
