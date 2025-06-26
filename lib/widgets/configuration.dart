import 'package:flutter/material.dart';

class Configuration extends StatelessWidget {
  const Configuration({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Configuraciones",
          style: Theme.of(context).textTheme.titleLarge?.copyWith(),
        ),
        leading: IconButton(
          icon: Icon(Icons.home),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center)),
    );
  }
}
