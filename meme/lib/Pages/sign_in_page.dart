import 'package:flutter/material.dart';
import 'package:meme/Models/User.dart';
import 'package:meme/Widgets/scroll_column_expandable.dart';
import '../Controller/auth.dart';

class SignInPage extends StatefulWidget {
  Function refresh;
  SignInPage({@required this.refresh});

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  String _userName = '';
  String _email = '';
  String _password = '';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Registrarse'),
          backgroundColor: Colors.deepOrange,
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
          child: ScrollColumnExpandable(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 60, right: 60, top: 40),
                      child: Image.asset(
                        'assets/images/bufon.png',
                      ),
                    ),
                    Text(
                      'JokeNet',
                      style: TextStyle(fontSize: 60, fontFamily: 'Maian'),
                    )
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 60, right: 60),
                            child: TextField(
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  labelText: 'nombre de usuario',
                                  prefixIcon: Icon(Icons.person)),
                              onChanged: (value) => _userName = value,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 60, right: 60),
                            child: TextField(
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  labelText: 'email',
                                  prefixIcon: Icon(Icons.email)),
                              onChanged: (value) => _email = value,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 60, right: 60),
                            child: TextField(
                              decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  labelText: 'password',
                                  prefixIcon: Icon(Icons.lock)),
                              obscureText: true,
                              onChanged: (value) => _password = value,
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
                            onPressed: () {
                              auth
                                  .registerUser(
                                      new User(
                                          _userName,
                                          '',
                                          '',
                                          <String>[],
                                          <String>[],
                                          <String>[],
                                          '',
                                          DateTime.now(),
                                          _email),
                                      _password)
                                  .then((_) {
                                widget.refresh();
                                Navigator.pop(context);
                              });
                            },
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
                                onTap: () {},
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
    );
  }
}
