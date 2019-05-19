import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:legi/src/API/api.dart';
import 'package:legi/src/compenents/KategoriScreen.dart';
import 'package:legi/src/compenents/newsCampaign.dart';
import 'package:legi/src/SessionManager/app_pref.dart';
import 'package:legi/src/dashboard_dompet.dart';
import 'package:legi/src/model/info_dompet_model.dart';
import 'package:legi/src/pages/buat_donasi.dart';
import 'package:legi/src/pages/dompet.dart';
import 'dart:convert';
import 'package:legi/src/pages/riwayat_dompet.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  var datadompet= new List<InfoDompetModel>();
    String _nama ='';
    String _email='';
    String _saldoDompet='';
    String _idUser='';
    
    void initState(){
      super.initState();
      _getData();
      print(_nama);
    }

  //final prefs = await SharedPreferences.getInstance();
  _getData() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
     _nama=(prefs.getString('nama') ?? ''); 
     _email=(prefs.getString('email') ?? '');
     _saldoDompet=(prefs.getString('jumlah_dompet') ?? '');
     _idUser=(prefs.getString('id') ?? '');
    });
    _getHistory();
  }

  _getHistory() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
      //_getData();
      print('haha $_idUser');
      API.getDataDompet(_idUser).then((responses){
        setState(() {
          print('gsgsg $_idUser');
          final list = json.decode(responses.body);
          print(list);
          datadompet=(list['data'] as List).map<InfoDompetModel>((json)=> new InfoDompetModel.fromJson(json)).toList();
          
          prefs.setString('jumlah_dompet', datadompet[0].saldoDompet);

        });

      });
    }
  
  
  
    
    
  @override
  Widget build(BuildContext context) {

    
    
    

    Widget image_carousel = new Container(
      height: 200.0,
      child: new Carousel(
        boxFit: BoxFit.cover,
        images: [
          AssetImage('assets/images/ede581967c723778d5332717ac56e0c7.png'),
          AssetImage('assets/images/tb_slide_2.jpg'),
          AssetImage('assets/images/tb_slide_1.jpg'),
          AssetImage('assets/images/tb_slide_2.jpg'),

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
        backgroundColor: Colors.greenAccent[400],
        title: Text('Lets Giving'),
        actions: <Widget>[
          new IconButton(icon: Icon(Icons.search, color: Colors.white,), onPressed: (){}),
          new IconButton(icon: Icon(Icons.shopping_cart, color: Colors.white,), onPressed: (){})
        ],
      ),
      drawer: new Drawer(
        child: new ListView(
          children: <Widget>[
            //header
            new UserAccountsDrawerHeader(accountName: Text('$_nama'), accountEmail: Text('$_email'+'$_saldoDompet'),
            currentAccountPicture: GestureDetector(
              child: new CircleAvatar(
                backgroundColor: Colors.grey,
                child: Icon(Icons.person, color: Colors.white,)

              ),
            ),
            decoration: new BoxDecoration(
              color: Colors.greenAccent[400],
            ),
            ),

            //Body
            
            InkWell(
              onTap: (){},
              child: ListTile(
                title: Text('Home Page'),
                leading: Icon(Icons.home, color: Colors.red,),
              ),
            ),
            InkWell(
              onTap: (){
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => Dompet()
                ));
              },
              child: ListTile(
                title: Text('Tambah Saldo Dompet'),
                leading: Icon(Icons.person, color: Colors.red,),
              ),
            ),
            InkWell(
              onTap: (){
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => DompetDashboard()
                ));
              },
              child: ListTile(
                title: Text('Dashboard Dompet'),
                leading: Icon(Icons.person, color: Colors.red,),
              ),
            ),
            InkWell(
              onTap: (){
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => RiwayatDompet()
                ));
              },
              child: ListTile(
                title: Text('Riwayat Dompet'),
                leading: Icon(Icons.person, color: Colors.red,),
              ),
            ),
            InkWell(
              onTap: (){
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => BuatDonasi()
                ));
              },
              child: ListTile(
                title: Text('Buat Donasi'),
                leading: Icon(Icons.shopping_basket, color: Colors.red,),
              ),
            ),
            InkWell(
              onTap: (){
                var jmlDompet=int.parse(_saldoDompet);
                print(jmlDompet+5+6);
                print(_idUser);
              },
              child: ListTile(
                title: Text('Zakat'),
                leading: Icon(Icons.dashboard, color: Colors.red,),
              ),
            ),
            InkWell(
              onTap: (){},
              child: ListTile(
                title: Text('Withdraw Dompet'),
                leading: Icon(Icons.favorite, color: Colors.red,),
              ),
            ),
            Divider(),
            
            InkWell(
              onTap: (){},
              child: ListTile(
                title: Text('FAQ'),
                leading: Icon(Icons.settings, color: Colors.grey,),
              ),
            ),
            InkWell(
              onTap: (){
                SessionManager.logout();
                Navigator.of(context).pushReplacementNamed('/login_page');
              },
              child: ListTile(
                title: Text('Logout'),
                leading: Icon(Icons.help, color: Colors.grey,),
              ),
            ),
            
          ],
        ),
      ),
      body:  new Column(
        children: <Widget>[
          //ini image carousel
          image_carousel,

          //ini padding caegories
          new Padding(padding: const EdgeInsets.all(4.0),
            child: Container(
                alignment: Alignment.centerLeft,
                child: new Text('News Campaign')),),
          //ini horizontal list view
            NewsCampaign(),
          //kategori campaign
            new Padding(padding: const EdgeInsets.all(8.0),
            child: Container(
                alignment: Alignment.centerLeft,
                child: new Text('Kategori Campaign')),),
            Flexible(child: KategoriScreen()),
            
         
          ],
      ),
    );
  }
  
}

