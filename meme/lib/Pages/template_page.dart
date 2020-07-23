import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:meme/Controller/db.dart';
import 'package:meme/Controller/local_storage.dart';
import 'package:meme/Controller/navigator.dart';
import 'package:meme/Models/Template.dart';
import 'package:meme/Widgets/loading.dart';
import 'package:meme/Widgets/scroll_column_expandable.dart';
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
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
                child: Align(
                    alignment: Alignment.center,
                    child: Text('Guardadas', style: TextStyle(fontSize: 18)))),
            if (storage.templates.length == 0)
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 100,
                  child: Center(
                    child: Text('No tienes plantillas guardadas',
                        style: TextStyle(fontSize: 16)),
                  ),
                ),
              ),
            if (storage.templates.length > 0)
              SliverToBoxAdapter(
                child: SizedBox(
                  height: 100,
                  child: StreamBuilder(
                      stream: CombineLatestStream.list(storage.templates
                              .map((templateId) => db.getTemplate(templateId)))
                          .asBroadcastStream(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) print(snapshot.error);
                        if (!snapshot.hasData) return Loading();
                        List<Template> templates = snapshot.data;
                        print(templates);
                        return ListView.separated(
                          itemCount: templates.length,
                          scrollDirection: Axis.horizontal,
                          separatorBuilder: (context, index) =>
                              SizedBox(width: 10),
                          itemBuilder: (context, index) {
                            return TemplateWidget(
                              template: templates[index],
                              refresh: () {
                                setState(() {});
                              },
                            );
                          },
                        );
                      }),
                ),
              ),
            SliverToBoxAdapter(
              child: Divider(
                indent: 50,
                endIndent: 50,
              ),
            ),
            SliverToBoxAdapter(
              child: StreamBuilder(
                  stream: db.getTemplates(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) print(snapshot.error);
                    if (!snapshot.hasData) return Loading();
                    List<Template> templates = snapshot.data;
                    return GridView.builder(
                      itemCount: templates.length,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4),
                      itemBuilder: (context, index) {
                        return TemplateWidget(
                          template: templates[index],
                          refresh: () {
                            setState(() {});
                          },
                        );
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
  TemplateWidget({Key key, @required this.template, this.refresh})
      : super(key: key);

  Template template;
  Function refresh;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Column(
        children: <Widget>[
          Expanded(
            child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: CachedNetworkImage(
                    imageUrl: template.image,
                    placeholder: (context, url) =>
                        Image.memory(kTransparentImage),
                    fit: BoxFit.contain)),
          ),
          Text(template.name, style: TextStyle(fontSize: 15))
        ],
      ),
      onTap: () => template.goTemplate(context, template),
      onLongPress: () async {
        await showModalTemplate(context, template);
        refresh();
      },
    );
  }
}

Future showModalTemplate(BuildContext context, Template template) {
  bool exists = storage.templates.contains(template.id);
  return showModalBottomSheet(
    context: context,
    builder: (context) {
      return Container(
        height: 150,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Text(template.name,
                  style: TextStyle(fontSize: 25, color: Colors.white)),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    RawMaterialButton(
                      onPressed: () {
                        if (!exists)
                          storage.templates = storage.templates + [template.id];
                        else {
                          List templates = storage.templates;
                          templates.remove(template.id);
                          storage.templates = templates;
                        }
                        navigator.pop(context);
                      },
                      elevation: 1,
                      fillColor: Colors.white.withOpacity(0.9),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          !exists ? Icons.file_download : Icons.clear,
                          size: 50,
                        ),
                      ),
                      shape: CircleBorder(),
                    ),
                    RawMaterialButton(
                      onPressed: () => template.goTemplate(context, template),
                      elevation: 1,
                      fillColor: Colors.white.withOpacity(0.9),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(
                          Icons.play_arrow,
                          size: 50,
                        ),
                      ),
                      shape: CircleBorder(),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      );
    },
  );
}
