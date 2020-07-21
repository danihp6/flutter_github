import 'dart:typed_data';

class Template {
  String _name;
  String _front;

  Template(name,front){
    this._name = name;
    this._front = front;
  }

  get name => this._name;

  get front => this._front;
}

Template president = Template('President','assets/images/president.png');

List<Template> templates = [president];