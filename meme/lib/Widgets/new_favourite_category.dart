import 'package:flutter/material.dart';

class NewFavouriteCategory extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        behavior: HitTestBehavior.translucent,
        child: Container(
          height: 50,
          child: Row(
            children: [
              Icon(Icons.add),
              SizedBox(
                width: 10,
              ),
              Text('Añadir nueva categoria'),
            ],
          ),
        ),
        onTap: (){},
      );
  }
}