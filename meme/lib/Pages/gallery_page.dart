import 'dart:io';
import 'dart:typed_data';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:image_editor/image_editor.dart';
import 'package:media_gallery/media_gallery.dart';
import 'package:meme/Widgets/loading.dart';
import 'package:transparent_image/transparent_image.dart';

class GalleryPage extends StatefulWidget {
  Function onTap;
  MediaPage page;

  GalleryPage({@required this.onTap, @required this.page});

  @override
  _GalleryPageState createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  Media selectedMedia;
  List<Media> mediaList;
  ImageProvider provider;
  GlobalKey<ExtendedImageEditorState> editorKey =
      GlobalKey<ExtendedImageEditorState>();
  ImageEditorOption editorOption = ImageEditorOption();

  Future<Uint8List> imageFromMedia(Media media) async {
    return (await media.getFile()).readAsBytesSync();
  }

  void setProvider(ExtendedMemoryImageProvider newProvider){
    setState(() {
      provider = newProvider;
    });
  }

  @override
  void initState() {
    print('holaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa');
    print(widget.page);
    if (widget.page != null) {
      mediaList = widget.page.items;
      print(mediaList);
      selectedMedia = mediaList.first;
      imageFromMedia(selectedMedia).then((bytes) {
        provider = ExtendedMemoryImageProvider(bytes);
        setState(() {});
      });
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('weeeeeeeeeeeeeeeeeeeee');
    print(widget.page);
    if (widget.page == null) return Scaffold(body: Loading());

    Widget _buildImage() {
      return ExtendedImage(
        image: provider,
        extendedImageEditorKey: editorKey,
        mode: ExtendedImageMode.editor,
        fit: BoxFit.contain,
        initEditorConfigHandler: (ExtendedImageState state) {
          return EditorConfig(
            maxScale: 3.0,
            cropRectPadding: const EdgeInsets.all(0),
            hitTestSize: 20.0,
            cropAspectRatio: 1,
            initCropRectType: InitCropRectType.layoutRect,
            cornerSize: Size.zero,
          );
        },
      );
    }

    Future<Uint8List> save() async {
      final ExtendedImageEditorState state = editorKey.currentState;
      final Rect rect = state.getCropRect();
      final EditActionDetails action = state.editAction;
      final double radian = action.rotateAngle;

      final bool flipHorizontal = action.flipY;
      final bool flipVertical = action.flipX;
      // final img = await getImageFromEditorKey(editorKey);
      final Uint8List img = state.rawImageData;

      final ImageEditorOption option = ImageEditorOption();

      option.addOption(ClipOption.fromRect(rect));
      option.addOption(
          FlipOption(horizontal: flipHorizontal, vertical: flipVertical));
      if (action.hasRotateAngle) {
        option.addOption(RotateOption(radian.toInt()));
      }

      option.outputFormat = const OutputFormat.png(88);

      final Uint8List result = await ImageEditor.editImage(
        image: img,
        imageEditorOption: option,
      );

      return result;
    }

    return Scaffold(
        body: Column(
      children: <Widget>[
        AspectRatio(aspectRatio: 1, child: _buildImage()),
        GridView.builder(
          shrinkWrap: true,
            itemCount: mediaList.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4, crossAxisSpacing: 1, mainAxisSpacing: 1),
            itemBuilder: (context, index) {
              return GestureDetector(
                  child: MediaProvider(media: mediaList[index]),
                  onTap: () {
                    Uint8List bytes = mediaList[index]
                    setState(() {
                      
                    });
                  });
            }),
      ],
    ));
  }
}

class MediaProvider extends StatelessWidget {
  Media media;
  MediaProvider({@required this.media});

  @override
  Widget build(BuildContext context) {
    if (media.mediaType == MediaType.image)
      return FadeInImage(
        fit: BoxFit.cover,
        placeholder: MemoryImage(kTransparentImage),
        image: MediaImageProvider(
          media: media,
        ),
      );

    return FadeInImage(
      fit: BoxFit.cover,
      placeholder: MemoryImage(kTransparentImage),
      image: MediaThumbnailProvider(
        media: media,
      ),
    );
  }
}
