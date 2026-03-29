import 'package:flutter/material.dart';

class PlaceholderPage extends StatelessWidget {
  const PlaceholderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Text(
          '功能开发中',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
    );
  }
}