import 'dart:io';

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:legi/src/API/api.dart';
import 'package:legi/src/constant.dart';
import 'package:legi/src/model/info_user_model.dart';
import 'package:path/path.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class _InputDropdown extends StatelessWidget {
  const _InputDropdown({
    Key key,
    this.child,
    this.labelText,
    this.valueText,
    this.valueStyle,
    this.onPressed,
  }) : super(key: key);

  final String labelText;
  final String valueText;
  final TextStyle valueStyle;
  final VoidCallback onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: labelText,
        ),
        baseStyle: valueStyle,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(valueText, style: valueStyle),
            Icon(Icons.arrow_drop_down,
              color: Theme.of(context).brightness == Brightness.light ? Colors.grey.shade700 : Colors.white70,
            ),
          ],
        ),
      ),
    );
  }
}

class _DateTimePicker extends StatelessWidget {
  const _DateTimePicker({
    Key key,
    this.labelText,
    this.selectedDate,
    this.selectedTime,
    this.selectDate,
    this.selectTime,
  }) : super(key: key);

  final String labelText;
  final DateTime selectedDate;
  final TimeOfDay selectedTime;
  final ValueChanged<DateTime> selectDate;
  final ValueChanged<TimeOfDay> selectTime;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate)
      selectDate(picked);
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null && picked != selectedTime)
      selectTime(picked);
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle valueStyle = Theme.of(context).textTheme.title;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Expanded(
          flex: 4,
          child: _InputDropdown(
            labelText: labelText,
            valueText: DateFormat.yMMMd().format(selectedDate),
            valueStyle: valueStyle,
            onPressed: () { _selectDate(context); },
          ),
        ),
        // const SizedBox(width: 12.0),
        // Expanded(
        //   flex: 3,
        //   child: _InputDropdown(
        //     valueText: selectedTime.format(context),
        //     valueStyle: valueStyle,
        //     onPressed: () { _selectTime(context); },
        //   ),
        // ),
      ],
    );
  }
}


class BuatDonasi extends StatefulWidget {
  @override
  _BuatDonasiState createState() => _BuatDonasiState();
}

class _BuatDonasiState extends State<BuatDonasi> {
  // DateTime _fromDate = DateTime.now();
  DateTime _fromDate2 = DateTime.now();
  // TimeOfDay _fromTime = const TimeOfDay(hour: 7, minute: 28);

  File _imageFile;
  String _mySelection;

  String _idMember='';

  var user= List<InfoUserModel>();
  var _status='';

  _getData() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
     _idMember=(prefs.getString('id') ?? '');

    });
   _getCampaign();
   _getStatus();
  }

  TextEditingController contJudulCampaign = new TextEditingController();
  TextEditingController contidKategori = new TextEditingController();
  TextEditingController contlink = new TextEditingController();
  TextEditingController contnohp = new TextEditingController();
  TextEditingController contAjakan = new TextEditingController();
  TextEditingController contDeskripsi = new TextEditingController();
  var contTargetDonasi = new MoneyMaskedTextController(decimalSeparator: ',', thousandSeparator: '.');
  TextEditingController contTanggalMulai = new TextEditingController();
  TextEditingController contBatasWaktu = new TextEditingController();
  
  TextEditingController contFoto = new TextEditingController();

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
            children: [Text("Pick An Image"),
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

    _showProgress(BuildContext context, status){
    ProgressDialog pr = new ProgressDialog(context, ProgressDialogType.Normal);
    
    if(status=='show'){
      pr.setMessage('Please wait...');
    return pr.show();
    }else if(status=='hide'){
    return pr.hide();
    }
    
  }

    Future submitCampaign(File imageFile, context) async{
    var stream = new http.ByteStream(DelegatingStream.typed(imageFile.openRead()));
    var length = await imageFile.length();
    var uri = Uri.parse(URLAPI+"/API/submit_campaign.php");
    var request = new http.MultipartRequest("post", uri);
    var multiPartFile = new http.MultipartFile("image", stream, length, filename: basename(imageFile.path));
  request.fields['id_member']=_idMember;
    request.fields['id_kategori']=_mySelection;
    request.fields['link']=contlink.text;
    request.fields['judul_campaign'] = contJudulCampaign.text;
    request.fields['no_hp']=contnohp.text;
    request.fields['ajakan']=contAjakan.text;
    request.fields['deskripsi']=contDeskripsi.text;
    request.fields['target_donasi']=contTargetDonasi.numberValue.round().toString();
    request.fields['batas_waktu']=_fromDate2.toString().substring(0,10);
    request.files.add(multiPartFile);

    _showProgress(context, 'show');
    var response = await request.send();
    if(response.statusCode==200){
      print("image berhasil upload");
      Navigator.of(context).pop();
      Navigator.of(context).pushReplacementNamed('/home');
      Toast.show("Berhasil Mengajukan Campaign", context, duration: Toast.LENGTH_LONG, gravity: Toast.CENTER);
      
    }else{
      print("gagal");
    }
  }

    

  final String url = URLAPI+"/API/list_kategori.php";
  final _formkey= GlobalKey<FormState>();

  List data; 
   Future<String> getSWData() async {
    var res = await http
        .post(url);
    var resBody = json.decode(res.body);
    //var data2 =resBody['data'][0];

    setState(() {
      data = resBody['data'];
    });

    print(resBody);

    return "Sucess";
  }
  Future<dynamic> _kategori() async{
   
    
   
    final response =await http.post(URLAPI+'/API/list_kategori.php');
  //Map<String, dynamic> jsonResponse = convert.jsonDecode(response.body);

  Map userMap = json.decode(response.body);
   // var jsonResponse= convert.jsonDecode(response.body);
    if(response.statusCode==200){
      var success = userMap['success'];
      var data2 =userMap['data'][0];
      if (success == '1') {
        setState(() {
          data=data2;
        });
        print(data2);
       
      }else if(success == '0'){
        //print(jsonResponse);
      }
    }
 
    return userMap;
  }

  _getCampaign(){
    API.getKategori().then((responses){
      setState(() {
       final list = json.decode(responses.body); 
       print(list);
       setState(() {
        data=list['data']; 
       });
      //  campaigns = (list['data'] as List).map<Campaign>((json) => new Campaign.fromJson(json)).toList();
      //  print(campaigns);
      });
    });
  }

  _getStatus() async {
    //_getData();
    print('haha $_idMember');
    API.getInfoUser(_idMember).then((responses) {
      setState(() {
        print('gsgsg $_idMember');
        final list = json.decode(responses.body);
        print(list);
        user = (list['data'] as List).map<InfoUserModel>((
            json) => new InfoUserModel.fromJson(json)).toList();

        _status = user[0].status;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    //_getCampaign();
    _getData();
    print(data);
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Lets Giving'),
        backgroundColor: const Color(0xFF0091EA),
      ),
      bottomNavigationBar: Container(
      color: Theme.of(context).primaryColor,
      child: Row(
        children: <Widget>[
          Expanded(
            child: (_status=='lengkap' || _status=='ditolak') ? Builder(
              builder: (context) => FlatButton.icon(
                onPressed: (){
                  print(_fromDate2.toString().substring(0,10));
                  print(_mySelection);
                  print(_idMember);
                  print(contTargetDonasi.numberValue.round());
                  if(_formkey.currentState.validate()){
                  submitCampaign(_imageFile, context);
                  }
                  
                },
                icon: Icon(Icons.launch),
                label: Text("Ajukan Campaign"),
                textColor: Colors.white,
              ),
            ): Builder(
              builder: (context) => FlatButton.icon(
                onPressed: null,
                icon: Icon(Icons.launch),
                label: Text("Ajukan Campaign"),
                textColor: Colors.white,
              ),
            ),
          )
        ],
      ),
    ),
    body: DropdownButtonHideUnderline(
      child: SafeArea(
        top: false,
          bottom: false,
          child: Form(
            key: _formkey,
                      child: ListView(
               padding: const EdgeInsets.all(16.0),
               children: <Widget>[
                 (_status!='lengkap') ? Wrap(
                                spacing: 8.0,
                                runSpacing: 4.0,
                                direction: Axis.horizontal,
                                children: <Widget>[
                                  Chip(
                                      avatar: CircleAvatar(
                                        backgroundColor: Colors.grey.shade800,
                                        child: Icon(Icons.error),
                                      ),
                                      label: Text('Silahkan lengkapi diri anda dahulu.'),
                                    )
                                ],
                              ):SizedBox(height:2.0),
                 const SizedBox(height: 24.0,),
                  Text("Masukan Nama Campaign", style: TextStyle(fontSize: 15.0),),
                 const SizedBox(height: 24.0),
                  TextFormField(
                    controller: contJudulCampaign,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      filled: true,
                      hintText: 'Masukan nama campaign',
                      labelText: 'Nama Campaign *',
                    ),
                    validator: (value){
                      if(value.isEmpty){
                        return 'Nama Campaign tidak boleh kosong';
                      }
                    },
                  ),
                  const SizedBox(height: 24.0,),
                  Text("Masukan Target Donasi", style: TextStyle(fontSize: 15.0),),
                 const SizedBox(height: 24.0),
                  TextFormField(
                    controller: contTargetDonasi,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      filled: true,
                      hintText: 'Masukan Target Donasi',
                      labelText: 'Target Donasi*',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value){
                      if(value.isEmpty){
                        return 'Target donasi tidak boleh kosong';
                      }
                    },
                  ),
                  const SizedBox(height: 24.0,),
                  Text("Masukan Kategori", style: TextStyle(fontSize: 15.0),),
                 const SizedBox(height: 24.0),
                  (data!= null) ? DropdownButton(
                    items: data.map((item){
                      return DropdownMenuItem(
                        child: Text(item['nama_kategori']),
                        value: item['id_kategori'],
                        
                      );
                    }).toList(),
                    onChanged: (newVal){
                      setState(() {
                       _mySelection = newVal; 
                      });
                    },
                    value: _mySelection,
                    
                  ) : Center(child: CircularProgressIndicator(),),
                  const SizedBox(height: 24.0,),
                  Text("Masukan Batas Waktu ", style: TextStyle(fontSize: 15.0),),
                 const SizedBox(height: 24.0),
                _DateTimePicker(
                  labelText: 'Batas Waktu*',
                  selectedDate: _fromDate2,
                  
                  selectDate: (DateTime date) {
                    setState(() {
                      _fromDate2 = date;
                    });
                  },
                  
                ),
                const SizedBox(height: 24.0,),
                  Text("Masukan link ", style: TextStyle(fontSize: 15.0),),
                 const SizedBox(height: 24.0),
                  TextFormField(
                    validator: (value){
                      if(value.isEmpty){
                        return 'link campaign tidak boleh kosong';
                      }
                    },
                    controller: contlink,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      filled: true,
                      hintText: 'Masukan link',
                      labelText: 'Link Campaign*',
                    ),
                  ),
                  const SizedBox(height: 24.0,),
                  Text("Masukan no hp", style: TextStyle(fontSize: 15.0),),
                 const SizedBox(height: 24.0),
                  TextFormField(
                    validator: (value){
                      if(value.isEmpty){
                        return 'no hp tidak boleh kosong';
                      }
                    },
                    controller: contnohp,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                      border: UnderlineInputBorder(),
                      filled: true,
                      hintText: 'Masukan no hp',
                      labelText: 'No Hp*',
                    ),
                  ),
                  const SizedBox(height: 24.0,),
                  Text("Masukan ajakan", style: TextStyle(fontSize: 15.0),),
                 const SizedBox(height: 24.0),
                  TextFormField(
                    validator: (value){
                      if(value.isEmpty){
                        return 'ajakan tidak boleh kosong';
                      }else if(value.length > 160){
                        return 'tidak boleh lebih dari 160 karakter';
                      }
                    },
                    controller: contAjakan,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Masukan ajakan',
                      labelText: 'Ajakan Campaign*',
                      helperText: 'Isi ajakan untuk campaign anda',
                    ),
                    maxLines: 4,
                  ),
                  const SizedBox(height: 24.0,),
                  Text("Masukan Deskripsi Campaign", style: TextStyle(fontSize: 15.0),),
                  const SizedBox(height: 12.0,),
                  TextFormField(
                    validator: (value){
                      if(value.isEmpty){
                        return 'Deskripsi tidak boleh kosong';
                      }
                    },
                    controller: contDeskripsi,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Deskripsi',
                      helperText: 'Isi selengkap mungkin tentang deskripsi campaign.',
                      labelText: 'Deskripsi',
                    ),
                    maxLines: 9,
                  ),
                  OutlineButton(
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
                  SizedBox(height: 10.0,),
                  _imageFile == null ? Text("pick an image") 
                    : Image.file(
                      _imageFile,
                      fit: BoxFit.cover,
                      height: 300,
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.topCenter,
                    ),
                
               ],
            ),
          ),
      ),
    ),
      
    );
  }
}