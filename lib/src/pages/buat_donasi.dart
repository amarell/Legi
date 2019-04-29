import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';

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
        const SizedBox(width: 12.0),
        Expanded(
          flex: 3,
          child: _InputDropdown(
            valueText: selectedTime.format(context),
            valueStyle: valueStyle,
            onPressed: () { _selectTime(context); },
          ),
        ),
      ],
    );
  }
}


class BuatDonasi extends StatefulWidget {
  @override
  _BuatDonasiState createState() => _BuatDonasiState();
}

class _BuatDonasiState extends State<BuatDonasi> {
  DateTime _fromDate = DateTime.now();
  DateTime _fromDate2 = DateTime.now();
  TimeOfDay _fromTime = const TimeOfDay(hour: 7, minute: 28);
  DateTime _toDate = DateTime.now();
  TimeOfDay _toTime = const TimeOfDay(hour: 7, minute: 28);

  TextEditingController contJudulCampaign = new TextEditingController();
  TextEditingController contidKategori = new TextEditingController();
  TextEditingController contlink = new TextEditingController();
  TextEditingController contnohp = new TextEditingController();
  TextEditingController contAjakan = new TextEditingController();
  TextEditingController contDeskripsi = new TextEditingController();
  TextEditingController contTargetDonasi = new TextEditingController();
  TextEditingController contTanggalMulai = new TextEditingController();
  TextEditingController contBatasWaktu = new TextEditingController();
  
  TextEditingController contFoto = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lets Giving'),
        backgroundColor: Colors.greenAccent[400],
      ),
      bottomNavigationBar: Container(
      color: Theme.of(context).primaryColor,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Builder(
              builder: (context) => FlatButton.icon(
                onPressed: (){
                  
                  
                },
                icon: Icon(Icons.launch),
                label: Text("CheckOut"),
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
          child: ListView(
             padding: const EdgeInsets.all(16.0),
             children: <Widget>[
               const SizedBox(height: 24.0,),
                Text("Masukan Nama Campaign", style: TextStyle(fontSize: 15.0),),
               const SizedBox(height: 24.0),
                TextFormField(
                  controller: contJudulCampaign,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    filled: true,
                    icon: Icon(Icons.person),
                    hintText: 'Masukan nama campaign',
                    labelText: 'Nama Campaign *',
                  ),
                ),
                const SizedBox(height: 24.0,),
                Text("Masukan jenis campaign", style: TextStyle(fontSize: 15.0),),
               const SizedBox(height: 24.0),
                TextFormField(
                  controller: contAjakan,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    filled: true,
                    icon: Icon(Icons.person),
                    hintText: 'Masukan Jenis',
                    labelText: 'Jenis Campaign*',
                  ),
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
                    icon: Icon(Icons.person),
                    hintText: 'Masukan target donasi',
                    labelText: 'Target Donasi*',
                  ),
                ),
                const SizedBox(height: 24.0,),
                Text("Masukan tanggal mulai", style: TextStyle(fontSize: 15.0),),
               const SizedBox(height: 24.0),
                TextField(
                decoration: const InputDecoration(
                  labelText: 'Tanggal Mulai',
                ),
                style: Theme.of(context).textTheme.display1.copyWith(fontSize: 20.0),
              ),
              _DateTimePicker(
                labelText: 'From',
                selectedDate: _fromDate,
                selectedTime: _fromTime,
                selectDate: (DateTime date) {
                  setState(() {
                    _fromDate = date;
                  });
                },
                selectTime: (TimeOfDay time) {
                  setState(() {
                    _fromTime = time;
                  });
                },
              ),
              const SizedBox(height: 24.0),
                TextField(
                decoration: const InputDecoration(
                  labelText: 'Batas Waktu',
                ),
                style: Theme.of(context).textTheme.display1.copyWith(fontSize: 20.0),
              ),
              _DateTimePicker(
                labelText: 'to',
                selectedDate: _fromDate2,
                selectedTime: _fromTime,
                selectDate: (DateTime date) {
                  setState(() {
                    _fromDate2 = date;
                  });
                },
                selectTime: (TimeOfDay time) {
                  setState(() {
                    _fromTime = time;
                  });
                },
              ),
              const SizedBox(height: 24.0,),
                Text("Masukan link ", style: TextStyle(fontSize: 15.0),),
               const SizedBox(height: 24.0),
                TextFormField(
                  controller: contlink,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    filled: true,
                    icon: Icon(Icons.person),
                    hintText: 'Masukan link',
                    labelText: 'Link Campaign*',
                  ),
                ),
                const SizedBox(height: 24.0,),
                Text("Masukan no hp", style: TextStyle(fontSize: 15.0),),
               const SizedBox(height: 24.0),
                TextFormField(
                  controller: contnohp,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    filled: true,
                    icon: Icon(Icons.person),
                    hintText: 'Masukan no hp',
                    labelText: 'No Hp*',
                  ),
                ),
                const SizedBox(height: 24.0,),
                Text("Masukan ajakan", style: TextStyle(fontSize: 15.0),),
               const SizedBox(height: 24.0),
                TextFormField(
                  controller: contAjakan,
                  textCapitalization: TextCapitalization.words,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    filled: true,
                    icon: Icon(Icons.person),
                    hintText: 'Masukan ajakan',
                    labelText: 'Ajakan Campaign*',
                  ),
                ),
                const SizedBox(height: 24.0,),
                Text("Masukan Jumlah Donasi", style: TextStyle(fontSize: 15.0),),
                const SizedBox(height: 12.0,),
                TextFormField(
                  controller: contDeskripsi,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: 'Tell us about deskripsi',
                    helperText: 'Keep it short, this is just a demo.',
                    labelText: 'Deskripsi',
                  ),
                  maxLines: 3,
                ),
                OutlineButton(
                  onPressed: (){},
                  borderSide: BorderSide(color: Theme.of(context).accentColor, width: 2.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.camera_alt),
                      SizedBox(width: 5.0,),
                      Text('Add Image'),


                    ],
                  ),
                )
              
             ],
          ),
      ),
    ),
      
    );
  }
}