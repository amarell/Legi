import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:legi/src/API/api.dart';
import 'package:legi/src/constant.dart';
import 'package:legi/src/model/list_donatur_model.dart';
import 'package:legi/src/model/list_update_model.dart';
import 'package:legi/src/model/zakat_model.dart';
import 'package:legi/src/pages/zakat.dart';
import 'package:legi/src/ui_widget/text_icon.dart';
import 'dart:convert';
import 'package:share/share.dart';


class DetailZakat extends StatefulWidget {
  DetailZakat({Key key, this.campaign}) : super(key: key);
  final ZakatModel campaign;

  @override
  _DetailZakatState createState() => _DetailZakatState(
        campaign: this.campaign,
      );
}

class _DetailZakatState extends State<DetailZakat> {
  _DetailZakatState({this.campaign});

  final campaign;

  var donatur = new List<ListDonaturModel>();
  var berita = new List<ListUpdateModel>();
  
  void initState() {
    super.initState();
    _getBerita();
    //_getHistory();
  }


  _getBerita() {
    //_getData();
    var haha =campaign.idCampaign;
    print('haha '+campaign.idCampaign);
    API.getLisUpdateBerita(haha).then((responses) {
      setState(() {
        print('gsgsg $haha');
        final list = json.decode(responses.body);
        print(list);
        berita = (list['data'] as List)
            .map<ListUpdateModel>((json) => new ListUpdateModel.fromJson(json))
            .toList();
      });
    });
  }

  _share(String link){
    Share.share(
      'Mari kita bantu saudara kita \n\n'+
      URLAPI+'/$link'
    );
  }

  

  @override
  Widget build(BuildContext context) {
    
    final NumberFormat formatter = NumberFormat.simpleCurrency(
        locale: Localizations.localeOf(context).toString(), name: 'Rp. ');
    return Scaffold(
        // appBar: AppBar(
        //   backgroundColor: const Color(0xFF0091EA),
        //   title: Text('Lets Giving'),
        // ),
        // backgroundColor: Colors.grey[300],
        bottomNavigationBar: Container(
          color: Theme.of(context).primaryColor,
          child: Row(
            children: <Widget>[
              Expanded(
                child: Builder(
                  builder: (context) => FlatButton.icon(
                        onPressed: () {
                          print('clicked');
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Zakat(
                                        idCampaign: campaign.idCampaign
                                      )));
                        },
                        icon: Icon(Icons.launch),
                        label: Text("Donasi Sekarang"),
                        textColor: Colors.white,
                      ),
                ),
              ) 
            ],
          ),
        ),
        body: DefaultTabController(
            length: 2,
                  child: CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                pinned: true,
                floating: false,
                expandedHeight: 256,
                title: Text('Detail Campaign'),
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      Image.network(
                        URLAPI+'/assets/uploads/artikel/'+campaign.fotoCampaign,
                        fit: BoxFit.cover,
                      ),
                      // This gradient ensures that the toolbar icons are distinct
                      // against the background image.
                      const DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment(0.0, -1.0),
                            end: Alignment(0.0, -0.4),
                            colors: <Color>[Color(0x60000000), Color(0x00000000)],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 20,
                        left: 0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 16),
                          color: Color.fromRGBO(255, 255, 255, 0.5),
                          child: Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: Icon(
                                  Icons.tag_faces,
                                  size: 20,
                                  color: Theme.of(context).accentColor,
                                ),
                              ),
                              Text(
                                campaign.namaKategori,
                                style: Theme.of(context).textTheme.title,
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                
              ),

              SliverPersistentHeader(
                
              
                delegate: _SliverAppBarDelegate(
                  TabBar(
                    labelColor: Colors.orange[700],
                    unselectedLabelColor: Colors.white,
                    
                    tabs: [
                      Tab(icon: Icon(Icons.info), text: "Deskripsi"),
                      Tab(icon: Icon(Icons.new_releases), text: "Update"),
                    ],
                  ),
                ),
                pinned: true,
              ),
              
             
             
              SliverList(
                delegate: SliverChildListDelegate([
                  SizedBox(
            height: 500.0,
            child: TabBarView(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Flexible(
                        // height: 400.0,
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Column(
                            children: <Widget>[
                              Container(
                          color: Colors.white,
                          padding: const EdgeInsets.all(16),
                          margin: const EdgeInsets.only(bottom: 4),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                campaign.judulCampaign,
                                style: Theme.of(context)
                                    .textTheme
                                    .title
                                    .copyWith(fontSize: 24.0),
                              ),
                              Container(
                                margin: const EdgeInsets.symmetric(vertical: 16.0),
                                padding: const EdgeInsets.symmetric(vertical: 16.0),
                                decoration: BoxDecoration(
                                  border: Border(
                                    top: BorderSide(color: Colors.grey, width: 0.4),
                                    bottom: BorderSide(color: Colors.grey, width: 0.4),
                                  ),
                                ),
                                child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      TextIcon(
                                        icon: FontAwesomeIcons.handHoldingUsd,
                                        text:
                                            "Target Donasi:\n Rp. ∞ ",
                                      ),
                                      TextIcon(
                                        icon: FontAwesomeIcons.handHoldingUsd,
                                        text:
                                            "Dana Terkumpul:\n ${formatter.format(campaign.danaTerkumpul) ?? "#"} ",
                                      ),
                                      TextIcon(
                                        icon: FontAwesomeIcons.clock,
                                        text:
                                            "Sisa Waktu:\n ∞ hari ",
                                      ),
                                      TextIcon(
                                        icon: FontAwesomeIcons.user,
                                        text:
                                            "Dibuat oleh:\n Baznas ",
                                      ),
                                      
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                      ),
                      Container(
                          color: Colors.white,
                          margin: const EdgeInsets.symmetric(vertical: 4.0),
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Deskripsi",
                                style: Theme.of(context)
                                    .textTheme
                                    .title
                                    .copyWith(fontSize: 20),
                              ),
                              Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                                  child: 
                                  Html(
                                    data: campaign.deskripsi,
                                  ),
                                  // HtmlView(
                                  //   data: campaign.deskripsi,

                                  // ),
                                  ),
                            ],
                          ),
                      ),
                      Container(
                        color: Colors.white,
                        margin: const EdgeInsets.symmetric(vertical: 4.0),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: <Widget>[
                            OutlineButton(
                                onPressed: () {
                                  _share(campaign.link);
                                },
                                borderSide: BorderSide(
                                    color: Theme.of(context).accentColor,
                                    width: 2.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(Icons.share),
                                    SizedBox(
                                      width: 5.0,
                                    ),
                                    Text('Share'),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Flexible(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: berita.length,
                          itemBuilder: (context, index){
                            var tgl =DateTime.parse(berita[index].tanggal);
                       var  format= DateFormat('dd MMM yyyy');

                      String formatted = format.format(tgl);
                            return InkWell(
                              onTap: (){

                              },
                              child: Card(
              child: Container(
                padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 5.0),
                child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            children: <Widget>[
                              Divider(),
                              
                              Text(berita[index].namaKegiatan,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Spacer(),
                              Text(formatted,style: TextStyle(color: Colors.grey),)
                            ],
                          ),
                          
                        ),
                        Divider(),
                        // Text(berita[index].berita, textAlign: TextAlign.justify,),
                        Html(data: berita[index].berita,),
                        
                        
                      ],
                ),
              ),
            ),
                            );
                          },
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),

                  
                ]),
              ),
            ],
          ),
        ));
  }
}
class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new Container(
      color: Colors.blue[800],
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}