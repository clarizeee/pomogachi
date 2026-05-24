import 'package:flutter/material.dart';

class habitPage extends StatefulWidget {
  const habitPage({super.key});

  @override
  State<habitPage> createState() => _habitState();
}

class _habitState extends State<habitPage> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Daily tasks")),
      ),
      body: Text("habit page")
       );
  }
}