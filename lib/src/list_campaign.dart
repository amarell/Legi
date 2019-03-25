import 'package:flutter/material.dart';
import 'package:legi/src/API/api.dart';
import 'package:legi/src/compenents/listview_campaign.dart';
import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
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
    ),
    body: ListView.builder(
      itemCount: campaigns.length,
      itemBuilder: (context, index){
        return InkWell(
          onTap: (){
            print(campaigns);
          },
          child: Card(
            
            child: Column(
              children: <Widget>[
                Image.asset('assets/images/ede581967c723778d5332717ac56e0c7.png', fit: BoxFit.cover, height: 100.0,),
                Text(campaigns[index].judul_campaign),
              ],
            ),
          ),
        );
      },
    ),
      
      
    );
  }
}