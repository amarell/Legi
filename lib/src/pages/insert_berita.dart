import 'dart:io';

import 'package:async/async.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:legi/src/constant.dart';
import 'package:flutter/services.dart';

import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:toast/toast.dart';

enum DismissDialogAction {
  cancel,
  discard,
  save,
}

class InsertBerita extends StatefulWidget {
InsertBerita({Key key, this.idCamp}) : super(key: key);
  final String idCamp;
  @override
  _InsertBeritaState createState() => _InsertBeritaState(
    idCamp: this.idCamp
  );
}

class _InsertBeritaState extends State<InsertBerita> {
  _InsertBeritaState({this.idCamp});
  final idCamp;
  File _imageFile;
  TextEditingController contBerita = new TextEditingController();
  TextEditingController contDana = new TextEditingController();
  TextEditingController contKegiatan = new TextEditingController();

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0091EA),
        title: Text('Update Berita'),
      ),

      body: SafeArea(
         top: false,
        bottom: false,
        child: Form(
          child: SingleChildScrollView(
            dragStartBehavior: DragStartBehavior.down,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                                    controller: contDana,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      border: OutlineInputBorder(),
                                      hintText: 'Masukan jumlah pengeluaran',
                                      helperText: 'Silahkan isi jumlah pengeluaran',
                                      labelText: 'Isi Pengeluaran Dana',
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
                    Row(
                      children: <Widget>[
                        FlatButton(
                                  child: const Text('Batal'),
                                  onPressed: () {
                                  },
                                ),
                        FlatButton(
                              child: const Text('Setuju'),
                              onPressed: () {
                                // _insertBerita(cam[index].idCampaign);
                                upload(_imageFile, idCamp, context);
                              },
                            ),        
                      ],
                    ),
                            
              ],
            ),
            
          ),
        ),
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
    request.fields['jumlah_dana'] = contDana.text;
    request.files.add(multiPartFile);

     _showProgress(context, 'show');
    var response = await request.send();
    
    if (response.statusCode == 200) {
      print("image berhasil upload");
      Navigator.pop(context, DismissDialogAction.save);
      Toast.show("Success", context, duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);     
    } else {
      print("gagal");
    }
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