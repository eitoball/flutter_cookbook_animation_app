import 'package:flutter/material.dart';

import 'package:fluttercookbookanimationapp/physics_card_drag_demo.dart';

void main() {
  runApp(MaterialApp(
    home: Page1()
  ));
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
        )
      )
    );
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
      }
    );
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
          )
      )
    );
  }

  PageRouteBuilder _createRoute() {
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => Page3(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          Offset begin = Offset(0.0, 1.0);
          Offset end = Offset.zero;
          Curve curve = Curves.ease;
          Animatable<Offset> animatable = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          Animation<Offset> offsetAnimation = animation.drive(animatable);

          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        }
    );
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
      body: Center(
          child: RaisedButton(
            child: Text('Go!'),
            onPressed: () {
              Navigator.of(context).push(_createRoute());
            },
          )
      )
    );
  }

  PageRouteBuilder _createRoute() {
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => PhysicsCardDragDemo(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          Offset begin = Offset(0.0, 1.0);
          Offset end = Offset.zero;
          Curve curve = Curves.ease;
          
          Tween<Offset> tween = Tween(begin: begin, end: end);
          CurvedAnimation curvedAnimation = CurvedAnimation(
            parent: animation,
            curve: curve
          );

          return SlideTransition(
            position: tween.animate(curvedAnimation),
            child: child,
          );
        }
    );
  }
}
