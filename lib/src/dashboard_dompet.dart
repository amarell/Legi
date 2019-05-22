import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:legi/src/API/api.dart';
import 'package:legi/src/model/info_dompet_model.dart';
import 'package:legi/src/pages/dompet.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert' as convert;

class DompetDashboard extends StatefulWidget {
  @override
  _DompetDashboardState createState() => _DompetDashboardState();
}

class _DompetDashboardState extends State<DompetDashboard> {
  var datadompet = new List<InfoDompetModel>();
  String _idUser = '';
  String _idDompet = '';
  String _emailUser = '';
  var _saldoDOmpet = '';

  void initState() {
    super.initState();
    _getData();
    print(_idUser);
    print(_idDompet);
  }

  _getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _idUser = (prefs.getString('id') ?? '');
      _idDompet = (prefs.getString('id_dompet') ?? '');
      _emailUser = (prefs.getString('email') ?? '');
    });
    _getDataDompet();
  }

  _getDataDompet() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //_getData();
    print('haha $_idUser');
    API.getDataDompet(_idUser).then((responses) {
      setState(() {
        print('gsgsg $_idUser');
        final list = convert.jsonDecode(responses.body);
        print(list);
        datadompet = (list['data'] as List)
            .map<InfoDompetModel>((json) => new InfoDompetModel.fromJson(json))
            .toList();

        prefs.setString('jumlah_dompet', datadompet[0].saldoDompet);
        _saldoDOmpet = datadompet[0].saldoDompet;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final NumberFormat formatter = NumberFormat.simpleCurrency(
        locale: Localizations.localeOf(context).toString(), name: 'Rp. ');
    return Scaffold(
      appBar: AppBar(
        title: Text('Lets Giving'),
        backgroundColor: const Color(0xFF0091EA),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).size.height - 50,
                child: Card(
                  // This ensures that the Card's children are clipped correctly.
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    children: <Widget>[
                      Text(
                        'Dompet',
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 24.0,
                            fontFamily: "WorkSansSemiBold"),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Card(
                        child: ListTile(
                          leading: Icon(
                            FontAwesomeIcons.creditCard,
                            color: Colors.lightBlue,
                          ),
                          title: (_saldoDOmpet!='')? Text(formatter.format(int.parse(_saldoDOmpet))): Text('cek koneksi anda'),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Divider(),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (BuildContext context) => Dompet()));
                        },
                        child: ListTile(
                          title: Text('Tambah Saldo Dompet'),
                          leading: Icon(
                            Icons.file_upload,
                            color: Colors.lightBlue,
                          ),
                        ),
                      ),
                      Divider(),
                      InkWell(
                        onTap: () {},
                        child: ListTile(
                          title: Text('Withdraw Dompet'),
                          leading: Icon(
                            Icons.file_download,
                            color: Colors.lightBlue,
                          ),
                        ),
                      ),
                      Divider(),
                      ExpansionTile(
                        title: const Text('Riwayat Dompet'),
                        backgroundColor:
                            Theme.of(context).accentColor.withOpacity(0.025),
                        children: <Widget>[
                          InkWell(
                            onTap: () {},
                            child: ListTile(
                              title: Text('Tambah Saldo Dompet'),
                            ),
                          ),
                          InkWell(
                            onTap: () {},
                            child: ListTile(
                              title: Text('Donasi Dengan Dompet'),
                            ),
                          ),
                          InkWell(
                            onTap: () {},
                            child: ListTile(
                              title: Text('Withdraw Dompet'),
                            ),
                          ),
                        ],
                      ),
                      Divider(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
