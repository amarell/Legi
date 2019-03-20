import 'package:flutter/material.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:legi/src/compenents/newsCampaign.dart';
import 'package:legi/src/SessionManager/app_pref.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
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
            new UserAccountsDrawerHeader(accountName: Text('Burhanudin'), accountEmail: Text('buburwakhid@gmail.com'),
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
              onTap: (){},
              child: ListTile(
                title: Text('My Account'),
                leading: Icon(Icons.person, color: Colors.red,),
              ),
            ),
            InkWell(
              onTap: (){},
              child: ListTile(
                title: Text('My Order'),
                leading: Icon(Icons.shopping_basket, color: Colors.red,),
              ),
            ),
            InkWell(
              onTap: (){},
              child: ListTile(
                title: Text('Categories'),
                leading: Icon(Icons.dashboard, color: Colors.red,),
              ),
            ),
            InkWell(
              onTap: (){},
              child: ListTile(
                title: Text('Favorit'),
                leading: Icon(Icons.favorite, color: Colors.red,),
              ),
            ),
            Divider(),
            InkWell(
              onTap: (){},
              child: ListTile(
                title: Text('Setting'),
                leading: Icon(Icons.settings, color: Colors.grey,),
              ),
            ),
            InkWell(
              onTap: (){
                SessionManager.logout();
              },
              child: ListTile(
                title: Text('Logout'),
                leading: Icon(Icons.help, color: Colors.grey,),
              ),
            ),
          ],
        ),
      ),
      body: new ListView(
        children: <Widget>[
          //ini image carousel
          image_carousel,

          //ini padding caegories
          new Padding(padding: const EdgeInsets.all(8.0),
          child: new Text('News Campaign', style: TextStyle(inherit: true, fontSize: 16.0, fontFamily: "WorkSansSemiBold", color: Colors.grey ),  ),),

          //ini horizontal list view
            NewsCampaign(),

             new Padding(padding: const EdgeInsets.all(8.0),
          child: new Text('Kategori Campaign', style: TextStyle(inherit: true, fontSize: 16.0, fontFamily: "WorkSansSemiBold" ),),),
        ],
      ),
    );
  }
}