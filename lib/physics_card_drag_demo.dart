import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';

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
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: Align(
              alignment: _dragAlignment,
              child: Card(
                child: widget.child,
              ),
            ),
          ),
        ],
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