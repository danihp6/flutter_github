import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:image_picker/image_picker.dart';

class ContactPage extends StatefulWidget {
  ContactPage({Key key}) : super(key: key);

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  List<String> reasons = ['error', 'duda', 'otro'];
  String reason;
  String reasonError;
  String message = '';
  String messageError;
  TextEditingController messageController = TextEditingController();
  Uint8List image;
  String path;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          child: AppBar(
            title: Text('Contactar'),
          ),
          preferredSize: Size.fromHeight(40)),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 80, right: 80),
                  child: DropdownButtonFormField(
                    value: reason,
                    isExpanded: true,
                    iconSize: 30,
                    decoration: InputDecoration(
                        prefixIcon: reason == null ? Icon(Icons.label) : null,
                        labelText: 'motivo',
                        errorText: reasonError),
                    items: reasons
                        .map((reason) => DropdownMenuItem(
                            child: Text(reason), value: reason))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        reason = value;
                        reasonError = null;
                      });
                    },
                    validator: (value) {
                      if (value == null)
                        setState(() {
                          reasonError = 'Debe seleccionar un motivo';
                        });
                      return null;
                    },
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 40, right: 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: TextFormField(
                          controller: messageController,
                          decoration: InputDecoration(
                              labelText: 'mensaje',
                              prefixIcon:
                                  message.isEmpty ? Icon(Icons.message) : null,
                              errorText: messageError,
                              border: OutlineInputBorder()),
                          maxLines: 8,
                          onChanged: (value) {
                            setState(() {
                              message = value;
                              messageError = null;
                            });
                          },
                          validator: (value) {
                            if (value == '')
                              setState(() {
                                messageError =
                                    'Debe escribir algo en el mensaje';
                              });
                            return null;
                          },
                        ),
                      ),
                      IconButton(
                          icon: Icon(Icons.clear),
                          onPressed: () {
                            setState(() {
                              message = '';
                              messageError = null;
                              messageController.clear();
                            });
                          })
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Stack(alignment: AlignmentDirectional.bottomEnd, children: [
                  Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.black38),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        image: image != null
                            ? DecorationImage(
                                image: MemoryImage(image), fit: BoxFit.cover)
                            : null),
                    child: image == null
                        ? Icon(
                            Icons.image,
                            size: 40,
                          )
                        : null,
                  ),
                  SizedBox(
                    width: 50,
                    child: RawMaterialButton(
                      onPressed: () async {
                        var pickedFile = await ImagePicker()
                            .getImage(source: ImageSource.gallery);
                        path = pickedFile.path;
                        image = await pickedFile.readAsBytes();
                        setState(() {});
                      },
                      elevation: 1,
                      fillColor: Theme.of(context).accentColor,
                      child: FittedBox(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.add,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      shape: CircleBorder(),
                    ),
                  ),
                ]),
                SizedBox(
                  height: 30,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 100, right: 100),
                  child: FlatButton(
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        Email email = Email(
                          body: message,
                          subject: reason,
                          recipients: ['danihp6@gmail.com'],
                          attachmentPaths: path != null ? [path] : [],
                          isHTML: false,
                        );
                        FlutterEmailSender.send(email);
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Enviar',
                          style: TextStyle(fontSize: 20),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Icon(Icons.send)
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
