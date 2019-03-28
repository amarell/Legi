import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:legi/src/model/list_campaign_model.dart';
import 'package:legi/src/ui_widget/text_icon.dart';

class DetailCampaign extends StatefulWidget {
  
  DetailCampaign({Key key, this.campaign}) :super(key : key);
  final Campaign campaign;
  @override
  _DetailCampaignState createState() => _DetailCampaignState(
    campaign: this.campaign,
  );
}

class _DetailCampaignState extends State<DetailCampaign> {
  _DetailCampaignState({this.campaign});
  final campaign;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      backgroundColor: Colors.greenAccent[400],
        title: Text('Lets Giving'),
    ),
    body: CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          pinned: true,
          floating: false,
          expandedHeight: 256,
          flexibleSpace: FlexibleSpaceBar(
            background: Stack(
              fit: StackFit.expand,
              children: <Widget>[
                Image.asset('assets/images/ede581967c723778d5332717ac56e0c7.png', fit: BoxFit.cover,),
                // This gradient ensures that the toolbar icons are distinct
                  // against the background image.
                const DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment(0.0, -1.0),
                        end: Alignment(0.0, -0.4),
                        colors: <Color>[Color(0x60000000), Color(0x00000000)],
                      ),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  left: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    color: Color.fromRGBO(255, 255, 255, 0.5),
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Icon(
                          Icons.tag_faces,
                          size: 20,
                          color: Theme.of(context).accentColor,
                          ),
                        ),
                        Text(
                          campaign.nama_kategori,
                          style: Theme.of(context).textTheme.title,
                        )
                      ],
                    ),
                  ),
                ),
              ],
              ),
          ),
        ),
        SliverList(
          delegate: SliverChildListDelegate([
            Container(
              color: Colors.white,
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.only(bottom: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    campaign.judul_campaign,
                    style: Theme.of(context)
                        .textTheme
                        .title
                        .copyWith(fontSize: 24.0),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 16.0),
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(color: Colors.grey, width: 0.4),
                        bottom: BorderSide(color: Colors.grey, width: 0.4),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        TextIcon(
                          icon: FontAwesomeIcons.bed,
                          text: "Target Donasi: ${campaign.target_donasi ?? "#"} ",
                        ),
                        TextIcon(
                          icon: FontAwesomeIcons.shower,
                          text: "Batas waktu: ${campaign.batas_waktu ?? "#"} ",
                        ),
                        TextIcon(
                          icon: FontAwesomeIcons.car,
                          text: "Dibuat oleh:\n ${campaign.nama_user ?? "#"} ",
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              color: Colors.white,
              margin: const EdgeInsets.symmetric(vertical: 4.0),
              padding: const EdgeInsets.all(16),
            ),
          ]),
        ),
      ],
    )
      
    );
  }
}