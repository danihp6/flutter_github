import 'dart:io';

import 'package:flutter/material.dart';
import 'package:media_gallery/media_gallery.dart';
import 'package:meme/Controller/db.dart';
import 'package:meme/Controller/media_storage.dart';
import 'package:meme/Models/User.dart';
import 'package:permission_handler/permission_handler.dart';
import 'gallery_page.dart';
import 'package:meme/Widgets/slide_left_route.dart';
import 'package:meme/Widgets/user_avatar.dart';
import '../Controller/gallery.dart';
import '../Controller/image_functions.dart';

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
    _userName = _user.userName;
    _nameController = new TextEditingController(text: _userName);
    _description = _user.description;
    _descriptionController = new TextEditingController(text: _description);
    _avatar = _user.avatar;
    _avatarLocation = _user.avatarLocation;
    gallery.getMediaGallery().then((_) {
    });
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
      db.editUser(
          _user.id, _userName, _description, _avatar, _avatarLocation, _file);
      Navigator.pop(context);
    }

    editAvatar(Media media) async {
      File cropedImage = null;///////////
      if (cropedImage != null) _file = cropedImage;
      setState(() {});
      Navigator.pop(context);
    }

    image() {
      if (_file == null && _avatar == '')
        return AssetImage('assets/images/user.png');
      else if (_file == null) return NetworkImage(_avatar);
      return FileImage(_file);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Edita tu perfil'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            children: [
              GestureDetector(
                child: SizedBox(
                  width: 90,
                  height: 90,
                  child: CircleAvatar(
                    backgroundImage: image(),
                  ),
                ),
                onTap: () async => await Permission.storage.request().isGranted
                    ? Navigator.push(
                        context,
                        SlideLeftRoute(
                            page: GalleryPage(
                          onTap: editAvatar,
                          page: gallery.imagePage,
                        )))
                    : null,
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
