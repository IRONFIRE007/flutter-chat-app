import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  final String title;
  const Logo({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
      width: 170,
      margin: EdgeInsets.only(top: 50),
      child: Column(
        children: <Widget>[
          const Image(image: AssetImage('assets/tag-logo.png')),
          Text(title, style: TextStyle(fontSize: 30)),
          const SizedBox(height: 20)
        ],
      ),
    ));
  }
}
