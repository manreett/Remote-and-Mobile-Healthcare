import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'dart:core';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'patientview.dart';
import 'docview.dart';
import 'user.dart';
import 'doc.dart';

final String URL = "http://68.183.205.184/index.php";

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late TextEditingController _emailController;
  late TextEditingController _nameController;
  late TextEditingController _passwordController;

  int i = 0;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _nameController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _attemptLogin(String name, String password, String email) async {
    try {
      final response = await http.post(
        Uri.parse(URL),
        body: {'username': name, 'password': password, 'email': email},
      );

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        if (result != null) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(result['message'])));
          print(result['doctor']);
          print(result['passwords']);
          // print(result['ecg_timestamp']);

          if (result['message'] == 'Successfully logged in' &&
              result['doctor'] == '') {
            String uname = result['username'];
            String eemail = result['email'];
            String pwd = result['password'];

            List<dynamic> dynamicList = result['bpm_data'];
            List<int> bpm =
                dynamicList.map((value) => int.parse(value)).toList();

            List<DateTime> bpm_time = List<DateTime>.from(
                result['bpm_timestamp'].map((time) => DateTime.parse(time)));

            List<int> ecg = List<int>.from(
                result['ecg_data'].map((data) => int.parse(data)));

            List<DateTime> ecg_time = List<DateTime>.from(
                result['ecg_timestamp'].map((time) => DateTime.parse(time)));

            List<int> red_value = List<int>.from(
                result['red_value'].map((time) => int.parse(time)));
            List<int> ir_value = List<int>.from(
                result['ir_value'].map((time) => int.parse(time)));
            List<DateTime> ppg_time = List<DateTime>.from(
                result['ppg_timestamp'].map((time) => DateTime.parse(time)));

            // create user object
            User user = User(
              name: uname,
              email: eemail,
              password: pwd,
              bpm: bpm,
              bpm_ts: bpm_time,
              ecg: ecg,
              ecg_ts: ecg_time,
              ir_val: ir_value,
              red_val: red_value,
              ppg_time: ppg_time,
            );

            // print(user.name);
            // print(user.email);
            // print(user.password);
            // print(user.bpm);
            // print(user.bpm_ts);
            // print(user.ecg);
            // print(user.ecg_ts);
            // print(user.ir_val);
            // print(user.red_val);
            // print(user.users);
            // print(user.emails);

            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => patientview(user: user)),
            );
          } else if (result['message'] == 'Successfully logged in' &&
              result['doctor'] == 'YES') {
            String uname = result['username'];
            String eemail = result['email'];
            String pwd = result['password'];

            List<String> users = List<String>.from(result['usernames']
                .map((dynamic element) => element.toString()));
            List<String> emails = List<String>.from(
                result['emails'].map((dynamic element) => element.toString()));

            Doc doc = Doc(
              name: uname,
              email: eemail,
              password: pwd,
              users: users,
              emails: emails,
            );

            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => docview(doc: doc)),
            );
          } else {
            print("no");
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Unable to retrieve any data from server")));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error: ${response.statusCode}")));
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Error: $e")));
    }
  }

  _onSignInButtonPressed() async {
    await _attemptLogin(_nameController.text, _passwordController.text, "");
  }

  void _onRegisterButtonPressed() async {
    if (i == 0) {
      setState(() {
        i = 1;
      });
    } else {
      setState(() {
        i = 0;
      });

      await _attemptLogin(_nameController.text, _passwordController.text,
          _emailController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: 'Enter Name',
              ),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                hintText: 'Enter Password',
              ),
            ),
            Visibility(
              visible: i == 1,
              child: TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: 'Enter Email',
                ),
              ),
            ),
            ElevatedButton(
              onPressed: _onSignInButtonPressed,
              // onPressed: () {
              //   _onSignInButtonPressed;
              // },
              child: Text("Sign In"),
            ),
            ElevatedButton(
              onPressed: _onRegisterButtonPressed,
              child: Text(i == 0 ? "Register" : "CREATE ACCOUNT"),
            ),
          ],
        ),
      ),
    );
  }

  List<int> parseIntArray(String input) {
    List<String> parts = input.split(',');
    List<int> result = [];

    for (String part in parts) {
      if (part.trim().isNotEmpty) {
        result.add(int.parse(part.trim()));
      }
    }

    return result;
  }

  List<String> parseStringArray(String input) {
    List<String> parts = input.split(',');
    List<String> result = [];

    for (String part in parts) {
      if (part.trim().isNotEmpty) {
        result.add(part.trim());
      }
    }

    return result;
  }

  List<DateTime> parseTimestamps(String input) {
    List<String> parts = input.split(',');
    List<DateTime> result = [];

    for (String part in parts) {
      if (part.trim().isNotEmpty) {
        result.add(DateTime.parse(part.trim()));
      }
    }

    return result;
  }
}
