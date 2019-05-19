import 'package:flutter/material.dart';


class DompetDashboard extends StatefulWidget {
  @override
  _DompetDashboardState createState() => _DompetDashboardState();
}

class _DompetDashboardState extends State<DompetDashboard> {
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lets Giving'),
        backgroundColor: Colors.greenAccent[400],
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
                      Text('data'),SizedBox(height: 50,),
                      Divider(),
                      InkWell(
                        onTap: (){},
                        child: ListTile(
                          title: Text('Withdraw Dompet'),
                          leading: Icon(Icons.favorite, color: Colors.red,),
                        ),
                      ),
                      Divider(),
                      ExpansionTile(
                          title: const Text('Riwayat Dompet'),
                        backgroundColor: Theme.of(context).accentColor.withOpacity(0.025),
                        children: <Widget>[
                          InkWell(
                            onTap: (){},
                            child: ListTile(
                              title: Text('Tambah Saldo Dompet'),
                            ),
                          ),
                          InkWell(
                            onTap: (){},
                            child: ListTile(
                              title: Text('Donasi Dengan Dompet'),
                            ),
                          ),
                          InkWell(
                            onTap: (){},
                            child: ListTile(
                              title: Text('Withdraw Dompet'),
                            ),
                          ),
                        ],
                        ),
                      Divider(),
                      ExpansionTile(
                        title: const Text('Sublist'),
                        backgroundColor: Theme.of(context).accentColor.withOpacity(0.025),
                        children: const <Widget>[
                          ListTile(title: Text('One')),
                          ListTile(title: Text('Two')),
                          // https://en.wikipedia.org/wiki/Free_Four
                          ListTile(title: Text('Free')),
                          ListTile(title: Text('Four')),
                        ],
                      ),
                      Divider(),
                      const ListTile(title: Text('Bottom')),
                    ],
                  )
                ,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}