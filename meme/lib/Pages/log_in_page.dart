import 'package:flutter/material.dart';
import 'package:meme/Controller/app_availability.dart';
import 'package:meme/Controller/db.dart';
import 'package:meme/Controller/navigator.dart';
import 'package:meme/Controller/push_notification_provider.dart';
import 'package:meme/Models/User.dart';
import 'package:meme/Pages/sign_in_page.dart';
import 'package:meme/Widgets/scroll_column_expandable.dart';
import 'package:meme/Widgets/slide_left_route.dart';
import '../Controller/auth.dart';
import '../Widgets/memes_header.dart';

class LogInPage extends StatefulWidget {
  @override
  _LogInPageState createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  String _email = '';
  String _password = '';
  final _formKey = GlobalKey<FormState>();
  String _emailError = '';
  String _passwordError = '';
  TextEditingController _emailController;
  TextEditingController _passwordController;
  bool _isLogIn = false;
  GlobalKey<ScaffoldState> scaffoldState = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: scaffoldState,
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
          child: ScrollColumnExpandable(
            children: [
              MemesHeader(),
              Expanded(
                flex: 2,
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 50, right: 50, top: 5),
                              child: TextFormField(
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    labelText: 'email',
                                    labelStyle: TextStyle(color: Colors.black),
                                    prefixIcon: Icon(Icons.email),
                                    suffixIcon: _emailController.text.length > 0
                                        ? IconButton(
                                            icon: Icon(Icons.clear),
                                            onPressed: () {
                                              setState(() {
                                                _email = '';
                                                _emailError = '';
                                                _emailController.clear();
                                              });
                                            })
                                        : null,
                                    errorText:
                                        _emailError != '' ? _emailError : null),
                                onChanged: (value) {
                                  setState(() {
                                    _email = value;
                                  });
                                },
                                validator: (value) {
                                  if (value.isEmpty)
                                    return 'El email no puede estar vacio';
                                  return null;
                                },
                                controller: _emailController,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 50, right: 50, top: 5),
                              child: TextFormField(
                                controller: _passwordController,
                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    labelText: 'contraseña',
                                    labelStyle: TextStyle(color: Colors.black),
                                    prefixIcon: Icon(Icons.lock),
                                    suffixIcon:
                                        _passwordController.text.length > 0
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
                                validator: (value) {
                                  if (value.isEmpty)
                                    return 'La contraseña no puede estar vacia';
                                  return null;
                                },
                              ),
                            ),
                            FlatButton(
                                onPressed: _email.isNotEmpty
                                    ? () async {
                                        try {
                                          await auth.resetPassword(_email);
                                          scaffoldState.currentState
                                              .showSnackBar(SnackBar(
                                            duration: Duration(seconds: 2),
                                            content: Container(
                                              height: 70,
                                              child: Column(
                                                children: <Widget>[
                                                  Center(
                                                      child: Text(
                                                          'Revisa tu correo para cambiar de contraseña',
                                                          style: TextStyle(
                                                              fontSize: 16))),
                                                  FlatButton(
                                                      onPressed: () async =>
                                                          await apps
                                                              .openEmailApp(
                                                                  context),
                                                      child: Text('Abrir gmail',
                                                          style: TextStyle(
                                                              fontSize: 18,
                                                              color:
                                                                  Colors.blue)))
                                                ],
                                              ),
                                            ),
                                          ));
                                        } catch (e) {
                                          showError(e);
                                        }
                                      }
                                    : () {
                                        setState(() {
                                          _emailError =
                                              'El email no puede estar vacio';
                                        });
                                      },
                                child: Text(
                                  'Has olvidado tu contraseña?',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.blue[600]),
                                )),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            RaisedButton(
                              onPressed: !_isLogIn
                                  ? () async {
                                      if (_formKey.currentState.validate()) {
                                        _isLogIn = true;
                                        setState(() {
                                          _emailError = '';
                                          _passwordError = '';
                                        });
                                        try {
                                          await auth.signIn(_email, _password);
                                        } catch (error) {
                                          showError(error);
                                        }
                                        _isLogIn = false;
                                      }
                                    }
                                  : null,
                              color: Colors.deepOrange,
                              textColor: Colors.white,
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Text(
                                  'Iniciar sesion',
                                  style: TextStyle(fontSize: 30),
                                ),
                              ),
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
                                      try {
                                        await auth.signInWithGoogle();
                                      } catch (e) {
                                        print(e.toString());
                                        print('problemas de conexion');
                                      }
                                    })
                              ],
                            ),
                            FlatButton(
                              onPressed: () => navigator.goSignIn(context),
                              child: Text(
                                'Registrarse',
                                style: TextStyle(
                                    fontSize: 16, color: Colors.blue[600]),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void showError(error) {
    setState(() {
      _emailError = '';
      _passwordError = '';
      switch (error.code) {
        case 'ERROR_INVALID_EMAIL':
          _emailError = 'Email incorrecto';
          break;
        case 'ERROR_WRONG_PASSWORD':
          _passwordError = 'Contraseña incorrecta';
          break;
        case 'ERROR_USER_NOT_FOUND':
          _emailError = 'Email no registrado, porfavor registrate';
          break;
        case 'ERROR_USER_DISABLED':
          _emailError = 'Usuario deshabilitado, consulte con ...';
          break;
        case 'ERROR_TOO_MANY_REQUESTS':
          _emailError = 'Demasiados intentos, intentelo más tarde';
          break;
        case 'ERROR_OPERATION_NOT_ALLOWED':
          _email = 'Email no permitido';
          break;
        default:
          print('problemas de conexión');
      }
    });
  }
}
