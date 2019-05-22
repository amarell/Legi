import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:legi/src/API/api.dart';
import 'package:legi/src/model/read_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Account extends StatefulWidget {
  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  String _idUser = '';
  var akun = new List<ReadProfile>();
  final String url =
      'https://static.independent.co.uk/s3fs-public/thumbnails/image/2018/09/04/15/lionel-messi-0.jpg?';
  final Color green = Color(0xFF1E8161);

  var exnama, exemail, exidUser, extelpon, exalamat, exavatar, exktp;

  ReadProfile rp;

  void initState() {
    super.initState();
    this.setState(() {
      _getData();
    });

    //_getDataUserg();
  }

  _getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _idUser = (prefs.getString('id') ?? '');
    });
    _getUserDetail();
  }

  _getUserDetail() {
    //_getData()d;
    print('haha $_idUser');
    API.getDetailUser(_idUser).then((responses) {
      setState(() {
        print('fgfdsfg $_idUser');
        final list = json.decode(responses.body);
        akun = (list['login'] as List)
            .map<ReadProfile>((json) => new ReadProfile.fromJson(json))
            .toList();

        print(akun);
        exnama = akun[0].nama;
        exemail = akun[0].email;
        extelpon = akun[0].telpon;
        print(exnama);
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
        title: Text('Profile'),
        elevation: 0,
        backgroundColor: green,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () {},
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          )
        ],
      ),
      bottomNavigationBar: Container(
        color: Colors.green,
        child: Row(
          children: <Widget>[
            Expanded(
              child: Builder(
                builder: (context) => FlatButton.icon(
                      onPressed: () {},
                      icon: Icon(Icons.launch),
                      label: Text("Update Profile"),
                      textColor: Colors.white,
                    ),
              ),
            )
          ],
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(top: 16),
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 2.6,
              decoration: BoxDecoration(
                color: green,
                borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(32),
                    bottomLeft: Radius.circular(32)),
              ),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(left: 16),
                        child: Column(
                          children: <Widget>[
                            Text(
                              'Familiar',
                              style: TextStyle(color: Colors.white),
                            ),
                            Text(
                              '12',
                              style: TextStyle(color: Colors.white),
                            )
                          ],
                        ),
                      ),
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                                fit: BoxFit.fill, image: NetworkImage(url))),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: Column(
                          children: <Widget>[
                            Text(
                              'Following',
                              style: TextStyle(color: Colors.white),
                            ),
                            Text(
                              '18',
                              style: TextStyle(color: Colors.white),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      "ID: 14552566",
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16, bottom: 32),
                    child: (exnama != null)
                        ? Text(
                            exnama,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold),
                          )
                        : Center(
                            child: CircularProgressIndicator(),
                          ),
                  ),
                ],
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height / 1.4,
              padding: EdgeInsets.all(42),
              child: (exemail != null)
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Divider(),
                            SizedBox(
                              height: 7,
                            ),
                            Row(
                              children: <Widget>[
                                Icon(
                                  Icons.table_chart,
                                  color: Colors.grey,
                                ),
                                Text(
                                  'Username: ' + exnama,
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 7,
                            ),
                            Divider(),
                            SizedBox(
                              height: 7,
                            ),
                            Row(
                              children: <Widget>[
                                Icon(
                                  Icons.show_chart,
                                  color: Colors.grey,
                                ),
                                Text(
                                  'Nama Lengkap: burhanudin wakhid',
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 7,
                            ),
                            Divider(),
                            SizedBox(
                              height: 7,
                            ),
                            Row(
                              children: <Widget>[
                                Icon(
                                  Icons.card_giftcard,
                                  color: Colors.grey,
                                ),
                                Text(
                                  'Email: ' + exemail,
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 7,
                            ),
                            Divider(),
                            SizedBox(
                              height: 7,
                            ),
                            Row(
                              children: <Widget>[
                                Icon(
                                  Icons.card_giftcard,
                                  color: Colors.grey,
                                ),
                                Text(
                                  'Alamat: ' + 'exalamat',
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 7,
                            ),
                            Divider(),
                            SizedBox(
                              height: 7,
                            ),
                            Row(
                              children: <Widget>[
                                Icon(
                                  Icons.card_giftcard,
                                  color: Colors.grey,
                                ),
                                Text(
                                  'Telepon: ' + extelpon,
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 7,
                            ),
                            Divider(),
                            SizedBox(
                              height: 7,
                            ),
                            Row(
                              children: <Widget>[
                                Icon(
                                  Icons.card_giftcard,
                                  color: Colors.grey,
                                ),
                                Text(
                                  'No Ktp: ' + 'exktp',
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 7,
                            ),
                            Divider(),
                            SizedBox(
                              height: 7,
                            ),
                          ],
                        ),
                      ],
                    )
                  : Center(
                      child: CircularProgressIndicator(),
                    ),
            )
          ],
        ),
      ),
    );
  }
}
