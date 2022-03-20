import 'package:chat_app/screens/screens.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: chackLoginState(context),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          return const Center(
            child: Text('Loading...'),
          );
        },
      ),
    );
  }

  Future chackLoginState(BuildContext context) async {
    final authservice = Provider.of<AuthService>(context, listen: false);

    final autenticated = await authservice.isLoggedIn();

    if (autenticated) {
      // Connect to Socket Server
      Navigator.pushReplacement(
          context,
          PageRouteBuilder(
              pageBuilder: (_, __, ___) => const UsersScreen(),
              transitionDuration: Duration(milliseconds: 0)));
    } else {
      Navigator.pushReplacement(
          context,
          PageRouteBuilder(
              pageBuilder: (_, __, ___) => const LoginScreen(),
              transitionDuration: Duration(milliseconds: 0)));
    }
  }
}
