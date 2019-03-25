import 'package:flutter/material.dart';
import 'package:legi/src/model/list_campaign_model.dart';

class DetailCampaign extends StatefulWidget {
  
  DetailCampaign({Key key, this.campaign}) :super(key : key);
  final Campaign campaign;
  @override
  _DetailCampaignState createState() => _DetailCampaignState(
    campaign: this.campaign,
  );
}

class _DetailCampaignState extends State<DetailCampaign> {
  _DetailCampaignState({this.campaign});
  final campaign;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      backgroundColor: Colors.greenAccent[400],
        title: Text('Lets Giving'),
    ),
    body: Column(
      children: <Widget>[
        Card(
          child: Text(campaign.judul_campaign),
          
        ),
        Text(campaign.nama_user),
      ],
    ),
      
    );
  }
}