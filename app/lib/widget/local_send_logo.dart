import 'package:flutter/material.dart';
import 'package:localsend_app/gen/assets.gen.dart';

class LocalSendLogo extends StatelessWidget {
  final bool withText;
  final double size;

  const LocalSendLogo({required this.withText, this.size = 200});

  @override
  Widget build(BuildContext context) {
    final logo = Assets.img.logo512.image(
      width: size,
      height: size,
    );

    if (withText) {
      return Column(
        children: [
          logo,
          const Text(
            'Lalitha Local Share',
            style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ],
      );
    } else {
      return logo;
    }
  }
}
