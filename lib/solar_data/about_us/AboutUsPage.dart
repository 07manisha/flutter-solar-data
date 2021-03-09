import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AboutUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text('About Us')),
      body: Container(
        child: Column(
          children: <Widget>[
            FadeInImage.assetNetwork(
              placeholder: 'assets/solar_logo.png',
              image: 'assets/solar_logo.png',
              height: 145,
              fit: BoxFit.cover,
            ),
            Center(
              child: Container(
                margin: EdgeInsets.all(8.0),
                child: Container(
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      'App by Apkmonk.com.\n\nData and XML feed provided by HAMQSL.com',
                      textAlign: TextAlign.center,
                      style: TextStyle(

                        fontFamily: 'Raleway',
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
