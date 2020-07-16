import 'dart:io';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:media_gallery/media_gallery.dart';
import 'package:meme/Controller/db.dart';
import 'package:meme/Controller/media_storage.dart';
import 'package:meme/Models/User.dart';
import 'package:meme/Widgets/loading.dart';
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
  ImageMedia _media;
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
    gallery.getMediaGallery().then((_) {});
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
          _user.id, _userName, _description, _avatar, _avatarLocation, _media);
      Navigator.pop(context);
    }

    editAvatar(MyMedia media) async {
      _media = media;
      setState(() {});
      Navigator.pop(context);
    }

    Widget _buildImage() {
      print(_avatar);
      if (_media != null) return Image.memory(_media.image);
      if (_avatar != '')
        CachedNetworkImage(
          imageUrl: _avatar,
          placeholder: (context, url) => Loading(),
        );
      return Image.asset('assets/images/user.png');
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
                child: Column(
                  children: <Widget>[
                    SizedBox(
                        width: 120,
                        height: 120,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: _buildImage(),
                        )),
                    SizedBox(
                      height: 10,
                    ),
                    Text('Cambiar foto del perfil'),
                  ],
                ),
                onTap: () async => await Permission.storage.request().isGranted
                    ? Navigator.push(
                        context,
                        SlideLeftRoute(
                            page: GalleryPage(onMediaSelected: editAvatar)))
                    : null,
              ),
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
