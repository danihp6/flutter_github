import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:meme/Controller/db.dart';
import 'package:meme/Controller/navigator.dart';
import 'package:meme/Models/User.dart';
import 'package:meme/Widgets/loading.dart';
import 'package:meme/Widgets/scroll_column_expandable.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:math' as math;

import '../Controller/gallery.dart';

class EditProfilePage extends StatefulWidget {
  User user;
  EditProfilePage({@required this.user});
  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  String _userName;
  String _description;
  String _avatar;
  ImageMedia _media;
  TextEditingController _nameController;
  TextEditingController _descriptionController;
  String _errorUserName = '';
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _userName = widget.user.userName;
    _description = widget.user.description;
    _avatar = widget.user.avatar;
    print('-------------avatar');
    print(widget.user.avatar);
    _nameController = TextEditingController(text: _userName);
    _descriptionController = TextEditingController(text: _description);
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future<bool> validate() async {
      setState(() {
        _errorUserName = '';
      });
      if (!await db.userNameExists(_userName) ||
          _userName == widget.user.userName) return true;
      setState(() {
        _errorUserName = 'Este nombre ya existe';
      });
      return false;
    }

    editAvatar(BuildContext context, Function media) async {
      _media = await media();
      setState(() {});
      navigator.pop(context);
    }

    Widget _buildImage() {
      print(_avatar);
      if (_media != null) return Image.memory(_media.image);
      if (_avatar != '')
        return CachedNetworkImage(
          imageUrl: _avatar,
          placeholder: (context, url) => Loading(),
        );
      return Image.asset('assets/images/user.png');
    }

    return Scaffold(
        appBar: AppBar(
          title: Text('Edita tu perfil'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: ScrollColumnExpandable(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                        height: 15,
                      ),
                      Text('Cambiar foto del perfil',
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1
                              .copyWith(fontSize: 15)),
                    ],
                  ),
                  onTap: () async =>
                      await Permission.storage.request().isGranted
                          ? navigator.goGallery(context, editAvatar)
                          : null,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: TextFormField(
                    maxLength: 15,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        .copyWith(fontSize: 16),
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Nombre',
                        suffixIcon: _nameController.text.length > 0
                            ? IconButton(
                                icon: Icon(Icons.clear),
                                onPressed: () {
                                  setState(() {
                                    _userName = '';
                                    _errorUserName = '';
                                    _nameController.clear();
                                  });
                                })
                            : null,
                        errorText:
                            _errorUserName != '' ? _errorUserName : null),
                    controller: _nameController,
                    onChanged: (name) {
                      setState(() {
                        _userName = name;
                        _errorUserName = '';
                      });
                    },
                    validator: (value) {
                      if (value.isEmpty)
                        return 'El nombre no puede estar vacio';

                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: TextFormField(
                      maxLines: 3,
                      style: Theme.of(context)
                          .textTheme
                          .bodyText1
                          .copyWith(fontSize: 16),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Descripción',
                        suffixIcon: _descriptionController.text.length > 0
                            ? IconButton(
                                icon: Icon(Icons.clear),
                                onPressed: () {
                                  setState(() {
                                    _description = '';
                                  });
                                  _descriptionController.clear();
                                })
                            : null,
                      ),
                      controller: _descriptionController,
                      onChanged: (description) {
                        setState(() {
                          _description = description;
                        });
                      }),
                ),
                RaisedButton(
                  color: Colors.deepOrange,
                  textColor: Colors.white,
                  child: Text('Confirmar'),
                  onPressed: () async {
                    if (_formKey.currentState.validate() && await validate()) {
                      db.editUser(widget.user.id, _userName, _description,
                          _avatar, _media);
                      navigator.pop(context);
                    }
                  },
                )
              ],
            ),
          ),
        ));
  }
}
