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
  List<ImageMedia> images;
  int selectedMediaIndex = 0;
  MediaPage page;
  ImageProvider provider;
  GlobalKey<ExtendedImageEditorState> editorKey =
      GlobalKey<ExtendedImageEditorState>();
  ImageEditorOption editorOption = ImageEditorOption();
  IconData icon = Icons.image;

  @override
  void initState() {
    gallery.getMediaGallery().then((_) {
      page = gallery.imagePage;
      print(page);
      page.items.forEach((media) {
        print(media);
        mediaToImageMedia(media).then((image) => images.add(image));
      });
      print(images);
      setState(() {});
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (page == null) return Scaffold(body: Loading());

    print(images);

    Widget _buildPreview() {
      Widget preview;
      if (images[selectedMediaIndex].mediaType == MediaType.image) {
        Uint8List image = images[selectedMediaIndex]._image;
        provider = ExtendedMemoryImageProvider(image);
        preview = Stack(
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
                              bytes: image))),
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
      }
      // else {
      //   File file = await selectedMedia.getFile();
      //   print(file.path);
      //   return VideoPlayerWidget(file: file);
      // }
      return preview;
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
      String path;
      File file;
      if (images[selectedMediaIndex].mediaType.mediaType == MediaType.image) {
        Uint8List image = await FlutterImageCompress.compressWithList(
            await save(),
            format: CompressFormat.jpeg,
            minHeight: 1080,
            minWidth: 1080,
            quality: 80);
        path = await ImageGallerySaver.saveImage(image);
        file = File(path.substring(7));
      }
      // else if (selectedMedia.mediaType == MediaType.video) {
      //   MediaInfo info = await FlutterVideoCompress().compressVideo(
      //       (await selectedMedia.getFile()).path,
      //       quality: VideoQuality.DefaultQuality);
      //   path = info.path;
      //   file = File(path);
      // }

      print(path);

      widget.onMediaSelected(file, images[selectedMediaIndex].mediaType);
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
                  page = icon == Icons.image
                      ? gallery.videoPage
                      : gallery.imagePage;
                  icon = icon == Icons.image ? Icons.slideshow : Icons.image;
                  images = page.items.map((media) {
                    mediaToImageMedia(media).then((image) => image);
                  }).toList();
                  selectedMediaIndex = 0;
                  print(page == gallery.videoPage);
                });
              },
            ),
            actions: <Widget>[
              IconButton(
                  icon: Icon(Icons.arrow_forward),
                  onPressed: page.items.isNotEmpty
                      ? () {
                          goUploadMedia();
                        }
                      : null)
            ],
          ),
        ),
        body: page.items.isNotEmpty
            ? Stack(
                children: <Widget>[
                  GridView.builder(
                      itemCount: images.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 4,
                          crossAxisSpacing: 1,
                          mainAxisSpacing: 1),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                            child: MediaProvider(media: images[index]),
                            onTap: () {
                              selectedMediaIndex = index;
                              setState(() {});
                            });
                      }),
                  DraggableScrollableSheet(
                    initialChildSize: 0.25,
                    maxChildSize: 1,
                    builder: (context, scrollController) {
                      return SingleChildScrollView(
                        controller: scrollController,
                        child: Column(
                          children: <Widget>[
                            AspectRatio(aspectRatio: 1, child: _buildPreview()),
                            Container(
                              height: 20,
                              color: Colors.red,
                            )
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
  ImageMedia media;
  MediaProvider({@required this.media});

  @override
  Widget build(BuildContext context) {
    return FadeInImage(
        fit: BoxFit.cover,
        placeholder: MemoryImage(kTransparentImage),
        image: MemoryImage(media._image));
  }
}

class ImageMedia {
  Uint8List _image;
  MediaType _mediaType;

  ImageMedia(image, mediaType) {
    this._image = image;
    this._mediaType = mediaType;
  }

  get image => this._image;

  get mediaType => this._mediaType;
}

Future<ImageMedia> mediaToImageMedia(Media media) async {
  return ImageMedia(
      await (await media.getFile()).readAsBytes(), media.mediaType);
}
