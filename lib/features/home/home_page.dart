import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),

      body: const Center(
        child: Text('Home Screen', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
