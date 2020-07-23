import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meme/Controller/navigator.dart';

enum TemplateType { OverImageCamera, Text }

class Template {
  String _id;
  String _name;
  String _image;
  TemplateType _type;
  DateTime _dateTime;

  Template(name, image, type) {
    this._name = name;
    this._image = image;
    this._type = type;
    _dateTime = DateTime.now();
  }

  Template.fromFirestore(DocumentSnapshot doc)
      : _id = doc.documentID,
        _name = doc.data['name'],
        _image = doc.data['image'],
        _type = toTemplateType(doc.data['type']),
        _dateTime = (doc.data['dateTime'] as Timestamp).toDate();

  Map<String, dynamic> toFirestore() => {
        'name': _name,
        'image': _image,
        'type': _type.toString(),
        'dateTime' : _dateTime
      };

  get id => this._id;

  String get name => this._name;

  get image => this._image;

  get goTemplate {
    switch (this._type) {
      case TemplateType.OverImageCamera:
        return navigator.goTemplateOverImageCamera;
        break;
      case TemplateType.Text:
        return navigator.goTemplateText;
        break;
      default:
        throw Exception('Template error');
    }
  }
}

List<Template> toTemplates(QuerySnapshot query) {
  return query.documents.map((doc) => Template.fromFirestore(doc)).toList();
}

TemplateType toTemplateType(String string) {
  switch (string) {
    case 'TemplateType.OverImageCamera':
      return TemplateType.OverImageCamera;
      break;
    case 'TemplateType.Text':
      return TemplateType.Text;
      break;
    default:
      throw Exception('Template error');
  }
}