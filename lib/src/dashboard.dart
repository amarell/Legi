import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/painting.dart';
import 'package:legi/src/API/api.dart';
import 'package:legi/src/compenents/KategoriScreen.dart';
import 'package:legi/src/SessionManager/app_pref.dart';
import 'package:legi/src/constant.dart';
import 'package:legi/src/dashboard_dompet.dart';
import 'package:legi/src/model/info_dompet_model.dart';
import 'package:legi/src/pages/buat_campaign.dart';
import 'package:legi/src/pages/list_zakat.dart';
import 'package:legi/src/pages/riwayat_campaign.dart';
import 'dart:convert';
import 'package:legi/src/pages/zakat.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  var datadompet = new List<InfoDompetModel>();
  String _nama = '';
  String _email = '';
  String _saldoDompet = '';
  String _idUser = '';
  String _foto='';

  void initState() {
    super.initState();
    _getData();
    print(_nama);
  }

  //final prefs = await SharedPreferences.getInstance();
  _getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _nama = (prefs.getString('nama') ?? '');
      _email = (prefs.getString('email') ?? '');
      _saldoDompet = (prefs.getString('jumlah_dompet') ?? '');
      _idUser = (prefs.getString('id') ?? '');
      _foto = (prefs.getString('foto') ?? '');
    });
    _getHistory();
  }

  _getHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //_getData();
    print('haha $_idUser');
    API.getDataDompet(_idUser).then((responses) {
      setState(() {
        print('gsgsg $_idUser');
        final list = json.decode(responses.body);
        print(list);
        datadompet = (list['data'] as List)
            .map<InfoDompetModel>((json) => new InfoDompetModel.fromJson(json))
            .toList();

        prefs.setString('jumlah_dompet', datadompet[0].saldoDompet);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final TextStyle titleStyle = theme.textTheme.headline.copyWith(color: Colors.black);
    Widget image_carousel = new Container(
      height: 200.0,
      child: new Carousel(
        boxFit: BoxFit.cover,
        images: [
          AssetImage('assets/images/a.jpeg'),
          AssetImage('assets/images/b.jpeg'),
          AssetImage('assets/images/c.jpeg'),
          AssetImage('assets/images/d.jpeg'),
        ],
        autoplay: true,
        animationCurve: Curves.fastOutSlowIn,
        animationDuration: Duration(milliseconds: 1000),
        dotSize: 4.0,
        indicatorBgPadding: 2.0,
      ),
    );

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
          new IconButton(
              icon: Icon(
                Icons.shopping_cart,
                color: Colors.white,
              ),
              onPressed: () {})
        ],
      ),
      drawer: new Drawer(
        child: new ListView(
          children: <Widget>[
            //header
            new UserAccountsDrawerHeader(
              accountName: Text('$_nama'),
              accountEmail: Text('$_email'),
              currentAccountPicture: GestureDetector(
                child: new CircleAvatar(
                    backgroundColor: Colors.grey,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: CachedNetworkImageProvider(URLAPI+'assets/uploads/avatar/'+_foto)
                        )
                      ),)),
              ),
              decoration: new BoxDecoration(
                color: Color(0xFF0091EA),
                
              ),
            
            ),

            //Body

            InkWell(
              onTap: () {},
              child: ListTile(
                title: Text('Home Page'),
                leading: Icon(
                  Icons.home,
                  color: Colors.red,
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => DompetDashboard()));
              },
              child: ListTile(
                title: Text('Dashboard Dompet'),
                leading: Icon(
                  Icons.person,
                  color: Colors.red,
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => BuatCampaign()));
              },
              child: ListTile(
                title: Text('Buat Campaign'),
                leading: Icon(
                  Icons.shopping_basket,
                  color: Colors.red,
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => ListZakat()));
              },
              child: ListTile(
                title: Text('Zakat'),
                leading: Icon(
                  Icons.dashboard,
                  color: Colors.red,
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => RiwayatCampaign()));
              },
              child: ListTile(
                title: Text('List Campaign saya'),
                leading: Icon(
                  Icons.change_history,
                  color: Colors.red,
                ),
              ),
            ),
            Divider(),

            InkWell(
              onTap: () {},
              child: ListTile(
                title: Text('FAQ'),
                leading: Icon(
                  Icons.settings,
                  color: Colors.grey,
                ),
              ),
            ),
            InkWell(
              onTap: () {
                SessionManager.logout();
                Navigator.of(context).pushReplacementNamed('/login_page');
              },
              child: ListTile(
                title: Text('Logout'),
                leading: Icon(
                  Icons.help,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
      body: new Column(
        children: <Widget>[
          //ini image carousel
          image_carousel,

          //ini padding caegories
          // new Padding(
          //   padding: const EdgeInsets.all(4.0),
          //   child: Container(
          //       alignment: Alignment.centerLeft,
          //       child: new Text('News Campaign')),
          // ),
          // //ini horizontal list view
          // NewsCampaign(),
          //kategori campaign
          // new Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: Container(
          //       alignment: Alignment.centerLeft,
          //       child: Center(child: new Text('Kategori Campaign',style: titleStyle,))),
          // ),
          Flexible(child: KategoriScreen()),
        ],
      ),
    );
  }
}
