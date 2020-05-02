import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

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

class PhysicsCardDragDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Physics Card Drag'),
      ),
      body: DraggableCard(
        child: FlutterLogo(
          size: 128
        )
      )
    );
  }
}

class DraggableCard extends StatefulWidget {
  final Widget child;

  DraggableCard({ this.child });

  @override
  _DraggableCardState createState() => _DraggableCardState();
}

class _DraggableCardState extends State<DraggableCard> with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Alignment _dragAlignment = Alignment.center;
  Animation<Alignment> _animation;

  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: Duration(seconds: 1));
    _controller.addListener(() {
      setState(() {
        _dragAlignment = _animation.value;
      });
    });

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return GestureDetector(
      onPanDown: (details) {
        _controller.stop();
      },
      onPanUpdate: (details) {
        setState(() {
          _dragAlignment += Alignment(
            details.delta.dx / (size.width / 2),
            details.delta.dy / (size.height / 2),
          );
        });
      },
      onPanEnd: (details) {
        _runAnimation(details.velocity.pixelsPerSecond, size);
      },
      child: Align(
        alignment: _dragAlignment,
        child: Card(
          child: widget.child,
        ),
      ),
    );
  }

  void _runAnimation(Offset pixelsPerSecond, Size size) {
    _animation = _controller.drive(
      AlignmentTween(
        begin: _dragAlignment,
        end: Alignment.center,
      )
    );

    final unitsPerSecondX = pixelsPerSecond.dx / size.width;
    final unitsPerSecordY = pixelsPerSecond.dy / size.height;
    final unitsPerSecord = Offset(unitsPerSecondX, unitsPerSecordY);
    final unitVelocity = unitsPerSecord.distance;

    const spring = SpringDescription(
      mass: 30,
      stiffness: 1,
      damping: 1,
    );

    final simulation = SpringSimulation(spring, 0, 1, -unitVelocity);

    _controller.animateWith(simulation);
  }
}
