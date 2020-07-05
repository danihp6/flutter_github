import 'package:flutter/material.dart';
import 'package:meme/Controller/auth.dart';
import '../Controller/db.dart';

class AccountPage extends StatefulWidget {

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
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
      body: Center(
        child: Column(
          children: <Widget>[
            FlatButton(
              onPressed: () => showDialog(
                context: context,
                builder: (context) => StatefulBuilder(
                  builder: (context, setState) => AlertDialog(
                    content: SizedBox(
                      height: 135,
                      child: Column(
                        children: <Widget>[
                          Text(
                              'Seguro que quiere eliminar su cuenta? No podrás recuperarla'),
                          SizedBox(
                            height: 15,
                          ),
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
                                errorText: _passwordError != ''
                                    ? _passwordError
                                    : null),
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
                        onPressed: _passwordController.text.length>0? () async {
                          try {
                            auth.deleteUser(_password);
                            Navigator.pop(context);
                            Navigator.pop(context);
                          } catch (e) {
                            setState(() {
                              if (e.code == 'ERROR_WRONG_PASSWORD')
                                _passwordError = 'contraseña incorrecta';
                            });
                          }
                        }:null,
                      ),
                      FlatButton(
                        child: Text('Cancelar'),
                        onPressed: () {
                          _password = '';
                          _passwordError = '';
                          _passwordController.clear();
                          Navigator.pop(context);
                        },
                      )
                    ],
                  ),
                ),
              ),
              child: Text('Eliminar cuenta'),
            )
          ],
        ),
      ),
    );
  }
}
