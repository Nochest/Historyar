import 'package:flutter/material.dart';
import 'package:historyar_app/model/forum_holder.dart';
import 'package:historyar_app/utils/color_palette.dart';


class VerticalCardItem extends StatefulWidget {

  final int index;
  VerticalCardItem(this.index);

  @override
  _VerticalCardItemState createState() => _VerticalCardItemState();
}

class _VerticalCardItemState extends State<VerticalCardItem> {
  ColorPalette _colorPalette = ColorPalette();

  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [
        Container(
          width: double.maxFinite,
          height: 152.0,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: _colorPalette.lightBlue
          ),
          child: Stack(
            alignment: Alignment.bottomLeft,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: FadeInImage.assetNetwork(
                  image: rowList[widget.index].imagUrl,
                  placeholder: 'assets/04_Login.png',
                  width: double.maxFinite,
                  fit: BoxFit.fitWidth,
                ),
              ),
              ListTile(
                title: Text(' ${rowList[widget.index].title}', style: TextStyle(color: _colorPalette.white, fontWeight: FontWeight.w700, fontSize: 20.0)),
                subtitle: Text(rowList[widget.index].description, style: TextStyle(color: _colorPalette.white, fontWeight: FontWeight.w400, fontSize: 14.0))
              )
            ],
          ),
        ),
        SizedBox(height: 16.0)
      ],
    );
  }
}