import 'dart:io';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:image_picker/image_picker.dart';
import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:legi/src/model/riwayat_dompet_model.dart';

class DetailRiwayatDompet extends StatefulWidget {
  DetailRiwayatDompet({Key key, this.dompet}) :super(key : key);
  final RiwayatDompetModel dompet;
  @override
  _DetailRiwayatDompetState createState() => _DetailRiwayatDompetState(dompet: this.dompet);
}

class _DetailRiwayatDompetState extends State<DetailRiwayatDompet> {
  _DetailRiwayatDompetState({this.dompet});
  final dompet;

  File _imageFile;

  Future upload(File imageFile, idDompet) async{
    var stream = new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    var length = await imageFile.length();
    var uri = Uri.parse("https://letsgiving.com/API/upload_bukti_dompet.php");
    var request = new http.MultipartRequest("post", uri);
    var multiPartFile = new http.MultipartFile("image", stream, length, filename: basename(imageFile.path));

    request.fields['id_dompet']=idDompet;
    request.files.add(multiPartFile);

    var response = await request.send();
    if(response.statusCode==200){
      print("image berhasil upload");
      print(idDompet);
    }else{
      print("gagal");
    }
  }

  void _getImage(BuildContext context, ImageSource source){
    ImagePicker.pickImage(source: source, maxWidth: 400.0).then((File image){
      Navigator.pop(context);
      setState(() {
       _imageFile=image; 
      });
    });
  }

  void _openImagePicker(BuildContext context){
      showModalBottomSheet(context: context, builder: (BuildContext context){
        return Container(
          padding: EdgeInsets.all(10.0),
          height: 150.0,
          child: Column(
            children: [Text("Pick An Image", style: TextStyle(fontWeight: FontWeight.bold),),
              SizedBox(height: 10.0,),
              FlatButton(
                textColor: Theme.of(context).primaryColor,
                child: Text("use Camera"),
                onPressed: (){
                  _getImage(context, ImageSource.camera);
                },
              ),
              SizedBox(height: 5.0,),
              FlatButton(
                textColor: Theme.of(context).primaryColor,
                child: Text("Use Gallery"),
                onPressed: (){
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
    final NumberFormat formatter = NumberFormat.simpleCurrency(
      locale: Localizations.localeOf(context).toString(), name: 'Rp. ');
    return Scaffold(
       appBar: AppBar(
      backgroundColor: Colors.greenAccent[400],
        title: Text('Lets Giving'),
    ),
    backgroundColor: Colors.grey[300],

    body: CustomScrollView(
      slivers: <Widget>[
        SliverList(
          delegate: SliverChildListDelegate([
            Container(
              color: Colors.white,
              margin: const EdgeInsets.symmetric(vertical: 4.0),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Center(
                    child: Text(
                      "Upload bukti bayar",
                      style: Theme.of(context)
                          .textTheme
                          .title
                          .copyWith(fontSize: 20),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Text('Nama Bank: '+ dompet.namaBank),
                    
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Text('Nama Rekening: '+ dompet.tanggalTransaksi),
                    
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Text('No Rek: '+ dompet.noRek),
                    
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Text('Jumlah Dana: '+ formatter.format(dompet.jumlahDana)),
                    
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Text('Status: '+ dompet.statusTransaksi),
                    
                  ),
                  Center(
                    child: OutlineButton(
                    onPressed: (){
                      _openImagePicker(context);
                    },
                    borderSide: BorderSide(color: Theme.of(context).accentColor, width: 2.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.camera_alt),
                        SizedBox(width: 5.0,),
                        Text('Add Image'),


                      ],
                    ),
                ),
                  ),
                SizedBox(height: 10.0,),
                _imageFile == null ? Text("pick an image") 
                  : Image.file(
                    _imageFile,
                    fit: BoxFit.cover,
                    height: 300,
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.topCenter,
                  ),

                  Center(
                    child: RaisedButton(
                      onPressed: (){
                        upload(_imageFile, dompet.idDompet);

                      },
                      child: Text("upload"),
                    ),
                  )

                ],
              ),
            ),
          ]),
        )
      ],
    ),
    );
  }
}