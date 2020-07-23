import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:meme/Controller/db.dart';
import 'package:meme/Controller/navigator.dart';
import 'package:meme/Models/Template.dart';
import 'package:meme/Widgets/loading.dart';
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
        padding: const EdgeInsets.all(4),
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
                    crossAxisCount: 4, mainAxisSpacing: 4, crossAxisSpacing: 4),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: CachedNetworkImage(
                            imageUrl: templates[index].image,
                            placeholder: (context, url) => Image.memory(kTransparentImage),
                            fit: BoxFit.contain)),
                    onTap: () =>
                        templates[index].goTemplate(context, templates[index]),
                  );
                },
              );
            }),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
