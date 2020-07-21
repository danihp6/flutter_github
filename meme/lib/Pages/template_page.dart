import 'package:flutter/material.dart';
import 'package:meme/Models/Template.dart';

class TemplatePage extends StatelessWidget {
  TemplatePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GridView.builder(
        itemCount: templates.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
        itemBuilder: (context, index) {
          return Card(
            child: Image.asset(templates[index].front),
          );
        },
      ),
    );
  }
}