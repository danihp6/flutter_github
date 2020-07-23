import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:meme/Controller/db.dart';
import 'package:meme/Controller/local_storage.dart';
import 'package:meme/Controller/navigator.dart';
import 'package:meme/Models/Template.dart';
import 'package:meme/Widgets/loading.dart';
import 'package:toast/toast.dart';
import 'package:rxdart/rxdart.dart';
import 'package:transparent_image/transparent_image.dart';

class TemplatePage extends StatefulWidget {
  TemplatePage({Key key}) : super(key: key);

  @override
  _TemplatePageState createState() => _TemplatePageState();
}

class _TemplatePageState extends State<TemplatePage>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(40),
        child: AppBar(
          title: Text('Plantillas'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            if (storage.templates.length > 0) Text('Guardadas'),
            if (storage.templates.length > 0)
              Expanded(
                child: StreamBuilder(
                    stream: CombineLatestStream.list(storage.templates
                            .map((templateId) => db.getTemplate(templateId)))
                        .asBroadcastStream(),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) print(snapshot.error);
                      if (!snapshot.hasData) return Loading();
                      List<Template> templates = snapshot.data;
                      print(templates);
                      return GridView.builder(
                        itemCount: templates.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4),
                        itemBuilder: (context, index) {
                          return TemplateWidget(template: templates[index]);
                        },
                      );
                    }),
              ),
            Expanded(
              child: StreamBuilder(
                  stream: db.getTemplates(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) print(snapshot.error);
                    if (!snapshot.hasData) return Loading();
                    List<Template> templates = snapshot.data;
                    print(templates);
                    return GridView.builder(
                      itemCount: templates.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4),
                      itemBuilder: (context, index) {
                        return TemplateWidget(template: templates[index]);
                      },
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class TemplateWidget extends StatelessWidget {
  const TemplateWidget({
    Key key,
    @required this.template,
  }) : super(key: key);

  final Template template;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Column(
        children: <Widget>[
          Expanded(
            child: Stack(
              children: <Widget>[
                ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: CachedNetworkImage(
                        imageUrl: template.image,
                        placeholder: (context, url) =>
                            Image.memory(kTransparentImage),
                        fit: BoxFit.contain)),
                RawMaterialButton(
                    onPressed: () {},
                    elevation: 1,
                    fillColor: Colors.white.withOpacity(0.9),
                    child: Padding(
                      padding: const EdgeInsets.all(6),
                      child: Icon(
                        Icons.file_download,
                      ),
                    ),
                    shape: CircleBorder(),
                  ),
              ],
            ),
          ),
          Text(template.name, style: TextStyle(fontSize: 15))
        ],
      ),
      onTap: () => template.goTemplate(context, template),
      onLongPress: () {
        // if (!storage.templates
        //     .contains(templates[index].id))
        //   storage.templates =
        //       storage.templates + [templates[index].id];
        // setState(() {});
      },
    );
  }
}
