import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CustomImage extends StatelessWidget {
  final String image;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final AlignmentGeometry alignment;

  const CustomImage({
    super.key,
    required this.image,
    this.width,
    this.height,
    this.fit,
    this.alignment = Alignment.center,
  });

  @override
  Widget build(BuildContext context) {
    if (image == 'programming') {
      final theme = Theme.of(context);
      return Container(
        width: width,
        height: height,
        color: theme.colorScheme.surface,
        alignment: Alignment.center,
        child: Text(
          '<Programming>',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: theme.colorScheme.primary,
            fontFamily: 'Barlow',
            fontSize: 22,
            fontWeight: FontWeight.w800,
          ),
        ),
      );
    }

    if (image.isEmpty) {
      return Container(
        width: width,
        height: height,
        color: Colors.grey[300],
        child: const Icon(Icons.image_not_supported),
      );
    }

    return Image.asset(
      image,
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded || frame != null) {
          return child;
        }
        return Shimmer.fromColors(
          baseColor: Colors.grey[800]!,
          highlightColor: Colors.grey[600]!,
          child: Container(
            width: width,
            height: height,
            decoration: const BoxDecoration(
              color: Colors.black,
            ),
          ),
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return Container(
          width: width,
          height: height,
          color: Colors.grey[900],
          child: const Center(
            child: Icon(Icons.broken_image, color: Colors.grey),
          ),
        );
      },
    );
  }
}
