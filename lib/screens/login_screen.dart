import 'package:chat_app/helpers/view_alert.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/services/socket_service.dart';
import 'package:chat_app/widgets/bottom_blue.dart';
import 'package:chat_app/widgets/custom_input.dart';
import 'package:chat_app/widgets/label.dart';
import 'package:chat_app/widgets/logo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xffF2F2F2),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.9,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Logo(title: 'Login'),
                  _Form(),
                  const Labels(
                    title: 'Create Account now!',
                    route: 'register',
                    subTitle: 'Not have Account ?',
                  ),
                  const Text(
                    'Terminus and Conditions of use ',
                    style: TextStyle(fontWeight: FontWeight.w200),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}

class _Form extends StatefulWidget {
  @override
  State<_Form> createState() => __FormState();
}

class __FormState extends State<_Form> {
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authservice = Provider.of<AuthService>(context);
    final socketservice = Provider.of<SocketService>(context);
    return Container(
        margin: const EdgeInsets.only(top: 40),
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          children: <Widget>[
            CustomInput(
                icon: Icons.email_outlined,
                placeholder: 'Email',
                keyboardType: TextInputType.emailAddress,
                textController: emailCtrl),
            CustomInput(
                icon: Icons.lock_outline,
                placeholder: 'Password',
                isPassword: true,
                textController: passCtrl),
            //Create Buttom
            BottomBlue(
                text: 'Login',
                onPressed: authservice.autentication
                    ? null
                    : () async {
                        // print(emailCtrl.text);
                        // print(passCtrl.text);
                        FocusScope.of(context).unfocus();
                        final loginOk = await authservice.login(
                            emailCtrl.text.trim(), passCtrl.text.trim());

                        if (loginOk) {
                          //Connect to Socket Server
                          socketservice.connect();
                          //Navigate to other Screen
                          Navigator.pushReplacementNamed(context, 'users');
                        } else {
                          //Alert
                          viewAlert(context, 'Login Incorrect',
                              'Verify your credentials');
                        }
                      }),
          ],
        ));
  }
}
