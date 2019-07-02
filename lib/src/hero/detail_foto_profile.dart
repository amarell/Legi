import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';

class DetailFotoProfile extends StatefulWidget {
  final String tag;
  final String url;

  DetailFotoProfile({Key key, @required this.tag, @required this.url}) 
    : assert(tag != null), 
      assert(url != null), 
      super(key: key);

  @override
  _DetailFotoProfileState createState() => _DetailFotoProfileState();
}

class _DetailFotoProfileState extends State<DetailFotoProfile> {
  
   @override
  initState() {
    SystemChrome.setEnabledSystemUIOverlays([]);
    super.initState();
  }

  @override
  void dispose() {
    //SystemChrome.restoreSystemUIOverlays();
    SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Scaffold (
        body: Center(
          child: Hero(
            tag: widget.tag,
            child: CachedNetworkImage(
              imageUrl: widget.url,
              placeholder: (context, url)=>Center(child: Container(width: 32, height: 32,child: new CircularProgressIndicator())),
              errorWidget: (context, url, error) => new Icon(Icons.error),
            ),
          ),
        ),
      ),
      onTap: () {
        Navigator.pop(context);
      },
    );
  }
}