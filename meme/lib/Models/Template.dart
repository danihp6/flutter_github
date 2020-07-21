import 'dart:typed_data';

import 'package:meme/Controller/navigator.dart';

class Template {
  String _name;
  String _front;
  Function _goTemplate;

  Template(name,front,goTemplate){
    this._name = name;
    this._front = front;
    this._goTemplate = goTemplate;
  }

  get name => this._name;

  get front => this._front;

  get goTemplate => this._goTemplate;
}

Template president = Template('President','assets/templates/president.png',navigator.goOverImageCamera);

Template fish = Template('Fish','assets/templates/fish.png',navigator.goTemplateFixText);

List<Template> templates = [president,fish];