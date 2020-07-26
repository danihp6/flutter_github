import 'package:flutter/material.dart';
import 'package:meme/Controller/navigator.dart';
import 'package:meme/Models/User.dart';
import 'package:meme/Widgets/scroll_column_expandable.dart';
import '../Controller/auth.dart';
import '../Controller/db.dart';
import '../Controller/push_notification_provider.dart';
import '../Widgets/memes_header.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final _formKey = GlobalKey<FormState>();
  String _userName = '';
  String _email = '';
  String _password = '';
  String _userNameError = '';
  String _emailError = '';
  String _passwordError = '';
  TextEditingController _userNameController;
  TextEditingController _emailController;
  TextEditingController _passwordController;
  bool _isSignIn = false;

  @override
  void initState() {
    super.initState();
    _userNameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(40),
                  child: AppBar(
            title: Text('Registrarse'),
          ),
        ),
        body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [
                Colors.orange[200],
                Colors.orange[100],
                Colors.white
              ],
                  stops: [
                0.3,
                0.5,
                0.8
              ],
                  begin: FractionalOffset.topCenter,
                  end: FractionalOffset.bottomCenter)),
          child: Form(
            key: _formKey,
            child: ScrollColumnExpandable(
              children: [
                MemesHeader(),
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 50, right: 50,top:5),
                              child: TextFormField(
                                controller: _userNameController,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    labelText: 'nombre de usuario',
                                    prefixIcon: Icon(Icons.person),
                                    suffixIcon:
                                        _userNameController.text.length > 0
                                            ? IconButton(
                                                icon: Icon(Icons.clear),
                                                onPressed: () {
                                                  setState(() {
                                                    _userNameError = '';
                                                    _userNameController.clear();
                                                  });
                                                })
                                            : null,
                                    errorText: _userNameError != ''
                                        ? _userNameError
                                        : null),
                                onChanged: (value) {
                                  setState(() {
                                    _userName = value;
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
                              padding:
                                  const EdgeInsets.only(left: 50, right: 50,top:5),
                              child: TextFormField(
                                controller: _emailController,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    labelText: 'email',
                                    prefixIcon: Icon(Icons.email),
                                    suffixIcon: _emailController.text.length > 0
                                        ? IconButton(
                                            icon: Icon(Icons.clear),
                                            onPressed: () {
                                              setState(() {
                                                _emailError = '';
                                                _emailController.clear();
                                              });
                                            })
                                        : null,
                                    errorText:
                                        _emailError != '' ? _emailError : null),
                                onChanged: (value) {
                                  _email = value;
                                },
                                validator: (value) {
                                  if (value.isEmpty)
                                    return 'El email no puede estar vacio';
                                  return null;
                                },
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 50, right: 50,top:5),
                              child: TextFormField(
                                controller: _passwordController,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    labelText: 'password',
                                    prefixIcon: Icon(Icons.lock),
                                    suffixIcon:
                                        _passwordController.text.length > 0
                                            ? IconButton(
                                                icon: Icon(Icons.clear),
                                                onPressed: () {
                                                  setState(() {
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
                                validator: (value) {
                                  if (value.isEmpty)
                                    return 'La contraseña no puede estar vacia';
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            RaisedButton(
                              onPressed: !_isSignIn
                                  ? () async {
                                      _isSignIn = true;
                                      setState(() {
                                        _userNameError = '';
                                        _emailError = '';
                                        _passwordError = '';
                                      });
                                      if (_formKey.currentState.validate() &&
                                          await validateUserName()) {
                                        try {
                                          String token =
                                              await pushProvider.getToken();
                                          await auth.registerUser(
                                              new User(
                                                  _userName,
                                                  '',
                                                  '',
                                                  <String>[],
                                                  <String>[],
                                                  <String>[],
                                                  '',
                                                  DateTime.now(),
                                                  _email,
                                                  [token]),
                                              _password);

                                          navigator.pop(context);
                                        } catch (error) {
                                          showError(error);
                                        }
                                      }
                                      _isSignIn = false;
                                    }
                                  : null,
                              color: Colors.deepOrange,
                              textColor: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Text(
                                  'Registrarse',
                                  style: TextStyle(fontSize: 30),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'o iniciar sesion con',
                                  style: TextStyle(fontSize: 15),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                GestureDetector(
                                  child: SizedBox(
                                      height: 40,
                                      child: Image.asset(
                                          'assets/images/google.png')),
                                  onTap: () async {
                                    navigator.pop(context);
                                    await auth.signInWithGoogle();
                                  } 
                                )
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> validateUserName() async {
    setState(() {
      _userNameError = '';
      _emailError = '';
      _passwordError = '';
    });

    if (await db.userNameExists(_userName)) {
      setState(() {
        _userNameError = 'Este nombre ya existe';
      });

      return false;
    } else
      return true;
  }

  void showError(error) {
    setState(() {
      _userNameError = '';
      _emailError = '';
      _passwordError = '';

      switch (error.code) {
        case 'ERROR_WEAK_PASSWORD':
          _passwordError = 'Contraseña débil, almenos 6 carácteres';
          break;
        case 'ERROR_INVALID_EMAIL':
          _emailError = 'Email incorrecto';
          break;
        case 'ERROR_EMAIL_ALREADY_IN_USE':
          _emailError = 'Email ya en uso';
          break;
      }
    });
  }
}
