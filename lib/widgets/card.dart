import 'package:flutter/material.dart';
import 'package:historyar_app/model/forum_holder.dart';
import 'package:historyar_app/utils/color_palette.dart';

class VerticalCardItem extends StatefulWidget {
  final int id;
  final List<ForumHolder> foros;
  VerticalCardItem(this.id, this.foros);

  @override
  _VerticalCardItemState createState() => _VerticalCardItemState();
}

class _VerticalCardItemState extends State<VerticalCardItem> {
  ColorPalette _colorPalette = ColorPalette();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.maxFinite,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              color: _colorPalette.lightBlue),
          child: Stack(
            alignment: Alignment.bottomLeft,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: FadeInImage.assetNetwork(
                  image: widget.foros[widget.id].imagUrl,
                  placeholder: 'assets/1872.jpg',
                  fit: BoxFit.cover,
                ),
              ),
              ListTile(
                  title: Text('${widget.foros[widget.id].title}',
                      style: TextStyle(
                          color: _colorPalette.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 20.0)),
                  subtitle: Text(widget.foros[widget.id].description,
                      style: TextStyle(
                          color: _colorPalette.white,
                          fontWeight: FontWeight.w400,
                          fontSize: 14.0)))
            ],
          ),
        ),
        SizedBox(height: 16.0)
      ],
    );
  }
}
