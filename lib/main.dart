import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:solardata/solar_data/solar_data_stateful.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.orange,

      ),
      home: SolarDataStateful(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    FetchData();
    return Scaffold(
        appBar: AppBar(
          title: Text('Demo'),
        ),
      body: Container(
        child: Center(
          child: Text("Demo")
        )
      ),
    );
  }

  void FetchData() async {
    var response = await http
        .get('https://www.hamqsl.com/solarxml.php');
    if (response.statusCode == 200) {
     print(response.body);

    }
  }

}

