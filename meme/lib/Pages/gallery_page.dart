import 'dart:typed_data';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:image_editor/image_editor.dart';
import 'package:meme/Controller/gallery.dart';
import 'package:meme/Controller/navigator.dart';
import 'package:meme/Pages/image_editor_page.dart';
import 'package:meme/Widgets/loading.dart';
import 'package:meme/Widgets/slide_left_route.dart';
import 'package:meme/Widgets/video_player.dart';
import 'package:transparent_image/transparent_image.dart';

List<double> myAspectRatios = [1, 1.91];

class GalleryPage extends StatefulWidget {
  Function onMediaSelected;

  GalleryPage({@required this.onMediaSelected});

  @override
  _GalleryPageState createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  List<MyMediaCollection> collections;
  MyMediaCollection selectedCollection;
  MyMedia selectedMedia;
  ImageProvider provider;
  GlobalKey<ExtendedImageEditorState> editorKey =
      GlobalKey<ExtendedImageEditorState>();
  ImageEditorOption editorOption = ImageEditorOption();
  IconData icon = Icons.image;
  double aspectRatio = myAspectRatios[0];
  double maxChildSize;
  ScrollController scrollController = ScrollController();
  GlobalKey<VideoPlayerWidgetState> videoPlayerKey =
      GlobalKey<VideoPlayerWidgetState>();

  @override
  void initState() {
    gallery.getMediaGallery().then((_) {
      collections = gallery.collections;
      selectedCollection = collections.first;
      if (selectedCollection.media.isNotEmpty)
        selectedMedia = selectedCollection.media.first;
      maxChildSize = (MediaQuery.of(context).size.width + 58) /
          MediaQuery.of(context).size.height;
      scrollController.addListener(_scrollListener);
      setState(() {});
    });

    super.initState();
  }

  void _scrollListener() async {
    if (scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange) {
      await gallery.loadMedia(collections.indexOf(selectedCollection));
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (collections == null) return Scaffold(body: Loading());

    if (collections.isEmpty)
      return Scaffold(
        body: Text('No hay contenido en la galeria'),
      );

    selectedMedia.aspectRatio = aspectRatio;

    changeAspectRatio() {
      setState(() {
        int indexAspectRatio = myAspectRatios.indexOf(aspectRatio);
        if (indexAspectRatio == myAspectRatios.length - 1)
          indexAspectRatio = 0;
        else
          indexAspectRatio++;
        aspectRatio = myAspectRatios[indexAspectRatio];
        maxChildSize = (MediaQuery.of(context).size.width + 58) /
            MediaQuery.of(context).size.height;
      });
    }

    Widget _buildPreview() {
      MyMedia media;
      if (selectedMedia is ImageMedia) {
        media = selectedMedia;
        provider = ExtendedMemoryImageProvider((media as ImageMedia).image);
      } else
        media = selectedMedia;
      return Stack(
        alignment: Alignment.bottomRight,
        children: <Widget>[
          if (selectedMedia is ImageMedia)
            ExtendedImage(
              height: MediaQuery.of(context).size.width,
              image: provider,
              extendedImageEditorKey: editorKey,
              mode: ExtendedImageMode.editor,
              fit: BoxFit.contain,
              initEditorConfigHandler: (ExtendedImageState state) {
                return EditorConfig(
                  maxScale: 3.0,
                  cropRectPadding: const EdgeInsets.all(8),
                  hitTestSize: 20.0,
                  cropAspectRatio: aspectRatio,
                  initCropRectType: InitCropRectType.layoutRect,
                );
              },
            ),
          if (selectedMedia is VideoMedia)
            Container(
              color: Colors.white,
              height: MediaQuery.of(context).size.width,
              child: VideoPlayerWidget(
                file: (media as VideoMedia).video,
                key: videoPlayerKey,
                aspectRatio: aspectRatio,
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                SizedBox(
                  width: 50,
                  child: RawMaterialButton(
                    onPressed: changeAspectRatio,
                    elevation: 1,
                    fillColor: Colors.white.withOpacity(0.9),
                    child: Icon(
                      Icons.aspect_ratio,
                      size: 20,
                    ),
                    shape: CircleBorder(),
                  ),
                ),
                if (media is ImageMedia)
                  SizedBox(
                    width: 50,
                    child: RawMaterialButton(
                      onPressed: () => navigator.goImageEditor(
                          context, widget.onMediaSelected, media),
                      elevation: 1,
                      fillColor: Colors.white.withOpacity(0.9),
                      child: Icon(
                        Icons.edit,
                        size: 20,
                      ),
                      shape: CircleBorder(),
                    ),
                  ),
              ],
            ),
          )
        ],
      );
    }

    Future<Uint8List> save() async {
      final ExtendedImageEditorState state = editorKey.currentState;
      final Rect rect = state.getCropRect();
      final Uint8List img = state.rawImageData;

      final ImageEditorOption option = ImageEditorOption();

      option.addOption(ClipOption.fromRect(rect));

      option.outputFormat = const OutputFormat.png(88);

      final Uint8List result = await ImageEditor.editImage(
        image: img,
        imageEditorOption: option,
      );

      return result;
    }

    Future<MyMedia> futureMedia() async {
      if (selectedMedia is ImageMedia) {
        (selectedMedia as ImageMedia).image = await save();
      }
      return selectedMedia;
    }

    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(40),
          child: AppBar(
            centerTitle: true,
            title: DropdownButton(
              value: selectedCollection,
              iconEnabledColor: Colors.white,
              selectedItemBuilder: (context) => collections
                  .map((item) => Center(
                      child: SizedBox(
                          width: 150,
                          child: Text(
                            selectedCollection.name,
                            style: TextStyle(color: Colors.white),
                            overflow: TextOverflow.ellipsis,
                          ))))
                  .toList(),
              items: collections
                  .map((collection) => DropdownMenuItem(
                        value: collection,
                        child: Text(
                          collection.name,
                        ),
                      ))
                  .toList(),
              onChanged: (collection) async {
                selectedCollection = collection;
                await gallery
                    .changeCollection(collections.indexOf(selectedCollection));
                if (selectedCollection.media.isNotEmpty)
                  selectedMedia = selectedCollection.media.first;
                setState(() {});
              },
            ),
            actions: <Widget>[
              IconButton(
                  icon: Icon(Icons.arrow_forward),
                  onPressed: selectedCollection.media.isNotEmpty
                      ? () {
                          widget.onMediaSelected(context, futureMedia);
                        }
                      : null)
            ],
          ),
        ),
        body: selectedCollection.media.isNotEmpty
            ? Stack(
                children: <Widget>[
                  GridView.builder(
                      controller: scrollController,
                      itemCount: selectedCollection.media.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          crossAxisSpacing: 1,
                          mainAxisSpacing: 1),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                            child: Stack(
                              children: <Widget>[
                                MediaProvider(
                                    media: selectedCollection.media[index]
                                            is ImageMedia
                                        ? (selectedCollection.media[index]
                                                as ImageMedia)
                                            .image
                                        : (selectedCollection.media[index]
                                                as VideoMedia)
                                            .thumbnail),
                                if (selectedMedia ==
                                    selectedCollection.media[index])
                                  Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        width: 2,
                                        color: Theme.of(context).accentColor,
                                      ),
                                    ),
                                  )
                              ],
                            ),
                            onTap: () async {
                              selectedMedia = selectedCollection.media[index];
                              setState(() {});
                              await Future.delayed(Duration(milliseconds: 100));
                              if (selectedMedia is VideoMedia)
                                videoPlayerKey.currentState.initController();
                              setState(() {});
                            });
                      }),
                  if (selectedCollection.media.isNotEmpty)
                    DraggableScrollableSheet(
                      initialChildSize: 0.1,
                      minChildSize: 0.1,
                      maxChildSize: maxChildSize,
                      builder: (context, scrollController) {
                        return Container(
                          color: Colors.white.withOpacity(0.7),
                          child: SingleChildScrollView(
                            controller: scrollController,
                            child: _buildPreview(),
                          ),
                        );
                      },
                    ),
                ],
              )
            : Center(child: Text('No hay contenido disponible')));
  }
}

class MediaProvider extends StatelessWidget {
  Uint8List media;
  MediaProvider({@required this.media});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: FadeInImage(
          fit: BoxFit.cover,
          placeholder: MemoryImage(kTransparentImage),
          image: MemoryImage(media)),
    );
  }
}
