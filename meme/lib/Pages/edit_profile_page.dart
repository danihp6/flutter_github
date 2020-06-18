import 'dart:io';

import 'package:flutter/material.dart';
import 'package:meme/Controller/db.dart' as db;
import 'package:meme/Controller/storage.dart';
import 'package:meme/Models/User.dart';
import 'package:meme/Pages/images_gallery_page.dart';
import 'package:meme/Widgets/slide_left_route.dart';

class EditProfilePage extends StatefulWidget {
  User user;
  EditProfilePage({@required this.user});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  User _user;
  String _name;
  String _description;
  String _image;
  String _urlImage;
  File _file;
  TextEditingController _nameController, _descriptionController;

  @override
  void initState() {
    super.initState();
    _user = widget.user;
    _name = _user.getName();
    _nameController = new TextEditingController(text: _name);
    _description = _user.getDescription();
    _descriptionController = new TextEditingController(text: _description);
    _image = _user.getImage();
    _urlImage = _user.getUrlImage();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    editUser() {
      if(_file != null){
        deleteImage(_user.getUrlImage());
        uploadAvatarImage(_file).then((map) => db.editUser(_user.getId(), _name, _description, map['image'],map['url']));
      }
      else db.editUser(_user.getId(), _name, _description, _image,_urlImage);
      Navigator.pop(context);
    }

    editAvatar(File file){
      setState(() {
        _file = file;
      });
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        title: Text('Edita tu perfil'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            children: [
              GestureDetector(
                child: CircleAvatar(
                  backgroundImage: NetworkImage(_image),
                  radius: 40,
                ),
                onTap: ()=>Navigator.push(context, SlideLeftRoute(page:ImagesGalleryPage(onTap: null))),
              ),
              SizedBox(
                height: 10,
              ),
              Text('Cambiar foto del perfil'),
              SizedBox(
                height: 10,
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Nombre',
                ),
                controller: _nameController,
                onChanged: (name) => _name = name,
              ),
              SizedBox(
                height: 20,
              ),
              TextFormField(
                maxLines: 3,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Descripción',
                ),
                controller: _descriptionController,
                onChanged: (description) => _description = description,
              ),
              SizedBox(
                height: 40,
              ),
              RaisedButton(
                color: Colors.deepOrange,
                textColor: Colors.white,
                child: Text('Confirmar'),
                onPressed: editUser,
              )
            ],
          ),
        ),
      ),
    );
  }
}
