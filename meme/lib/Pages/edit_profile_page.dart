import 'package:flutter/material.dart';
import 'package:meme/Controller/db.dart' as db;
import 'package:meme/Models/User.dart';

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
      db.editUser(_user.getId(), _name, _description, _image);
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
              CircleAvatar(
                backgroundImage: NetworkImage(_image),
                radius: 40,
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
