import 'package:flutter/material.dart';
import 'package:historyar_app/utils/color_palette.dart';
import 'package:historyar_app/widgets/app_bar.dart';
import 'package:historyar_app/widgets/button_app_bar.dart';

class ForumDetail extends StatefulWidget {
  final String title;
  const ForumDetail({Key? key, required this.title}) : super(key: key);
  @override
  _ForumDetailState createState() => _ForumDetailState();
}

class _ForumDetailState extends State<ForumDetail> {
  ColorPalette _colorPalette = ColorPalette();
  TextEditingController _controller = TextEditingController();

  String lorem =
      'It is a long established fact that a reader will be distracted '
      'by the readable content of a page when looking at its layout. The point of using Lorem '
      'Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using '
      'Content here, content here, making it look like readable English. Many desktop publishing '
      'packages and web page editors now use Lorem Ipsum as their default model text, and a search for lorem ipsum'
      'will uncover many web sites still in their infancy. Various versions have evolved over the years, sometimes by accident, '
      'sometimes on purpose (injected humour and the like).';

  String lorem_reply =
      'It is a long established fact that a reader will be distracted '
      'by the readable content of a page when looking at its layout. The point of using Lorem ';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _colorPalette.cream,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                children: [
                  Container(
                    width: double.maxFinite,
                    height: 48.0,
                    decoration: BoxDecoration(
                        color: _colorPalette.lightBlue,
                        border:
                            Border.all(color: _colorPalette.yellow, width: 2.0),
                        borderRadius: BorderRadius.vertical(
                            bottom: Radius.circular(25.0))),
                    child: Center(
                      child: Text(widget.title,
                          style: TextStyle(
                              color: _colorPalette.yellow,
                              fontWeight: FontWeight.w700,
                              fontSize: 24.0)),
                    ),
                  ),
                  Padding(
                      padding: EdgeInsets.only(top: 24.0),
                      child: Container(
                        width: double.maxFinite,
                        decoration: BoxDecoration(
                            color: _colorPalette.white,
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(
                                color: _colorPalette.yellow, width: 2.0)),
                        child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Text(lorem,
                                style: TextStyle(
                                    fontSize: 12.0, color: _colorPalette.text),
                                textAlign: TextAlign.justify)),
                      )),
                  Container(
                    alignment: Alignment.topRight,
                    child: Padding(
                        padding: EdgeInsets.only(top: 24.0),
                        child: Container(
                          width: 280.0,
                          decoration: BoxDecoration(
                              color: _colorPalette.white,
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(
                                  color: _colorPalette.yellow, width: 2.0)),
                          child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Text(lorem_reply,
                                  style: TextStyle(
                                      fontSize: 12.0,
                                      color: _colorPalette.text),
                                  textAlign: TextAlign.justify)),
                        )),
                  ),
                  Container(
                    alignment: Alignment.topRight,
                    child: Padding(
                        padding: EdgeInsets.only(top: 24.0),
                        child: Container(
                          width: 280.0,
                          decoration: BoxDecoration(
                              color: _colorPalette.white,
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(
                                  color: _colorPalette.yellow, width: 2.0)),
                          child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Text(lorem_reply,
                                  style: TextStyle(
                                      fontSize: 12.0,
                                      color: _colorPalette.text),
                                  textAlign: TextAlign.justify)),
                        )),
                  ),
                  Container(
                    alignment: Alignment.topRight,
                    child: Padding(
                        padding: EdgeInsets.only(top: 24.0),
                        child: Container(
                          width: 280.0,
                          decoration: BoxDecoration(
                              color: _colorPalette.white,
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(
                                  color: _colorPalette.yellow, width: 2.0)),
                          child: Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Text(lorem_reply,
                                  style: TextStyle(
                                      fontSize: 12.0,
                                      color: _colorPalette.text),
                                  textAlign: TextAlign.justify)),
                        )),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16.0),
                    child: _comment_box(),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Row(
                      children: [Spacer(), _commentButton(context)],
                    ),
                  ),
                ],
              )),
        ),
      ),
      floatingActionButton: historyarButtonApp(context, false),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar:
          historyarBottomAppBar(context, false, false, true, false),
    );
  }

  Widget _comment_box() {
    return Container(
      width: double.maxFinite,
      height: 104.0,
      decoration: BoxDecoration(
          color: Colors.white70, borderRadius: BorderRadius.circular(5.0)),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: TextFormField(
          controller: _controller,
          expands: true,
          maxLines: null,
          keyboardType: TextInputType.multiline,
          enableInteractiveSelection: false,
          decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Insert comment',
              hintStyle: TextStyle(
                  fontSize: 16.0,
                  color: _colorPalette.yellow,
                  fontWeight: FontWeight.w400)),
          cursorColor: _colorPalette.lightBlue,
        ),
      ),
    );
  }

  Widget _commentButton(BuildContext context) {
    return Center(
      child: MaterialButton(
          height: 32.0,
          minWidth: 104.0,
          color: _colorPalette.darkBlue,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(100.0),
              side: BorderSide(color: _colorPalette.yellow)),
          child: Text('Comment',
              style: TextStyle(
                  fontSize: 14.0,
                  color: _colorPalette.yellow,
                  fontWeight: FontWeight.w600)),
          onPressed: () {
            //TODO: Push comment
          }),
    );
  }
}
