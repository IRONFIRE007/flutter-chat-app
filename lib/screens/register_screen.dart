import 'package:chat_app/helpers/view_alert.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/services/socket_service.dart';
import 'package:chat_app/widgets/bottom_blue.dart';
import 'package:chat_app/widgets/custom_input.dart';
import 'package:chat_app/widgets/label.dart';
import 'package:chat_app/widgets/logo.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({Key? key}) : super(key: key);

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
                  const Logo(title: 'Register'),
                  _Form(),
                  const Labels(
                      title: 'Start Session now!',
                      subTitle: 'You have Account?',
                      route: 'login'),
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
  final nameCtrl = TextEditingController();

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
                icon: Icons.perm_identity,
                placeholder: 'Name',
                keyboardType: TextInputType.emailAddress,
                textController: nameCtrl),
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
                text: 'Regiter',
                onPressed: authservice.autentication
                    ? null
                    : () async {
                        print(nameCtrl.text);
                        print(emailCtrl.text);
                        print(passCtrl.text);
                        final registerOk = await authservice.register(
                            nameCtrl.text.trim(),
                            emailCtrl.text.trim(),
                            passCtrl.text.trim());

                        if (registerOk == true) {
                          //Connect to Socket Server
                          socketservice.connect();
                          Navigator.pushReplacementNamed(context, 'users');
                        } else {
                          viewAlert(context, 'Register Incorrect', registerOk);
                        }
                      }),
          ],
        ));
  }
}
