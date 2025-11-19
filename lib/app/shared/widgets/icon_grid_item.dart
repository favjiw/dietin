import 'package:flutter/material.dart';

class IconGridItem extends StatelessWidget {
  final String label;
  final String iconUrl;
  final bool locked;
  final bool isTextLogo;
  final bool isCircleRed;

  const IconGridItem({
    super.key,
    required this.label,
    required this.iconUrl,
    this.locked = false,
    this.isTextLogo = false,
    this.isCircleRed = false,
  });

  @override
  Widget build(BuildContext context) {
    const lockIconSize = 16.0;

    Widget iconWidget = Image.network(
      iconUrl,
      width: 48,
      height: 48,
      fit: BoxFit.contain,
      semanticLabel: label.isEmpty ? 'Icon' : label,
    );

    if (isCircleRed) {
      iconWidget = Container(
        width: 48,
        height: 48,
        decoration: const BoxDecoration(
          color: Color(0xFFEC1C24),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            'SOS',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            iconWidget,
            if (locked)
              Positioned(
                top: -4,
                right: -4,
                child: Container(
                  width: lockIconSize,
                  height: lockIconSize,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Colors.white, width: 1.5),
                  ),
                  child: const Icon(
                    Icons.lock,
                    size: 10,
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 6),
        SizedBox(
          width: 70,
          child: Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFF3A3A3A),
            ),
          ),
        ),
      ],
    );
  }
}
