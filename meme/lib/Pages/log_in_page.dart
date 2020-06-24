import 'package:flutter/material.dart';
import 'package:meme/Pages/sign_in_page.dart';
import 'package:meme/Widgets/scroll_column_expandable.dart';
import 'package:meme/Widgets/slide_left_route.dart';
import '../Controller/auth.dart';

class LogInPage extends StatefulWidget {
  Function refresh;
  LogInPage({@required this.refresh});

  @override
  _LogInPageState createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {
  String _email = '';
  String _password = '';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
                                  labelText: 'email',
                                  prefixIcon: Icon(Icons.email)),
                              onChanged: (value) => _email = value,
                            ),
                          ),
                          Column(
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 60, right: 60),
                                child: TextField(
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      labelText: 'contraseña',
                                      prefixIcon: Icon(Icons.lock)),
                                  obscureText: true,
                                  onChanged: (value) => _password = value,
                                ),
                              ),
                              FlatButton(
                                  onPressed: () {},
                                  child: Text(
                                    'Has olvidado tu contraseña?',
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.blue[600]),
                                  ))
                            ],
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          RaisedButton(
                            onPressed: () { auth.signIn(_email, _password).then((_) => widget.refresh());},
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
                                onTap: () {},
                              )
                            ],
                          ),
                          FlatButton(
                            onPressed: ()=>Navigator.push(context, SlideLeftRoute(page: SignInPage(refresh:widget.refresh))),
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
