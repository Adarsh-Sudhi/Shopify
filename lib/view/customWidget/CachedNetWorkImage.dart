import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class AppCachedImage extends StatelessWidget {
  final String imageUrl;
  final double width;
  final double height;
  final BoxFit fit;
  final bool circular;
  final Widget? errorWidget;

  const AppCachedImage({
    super.key,
    required this.imageUrl,
    this.width = double.infinity,
    this.height = double.infinity,
    this.fit = BoxFit.cover,
    this.circular = false,
    this.errorWidget,
  });

  @override
  Widget build(BuildContext context) {
    Widget image = CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
     
      errorWidget: (_, __, ___) =>
          errorWidget ??
          Icon(Icons.broken_image, size: width < height ? width : height),
    );

    if (circular) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(width / 2),
        child: image,
      );
    }

    return image;
  }
}
