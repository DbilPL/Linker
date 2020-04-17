import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  AuthPage({Key key}) : super(key: key);

  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        color: Colors.black,
        elevation: 1.0,
        child: Container(
          height: 70.0,
          child: RaisedButton(
            color: Colors.black,
            child: Center(
              child: Text(
                'REGISTER',
                style: TextStyle(color: Colors.white, fontSize: 20.0),
              ),
            ),
            onPressed: () {},
            splashColor: Colors.white,
          ),
        ),
      ),
    );
  }
}
