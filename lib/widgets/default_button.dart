import 'package:flutter/material.dart';
import 'package:historyar_app/utils/color_palette.dart';

class DefaultButton extends StatelessWidget {
  const DefaultButton({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  final String text;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    final palette = ColorPalette();
    return MaterialButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(100.0),
        side: BorderSide(
          color: palette.yellow,
          width: 2,
        ),
      ),
      color: palette.lightBlue,
      minWidth: 160,
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 18),
      ),
      onPressed: onPressed,
    );
  }
}
