import 'package:flutter/material.dart';

import '../widgets/auth_form.dart';

class AuthScreen extends StatelessWidget {
  static const routeName = '/auth';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: SafeArea(
        child: AuthForm(),
      ),
    );
  }
}
