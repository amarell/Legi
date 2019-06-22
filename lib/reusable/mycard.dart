import 'package:legi/src/ui_widget/text_style.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class MyCard extends StatelessWidget {
  final String  tanggal, judul, kategori, sisaHari, status;
  final int danaTerkumpul, targetPencapaian;

  MyCard({ this.tanggal, this.judul, this.kategori,this.targetPencapaian,this.status, this.sisaHari, this.danaTerkumpul});

  @override
  Widget build(BuildContext context) {
    final NumberFormat formatter = NumberFormat.simpleCurrency(
        locale: Localizations.localeOf(context).toString(), name: 'Rp. ');
    return Material(
      elevation: 4.0,
      color: Colors.white,
      borderRadius: BorderRadius.all(
        Radius.circular(4.0),
      ),
      child: Stack(
        children: <Widget>[
          // Positioned(
          //   bottom: 5.0,
          //   right: 70.0,
          //   width: 120.0,
          //   child: Container(
          //     height: 120.0,
          //     decoration: BoxDecoration(
          //       image: DecorationImage(
          //         image: AssetImage('assets/paid.jpg'),
          //         colorFilter: ColorFilter.mode(
          //             Colors.black.withOpacity(0.3), BlendMode.dstATop),
          //       ),
          //     ),
          //   ),
          // ),
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(
                    top: 16.0, bottom: 0.0, left: 16.0, right: 16.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          tanggal,
                          style: boldBlackLargeTextStyle,
                        ),
                      ],
                    ),
                    Spacer(),
                    // ClipOval(
                    //   child: Image.asset(
                    //     'assets/profile_pic.jpg',
                    //     fit: BoxFit.cover,
                    //     height: 45.0,
                    //     width: 45.0,
                    //   ),
                    // ),
                  ],
                ),
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.only(
                    top: 8.0, bottom: 0.0, left: 16.0, right: 16.0),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          judul,
                          style: boldBlackLargeTextStyle,
                        ),
                        Row(
                          children: <Widget>[
                            Text(
                              kategori.toUpperCase(),
                              style: normalGreyTextStyle,
                            ),
                            SizedBox(
                              width: 5.0,
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 4.0, vertical: 1.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(1.0),
                                ),
                                border: Border.all(color: greyColor),
                              ),
                              child: Text(
                                sisaHari,
                                style: normalGreyTextStyle,
                              ),
                            )
                          ],
                        ),
                      ],
                    ),
                    Spacer(),
                    Text(
                      formatter.format(danaTerkumpul),
                      style: boldPurpleTextStyle,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 8.0,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  formatter.format(targetPencapaian),
                  style: boldPurpleTextStyle,
                ),
              ),
              SizedBox(
                height: 16.0,
              ),
              Divider(
                color: Colors.black,
                height: 0.0,
              ),
              Container(
                color: Colors.white,
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      status.toUpperCase(),
                      style: boldGreenLargeTextStyle,
                    ),
                    Icon(
                      Icons.keyboard_arrow_right,
                      color: Colors.green,
                    ),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
