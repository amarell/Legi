// import 'package:flutter/cupertino.dart';
import 'dart:io';

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:legi/reusable/mycard.dart';
import 'package:legi/src/API/api.dart';
import 'package:legi/src/constant.dart';
import 'package:legi/src/model/riwayat_campaign.dart';
import 'package:path/path.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';
class RiwayatCampaign extends StatefulWidget {
  @override
  _RiwayatCampaignState createState() => _RiwayatCampaignState();
}

class _RiwayatCampaignState extends State<RiwayatCampaign> 
  with SingleTickerProviderStateMixin{
  String _idUser = '';
  File _imageFile;
  var warnakuning=Colors.yellow[500];
  var warnabiru= Colors.blue[300];
  var warnamerah= Colors.red[300];
  var cam= new List<RiwayatCampaignModel>();


  bool isOpened = false;
  AnimationController _animationController;
  Animation<Color> _animateColor;
  Animation<double> _animateIcon;
  Curve _curve = Curves.easeOut;

  TextEditingController contBerita = new TextEditingController();
  TextEditingController contKegiatan = new TextEditingController();

  void initState() {
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500))
          ..addListener(() {
            setState(() {});
          });
    _animateIcon =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _animateColor = ColorTween(
      begin: Colors.blue,
      end: Colors.red,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.00,
        1.00,
        curve: _curve,
      ),
    ));
    super.initState();
    _getData();
    //_getHistory();
  }  

  animate() {
    if (!isOpened) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
    isOpened = !isOpened;
  }


  Widget toggle(context) {
    return FloatingActionButton(
      backgroundColor: _animateColor.value,
      onPressed: (){
        animate();
        _showModal(context);
      },
      tooltip: 'Toggle',
      child: AnimatedIcon(
        icon: AnimatedIcons.menu_close,
        progress: _animateIcon,
      ),
    );
  }

  void _showModal(BuildContext context){
      showModalBottomSheet(context: context, builder: (BuildContext context){
        return Container(
          padding: EdgeInsets.all(10.0),
          height: 150.0,
          child: Wrap(
            children: <Widget>[
              Text('data')
            ],
          )
        );
      });
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
    _animationController.dispose();
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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  void showDemoDialog<T>({ BuildContext context, Widget child }) {
    showDialog<T>(
      context: context,
      builder: (BuildContext context) => child,
    )
    .then<void>((T value) { // The value passed to Navigator.pop() or null.
      if (value != null) {
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text('You selected: $value'),
        ));
      }
    });
  }
    final _formkey= GlobalKey<FormState>();

  // Future<dynamic> _insertBerita(idcampaign) async{
    
  //     final response = await http.post(
  //           URLAPI+'/API/insert_berita.php', body: {
  //             'id_campaign': idcampaign,
  //             'berita': contBerita.text,
  //             'nama_kegiatan': contKegiatan.text,
  //       });

  //       Map<String, dynamic> jsonResponse = json.decode(response.body);
  //       //var jsonResponse= convert.jsonDecode(response.body);
  //       if (response.statusCode == 200) {
  //         var success = jsonResponse['success'];
  //         if (success == '1') {
  //           print('berhasil donasi');
  //           Toast.show("Success", context, duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
  //           // showInSnackBar('Berhasil Withdraw');
  //         } else if (success == '0') {
  //           // showInSnackBar('Gagal');
  //           Toast.show("gagal", context, duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
  //           print(jsonResponse);
  //         }
  //       }

  //       return jsonResponse;
    
  // }


  Future upload(File imageFile, idCampaign, context) async {
    var stream =
        new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    var length = await imageFile.length();
    var uri =
        Uri.parse(URLAPI+"/API/insert_berita.php");
    var request = new http.MultipartRequest("post", uri);
    var multiPartFile = new http.MultipartFile("image", stream, length,
        filename: basename(imageFile.path));

    request.fields['id_campaign'] = idCampaign;
    request.fields['berita'] = contBerita.text;
    request.fields['nama_kegiatan'] = contKegiatan.text;
    request.files.add(multiPartFile);

     _showProgress(context, 'show');
    var response = await request.send();
    
    if (response.statusCode == 200) {
      print("image berhasil upload");
      Navigator.of(context).pop();
      Toast.show("Success", context, duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);     
    } else {
      print("gagal");
    }
  }



  
  


  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      resizeToAvoidBottomPadding: false,
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
      floatingActionButton: toggle(context),
      body: ListView.builder(
        itemCount: cam.length,
        itemBuilder: (context, index){
          return InkWell(
            onLongPress: (){
              HapticFeedback.vibrate();
              (cam[index].status=='proses')?
              // HapticFeedback.vibrate();
              // showDemoDialog<String>(
              //   context: context,
              //   child: SimpleDialog(
              //     title: const Text('Set backup account'),
              //     children: <Widget>[
              //       TextFormField(
                                        // controller: contKegiatan,
                                        // decoration: const InputDecoration(
                                        //   border: OutlineInputBorder(),
                                        //   hintText: 'silahkan isi kegiatan campaign',
                                        //   helperText: 'Silahkan isi kegiatan campaign',
                                        //   labelText: 'Kegiatan Campaign',
                                        // ),
                                        //   maxLines: 9,
                                        // ),
              //       DialogDemoItem(
              //         icon: Icons.account_circle,
              //         color: theme.primaryColor,
              //         text: 'user02@gmail.com',
              //         onPressed: () { Navigator.pop(context, 'user02@gmail.com'); },
              //       ),
              //       DialogDemoItem(
              //         icon: Icons.add_circle,
              //         text: 'add account',
              //         color: theme.disabledColor,
              //       ),
              //     ],
              //   ),
              // )
              // HapticFeedback.vibrate();
              showDemoDialog<String>(
                context: context,
                child: SimpleDialog(
                  title: const Text('Update Berita'),
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                                          controller: contKegiatan,
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(),
                                            hintText: 'silahkan isi kegiatan campaign',
                                            helperText: 'Silahkan isi kegiatan campaign',
                                            labelText: 'Kegiatan Campaign',
                                          ),
                                            maxLines: 2,
                                          ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                                    controller: contBerita,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      hintText: 'silahkan isi berita',
                                      helperText: 'Silahkan isi update berita campaign',
                                      labelText: 'Isi Berita',
                                    ),
                                      maxLines: 2,
                                    ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: OutlineButton(
                                onPressed: () {
                                  _openImagePicker(context);
                                },
                                borderSide: BorderSide(
                                    color: Theme.of(context).accentColor,
                                    width: 2.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(Icons.camera_alt),
                                    SizedBox(
                                      width: 5.0,
                                    ),
                                    Text('Add Image'),
                                  ],
                                ),
                              ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: _imageFile == null
                            ? Text("pick an image")
                            : Image.file(
                                _imageFile,
                                fit: BoxFit.cover,
                                height: 300,
                                width: MediaQuery.of(context).size.width,
                                alignment: Alignment.topCenter,
                              ),
                    ),
                    FlatButton(
                              child: const Text('Batal'),
                              onPressed: () {
                                Navigator.pop(context, 'Batal');
                              },
                            ),
                            FlatButton(
                              child: const Text('Setuju'),
                              onPressed: () {
                                // _insertBerita(cam[index].idCampaign);
                                upload(_imageFile, cam[index].idCampaign, context);
                                Navigator.pop(context, 'Setuju');
                              },
                            ),
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

  void _getImage(BuildContext context, ImageSource source){
    ImagePicker.pickImage(source: source, maxWidth: 400.0).then((File image) {
      
      // final tempDir = await getTemporaryDirectory();
      // final path= tempDir.path;
      
      // Img.Image image2= Img.decodeImage(image.readAsBytesSync());
      // Img.Image smlImage = Img.copyResize(image2, width: 500);


      // var compressImg= new File("$path/image_bukti_bayar.jpg")
      //   ..writeAsBytesSync(Img.encodeJpg(smlImage, quality: 85));      
      Navigator.pop(context);
      


      setState(() {
        _imageFile = image;
      });
    });
  }

  void _openImagePicker(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
            padding: EdgeInsets.all(10.0),
            height: 150.0,
            child: Column(
              children: [
                Text(
                  "Pick An Image",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10.0,
                ),
                FlatButton(
                  textColor: Theme.of(context).primaryColor,
                  child: Text("use Camera"),
                  onPressed: () {
                    _getImage(context, ImageSource.camera);
                  },
                ),
                SizedBox(
                  height: 5.0,
                ),
                FlatButton(
                  textColor: Theme.of(context).primaryColor,
                  child: Text("Use Gallery"),
                  onPressed: () {
                    _getImage(context, ImageSource.gallery);
                  },
                )
              ],
            ),
          );
        });
  }

   _showProgress(BuildContext context, status){
    ProgressDialog pr = new ProgressDialog(context, ProgressDialogType.Normal);
    
    if(status=='show'){
      pr.setMessage('Please wait...');
    return pr.show();
    }else if(status=='hide'){
    return pr.hide();
    }
    
  }

}