import 'package:flutter/material.dart';
import 'dart:math';

class FlipCard extends StatefulWidget {
  final String frontImage;
  final String backImage;
  final bool isFlipped;
  final VoidCallback onFlip;

  const FlipCard({
    Key? key,
    required this.frontImage,
    required this.backImage,
    required this.isFlipped,
    required this.onFlip,
  }) : super(key: key);

  @override
  _FlipCardState createState() => _FlipCardState();
}

class _FlipCardState extends State<FlipCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  @override
  void didUpdateWidget(covariant FlipCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isFlipped && !_controller.isCompleted) {
      _controller.forward();
    } else if (!widget.isFlipped && _controller.isCompleted) {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (!widget.isFlipped) {
          widget.onFlip();
        }
      },
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          final angle = _animation.value * pi;
          final isBack = angle > pi / 2;

          return Transform(
            transform: Matrix4.rotationY(angle),
            alignment: Alignment.center,
            child: isBack
                ? Transform(
                    transform: Matrix4.rotationY(pi),
                    alignment: Alignment.center,
                    child: Image.asset(widget.backImage, fit: BoxFit.cover),
                  )
                : Image.asset(widget.frontImage, fit: BoxFit.cover),
          );
        },
      ),
    );
  }
}
