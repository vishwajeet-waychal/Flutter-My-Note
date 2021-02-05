import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:photo_view/photo_view.dart';

class ImageView extends StatefulWidget {

  final String imageurl;
  ImageView(this.imageurl);

  @override
  _ImageViewState createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: PhotoView(
            maxScale: 1.0,
            imageProvider: NetworkImage(widget.imageurl),
            filterQuality: FilterQuality.high,
            backgroundDecoration: BoxDecoration(color: Colors.white),
            loadFailedChild: Text("Failed to load image"),
          ),
        )
      ),
    );
  }
}
