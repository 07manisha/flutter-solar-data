import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:solardata/solar_data/solar_calculated_condition_model.dart';
import 'package:solardata/solar_data/solar_prototype.dart';
import 'package:xml2json/xml2json.dart';

class SolarDataHome extends StatelessWidget {
  Xml2Json xml2json = new Xml2Json();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text('Solar Data')),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            Container(
                height: 100.0,
                child: DrawerHeader(
                  child: Center(
                      child: Text(
                    'Solar Live Data',
                    style: TextStyle(
                      fontFamily: 'Raleway',
                    ),
                  )),
                )),
            ListTile(
              leading: Icon(Icons.info),
              title: Text('About Us'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.privacy_tip),
              title: Text('Terms & Conditions'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: Container(
          margin: EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Container(
              child: Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      margin: EdgeInsets.fromLTRB(8.0, 12.0, 8.0, 12.0),
                      child: Text(
                        "Basic Info",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor),
                      ),
                    ),
                  ),
                  Card(
                      child: Column(children: <Widget>[
                    _widgetSolarIntroData(),
                  ])),
                  Divider(),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      margin: EdgeInsets.fromLTRB(8.0, 12.0, 8.0, 12.0),
                      child: Text(
                        "Calculated Solar Conditions",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor),
                      ),
                    ),
                  ),
                  Card(
                    child: Column(
                      children: <Widget>[
                        _rowItem('Bands', 'Day', 'Night'),
                        _buildWidgetsFromApi(context),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }

  Widget _widgetSolarIntroData() {
    return FutureBuilder<SolarPrototype>(
        future: getData(),
        builder: (context, AsyncSnapshot<SolarPrototype> snapshot) {
          if (snapshot.hasData) {
            return Container(
              margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
              child: Column(
                children: _widgetSolarIntroItems(snapshot.data),
              ),
            );
          } else {
            return CircularProgressIndicator();
          }
        });
  }

  List<Widget> _widgetSolarIntroItems(SolarPrototype solarPrototype) {
    List<Widget> results = new List<Widget>();
    results
        .add(_widgetSolarIntroItem("Updated", solarPrototype.updated ?? '-'));
    results.add(_widgetSolarIntroItem("Xray", solarPrototype.xray ?? '-'));
    results.add(
        _widgetSolarIntroItem("Solar Flux", solarPrototype.solarflux ?? '-'));
    results.add(
        _widgetSolarIntroItem("Solar Wind", solarPrototype.solarwind ?? '-'));
    results
        .add(_widgetSolarIntroItem("Sunspots", solarPrototype.sunspots ?? '-'));

    return results;
  }

  Widget _widgetSolarIntroItem(String title, String value) {
    return Container(
        margin: EdgeInsets.fromLTRB(8.0, 2.0, 8.0, 2.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  title,
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                Text(value,
                    style: TextStyle(fontSize: 16, color: Colors.black)),
              ],
            ),
            Divider(),
          ],
        ));
  }

  Widget _buildWidgetsFromApi(context) {
    return FutureBuilder<SolarPrototype>(
        future: getData(),
        builder: (context, AsyncSnapshot<SolarPrototype> snapshot) {
          if (snapshot.hasData) {
            return Column(
              children: _listWidgetItems(
                  snapshot.data.solarCalculatedConditionModels),
            );
          } else {
            return CircularProgressIndicator();
          }
        });
  }

  List<Widget> _listWidgetItems(List<SolarCalculatedConditionModel> results) {
    List<Widget> widgetList = new List<Widget>();
    widgetList.clear();
    for (SolarCalculatedConditionModel solarPrototype in results) {
      Widget current = _rowItem(
          solarPrototype.bands, solarPrototype.day, solarPrototype.night);
      widgetList.add(current);
    }
    return widgetList;
  }

  Widget _rowItem(String banda, String day, String night) {
    MaterialColor dayColor = Colors.green;
    MaterialColor nightColor = Colors.green;
    if (day.contains('Fair')) {
      dayColor = Colors.orange;
    } else if (day.contains('Good')) {
      dayColor = Colors.green;
    } else if (day.contains('Poor')) {
      dayColor = Colors.red;
    } else if (day.contains('Day')) {
      dayColor = Colors.blueGrey;
    }

    if (night.contains('Fair')) {
      nightColor = Colors.orange;
    } else if (night.contains('Good')) {
      nightColor = Colors.green;
    } else if (night.contains('Poor')) {
      nightColor = Colors.red;
    } else if (night.contains('Night')) {
      nightColor = Colors.blueGrey;
    }

    return Container(
        child: Container(
      margin: EdgeInsets.fromLTRB(8.0, 2.0, 8.0, 2.0),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                banda,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(day, style: TextStyle(fontSize: 16, color: dayColor)),
              Text(night, style: TextStyle(fontSize: 16, color: nightColor)),
            ],
          ),
          Divider(),
        ],
      ),
    ));
  }

  Future<SolarPrototype> getData() async {
    try {
      String url1 = "https://www.hamqsl.com/solarxml.php";
      http.Response response = await http.get(url1);
      xml2json.parse(response.body);
      var jsonData = xml2json.toGData();
      print(jsonData);
      var data = json.decode(jsonData);
      print(data);

      var results = data['solar']['solardata']['calculatedconditions']['band'];
      List<SolarCalculatedConditionModel> listResults =
          new List<SolarCalculatedConditionModel>();
      listResults.clear();
      Map<String, String> dayMap = new Map<String, String>();
      Map<String, String> nightMap = new Map<String, String>();
      for (int i = 0; i < results.length; i++) {
        print(results[i]);
        String currValue = results[i]['\$t'];
        if (results[i]['time'].toString().contains("day")) {
          dayMap.putIfAbsent(results[i]['name'], () => currValue);
        } else if (results[i]['time'].toString().contains('night')) {
          nightMap.putIfAbsent(results[i]['name'], () => currValue);
        }
      }
      dayMap.keys.forEach((element) {
        SolarCalculatedConditionModel prototype =
            new SolarCalculatedConditionModel(
                element, dayMap[element], nightMap[element]);
        listResults.add(prototype);
      });

      print(164);
      var solarData = data['solar']['solardata'];
      print(solarData['updated']['\$t']);
      print(solarData);
      print(solarData['solarflux']['\$t']);

      SolarPrototype solarPrototype = new SolarPrototype(
          listResults,
          solarData['updated']['\$t'],
          solarData['solarflux']['\$t'],
          solarData['xray']['\$t'],
          solarData['sunspots']['\$t']);

      return solarPrototype;
    } catch (e) {
      print(e);
    }
  }
}
