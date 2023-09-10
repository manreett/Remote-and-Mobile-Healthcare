import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'docview.dart';
import 'patientview.dart';
import 'LoginPage.dart';
import 'package:http/http.dart' as http;

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: HomePage(),
  ));
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [
          Colors.blue,
          Colors.white,
        ],
      )),
      height: MediaQuery.of(context).size.height,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Column(children: <Widget>[
            ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image(image: AssetImage("assets/Logo.jpg"))),
            SizedBox(
              height: 20,
            ),
            Text(
              "Health Monitoring System \n Live a Better Tomorrow",
              style: TextStyle(
                color: Colors.blue,
                fontSize: 20,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LoginPage(title: 'Doctor')),
                  );
                },
                child: const Text('Doctor')),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => LoginPage(title: 'Patient')),
                  );
                },
                child: const Text('Patient'))
          ])
        ],
      ),
      // Container(
      //   height: MediaQuery.of(context).size.height / 3,
      //   decoration: BoxDecoration(
      //       image: DecorationImage(image: AssetImage("assets/Logo.jpg"))),
      // ),
    )));
  }
}
