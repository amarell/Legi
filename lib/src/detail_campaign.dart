import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:legi/src/API/api.dart';
import 'package:legi/src/form_donasi.dart';
import 'package:legi/src/model/list_campaign_model.dart';
import 'package:legi/src/model/list_donatur_model.dart';
import 'package:legi/src/ui_widget/text_icon.dart';
import 'dart:convert';

class DetailCampaign extends StatefulWidget {
  DetailCampaign({Key key, this.campaign}) : super(key: key);
  final Campaign campaign;

  @override
  _DetailCampaignState createState() => _DetailCampaignState(
        campaign: this.campaign,
      );
}

class _DetailCampaignState extends State<DetailCampaign> {
  _DetailCampaignState({this.campaign});

  final campaign;

  var donatur = new List<ListDonaturModel>();

  


  void initState() {
    super.initState();
    _getDonatur();
    //_getHistory();
  }

  _getDonatur() {
    //_getData();
    var haha =campaign.id_campaign;
    print('haha '+campaign.id_campaign);
    API.getLisDonatur(haha).then((responses) {
      setState(() {
        print('gsgsg $haha');
        final list = json.decode(responses.body);
        print(list);
        donatur = (list['data'] as List)
            .map<ListDonaturModel>((json) => new ListDonaturModel.fromJson(json))
            .toList();
      });
    });
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
        backgroundColor: Colors.grey[300],
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
                                  builder: (context) => FormDonation(
                                        idCampaign: campaign.id_campaign, dibuatOleh: campaign.dibuatOleh ,
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
            length: 3,
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
                        'https://letsgiving.com/assets/uploads/artikel/'+campaign.foto_campaign,
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
                                campaign.nama_kategori,
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
                    labelColor: Colors.black87,
                    unselectedLabelColor: Colors.white,
                    
                    tabs: [
                      Tab(icon: Icon(Icons.info), text: "Deskripsi"),
                      Tab(icon: Icon(Icons.people), text: "Donatur"),
                      Tab(icon: Icon(Icons.new_releases), text: "Update"),
                    ],
                  ),
                ),
                pinned: false,
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
                                campaign.judul_campaign,
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
                                            "Target Donasi:\n ${formatter.format(campaign.target_donasi) ?? "#"} ",
                                      ),
                                      TextIcon(
                                        icon: FontAwesomeIcons.handHoldingUsd,
                                        text:
                                            "Dana Terkumpul:\n ${formatter.format(campaign.dana_terkumpul) ?? "#"} ",
                                      ),
                                      TextIcon(
                                        icon: FontAwesomeIcons.clock,
                                        text:
                                            "Sisa Waktu:\n ${campaign.batas_waktu ?? "#"} hari ",
                                      ),
                                      TextIcon(
                                        icon: FontAwesomeIcons.user,
                                        text:
                                            "Dibuat oleh:\n ${campaign.nama_user ?? "Admin"} ",
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
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Flexible(
                        // height: 400,
                          child: ListView.builder(
                            //  scrollDirection: Axis.vertical,
                             shrinkWrap: true,
                             itemCount: donatur.length,
                             itemBuilder: (context, index){
                               return InkWell(
            onTap: () {
              
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
                              Text(donatur[index].namaUser,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(formatter.format(donatur[index].jumlahDana),style: TextStyle(color: Colors.grey),)
                            ],
                          ),
                        ),
                        Divider(),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Jumlah Donasi: ' +
                              formatter.format(donatur[index].jumlahDana),style: TextStyle(color: Colors.grey),),
                        ),
                        
                      ],
                ),
              ),
            ),
          );
                             }, 
                            ),
                          
                      ),
                    ],
                  ),
                  Container(
                    height: 200.0,
                    color: Colors.purple,
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
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
