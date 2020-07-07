import 'dart:io';
import 'dart:typed_data';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:image_editor/image_editor.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:media_gallery/media_gallery.dart';
import 'package:meme/Controller/gallery.dart';
import 'package:meme/Pages/image_editor_page.dart';
import 'package:meme/Pages/upload_publication_page.dart';
import 'package:meme/Widgets/loading.dart';
import 'package:meme/Widgets/media_provider.dart';
import 'package:meme/Widgets/slide_left_route.dart';
import 'package:transparent_image/transparent_image.dart';

class GalleryPage extends StatefulWidget {
  Function onMediaSelected;

  GalleryPage({@required this.onMediaSelected});

  @override
  _GalleryPageState createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  Media selectedMedia;
  MediaPage page;
  List<Media> mediaList;
  ImageProvider provider;
  GlobalKey<ExtendedImageEditorState> editorKey =
      GlobalKey<ExtendedImageEditorState>();
  ImageEditorOption editorOption = ImageEditorOption();
  IconData icon = Icons.image;

  Future<Uint8List> bytesFromMedia(Media media) async {
    return await (await media.getFile()).readAsBytes();
  }

  @override
  void initState() {
    gallery.getMediaGallery().then((_) {
      page = gallery.imagePage;
      mediaList = page.items;
      print(mediaList);
      selectedMedia = mediaList.first;
      bytesFromMedia(selectedMedia).then((bytes) {
        provider = ExtendedMemoryImageProvider(bytes);
        setState(() {});
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (page == null) return Scaffold(body: Loading());

    Future<Widget> _buildPreview() async {
      if (selectedMedia.mediaType == MediaType.image) {
        Uint8List bytes = await bytesFromMedia(selectedMedia);
        provider = ExtendedMemoryImageProvider(bytes);
        return Stack(
          alignment: Alignment.bottomRight,
          children: <Widget>[
            ExtendedImage(
              image: provider,
              extendedImageEditorKey: editorKey,
              mode: ExtendedImageMode.editor,
              fit: BoxFit.contain,
              initEditorConfigHandler: (ExtendedImageState state) {
                return EditorConfig(
                  maxScale: 3.0,
                  cropRectPadding: const EdgeInsets.all(8),
                  hitTestSize: 20.0,
                  cropAspectRatio: 1,
                  initCropRectType: InitCropRectType.layoutRect,
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: SizedBox(
                width: 50,
                              child: RawMaterialButton(
                  onPressed: () async => Navigator.push(
                      context,
                      SlideLeftRoute(
                          page: ImageEditorPage(
                            onMediaSelected: widget.onMediaSelected,
                              bytes: await bytesFromMedia(selectedMedia)))),
                  elevation: 1,
                  fillColor: Colors.white.withOpacity(0.9),
                  child: Icon(
                    Icons.edit,
                    size: 20,
                  ),
                  shape: CircleBorder(),
                ),
              ),
            )
          ],
        );
      } else {
        return FadeInImage(
          fit: BoxFit.cover,
          placeholder: MemoryImage(kTransparentImage),
          image: MediaThumbnailProvider(
            media: selectedMedia,
          ),
        );
      }
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

    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(40),
          child: AppBar(
            centerTitle: true,
            title: IconButton(
              icon: Icon(icon),
              onPressed: () {
                setState(() {
                  page = page == gallery.imagePage
                      ? gallery.videoPage
                      : gallery.imagePage;
                  icon = icon == Icons.image ? Icons.slideshow : Icons.image;
                });
              },
            ),
            actions: <Widget>[
              IconButton(
                  icon: Icon(Icons.arrow_forward),
                  onPressed: () async {
                    String path = await ImageGallerySaver.saveImage(await save());
                    print(path);
                    File file = File(path.substring(7));
                    widget.onMediaSelected(file,selectedMedia.mediaType);
                  })
            ],
          ),
        ),
        body: Column(
          children: <Widget>[
            AspectRatio(
                aspectRatio: 1,
                child: FutureBuilder(
                  future: _buildPreview(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) print(snapshot.error.toString());
                    if (!snapshot.hasData)
                      return Image.memory(kTransparentImage);
                    return snapshot.data;
                  },
                )),
            Expanded(
                          child: GridView.builder(
                  itemCount: mediaList.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4, crossAxisSpacing: 1, mainAxisSpacing: 1),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                        child: MediaProvider(media: mediaList[index]),
                        onTap: () {
                          selectedMedia = mediaList[index];

                          setState(() {});
                        });
                  }),
            ),
          ],
        ));
  }
}
