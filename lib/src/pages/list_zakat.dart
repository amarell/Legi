import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:legi/src/API/api.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:legi/src/constant.dart';
import 'package:legi/src/hero/detail_foto_profile.dart';
import 'package:legi/src/model/zakat_model.dart';
import 'package:legi/src/pages/detail_zakat.dart';

class ListZakat extends StatefulWidget {
  

  @override
  _ListZakatState createState() => _ListZakatState();
}

class _ListZakatState extends State<ListZakat> {
  
  TextEditingController searchController = TextEditingController();

  var campaigns = new List<ZakatModel>();

  _getCampaign() async{
    API.getListZakat().then((responses) {
      // Future.delayed(Duration(milliseconds: 500));
      setState(() {
        final list = json.decode(responses.body);
        print(list);
        campaigns = (list['data'] as List)
            .map<ZakatModel>((json) => new ZakatModel.fromJson(json))
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

  // void cariCampaign(String query){
  //   List<Campaign> dummySearchListData = List<Campaign>();
  //   dummySearchListData.addAll(campaigns);

  //   if(query.isNotEmpty){
  //     List<Campaign> dummyListData =List<Campaign>();
  //     dummySearchListData.forEach((item){
  //       if(item.judul_campaign.contains(query)){
  //         dummyListData.add(item);

  //       }
  //     });
  //     setState(() {
  //      campaigns.clear(); 
  //     //  _getCampaign();
  //     campaigns.addAll(dummyListData);
  //     });

  //     return;
  //   }else{
  //     setState(() {
  //      campaigns.clear();
  //      _getCampaign();
  //     });
  //   }
  // }

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
                      

                      final NumberFormat formatter = NumberFormat.simpleCurrency(
                          locale: Localizations.localeOf(context).toString(), name: 'Rp. ');
                      return InkWell(
                        onTap: () {
                          print(campaigns);
                          Navigator.push(context, new MaterialPageRoute(builder: (context) {
                            return new DetailZakat(
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
                                                  tag: campaigns[index].fotoCampaign, 
                                                  child: CachedNetworkImage(
                                                    imageUrl: URLAPI+'/assets/uploads/artikel/'+campaigns[index].fotoCampaign,
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
                                                      return DetailFotoProfile(tag: campaigns[index].fotoCampaign, url: URLAPI+'/assets/uploads/artikel/'+campaigns[index].fotoCampaign);
                                                    }));
                                                  },
                                                ),
                                              ),
                                              Divider(),
                                            Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Center(
                                                child: Text(
                                                  campaigns[index].judulCampaign,
                                                  style: titleStyle,
                                                ),
                                              ),
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
