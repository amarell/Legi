import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:legi/src/API/api.dart';
import 'package:legi/src/constant.dart';
import 'package:legi/src/hero/detail_foto_profile.dart';
import 'package:legi/src/model/update_berita_user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class UpdateBeritaUser extends StatefulWidget {
  @override
  _UpdateBeritaUserState createState() => _UpdateBeritaUserState();
}

class _UpdateBeritaUserState extends State<UpdateBeritaUser> {

  String _idUser = '';
  var update = new List<UpdateBeritaUserModel>();

  void initState() {
    super.initState();
    _getData();
    //_getHistory();
  }

  String haha = '10';

  _getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _idUser = (prefs.getString('id') ?? '');
    });
    _getUpdate();
  }

  _getUpdate() {
    //_getData();
    print('haha $_idUser');
    API.getUpdateBeritaUser(_idUser).then((responses) {
      setState(() {
        print('gsgsg $_idUser');
        final list = json.decode(responses.body);
        print(list);
        update = (list['data'] as List)
            .map<UpdateBeritaUserModel>((json) => new UpdateBeritaUserModel.fromJson(json))
            .toList();
      });
    });
  }

  
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: AppBar(
        backgroundColor: const Color(0xFF0091EA),
        title: Text('Lets Giving'),
        
      ),

      body: ListView.builder(
        itemCount: update.length,
        itemBuilder: (context, index){
          var tgl =DateTime.parse(update[index].tanggal);
                       var  format= DateFormat('dd MMM yyyy');

                      String formatted = format.format(tgl);
          return InkWell(
            onTap: (){

            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                elevation: 4.0,
                borderOnForeground: true,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 5.0),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[Text(
                            update[index].judulCampaign,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        
                        Divider(),

                        Text(formatted,style: TextStyle(color: Colors.grey)),

                        Html(data: update[index].berita,),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: (){
                                                    Navigator.push(context, MaterialPageRoute(builder: (_) {
                                                      return DetailFotoProfile(tag: update[index].idBerita, url: URLAPI+'/assets/uploads/transaksi/saldo/'+update[index].fotoKegiatan);
                                                    }));
                                                  },
                                                      child: Hero(
                              tag: update[index].idBerita,
                                                        child: CachedNetworkImage(
                                                            imageUrl: URLAPI+'/assets/uploads/transaksi/saldo/'+update[index].fotoKegiatan,
                                                            placeholder: (context, url)=>Center(child: Container(width: 32, height: 32,child: new CircularProgressIndicator())),
                                                            errorWidget: (context, url, error) => new Icon(Icons.error),
                                                            fit: BoxFit.cover,
                                                            height: 150,
                                                            width: MediaQuery.of(context).size.width
                                                            // 'https://letsgiving.com/assets/uploads/artikel/'+campaigns[index].foto_campaign, fit: BoxFit.cover, height: 100,width: MediaQuery.of(context).size.width,
                                                            ),
                            ),
                          ),
                        )

                        
                      ],
                    ),
                  ),
                ),
              ),
            ), 
          );
        },
      ),
    );
  }
}