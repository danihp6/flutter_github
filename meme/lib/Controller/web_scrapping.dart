

import 'package:http/http.dart';
import 'package:html/parser.dart';

Future initiate() async {
  var client = Client();
  Response response = await client.get(
    'https://bigsta.net/account/danihp6/?hl=tr'
  );


  var document = parse(response.body);

  var element = document.querySelector('p').innerHtml;

  print(element);

}