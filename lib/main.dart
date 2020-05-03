import 'package:flutter/material.dart';

import 'package:fluttercookbookanimationapp/physics_card_drag_demo.dart';
import 'package:fluttercookbookanimationapp/animate_container_app.dart';
import 'package:fluttercookbookanimationapp/fade_widget_app.dart';

void main() => runApp(AnimationApp());

class AnimationApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: AnimationHome());
  }
}

class AnimationHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Animation'),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 40.0, left: 20.0, right: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            RaisedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                  return Page1();
                }));
              },
              child: Text('Animate a page route transition'),
            ),
            RaisedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                  return PhysicsCardDragDemo();
                }));
              },
              child: Text('Animate a widget using a physics simulation'),
            ),
            RaisedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                  return AnimateContainerApp();
                }));
              },
              child: Text('Animate the properties of a container'),
            ),
            RaisedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                  return FadeWidgetApp(title: 'Fade a widget in and out');
                }));
              },
              child: Text('Fade a widget in and out'),
            ),
          ],
        ),
      ),
    );
  }
}

class Page1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Page 1'),
        ),
        body: Center(
            child: RaisedButton(
          child: Text('Go!'),
          onPressed: () {
            Navigator.of(context).push(_createRoute());
          },
        )));
  }

  PageRouteBuilder _createRoute() {
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => Page2(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          Offset begin = Offset(0.0, 1.0);
          Offset end = Offset.zero;
          Tween<Offset> tween = Tween(begin: begin, end: end);
          Animation<Offset> offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        });
  }
}

class Page2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Page 2'),
          backgroundColor: Colors.green,
        ),
        body: Center(
            child: RaisedButton(
          child: Text('Go!'),
          onPressed: () {
            Navigator.of(context).push(_createRoute());
          },
        )));
  }

  PageRouteBuilder _createRoute() {
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => Page3(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          Offset begin = Offset(0.0, 1.0);
          Offset end = Offset.zero;
          Curve curve = Curves.ease;
          Animatable<Offset> animatable =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          Animation<Offset> offsetAnimation = animation.drive(animatable);

          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        });
  }
}

class Page3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Page 3'),
          backgroundColor: Colors.red,
        ),
        body: Container()
    );
  }

  PageRouteBuilder _createRoute() {
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            PhysicsCardDragDemo(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          Offset begin = Offset(0.0, 1.0);
          Offset end = Offset.zero;
          Curve curve = Curves.ease;

          Tween<Offset> tween = Tween(begin: begin, end: end);
          CurvedAnimation curvedAnimation =
              CurvedAnimation(parent: animation, curve: curve);

          return SlideTransition(
            position: tween.animate(curvedAnimation),
            child: child,
          );
        });
  }
}
