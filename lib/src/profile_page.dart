import 'dart:io';

import 'package:async/async.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'package:legi/src/API/api.dart';
import 'package:http/http.dart' as http;
import 'package:legi/src/constant.dart';
import 'package:legi/src/model/info_user_model.dart';
import 'package:legi/src/model/read_profile.dart';
import 'package:path/path.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

import 'hero/detail_foto_profile.dart';

class ProfilePage extends StatefulWidget {
  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<ProfilePage>
    with SingleTickerProviderStateMixin {
  bool _status = true;
  final FocusNode myFocusNode = FocusNode();
  String _idUser = '';
  String _foto='';
  var akun = new List<ReadProfile>();
  var user = new List<InfoUserModel>();
  var _statusUser='';
  var exnama, exemail, exidUser, extelpon, exalamat, exavatar, exktp;

  TextEditingController controller, emailCont, telpCont, alamatCont;

  File _imageFile, _imageKtp;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.setState(() {
      _getData();
      
    });
  }

  

  _getData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _idUser = (prefs.getString('id') ?? '');
      _foto = (prefs.getString('foto') ?? '');
    });
    _getUserDetail();
    _getStatus();
  }

  _getStatus() async {
    //_getData();
    print('haha $_idUser');
    API.getInfoUser(_idUser).then((responses) {
      setState(() {
        print('gsgsg $_idUser');
        final list = json.decode(responses.body);
        print(list);
        user = (list['data'] as List).map<InfoUserModel>((
            json) => new InfoUserModel.fromJson(json)).toList();

        _statusUser = user[0].status;
      });
    });
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
        exalamat=akun[0].alamat;
        print(exnama);
        controller=new TextEditingController(text: exnama);
        emailCont=new TextEditingController(text: exemail);
        telpCont=new TextEditingController(text: extelpon);
        alamatCont=new TextEditingController(text: exalamat);
      });
    });
  }

  void _getImage(BuildContext context, ImageSource source) {
    ImagePicker.pickImage(source: source, maxWidth: 400.0, maxHeight: 400.0 ).then((File image) {
      Navigator.pop(context);
      setState(() {
        _imageFile = image;
      });
    });
  }

  void _getImageKtp(BuildContext context, ImageSource source) {
    ImagePicker.pickImage(source: source, maxWidth: 400.0).then((File image) {
      Navigator.pop(context);
      setState(() {
        _imageKtp = image;
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

  void _openImagePickerKtp(BuildContext context) {
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
                    _getImageKtp(context, ImageSource.camera);
                  },
                ),
                SizedBox(
                  height: 5.0,
                ),
                FlatButton(
                  textColor: Theme.of(context).primaryColor,
                  child: Text("Use Gallery"),
                  onPressed: () {
                    _getImageKtp(context, ImageSource.gallery);
                  },
                )
              ],
            ),
          );
        });
  }

  Future editProfile(File imageKtp, context) async{
    var stream = new http.ByteStream(DelegatingStream.typed(imageKtp.openRead()));
    var length = await imageKtp.length();
    var uri = Uri.parse(URLAPI+"/API/edit_profile.php");
    var request = new http.MultipartRequest("post", uri);
    // var multiPartFile = new http.MultipartFile("image", stream, length, filename: basename(imageFile.path));
    var multiPartFileKtp = new http.MultipartFile("image", stream, length, filename: basename(imageKtp.path));
    request.fields['id_user']=_idUser;
    request.fields['nama']=controller.text;
    request.fields['email']=emailCont.text;
    request.fields['alamat'] = alamatCont.text;
    request.fields['no_hp']=telpCont.text;
    // request.files.add(multiPartFile);
    request.files.add(multiPartFileKtp);
    _showProgress(context, 'show');
    var response = await request.send();
    if(response.statusCode==200){
      print("image berhasil upload");
      Navigator.of(context).pop();
      Toast.show("Image berhasil upload", context, duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
      
    }else{
      print("gagal");
      Navigator.of(context).pop();
      Toast.show("gagals", context, duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
      
    }
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

  _showStatus(status){
    if(status=='lengkap'){
      return Text('Profil Anda sudah lengkap');
    }else if(status=='tidak_lengkap'){
      return Text('Silahkan lengkapi profil anda');
    }else{
      return Text('Silahkan perbaharui profil anda');
    }
  }

  

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: new Container(
      color: Colors.white,
      child: new ListView(
        children: <Widget>[
          Column(
            children: <Widget>[
              new Container(
                height: 250.0,
                color: Colors.white,
                child: new Column(
                  children: <Widget>[
                    Padding(
                        padding: EdgeInsets.only(left: 20.0, top: 20.0),
                        child: new Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            new Icon(
                              Icons.arrow_back_ios,
                              color: Colors.black,
                              size: 22.0,
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 25.0),
                              child: new Text('PROFILE',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20.0,
                                      fontFamily: 'sans-serif-light',
                                      color: Colors.black)),
                            )
                          ],
                        )),
                    Padding(
                      padding: EdgeInsets.only(top: 20.0),
                      child: new Stack(fit: StackFit.loose, children: <Widget>[
                        new Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            GestureDetector(
                              onTap: (){
                                Navigator.push(context, MaterialPageRoute(builder: (_) {
                                                      return DetailFotoProfile(tag: _foto, url: URLAPI+'assets/uploads/avatar/'+_foto);
                                                    }));
                              },
                                                          child: Hero(
                                tag: _foto,
                                                            child: _imageFile == null ? Container(
                                    width: 140.0,
                                    height: 140.0,
                                    decoration: new BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: new DecorationImage(
                                        image: CachedNetworkImageProvider(
                                          URLAPI+'assets/uploads/avatar/'+_foto,
                                          ),
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                    ):Container(
                                    width: 140.0,
                                    height: 140.0,
                                    decoration: new BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: new DecorationImage(
                                        image: FileImage(_imageFile),
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                    ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                            padding: EdgeInsets.only(top: 90.0, right: 100.0),
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                GestureDetector(
                                  child: new CircleAvatar(
                                    backgroundColor: Colors.red,
                                    radius: 25.0,
                                    child: new Icon(
                                      Icons.camera_alt,
                                      color: Colors.white,
                                    ),
                                  ),
                                  onTap: (){
                                    _openImagePicker(context);
                                  },
                                )
                              ],
                            )),
                      ]),
                    )
                  ],
                ),
              ),
              new Container(
                color: Color(0xffFFFFFF),
                child: Padding(
                  padding: EdgeInsets.only(bottom: 25.0),
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 25.0),
                        child: Wrap(
                                spacing: 8.0,
                                runSpacing: 4.0,
                                direction: Axis.horizontal,
                                children: <Widget>[
                                  Chip(
                                      avatar: CircleAvatar(
                                        backgroundColor: Colors.grey.shade800,
                                        child: Icon(Icons.error),
                                      ),
                                      label: _showStatus(_statusUser),
                                    )
                                ],
                              ),
                      ),
                      Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 25.0),
                          child: new Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              
                              new Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  new Text(
                                    'Personal Information',
                                    style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                              new Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  _status ? _getEditIcon() : new Container(),
                                ],
                              )
                            ],
                          )
                          ),
                      Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 25.0),
                          child: new Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              new Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  new Text(
                                    'Name',
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          )),
                      Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 2.0),
                          child: new Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              new Flexible(
                                child: new TextField(
                                  onChanged: (value){
                                    print(value);
                                  },
                                  controller: controller,
                                  decoration: const InputDecoration(
                                    hintText: "Enter Your Name",
                                  ),
                                  
                                  enabled: !_status,
                                  autofocus: !_status,

                                ),
                              ),
                            ],
                          )),
                      Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 25.0),
                          child: new Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              new Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  new Text(
                                    'Email',
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          )),
                      Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 2.0),
                          child: new Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              new Flexible(
                                child: new TextField(
                                  onChanged: (value){
                                    print(value);
                                  },
                                  controller: emailCont,
                                  decoration: const InputDecoration(
                                      hintText: "Enter Email ID"),
                                  enabled: !_status,
                                ),
                              ),
                            ],
                          )),
                      Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 25.0),
                          child: new Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              new Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  new Text(
                                    'Mobile',
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          )),
                      Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 2.0),
                          child: new Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              new Flexible(
                                child: new TextField(
                                  onChanged: (value){
                                    print(value);
                                  },
                                  controller: telpCont,
                                  decoration: const InputDecoration(
                                      hintText: "Enter Mobile Number"),
                                  enabled: !_status,
                                ),
                              ),
                            ],
                          )),
                      Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 25.0),
                          child: new Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              new Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  new Text(
                                    'Alamat',
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ],
                          )),
                      Padding(
                          padding: EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 2.0),
                          child: new Row(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              new Flexible(
                                child: new TextField(
                                  onChanged: (value){
                                    print(value);
                                  },
                                  controller: alamatCont,
                                  decoration: const InputDecoration(
                                    hintText: "Masukan alamat anda",
                                  ),
                                  
                                  enabled: !_status,
                                  autofocus: !_status,

                                ),
                              ),
                            ],
                          )),    
                          
                      !_status ? _getActionButtons(context) : new Container(),
                    ],
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    ));
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    myFocusNode.dispose();
    controller.dispose();
    super.dispose();
  }

  Widget _getActionButtons(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 45.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          OutlineButton(
                    onPressed: (){
                      _openImagePickerKtp(context);
                    },
                    borderSide: BorderSide(color: Theme.of(context).accentColor, width: 2.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.camera_alt),
                        SizedBox(width: 5.0,),
                        Text('Add foto ktp'),


                      ],
                    ),
                  ),
                  SizedBox(height: 10.0,),
                  _imageKtp == null ? Text("pick an image") 
                    : Image.file(
                      _imageKtp,
                      fit: BoxFit.cover,
                      height: 300,
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.topCenter,
                    ),
          new Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: 10.0),
                  child: Container(
                      child: new RaisedButton(
                    child: new Text("Save"),
                    textColor: Colors.white,
                    color: Colors.green,
                    onPressed: () {
                      setState(() {
                        // _status = true;
                        // FocusScope.of(context).requestFocus(new FocusNode());

                        print('hasil:'+telpCont.text);
                        editProfile(_imageKtp, context);
                      });
                    },
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(20.0)),
                  )),
                ),
                flex: 2,
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Container(
                      child: new RaisedButton(
                    child: new Text("Cancel"),
                    textColor: Colors.white,
                    color: Colors.red,
                    onPressed: () {
                      setState(() {
                        _status = true;
                        FocusScope.of(context).requestFocus(new FocusNode());
                      });
                    },
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(20.0)),
                  )),
                ),
                flex: 2,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _getEditIcon() {
    return new GestureDetector(
      child: new CircleAvatar(
        backgroundColor: Colors.red,
        radius: 14.0,
        child: new Icon(
          Icons.edit,
          color: Colors.white,
          size: 16.0,
        ),
      ),
      onTap: () {
        setState(() {
          _status = false;
        });
      },
    );
  }
}
