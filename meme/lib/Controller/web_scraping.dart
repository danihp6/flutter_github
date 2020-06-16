import 'package:html/dom.dart';
import 'package:html/parser.dart';
import 'package:http/http.dart';

Future initiate() async {
  var client = Client();
  Response response = await client.get(
    'https://github.com/danihp6'
  );

  Document document = parse(response.body);

  var element = document.querySelectorAll('h2.mb-1');

  print(element);
}