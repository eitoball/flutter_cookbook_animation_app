import 'package:flutter/material.dart';

class FadeWidgetApp extends StatefulWidget {
  FadeWidgetApp({ Key key, this.title });

  final String title;

  @override
  _FadeWidgetAppState createState() => _FadeWidgetAppState();
}

class _FadeWidgetAppState extends State<FadeWidgetApp> {
  bool _visible = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Container(
          child: AnimatedOpacity(
            opacity: _visible ? 1.0 : 0.0,
            duration: Duration(milliseconds: 500),
            child: Container(
              width: 200.0,
              height: 200.0,
              color: Colors.green
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            _visible = !_visible;
          });
        },
        tooltip: 'Toggle Opacity',
        child: Icon(Icons.flip),
      ),
    );
  }
}
