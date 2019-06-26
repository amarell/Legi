import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:legi/reusable/mycard.dart';
import 'package:legi/src/API/api.dart';
import 'package:legi/src/model/riwayat_campaign.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';
class RiwayatCampaign extends StatefulWidget {
  @override
  _RiwayatCampaignState createState() => _RiwayatCampaignState();
}

class _RiwayatCampaignState extends State<RiwayatCampaign> {
  String _idUser = '';
  var warnakuning=Colors.yellow[500];
  var warnabiru= Colors.blue[300];
  var warnamerah= Colors.red[300];
  var cam= new List<RiwayatCampaignModel>();

  TextEditingController contBerita = new TextEditingController();
  TextEditingController contKegiatan = new TextEditingController();

  void initState() {
    super.initState();
    _getData();
    //_getHistory();
  }  

  _getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _idUser = (prefs.getString('id') ?? '');
    });
    _getRiwayat();
  }

  _getRiwayat() {
    //_getData();
    print('haha $_idUser');
    API.getRiwayatCampaign(_idUser).then((responses) {
      setState(() {
        print('gsgsg $_idUser');
        final list = json.decode(responses.body);
        print(list);
        cam = (list['data'] as List)
            .map<RiwayatCampaignModel>((json) => new RiwayatCampaignModel.fromJson(json))
            .toList();
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  _color(status){
    if(status=="proses"){
      return warnakuning;
    }else if(status=="verifikasi"){
      return warnabiru;
    }else{
      return warnamerah;
    }
  }
  String lastSelectedValue;

  void showDemoDialog({BuildContext context, Widget child}) {
    showCupertinoDialog<String>(
      context: context,
      builder: (BuildContext context) => child,
    ).then((String value) {
      if (value != null) {
        setState(() { lastSelectedValue = value; });
      }
    });
  }
    final _formkey= GlobalKey<FormState>();

  Future<dynamic> _insertBerita(idcampaign) async{
    
      final response = await http.post(
            'https://letsgiving.com/API/insert_berita.php', body: {
              'id_campaign': idcampaign,
              'berita': contBerita.text,
              'nama_kegiatan': contKegiatan.text,
        });

        Map<String, dynamic> jsonResponse = json.decode(response.body);
        //var jsonResponse= convert.jsonDecode(response.body);
        if (response.statusCode == 200) {
          var success = jsonResponse['success'];
          if (success == '1') {
            print('berhasil donasi');
            Toast.show("Success", context, duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
            // showInSnackBar('Berhasil Withdraw');
          } else if (success == '0') {
            // showInSnackBar('Gagal');
            Toast.show("gagal", context, duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
            print(jsonResponse);
          }
        }

        return jsonResponse;
    
  }
  


  @override
  Widget build(BuildContext context) {
    
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
        ],
      ),
      body: ListView.builder(
        itemCount: cam.length,
        itemBuilder: (context, index){
          return InkWell(
            onLongPress: (){
              HapticFeedback.vibrate();
              (cam[index].status=='proses')?
              // HapticFeedback.vibrate();
              showDemoDialog(
                        context: context,
                        child: AlertDialog(
                          title: const Text('Form Update Berita'),
                          content: const Text('Silahkan isi berita terkini tentang campaign anda'),
                          actions: <Widget>[
                            Form(
                              key: _formkey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  TextFormField(
                                  controller: contKegiatan,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: 'silahkan isi kegiatan campaign',
                                    helperText: 'Silahkan isi kegiatan campaign',
                                    labelText: 'Kegiatan Campaign',
                                  ),
                                    maxLines: 9,
                                  ),
                                  TextFormField(
                                  controller: contBerita,
                                  decoration: const InputDecoration(
                                    border: OutlineInputBorder(),
                                    hintText: 'silahkan isi berita',
                                    helperText: 'Silahkan isi update berita campaign',
                                    labelText: 'Isi Berita',
                                  ),
                                    maxLines: 9,
                                  ),
                                ],
                              ),
                            ),
                            // CupertinoDialogAction(
                            //   child: const Text('Batal'),
                            //   onPressed: () {
                            //     Navigator.pop(context, 'Batal');
                            //   },
                            // ),
                            // CupertinoDialogAction(
                            //   child: const Text('Setuju'),
                            //   onPressed: () {
                            //     _insertBerita(cam[index].idCampaign);
                            //     Navigator.pop(context, 'Setuju');
                            //   },
                            // ),
                          ],
                        ),
                      ): HapticFeedback.vibrate();
            },
            child: Container(
              padding: EdgeInsets.all(16.0),
              child: MyCard(
                judul: cam[index].judulCampaign,
                status: cam[index].status,
                sisaHari: cam[index].batasWaktu,
                targetPencapaian: cam[index].targetDonasi,
                tanggal: cam[index].tanggalMulai,
                kategori: cam[index].namaKategori,
                danaTerkumpul: cam[index].danaTerkumpul,
                
              ),
            ),
          );
        },
      ),
    );
  }
}