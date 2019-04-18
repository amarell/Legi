import 'package:flutter/material.dart';
import 'package:legi/src/API/api.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart';
import 'package:legi/src/detail_campaign.dart';
import 'package:legi/src/model/list_campaign_model.dart';


class ListCampaign extends StatefulWidget {
    ListCampaign({Key key, this.idCampaign="1", this.namaKategori="2"}) : super(key: key);
    final idCampaign;
    final namaKategori;
  @override
  _ListCampaignState createState() => _ListCampaignState(
    idCampaign: this.idCampaign,
    namaKategori: this.namaKategori
  );
}

class _ListCampaignState extends State<ListCampaign> {
  _ListCampaignState({this.idCampaign, this.namaKategori});
  final idCampaign;
  final namaKategori;

  var campaigns = new List<Campaign>();

  _getCampaign(){
    API.getListCampaign(idCampaign).then((responses){
      setState(() {
       final list = json.decode(responses.body); 
       print(list);
       campaigns = (list['data'] as List).map<Campaign>((json) => new Campaign.fromJson(json)).toList();
       print(campaigns);
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _getCampaign();
  }
  @override
  void dispose() {
    
    super.dispose();
  }
  

//   Future<List<Campaign>> fetchCampaign(http.Client client) async {
//   final response =     
//   await client.post('http://192.168.43.64/API/list_campaign.php', body: {
//     'id_kategori': idCampaign,
//   });

//   // Use the compute function to run parsePhotos in a separate isolate
//   return compute(parseCampaign, response.body);
//   }
// // A function that will convert a response body into a List<Photo>
//   List<Campaign> parseCampaign(String responseBody) {
//     final parsed = json.decode(responseBody);
//     //print(parsed);
//     return (parsed['data'] as List).map<Campaign>((json) => new Campaign.fromJson(json)).toList();
//    //return parsed.map<Campaign>((json) => new Campaign.fromJson(json)).toList();
    
//   }

  
  
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
      itemCount: campaigns.length,
      itemBuilder: (context, index){
        var targetDonasi=[
          TargetDonasi('target', campaigns[index].target_donasi, Colors.blue[200]),
        ];

        var pencapaianDonasi=[
          TargetDonasi('target', campaigns[index].dana_terkumpul,Colors.blue),
        ]; 

        var series=[
          charts.Series(
              domainFn: (TargetDonasi target,_)=>target.target,
            measureFn: (TargetDonasi target,_)=>target.jumlah,
            colorFn: (TargetDonasi target,_)=>target.color,
            id: 'Pencapaian',
            data: pencapaianDonasi,
            //labelAccessorFn: (TargetDonasi target,_)=>'${target.target} : ${target.jumlah.toString()}'
            ),
          charts.Series(
            domainFn: (TargetDonasi target,_)=>target.target,
            measureFn: (TargetDonasi target,_)=>target.jumlah,
            id: 'Target',
            data: targetDonasi,
            //labelAccessorFn: (TargetDonasi target,_)=>'${target.target} : ${target.jumlah.toString()}',
            colorFn: (TargetDonasi target,_)=>target.color,
            
            ),
            
        ];

        var chart = charts.BarChart(
          series,
          barGroupingType: charts.BarGroupingType.stacked,
          vertical: false,
          barRendererDecorator: charts.BarLabelDecorator<String>(),
          domainAxis: charts.OrdinalAxisSpec(renderSpec: charts.NoneRenderSpec()),
          
        );


        final NumberFormat formatter = NumberFormat.simpleCurrency(
      locale: Localizations.localeOf(context).toString(), name: 'Rp. ');
        return InkWell(
          onTap: (){
            print(campaigns);
            Navigator.push(context, new MaterialPageRoute(builder: (context){
                          return new DetailCampaign(campaign: campaigns[index],);
                        }));
          },
          child: Card(
            
           child: Container(
             padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 5.0),
             child: Row(
               children: [
                 Expanded(
                   child: Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       Container(
                         padding: const EdgeInsets.only(bottom: 8.0),
                         child: Image.asset('assets/images/ede581967c723778d5332717ac56e0c7.png'),

                       ),
                       Padding(
                         padding: EdgeInsets.all(8.0),
                         child: Text(campaigns[index].judul_campaign, style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),),
                       ),
                       Padding(
                         padding: EdgeInsets.all(0.0),
                         child: Column(
                           children: <Widget>[
                             SizedBox(
                               height: 50,
                               child: chart,
                             )
                           ],
                         ),
                       ),
                        Padding(
                         padding: EdgeInsets.all(8.0),
                         child: Text("target Donasi: "+ formatter.format(campaigns[index].target_donasi), style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),),
                       ),
                       
                       
                     ],
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

class TargetDonasi{
  final String target;
  final int jumlah;
  final charts.Color color;

  TargetDonasi(this.target, this.jumlah, Color color)
  :this.color=charts.Color(r: color.red, g: color.green, b: color.blue,a: color.alpha);
}