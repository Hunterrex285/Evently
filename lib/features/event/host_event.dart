import 'package:flutter/material.dart';

class HostEvent extends StatefulWidget {
  const HostEvent({super.key});

  @override
  State<HostEvent> createState() => _HostEventState();
}

class _HostEventState extends State<HostEvent> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Host Event Page'),
      ),
    );
  }
}