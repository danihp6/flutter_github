import 'package:flutter/material.dart';
import 'package:meme/Controller/auth.dart';
import 'package:meme/Controller/navigator.dart';
import 'package:meme/Widgets/loading.dart';
import '../Controller/db.dart';

class AccountPage extends StatelessWidget {
  GlobalKey<ScaffoldState> scaffoldState = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldState,
      appBar: AppBar(
        title: Text('Cuenta'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            children: <Widget>[
              FutureBuilder(
                future: auth.currentUserEmail(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) print(snapshot.error);
                  if (!snapshot.hasData) return Loading();
                  String email = snapshot.data;
                  return Text('Tu email: $email',style:Theme.of(context).textTheme.bodyText1.copyWith(fontSize: 16));
                },
              ),
              ChangePasswordButton(scaffoldState: scaffoldState),
              ChangeEmailButton(
                scaffoldState: scaffoldState,
              ),
              DeleteButton()
            ],
          ),
        ),
      ),
    );
  }
}

class DeleteButton extends StatefulWidget {
  @override
  _DeleteButtonState createState() => _DeleteButtonState();
}

class _DeleteButtonState extends State<DeleteButton> {
  TextEditingController _passwordController;
  String _passwordError = '';
  String _password = '';

  @override
  void initState() {
    _passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: () => showDialog(
        context: context,
        builder: (context) => StatefulBuilder(
          builder: (context, setState) => WillPopScope(
            onWillPop: reset,
            child: AlertDialog(
              content: SizedBox(
                height: 135,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                          errorText:
                              _passwordError != '' ? _passwordError : null),
                      obscureText: true,
                      onChanged: (value) {
                        _password = value;
                        setState(() {});
                      },
                    )
                  ],
                ),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text('Eliminar cuenta'),
                  onPressed: _passwordController.text.length > 0
                      ? () async {
                          try {
                            final user =
                                await auth.reauthCurrentUser(_password);
                            await auth.deleteUser(user);
                            navigator.pop(context);
                            navigator.pop(context);
                          } catch (e) {
                            print(e.code);
                            setState(() {
                              showError(e);
                            });
                          }
                        }
                      : null,
                ),
                FlatButton(child: Text('Cancelar'), onPressed: reset)
              ],
            ),
          ),
        ),
      ),
      child: Text('Eliminar cuenta',
          style: TextStyle(color: Theme.of(context).accentColor, fontSize: 16)),
    );
  }

  void showError(error) {
    setState(() {
      _passwordError = '';
      switch (error.code) {
        case 'ERROR_WRONG_PASSWORD':
          _passwordError = 'Contraseña incorrecta';
          break;
        case 'ERROR_TOO_MANY_REQUESTS':
          _passwordError = 'Demasiados intentos, intentelo más tarde';
          break;
      }
    });
  }

  Future<bool> reset() async {
    _password = '';
    _passwordError = '';
    _passwordController.clear();
    navigator.pop(context);
    return true;
  }
}

class ChangePasswordButton extends StatefulWidget {
  GlobalKey<ScaffoldState> scaffoldState;
  ChangePasswordButton({@required this.scaffoldState});
  @override
  _ChangePasswordButtonState createState() => _ChangePasswordButtonState();
}

class _ChangePasswordButtonState extends State<ChangePasswordButton> {
  TextEditingController _passwordController;
  String _passwordError = '';
  String _password = '';

  TextEditingController _newPasswordController;
  String _newPasswordError = '';
  String _newPassword = '';

  @override
  void initState() {
    _passwordController = TextEditingController();
    _newPasswordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _newPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: () => showDialog(
        context: context,
        builder: (context) => StatefulBuilder(
          builder: (context, setState) => WillPopScope(
            onWillPop: reset,
            child: AlertDialog(
              content: SizedBox(
                height: 190,
                width: 250,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text('Es necesaria su actual contraseña'),
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
                          errorText:
                              _passwordError != '' ? _passwordError : null),
                      obscureText: true,
                      onChanged: (value) {
                        _password = value;
                        setState(() {});
                      },
                    ),
                    TextField(
                      controller: _newPasswordController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20)),
                          labelText: 'nueva contraseña',
                          prefixIcon: Icon(Icons.lock),
                          suffixIcon: _newPasswordController.text.length > 0
                              ? IconButton(
                                  icon: Icon(Icons.clear),
                                  onPressed: () {
                                    setState(() {
                                      _newPassword = '';
                                      _newPasswordError = '';
                                      _newPasswordController.clear();
                                    });
                                  })
                              : null,
                          errorText: _newPasswordError != ''
                              ? _newPasswordError
                              : null),
                      obscureText: true,
                      onChanged: (value) {
                        _newPassword = value;
                        setState(() {});
                      },
                    )
                  ],
                ),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text('Cambiar contraseña'),
                  onPressed: _passwordController.text.length > 0 &&
                          _newPasswordController.text.length > 0
                      ? () async {
                          try {
                            final user =
                                await auth.reauthCurrentUser(_password);
                            await auth.changePassword(user, _newPassword);
                            navigator.pop(context);
                            widget.scaffoldState.currentState.showSnackBar(
                                SnackBar(
                                    duration: Duration(seconds: 2),
                                    content: Container(
                                        height: 40,
                                        child: Center(
                                            child:
                                                Text('Contraseña cambiada')))));
                          } catch (e) {
                            setState(() {
                              showError(e);
                            });
                          }
                        }
                      : null,
                ),
                FlatButton(
                  child: Text('Cancelar'),
                  onPressed: reset,
                )
              ],
            ),
          ),
        ),
      ),
      child: Text('Cambiar contraseña',
          style: TextStyle(color: Theme.of(context).accentColor, fontSize: 16)),
    );
  }

  void showError(error) {
    setState(() {
      _newPasswordError = '';
      _passwordError = '';

      switch (error.code) {
        case 'ERROR_WRONG_PASSWORD':
          _passwordError = 'Contraseña incorrecta';
          break;
        case 'ERROR_WEAK_PASSWORD':
          _passwordError = 'Contraseña débil, almenos 6 carácteres';
          break;
        case 'ERROR_TOO_MANY_REQUESTS':
          _passwordError = 'Demasiados intentos, intentelo más tarde';
          break;
      }
    });
  }

  Future<bool> reset() async {
    _password = '';
    _newPassword = '';
    _passwordError = '';
    _newPasswordError = '';
    _passwordController.clear();
    _newPasswordController.clear();
    navigator.pop(context);
    return true;
  }
}

class ChangeEmailButton extends StatefulWidget {
  GlobalKey<ScaffoldState> scaffoldState;
  ChangeEmailButton({@required this.scaffoldState});
  @override
  _ChangeEmailButtonState createState() => _ChangeEmailButtonState();
}

class _ChangeEmailButtonState extends State<ChangeEmailButton> {
  TextEditingController _passwordController;
  String _passwordError = '';
  String _password = '';

  TextEditingController _newEmailController;
  String _newEmailError = '';
  String _newEmail = '';

  @override
  void initState() {
    _passwordController = TextEditingController();
    _newEmailController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _newEmailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: () => showDialog(
        context: context,
        builder: (context) => StatefulBuilder(
          builder: (context, setState) => WillPopScope(
            onWillPop: reset,
            child: AlertDialog(
              content: SizedBox(
                height: 190,
                width: 250,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text('Es necesaria su contraseña'),
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
                          errorText:
                              _passwordError != '' ? _passwordError : null),
                      obscureText: true,
                      onChanged: (value) {
                        _password = value;
                        setState(() {});
                      },
                    ),
                    TextField(
                      controller: _newEmailController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20)),
                          labelText: 'nuevo email',
                          prefixIcon: Icon(Icons.email),
                          suffixIcon: _newEmailController.text.length > 0
                              ? IconButton(
                                  icon: Icon(Icons.clear),
                                  onPressed: () {
                                    setState(() {
                                      _newEmail = '';
                                      _newEmailError = '';
                                      _newEmailController.clear();
                                    });
                                  })
                              : null,
                          errorText:
                              _newEmailError != '' ? _newEmailError : null),
                      onChanged: (value) {
                        _newEmail = value;
                        setState(() {});
                      },
                    )
                  ],
                ),
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text('Cambiar email'),
                  onPressed: _passwordController.text.length > 0 &&
                          _newEmailController.text.length > 0
                      ? () async {
                          try {
                            final user =
                                await auth.reauthCurrentUser(_password);
                            await auth.changeEmail(user, _newEmail);
                            navigator.pop(context);
                            widget.scaffoldState.currentState.showSnackBar(
                                SnackBar(
                                    duration: Duration(seconds: 2),
                                    content: Container(
                                        height: 40,
                                        child: Center(
                                            child: Text('Email cambiado')))));
                          } catch (e) {
                            setState(() {
                              showError(e);
                            });
                          }
                        }
                      : null,
                ),
                FlatButton(
                  child: Text('Cancelar'),
                  onPressed: reset,
                )
              ],
            ),
          ),
        ),
      ),
      child: Text('Cambiar email',
          style: TextStyle(color: Theme.of(context).accentColor, fontSize: 16)),
    );
  }

  void showError(error) {
    setState(() {
      _newEmailError = '';
      _passwordError = '';

      switch (error.code) {
        case 'ERROR_WRONG_PASSWORD':
          _passwordError = 'Contraseña incorrecta';
          break;
        case 'ERROR_TOO_MANY_REQUESTS':
          _passwordError = 'Demasiados intentos, intentelo más tarde';
          break;
        case 'ERROR_WEAK_PASSWORD':
          _passwordError = 'Contraseña débil, almenos 6 carácteres';
          break;
        case 'ERROR_INVALID_EMAIL':
          _newEmailError = 'Email incorrecto';
          break;
        case 'ERROR_EMAIL_ALREADY_IN_USE':
          _newEmailError = 'Email ya en uso';
          break;
      }
    });
  }

  Future<bool> reset() async {
    _password = '';
    _newEmail = '';
    _passwordError = '';
    _newEmailError = '';
    _passwordController.clear();
    _newEmailController.clear();
    navigator.pop(context);
    return true;
  }
}
