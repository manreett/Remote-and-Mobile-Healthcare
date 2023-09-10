import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'doc.dart';
import 'user.dart';
import 'LoginPage.dart';
import 'patientview.dart';
import 'package:http/http.dart' as http;

final String URL = "http://68.183.205.184/index.php";

class docview extends StatelessWidget {
  final Doc doc;

  const docview({Key? key, required this.doc}) : super(key: key);
  Future<void> _attemptLogin(
      BuildContext context, String name, String password, String email) async {
    final response = await http.post(
      Uri.parse(URL),
      body: {'username': name, 'password': password, 'email': email},
    );
    print("check1");
    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      print(result);
      if (result != null) {
        print(name);
        print("Working");
        // print(result['ecg_timestamp']);
        print(result);

        String uname = name;
        // String eemail = result['email'];
        // String pwd = result['password'];
        print("testttt");
        List<dynamic> dynamicList = result['bpm_data'];
        List<int> bpm = dynamicList.map((value) => int.parse(value)).toList();

        List<DateTime> bpm_time = List<DateTime>.from(
            result['bpm_timestamp'].map((time) => DateTime.parse(time)));

        List<int> ecg =
            List<int>.from(result['ecg_data'].map((data) => int.parse(data)));

        List<DateTime> ecg_time = List<DateTime>.from(
            result['ecg_timestamp'].map((time) => DateTime.parse(time)));

        List<int> red_value =
            List<int>.from(result['red_value'].map((time) => int.parse(time)));
        List<int> ir_value =
            List<int>.from(result['ir_value'].map((time) => int.parse(time)));
        List<DateTime> ppg_time = List<DateTime>.from(
            result['ppg_timestamp'].map((time) => DateTime.parse(time)));

        // create user object
        User user = User(
          name: uname,
          // email: eemail,
          // password: pwd,
          bpm: bpm,
          bpm_ts: bpm_time,
          ecg: ecg,
          ecg_ts: ecg_time,
          ir_val: ir_value,
          red_val: red_value,
          ppg_time: ppg_time,
        );

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => patientview(user: user)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    print(doc.users);
    print(doc.emails);

    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Doctor View"),
      ),
      body: Container(
        color: Colors.white,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: doc.users.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                  title: Text("User Profile"),
                                  content: Text(doc.users[index] +
                                      " \n" +
                                      doc.emails[index]),
                                  actions: [
                                    TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: Text("Close")),
                                    TextButton(
                                      onPressed: () async {
                                        await _attemptLogin(
                                            context, doc.users[index], "", "");
                                      },
                                      child: Text("View Details"),
                                    )
                                  ]));
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      padding: EdgeInsets.all(16.0),
                    ),
                    child: Column(
                      children: [
                        Text(
                          doc.users[index],
                          style: TextStyle(fontSize: 20),
                        ),
                        Text(
                          doc.emails[index],
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
