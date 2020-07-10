import 'dart:io';
import 'dart:typed_data';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:flutter_video_compress/flutter_video_compress.dart';
import 'package:image_editor/image_editor.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:media_gallery/media_gallery.dart';
import 'package:meme/Controller/gallery.dart';
import 'package:meme/Pages/image_editor_page.dart';
import 'package:meme/Pages/upload_publication_page.dart';
import 'package:meme/Widgets/loading.dart';
import 'package:meme/Widgets/slide_left_route.dart';
import 'package:meme/Widgets/video_player.dart';

import 'package:transparent_image/transparent_image.dart';

class GalleryPage extends StatefulWidget {
  Function onMediaSelected;

  GalleryPage({@required this.onMediaSelected});

  @override
  _GalleryPageState createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  List<MyMedia> mediaList;
  MyMedia selectedMedia;
  ImageProvider provider;
  GlobalKey<ExtendedImageEditorState> editorKey =
      GlobalKey<ExtendedImageEditorState>();
  ImageEditorOption editorOption = ImageEditorOption();
  IconData icon = Icons.image;
  double aspectRatio = 1;
  double maxChildSize;

  @override
  void initState() {
    gallery.getMediaGallery().then((gallery) {
      print(gallery);
      mediaList = gallery;
      selectedMedia = mediaList.first;
      maxChildSize = (MediaQuery.of(context).size.width + 58) /
          MediaQuery.of(context).size.height;
      setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (mediaList == null) return Scaffold(body: Loading());

    selectedMedia.aspectRatio = aspectRatio;

    changeAspectRatio() {
      setState(() {
        aspectRatio = aspectRatio == 1 ? (4 / 3) : 1;
        maxChildSize = aspectRatio == 1
            ? (MediaQuery.of(context).size.width + 58) /
                MediaQuery.of(context).size.height
            : (MediaQuery.of(context).size.width / (4 / 3) + 40) /
                MediaQuery.of(context).size.height;
        print(maxChildSize);
      });
    }

    Widget _buildPreview() {
      if (selectedMedia is ImageMedia) {
        ImageMedia media = selectedMedia;
        provider = ExtendedMemoryImageProvider(media.image);
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
                  cropAspectRatio: aspectRatio,
                  initCropRectType: InitCropRectType.layoutRect,
                );
              },
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
                  SizedBox(
                    width: 50,
                    child: RawMaterialButton(
                      onPressed: () async => Navigator.push(
                          context,
                          SlideLeftRoute(
                              page: ImageEditorPage(
                                  onMediaSelected: widget.onMediaSelected,
                                  bytes: media.image))),
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
      VideoMedia media = selectedMedia;
      return VideoPlayerWidget(file: media.video);
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

    Future goUploadMedia() async {
      if (selectedMedia is ImageMedia) {
        (selectedMedia as ImageMedia).image = await save();
      }
      widget.onMediaSelected(selectedMedia);
    }

    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(40),
          child: AppBar(
            centerTitle: true,
            // title: IconButton(
            //   icon: Icon(icon),
            //   onPressed: () {
            //     setState(() {
            //       page = icon == Icons.image
            //           ? gallery.videoPage
            //           : gallery.imagePage;
            //       icon = icon == Icons.image ? Icons.slideshow : Icons.image;
            //       images = page.items.map((media) {
            //         mediaToImageMedia(media).then((image) => image);
            //       }).toList();
            //       selectedMediaIndex = 0;
            //       print(page == gallery.videoPage);
            //     });
            //   },
            // ),
            actions: <Widget>[
              IconButton(
                  icon: Icon(Icons.arrow_forward),
                  onPressed: mediaList.isNotEmpty
                      ? () {
                          goUploadMedia();
                        }
                      : null)
            ],
          ),
        ),
        body: mediaList.isNotEmpty
            ? Stack(
                children: <Widget>[
                  GridView.builder(
                      itemCount: mediaList.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          crossAxisSpacing: 1,
                          mainAxisSpacing: 1),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                            child: MediaProvider(
                                media: mediaList[index] is ImageMedia
                                    ? (mediaList[index] as ImageMedia).image
                                    : (mediaList[index] as VideoMedia)
                                        .thumbnail),
                            onTap: () {
                              selectedMedia = mediaList[index];
                              setState(() {});
                            });
                      }),
                  DraggableScrollableSheet(
                    initialChildSize: 0.1,
                    minChildSize: 0.1,
                    maxChildSize: maxChildSize,
                    builder: (context, scrollController) {
                      print(maxChildSize);
                      return SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          children: <Widget>[
                            Container(
                              height: 0,
                              color: Theme.of(context)
                                  .accentColor
                                  .withOpacity(0.7),
                              child: Center(
                                child: Icon(
                                  Icons.keyboard_arrow_up,
                                  size: 30,
                                ),
                              ),
                            ),
                            AspectRatio(
                                aspectRatio: selectedMedia.aspectRatio,
                                child: _buildPreview())
                          ],
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
    return FadeInImage(
        fit: BoxFit.cover,
        placeholder: MemoryImage(kTransparentImage),
        image: MemoryImage(media));
  }
}
