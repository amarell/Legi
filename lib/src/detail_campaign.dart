import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:legi/src/form_donasi.dart';
import 'package:legi/src/model/list_campaign_model.dart';
import 'package:legi/src/ui_widget/text_icon.dart';
import 'package:flutter_html/flutter_html.dart';

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


   List<Widget> _textTab() => [
        Tab(text: "Home"),
        Tab(text: "Articles"),
        Tab(text: "User"),
      ];

  List<Widget> _tabTwoParameters() => [
        Tab(
          text: "Home",
          icon: Icon(Icons.home),
        ),
        Tab(text: "Articles", icon: Icon(Icons.book)),
        Tab(
          text: "User",
          icon: Icon(Icons.account_box),
        ),
      ];

  TabBar _tabBarLabel() => TabBar(
        tabs: _tabTwoParameters(),
        labelColor: Colors.red,
        labelPadding: EdgeInsets.symmetric(vertical: 10),
        labelStyle: TextStyle(fontSize: 20),
        unselectedLabelColor: Colors.lightBlue,
        unselectedLabelStyle: TextStyle(fontSize: 14),
        onTap: (index) {
          var content = "";
          switch (index) {
            case 0:
              content = "Home";
              break;
            case 1:
              content = "Articles";
              break;
            case 2:
              content = "User";
              break;
            default:
              content = "Other";
              break;
          }
          print("You are clicking the $content");
        },
      );
    

  @override
  Widget build(BuildContext context) {
    final NumberFormat formatter = NumberFormat.simpleCurrency(
        locale: Localizations.localeOf(context).toString(), name: 'Rp. ');
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF0091EA),
          title: Text('Lets Giving'),
        ),
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
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      Image.asset(
                        'assets/images/ede581967c723778d5332717ac56e0c7.png',
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
                    unselectedLabelColor: Colors.grey,
                    tabs: [
                      Tab(icon: Icon(Icons.info), text: "Tab 1"),
                      Tab(icon: Icon(Icons.lightbulb_outline), text: "Tab 2"),
                      Tab(icon: Icon(Icons.lightbulb_outline), text: "Tab 3"),
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
                  Container(
                    height: 400.0,
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
                                  icon: FontAwesomeIcons.clock,
                                  text:
                                      "Batas waktu:\n ${campaign.batas_waktu ?? "#"} hari ",
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
                            child: Html(
                              data: campaign.deskripsi,
                            )),
                      ],
                    ),
                  ),
                      ],
                    ),
                  ),
                  Container(
                    height: 200.0,
                    color: Colors.green,
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
