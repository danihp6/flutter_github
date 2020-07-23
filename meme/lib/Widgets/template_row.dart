import 'package:flutter/material.dart';
import 'package:meme/Models/Template.dart';

class TemplateRow extends StatelessWidget {
  const TemplateRow({
    Key key,
    @required this.template,
  }) : super(key: key);

  final Template template;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      child: Padding(
        padding: const EdgeInsets.all(4),
        child: Row(
          children: <Widget>[
            Text('Plantilla      ${template.name}',
                style: TextStyle(fontSize: 20, color: Colors.white)),
            Expanded(
                child: Align(
              alignment: Alignment.centerRight,
              child: SizedBox(
                height: 40,
                child: FittedBox(
                  child: IconButton(
                    onPressed: () {},
                    padding: EdgeInsets.all(0),
                    color: Colors.white,
                    icon: Icon(
                      Icons.file_download,
                    ),
                  ),
                ),
              ),
            ))
          ],
        ),
      ),
    );
  }
}
