import 'package:flutter/material.dart';
import 'package:legi/reusable/mycard.dart';
import 'package:legi/src/API/api.dart';
import 'package:legi/src/model/riwayat_campaign.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
class RiwayatCampaign extends StatefulWidget {
  @override
  _RiwayatCampaignState createState() => _RiwayatCampaignState();
}

class _RiwayatCampaignState extends State<RiwayatCampaign> {
  String _idUser = '';
  var warnakuning=Colors.yellow[500];
  var warnabiru= Colors.blue[300];
  var warnamerah= Colors.red[300];
  var cam= new List<RiwayatCampaignModel>();

  void initState() {
    super.initState();
    _getData();
    //_getHistory();
  }  

  _getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _idUser = (prefs.getString('id') ?? '');
    });
    _getRiwayat();
  }

  _getRiwayat() {
    //_getData();
    print('haha $_idUser');
    API.getRiwayatCampaign(_idUser).then((responses) {
      setState(() {
        print('gsgsg $_idUser');
        final list = json.decode(responses.body);
        print(list);
        cam = (list['data'] as List)
            .map<RiwayatCampaignModel>((json) => new RiwayatCampaignModel.fromJson(json))
            .toList();
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
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
        itemCount: cam.length,
        itemBuilder: (context, index){
          return InkWell(
            child: Container(
              padding: EdgeInsets.all(16.0),
              child: MyCard(
                judul: cam[index].judulCampaign,
                status: 'proses',
                sisaHari: cam[index].batasWaktu,
                targetPencapaian: cam[index].targetDonasi,
                tanggal: cam[index].tanggalMulai,
                kategori: cam[index].namaKategori,
                danaTerkumpul: cam[index].danaTerkumpul,
                
              ),
            ),
          );
        },
      ),
    );
  }
}