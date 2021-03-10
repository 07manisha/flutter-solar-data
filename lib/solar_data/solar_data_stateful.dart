import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:solardata/solar_data/solar_calculated_condition_model.dart';
import 'package:solardata/solar_data/solar_prototype.dart';
import 'package:solardata/solar_data/terms_conditions/terms_condition_page.dart';
import 'package:xml2json/xml2json.dart';

import 'about_us/AboutUsPage.dart';
import 'model/vhf_model.dart';

class SolarDataStateful extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SolarDataStateful();
  }
}

class _SolarDataStateful extends State<SolarDataStateful> {
  SolarPrototype solarPrototypeObj;
  Xml2Json xml2json = new Xml2Json();

  void fetchData() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
      }
    } on SocketException catch (_) {
      print('not connected');
      showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: Text("No Internet Connection!"),
          )
      );
    }
    try {
      String url1 = "https://www.hamqsl.com/solarxml.php";
      http.Response response = await http.get(url1);
      xml2json.parse(response.body);
      var jsonData = xml2json.toGData();
      print(jsonData);
      var data = json.decode(jsonData);
      print(data);

      final snackBar = SnackBar(duration: const Duration(seconds: 1),content: Text('Data Refreshed...'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

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

      var solarData = data['solar']['solardata'];

      // fetching the vhf conditoins and append it into a list
      List<VHFConditionsPrototype> _listVHFConditions =
          new List<VHFConditionsPrototype>();
      _listVHFConditions.clear();
      var vhfData = solarData['calculatedvhfconditions']['phenomenon'];
      for (int i = 0; i < vhfData.length; i++) {
        VHFConditionsPrototype vhfConditionsPrototype =
            new VHFConditionsPrototype(
                vhfData[i]['name'], vhfData[i]['location'], vhfData[i]['\$t']);
        print(vhfConditionsPrototype.toString());
        _listVHFConditions.add(vhfConditionsPrototype);
      }

      // fetching the calculated conditions values
      CalculatedConditionsFields calculatedConditionsFields =
          new CalculatedConditionsFields(
              solarData['geomagfield']['\$t'],
              solarData['signalnoise']['\$t'],
              solarData['muffactor']['\$t'],
              solarData['fof2']['\$t'],
              solarData['muf']['\$t']);

      SolarPrototype solarPrototype = new SolarPrototype(
          listResults,
          solarData['updated']['\$t'],
          solarData['solarflux']['\$t'],
          solarData['aindex']['\$t'],
          solarData['kindex']['\$t'],
          solarData['kindexnt']['\$t'],
          solarData['xray']['\$t'],
          solarData['sunspots']['\$t'],
          solarData['heliumline']['\$t'],
          solarData['protonflux']['\$t'],
          solarData['electonflux']['\$t'],
          solarData['aurora']['\$t'],
          solarData['normalization']['\$t'],
          solarData['latdegree']['\$t'],
          solarData['solarwind']['\$t'],
          solarData['magneticfield']['\$t'],
          _listVHFConditions,
          calculatedConditionsFields);

      setState(() {
        solarPrototypeObj = solarPrototype;
      });
    } catch (e) {
      final snackBar = SnackBar(duration: const Duration(seconds: 5),content: Text('Unable to load data...'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> _getData() async {
    setState(() {
      fetchData();
    });
  }

  Widget _buildWidget() {
    return solarPrototypeObj != null
        ? RefreshIndicator(
            child: Stack(
              children: <Widget>[ListView(), _widgetMainBody()],
            ),
            onRefresh: _getData,
          )
        : Center(child: CircularProgressIndicator());
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('HF Propagation'),
        actions: <Widget>[
          FlatButton(
            textColor: Colors.black,
            onPressed: () {_getData();},
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              // Replace with a Row for horizontal icon + text
              children: <Widget>[
                Center(child: Icon(Icons.refresh)),
              ],
            ),
            shape: CircleBorder(side: BorderSide(color: Colors.transparent)),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            Container(
                height: 100.0,
                margin: EdgeInsets.all(12.0),
                child: DrawerHeader(
                  child: Center(
                    child: Row(children: <Widget>[
                      FadeInImage.assetNetwork(
                        placeholder: 'assets/solar_logo.png',
                        image: 'assets/solar_logo.png',
                        height: 95,
                        fit: BoxFit.cover,
                      ),
                      Container(
                        margin: EdgeInsets.all(8),
                        child: Text(
                          'HF Propagation',
                          style: TextStyle(
                            fontFamily: 'Raleway',
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ]),
                  ),
                )),
            ListTile(
              leading: Icon(Icons.info),
              title: Text(
                'About Us',
                style: TextStyle(fontFamily: 'Raleway', fontSize: 16),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(_createRoute(AboutUsPage()));
              },
            ),
            ListTile(
              leading: Icon(Icons.privacy_tip),
              title: Text('Terms & Conditions',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Raleway',
                  )),
              onTap: () {
                Navigator.pop(context);
                Navigator.of(context).push(_createRoute(TermsConditionPage()));
              },
            ),
          ],
        ),
      ),
      body: Container(
        child: _buildWidget(),
      ),
    );
  }

  Route _createRoute(dynamic screen) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => screen,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        var curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: tween.animate(animation),
          child: child,
        );
      },
    );
  }

  Widget _widgetSolarIntroData() {
    return Container(
      margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
      child: Column(
        children: _widgetSolarIntroItems(solarPrototypeObj),
      ),
    );
  }

  Widget _widgetSolarIntroItem(String title, String value) {
    var colorTitle = Colors.black;
    if(value.contains("Closed")){
      colorTitle = Colors.red;
    }
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
                      fontFamily: 'Raleway',
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                Text(value,
                    style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Raleway',
                        color: colorTitle)),
              ],
            ),
            Divider(),
          ],
        ));
  }

  List<Widget> _widgetSolarIntroItems(SolarPrototype solarPrototype) {
    List<Widget> results = new List<Widget>();
    results
        .add(_widgetSolarIntroItem("Updated", solarPrototype.updated ?? '-'));
    results.add(
        _widgetSolarIntroItem("Solar Flux", solarPrototype.solarflux ?? '-'));
    results.add(_widgetSolarIntroItem("a Index", solarPrototype.aindex ?? '-'));
    results.add(_widgetSolarIntroItem("k Index", solarPrototype.kindex ?? '-'));
    results.add(
        _widgetSolarIntroItem("k Indexent", solarPrototype.kindexent ?? '-'));
    results.add(_widgetSolarIntroItem("X-Ray", solarPrototype.xray ?? '-'));
    results
        .add(_widgetSolarIntroItem("Sunspots", solarPrototype.sunspots ?? '-'));
    results.add(
        _widgetSolarIntroItem("Helium Line", solarPrototype.heliumline ?? '-'));
    results.add(
        _widgetSolarIntroItem("Proton Flux", solarPrototype.protonFlux ?? '-'));

    results.add(_widgetSolarIntroItem("Aurora", solarPrototype.aurora ?? '-'));
    results.add(_widgetSolarIntroItem(
        "Normalization", solarPrototype.normalization ?? '-'));
    results.add(
        _widgetSolarIntroItem("Lat Degree", solarPrototype.latdegree ?? '-'));
    results.add(
        _widgetSolarIntroItem("Solar Wind", solarPrototype.solarwind ?? '-'));
    results.add(_widgetSolarIntroItem(
        "Magnetic Field", solarPrototype.magneticfield ?? '-'));

    return results;
  }

  Widget _headerRowItem(String band, String day, String night) {
    return Container(
        child: Container(
      margin: EdgeInsets.fromLTRB(8.0, 2.0, 8.0, 2.0),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                width: 140,
                child: Center(
                  child: Text(
                    band,
                    style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'Raleway',
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Container(
                width: 100,
                child: Center(
                  child: Text(
                    day,
                    style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'Raleway',
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Container(
                width: 60,
                child: Text(
                  night,
                  style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Raleway',
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          Divider(),
        ],
      ),
    ));
  }

  Widget _buildWidgetsFromApi(context) {
    return Column(
      children:
          _listWidgetItems(solarPrototypeObj.solarCalculatedConditionModels),
    );
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
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                width: 140,
                child: Center(
                  child: Text(
                    banda,
                    style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'Raleway',
                        fontWeight: FontWeight.normal),
                  ),
                ),
              ),
              Container(
                width: 100,
                child: Center(
                  child: Text(day,
                      style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Raleway',
                          color: dayColor)),
                ),
              ),
              Container(
                width: 60,
                child: Text(night,
                    style: TextStyle(
                        fontSize: 16,
                        fontFamily: 'Raleway',
                        color: nightColor)),
              ),
            ],
          ),
          Divider(),
        ],
      ),
    ));
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

  Widget _widgetVHFData() {
    return Container(
      margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
      child: Column(
        children: _widgetVHFItems(solarPrototypeObj),
      ),
    );
  }

  List<Widget> _widgetVHFItems(SolarPrototype solarPrototype) {
    VHFModel vhfModel = new VHFModel(solarPrototype);
    List<Widget> results = new List<Widget>();
    results
        .add(_widgetSolarIntroItem("Aurora Lat", solarPrototype.latdegree?? '-'));
    results.add(_widgetSolarIntroItem("Aurora", vhfModel.auroraVal ?? '-'));
    results.add(_widgetSolarIntroItem("Europe", vhfModel.europeVal ?? '-'));
    results.add(_widgetSolarIntroItem(
        "North America", vhfModel.northAmericaVal ?? '-'));
    results
        .add(_widgetSolarIntroItem("Europe 6m", vhfModel.europee6mVal ?? '-'));
    results
        .add(_widgetSolarIntroItem("Europe 4m", vhfModel.europe4mVal ?? '-'));

    return results;
  }

  Widget _widgetCalculatedCondtionsData() {
    return Container(
      margin: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 10.0),
      child: Column(
        children: _widgetCalculatedCondition(solarPrototypeObj),
      ),
    );
  }

  List<Widget> _widgetCalculatedCondition(SolarPrototype solarPrototype) {
    CalculatedConditionsFields calculatedConditionsFields =
        solarPrototype.calculatedConditionsFields;
    List<Widget> results = new List<Widget>();
    results.add(_widgetSolarIntroItem("Geo-Magnetic Field",
        calculatedConditionsFields.geomagneticField ?? '-'));
    results.add(_widgetSolarIntroItem(
        "Signal Noise", calculatedConditionsFields.signalNoiseField ?? '-'));
    results.add(_widgetSolarIntroItem(
        "FoF2", calculatedConditionsFields.fof2Value ?? '-'));
    results.add(_widgetSolarIntroItem(
        "Muff-Factor", calculatedConditionsFields.muffactorFieldValue ?? '-'));
    results.add(_widgetSolarIntroItem(
        "Muf", calculatedConditionsFields.mufValue ?? '-'));

    return results;
  }

  Widget _widgetMainBody() {
    return Container(
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
                      "Solar Data",
                      style: TextStyle(
                          fontSize: 22,
                          fontFamily: 'Heading',
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
                      "HF Conditions",
                      style: TextStyle(
                          fontSize: 22,
                          fontFamily: 'Heading',
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor),
                    ),
                  ),
                ),
                Card(
                  child: Container(
                    margin: EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        _headerRowItem('Bands', 'Day', 'Night'),
                        _buildWidgetsFromApi(context),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.fromLTRB(8.0, 12.0, 8.0, 12.0),
                    child: Text(
                      "VHF Conditions",
                      style: TextStyle(
                          fontSize: 22,
                          fontFamily: 'Heading',
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor),
                    ),
                  ),
                ),
                Card(
                    child: Column(children: <Widget>[
                  _widgetVHFData(),
                ])),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.fromLTRB(8.0, 12.0, 8.0, 12.0),
                    child: Text(
                      "Calculated Conditions",
                      style: TextStyle(
                          fontSize: 22,
                          fontFamily: 'Heading',
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor),
                    ),
                  ),
                ),
                Card(
                  child: Column(
                    children: <Widget>[
                      _widgetCalculatedCondtionsData(),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.fromLTRB(8.0, 12.0, 8.0, 12.0),
                    child: Text(
                      "Copyright  Paul L Herrman ",
                      style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Raleway',
                          fontWeight: FontWeight.normal,
                          color: Theme.of(context).primaryColor),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
