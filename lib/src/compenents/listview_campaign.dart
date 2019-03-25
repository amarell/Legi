import 'package:flutter/material.dart';
import 'package:legi/src/model/list_campaign_model.dart';

class ListViewCampaign extends StatelessWidget {
  final List<Campaign> campaigns;

  ListViewCampaign({Key key, this.campaigns}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
          itemCount: campaigns.length,
          padding: const EdgeInsets.all(15.0),
          itemBuilder: (context, position) {
            return Column(
              children: <Widget>[
                Divider(height: 5.0),
                ListTile(
                  title: Text(
                    '${campaigns[position].judul_campaign}',
                    style: TextStyle(
                      fontSize: 22.0,
                      color: Colors.deepOrangeAccent,
                    ),
                  ),
                  subtitle: Text(
                    '${campaigns[position].target_donasi}',
                    style: new TextStyle(
                      fontSize: 18.0,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  leading: Column(
                    children: <Widget>[
                      CircleAvatar(
                        backgroundColor: Colors.blueAccent,
                        radius: 35.0,
                        child: Text(
                          'User ${campaigns[position].batas_waktu}',
                          style: TextStyle(
                            fontSize: 22.0,
                            color: Colors.white,
                          ),
                        ),
                      )
                    ],
                  ),
                  onTap: () => _onTapItem(context, campaigns[position]),
                ),
              ],
            );
          }),
      
    );
    
  }
  void _onTapItem(BuildContext context, Campaign campaigns) {
    Scaffold
        .of(context)
        .showSnackBar(new SnackBar(content: new Text(campaigns.id_campaign.toString() + ' - ' + campaigns.nama_user)));
  }
}