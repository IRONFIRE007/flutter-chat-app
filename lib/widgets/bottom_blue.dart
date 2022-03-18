import 'package:flutter/material.dart';

class BottomBlue extends StatelessWidget {
  final String text;
  final Function() onPressed;
  const BottomBlue({Key? key, required this.text, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      elevation: 2,
      hoverElevation: 5,
      onPressed: onPressed,
      child: Container(
        width: double.infinity,
        height: 55,
        decoration: BoxDecoration(
            color: Colors.blue, borderRadius: BorderRadius.circular(32)),
        child: Center(
          child: Text(text,
              style: const TextStyle(color: Colors.white, fontSize: 22)),
        ),
      ),
    );
  }
}
