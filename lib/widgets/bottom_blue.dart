import 'package:chat_app/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BottomBlue extends StatelessWidget {
  final String text;
  final Function()? onPressed;
  const BottomBlue({Key? key, required this.text, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authservice = Provider.of<AuthService>(context);
    return MaterialButton(
      elevation: 2,
      hoverElevation: 5,
      onPressed: onPressed,
      child: Container(
        width: double.infinity,
        height: 55,
        decoration: authservice.autentication
            ? BoxDecoration(
                color: Colors.grey, borderRadius: BorderRadius.circular(32))
            : BoxDecoration(
                color: Colors.blue, borderRadius: BorderRadius.circular(32)),
        child: Center(
          child: Text(text,
              style: const TextStyle(color: Colors.white, fontSize: 22)),
        ),
      ),
    );
  }
}
