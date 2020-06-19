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
  String _userName;
  String _description;
  String _avatar;
  String _avatarLocation;
  File _file;
  TextEditingController _nameController, _descriptionController;

  @override
  void initState() {
    super.initState();
    _user = widget.user;
    _userName = _user.getUserName();
    _nameController = new TextEditingController(text: _userName);
    _description = _user.getDescription();
    _descriptionController = new TextEditingController(text: _description);
    _avatar = _user.getAvatar();
    _avatarLocation = _user.getAvatarLocation();
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
        deleteFile(_user.getAvatarLocation());
        uploadAvatar(_file).then((map) => db.editUser(_user.getId(), _userName, _description, map['media'],map['location']));
      }
      else db.editUser(_user.getId(), _userName, _description, _avatar,_avatarLocation);
      Navigator.pop(context);
    }

    editAvatar(File file){
      setState(() {
        _file = file;
      });
      Navigator.pop(context);
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
                  backgroundImage: _file == null?NetworkImage(_avatar):FileImage(_file),
                  radius: 40,
                ),
                onTap: ()=>Navigator.push(context, SlideLeftRoute(page:ImagesGalleryPage(onTap: editAvatar))),
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
                onChanged: (name) => _userName = name,
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
