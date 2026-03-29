import 'package:flutter/material.dart';

class PlaceholderPage extends StatelessWidget {
  final String text;
  
  const PlaceholderPage({
    super.key,
    this.text = '功能开发中',
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}