import 'dart:io';
import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:legi/src/model/history_model.dart';
import 'package:path/path.dart';

class DetailHistory extends StatefulWidget {
  DetailHistory({Key key, this.historys}) : super(key: key);
  final HistoryDonasi historys;

  @override
  _DetailHistoryState createState() => _DetailHistoryState(
        history: this.historys,
      );
}

class _DetailHistoryState extends State<DetailHistory> {
  _DetailHistoryState({this.history});

  final history;

  File _imageFile;

  Future upload(File imageFile, idDona) async {
    var stream =
        new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    var length = await imageFile.length();
    var uri =
        Uri.parse("https://letsgiving.com/API/upload_bukti_donasi.php");
    var request = new http.MultipartRequest("post", uri);
    var multiPartFile = new http.MultipartFile("image", stream, length,
        filename: basename(imageFile.path));

    request.fields['id_donasi'] = idDona;
    request.files.add(multiPartFile);

    var response = await request.send();
    if (response.statusCode == 200) {
      print("image berhasil upload");
      print(idDona);
    } else {
      print("gagal");
    }
  }

  void _getImage(BuildContext context, ImageSource source) {
    ImagePicker.pickImage(source: source, maxWidth: 400.0).then((File image) {
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

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0091EA),
        title: Text('Lets Giving'),
      ),
      // backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.all(10.0),
                              child: Card(
                  clipBehavior: Clip.antiAlias,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
                                child: Container(
                    color: Colors.white,
                    margin: const EdgeInsets.symmetric(vertical: 4.0),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "Detail",
                          style: Theme.of(context)
                              .textTheme
                              .title
                              .copyWith(fontSize: 20),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: Text('Nama Bank: ' + history.namaBank),
                        ),
                        Container(
                          color: Colors.lime[100],
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 30.0),
                            child: Text('No Rek: ' + history.noRek),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: Text('Id Transaksi Anda: '+ history.idDonasi),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                          child: Text('Status: ' + history.statusDonasi),
                        ),
                        history.statusDonasi == 'proses'
                            ? OutlineButton(
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
                              )
                            : OutlineButton(
                                onPressed: null,
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
                        SizedBox(
                          height: 10.0,
                        ),
                        _imageFile == null
                            ? Text("pick an image")
                            : Image.file(
                                _imageFile,
                                fit: BoxFit.cover,
                                height: 300,
                                width: MediaQuery.of(context).size.width,
                                alignment: Alignment.topCenter,
                              ),
                         history.statusDonasi == 'proses'
                            ? RaisedButton(
                          onPressed: () {
                            upload(_imageFile, history.idDonasi);
                          },
                          child: Text("upload"),
                        ) : RaisedButton(
                          onPressed: null,
                          child: Text("upload"),
                        ) 
                      ],
                    ),
                  ),
                ),
              ),
            ]),
          )
        ],
      ),
    );
  }
}
