import 'package:flutter/material.dart';
import 'package:meme/Widgets/theme_changer.dart';
import 'package:provider/provider.dart';

// String colorModeToString(ColorMode colorMode) {
//   String string = colorMode.toString();
//   return string.substring(10, string.length);
// }


class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  ThemeMode themeMode;
  ThemeChanger themeChanger;

  @override
  void didChangeDependencies() {
    themeChanger = Provider.of<ThemeChanger>(context);
    themeMode = themeChanger.themeMode;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Configuración')),
        body: Column(children: <Widget>[
          RadioListTile(
              title: Text('Brillante',
                  style: Theme.of(context).textTheme.bodyText1),
              value: ThemeMode.light,
              groupValue: themeMode,
              onChanged: (newThemeMode) {
                setState(() {
                  themeChanger.themeMode = newThemeMode;
                });
              }),
          RadioListTile(
              title: Text('Oscuro',
                  style: Theme.of(context).textTheme.bodyText1),
              value: ThemeMode.dark,
              groupValue: themeMode,
              onChanged: (newThemeMode) {
                setState(() {
                  themeChanger.themeMode = newThemeMode;
                });
              }),
          RadioListTile(
              title: Text('Sistema',
                  style: Theme.of(context).textTheme.bodyText1),
              value: ThemeMode.system,
              groupValue: themeMode,
              onChanged: (newThemeMode) {
                setState(() {
                  themeChanger.themeMode = newThemeMode;
                });
              })
        ]));
  }
}
