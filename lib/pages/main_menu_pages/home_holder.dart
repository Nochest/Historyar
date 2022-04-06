import 'package:flutter/material.dart';
import 'package:historyar_app/utils/color_palette.dart';
import 'package:historyar_app/widgets/app_bar.dart';
import 'package:historyar_app/widgets/button_app_bar.dart';

//TODO: Home holder for sprint 2
class HomeHolder extends StatefulWidget {

  final int id;
  final int type;

  const HomeHolder({
    required this.id,
    required this.type,
    Key? key
  }) : super(key: key);

  @override
  _HomeHolderState createState() => _HomeHolderState();
}

class _HomeHolderState extends State<HomeHolder> {

  ColorPalette _colorPalette = ColorPalette();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.maxFinite,
        color: _colorPalette.cream,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Text(
                widget.id.toStringAsPrecision(1),
                style: TextStyle(fontSize: 24),
              ),
            ),

          ],
        ),
      ),
      floatingActionButton: historyarButtonApp(context, false),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: historyarBottomAppBar(context, true, false, false, false, widget.id, widget.type),
    );
  }
}
