import 'package:flutter/material.dart';
import 'package:meme/Controller/auth.dart';
import '../Controller/db.dart';

class SettingsPage extends StatefulWidget {
  Function refresh;
  SettingsPage({this.refresh});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String _password = '';
  String _passwordError = '';
  TextEditingController _passwordController;

  @override
  void initState() { 
    super.initState();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Configuración'),
      ),
      body: Column(
        children: <Widget>[
          FlatButton(
            onPressed: () => showDialog(
              context: context,
              builder: (context) => AlertDialog(
                content: SizedBox(
                  height: 110,
                  child: Column(
                    children: <Widget>[
                      Text(
                          'Seguro que quiere eliminar su cuenta? No podrá recuperarla'),
                          SizedBox(height: 10,),
                      TextField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20)),
                            labelText: 'contraseña',
                            prefixIcon: Icon(Icons.lock),
                            suffixIcon: _passwordController.text.length > 0
                                ? IconButton(
                                    icon: Icon(Icons.clear),
                                    onPressed: () {
                                      setState(() {
                                        _password = '';
                                        _passwordError = '';
                                        _passwordController.clear();
                                      });
                                    })
                                : null,
                            errorText:
                                _passwordError != '' ? _passwordError : null),
                        obscureText: true,
                        onChanged: (value) {
                          setState(() {
                            _password = value;
                          });
                        },
                      )
                    ],
                  ),
                ),
                actions: <Widget>[
                  FlatButton(
                    child: Text('Eliminar cuenta'),
                    onPressed: () {
                      try {
                        db.deleteUser(db.userId);
                        auth.deleteUser(_password);
                      } catch (e) {
                        _passwordError = e.toString();
                      }

                      Navigator.pop(context);
                      auth.signOut().then((_) => widget.refresh());
                    },
                  ),
                  FlatButton(
                    child: Text('Cancelar'),
                    onPressed: () => Navigator.pop(context),
                  )
                ],
              ),
            ),
            child: Text('Eliminar cuenta'),
          )
        ],
      ),
    );
  }
}
