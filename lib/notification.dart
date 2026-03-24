import 'package:flutter/material.dart';

class Mynotification extends StatelessWidget {
  
  const Mynotification({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Center(child: Text("notifications")),),
      body: Text("data"),
    );
  }
}