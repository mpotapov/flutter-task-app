import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/auth.dart';

class AuthForm extends StatefulWidget {
  @override
  _AuthState createState() => _AuthState();
}

class _AuthState extends State<AuthForm> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  bool _loginPage = true;
  bool _submitting = false;
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };

  void _submit() async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _submitting = true;
    });
    try {
      if (_loginPage) {
        await Provider.of<Auth>(context, listen: false).signin(
          _authData['email'],
          _authData['password'],
        );
      } else {
        await Provider.of<Auth>(context, listen: false).signup(
          _authData['email'],
          _authData['password'],
        );
      }
    } catch (err) {
      showDialog(
        context: context,
        child: AlertDialog(
          title: const Text('Error'),
          content: Text(err is String ? err : 'Something went wrong!'),
          actions: <Widget>[
            FlatButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _submitting = false;
                });
              },
            )
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final _deviceData = MediaQuery.of(context);

    return Center(
      child: SingleChildScrollView(
        child: Container(
          width: _deviceData.size.width * 0.80,
          height: _deviceData.size.height * 0.5,
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  height: _deviceData.size.height * 0.06,
                  child: FittedBox(
                    fit: BoxFit.fitHeight,
                    child: Text(
                      _loginPage ? 'Sign in' : 'Sign up',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Container(
                  height: _deviceData.size.height * 0.1,
                  child: TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    validator: (val) {
                      if (val.isEmpty || !val.contains('@')) {
                        return 'Invalid email!';
                      }
                      return null;
                    },
                    onSaved: (val) => _authData['email'] = val,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(),
                      ),
                      fillColor: Colors.white,
                      filled: true,
                      labelStyle:
                          TextStyle(fontSize: _deviceData.size.height * 0.03),
                      hintText: 'E-mail',
                      hintStyle:
                          TextStyle(fontSize: _deviceData.size.height * 0.03),
                    ),
                  ),
                ),
                Container(
                  height: _deviceData.size.height * 0.1,
                  child: TextFormField(
                    validator: (val) {
                      if (val.isEmpty || val.length < 5) {
                        return 'Password is too short!';
                      }
                      return null;
                    },
                    onSaved: (val) => _authData['password'] = val,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(),
                      ),
                      fillColor: Colors.white,
                      filled: true,
                      hintText: 'Password',
                      hintStyle:
                          TextStyle(fontSize: _deviceData.size.height * 0.03),
                    ),
                    obscureText: true,
                  ),
                ),
                Container(
                  height: _deviceData.size.height * 0.1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Login / Register',
                        style: TextStyle(
                          fontSize: _deviceData.size.height * 0.035,
                        ),
                      ),
                      Switch(
                        value: _loginPage,
                        onChanged: (_) => setState(() {
                          _loginPage = !_loginPage;
                        }),
                      ),
                    ],
                  ),
                ),
                FlatButton(
                  padding: EdgeInsets.symmetric(
                      vertical: _deviceData.size.height * 0.02),
                  child: _submitting
                      ? LinearProgressIndicator(
                          backgroundColor: Theme.of(context).primaryColor,
                        )
                      : Center(
                          child: Text(
                            _loginPage ? 'LOG IN' : 'REGISTER',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                            textScaleFactor: 1.2,
                          ),
                        ),
                  onPressed: _submit,
                  color: Theme.of(context).accentColor,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
