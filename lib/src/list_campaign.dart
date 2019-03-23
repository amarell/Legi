import 'package:flutter/material.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
      backgroundColor: Colors.greenAccent[400],
        title: Text('Lets Giving'),
    ),
    body: Column(
      children: <Widget>[
        Text(idCampaign),
        Text(namaKategori),
      ],
    ),
      
      
    );
  }
}