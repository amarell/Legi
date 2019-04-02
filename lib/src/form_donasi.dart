import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FormDonation extends StatefulWidget {
  FormDonation({Key key, this.idCampaign}) : super(key: key);
  final idCampaign;
  @override
  _FormDonationState createState() => _FormDonationState(
    idCampaign: this.idCampaign,
  );
}

class _FormDonationState extends State<FormDonation> {
  _FormDonationState({this.idCampaign});
  final idCampaign;

   String _radioValue = "";

  TextEditingController jumlah_donasi = new TextEditingController();
  
  void _radioAction(String value){
    setState(() {
     _radioValue=value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final NumberFormat formatter = NumberFormat.simpleCurrency(
    locale: Localizations.localeOf(context).toString(), name: 'Rp. ');
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
                  print('clicked');
                  
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
                const SizedBox(height: 24.0,),
                Text("Masukan Jumlah Donasi", style: TextStyle(fontSize: 15.0),),
                const SizedBox(height: 12.0,),
                TextFormField(
                  controller: jumlah_donasi,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.attach_money),
                    border: OutlineInputBorder(),
                    labelText: 'Jumlah Donasi',
                    prefixText: '\Rp ',
                    helperText: 'Donasi Minimal Rp. 10.000',
                    suffixText: 'Rupiah',
                    suffixStyle: TextStyle(color: Colors.green),
                  ),
                  maxLines: 1,
                ),
                const SizedBox(height: 24.0),
                Text("Pilih Metode Pembayaran", style: TextStyle(fontSize: 15.0),),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Radio(
                      value: "1",
                      groupValue: _radioValue,
                      onChanged: (val){
                        print('radio $val');
                      },
                    ),
                    Text('Dompet'),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Radio(
                      value: "2",
                      groupValue: _radioValue,
                      onChanged: _radioAction,
                    ),
                    Text('Bank BNI'),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Radio(
                      value: "3",
                      groupValue: _radioValue,
                      onChanged: _radioAction,
                    ),
                    Text('Bank Mandiri'),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Radio(
                      value: "4",
                      groupValue: _radioValue,
                      onChanged: _radioAction,
                    ),
                    Text('Bank BCA'),
                      ],
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
}