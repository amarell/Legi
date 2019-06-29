import 'package:flutter/material.dart';
import 'package:legi/src/compenents/ListKategori.dart' as listKategori;
import 'package:legi/src/list_campaign.dart';
class KategoriScreen extends StatefulWidget {
  KategoriScreen({Key key}) : super(key: key);
  @override
  _KategoriScreenState createState() => _KategoriScreenState();
}

class _KategoriScreenState extends State<KategoriScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
     
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,mainAxisSpacing: 25.0
        ),
        padding: const EdgeInsets.all(10.0),
        itemCount: listKategori.list.length,
        itemBuilder: (BuildContext contex, int index){
          return GridTile(
            // footer: Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: <Widget>[
            //             new SizedBox(
            //                 height: 16.0,
            //                 width: 100.0,
            //                 child: new Text(
            //                   listKategori.list[index]["name"],
            //                   maxLines: 2,
            //                   textAlign: TextAlign.center,
            //                   overflow: TextOverflow.ellipsis,
            //                 ),
            //               ),
                        
            //           ]
            // ),
            child: Card(
                          child: Container(
                height: 500.0,
                child: InkWell(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 100.0,
                        width: 100.0,
                        child: Row(
                          children: <Widget>[
                            Stack(
                              children: <Widget>[
                                SizedBox(
                                  child: Container(
                                    child: CircleAvatar(
                                      backgroundColor: Colors.grey[100],
                                      radius: 40.0,
                                      child: Icon(
                                        listKategori.list[index]['icon'],
                                        color: listKategori.list[index]['color'],
                                        size: 40.0,
                                      ),
                                    ),
                                    padding: const EdgeInsets.only(
                                    left: 10.0, right: 10.0),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(listKategori.list[index]["name"]),
                      )
                    ],
                  ),
                  onTap: (){
                    print('rrr');
                    Navigator.push(context, MaterialPageRoute(
                      builder: (contex) =>
                      ListCampaign(idCampaign:listKategori.list[index]['id'], namaKategori:listKategori.list[index]['name'],)
                        
                    )
                    );
                  },
                ),
              ),
            ),
          );
        },
      );
    
    
  }
}