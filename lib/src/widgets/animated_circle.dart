import 'package:flutter/material.dart';

class AnimatedCircle extends AnimatedWidget {
  final Widget child;
  final Color color;
  final void Function() onTap;

  AnimatedCircle({
    Key key,
    this.child,
    this.color,
    this.onTap,
    Animation<double> animation,
  }) : super(key: key, listenable: animation);

  Animation<double> get _animation => listenable;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: _animation.value,
        width: _animation.value,
        child: AnimatedContainer(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
          ),
          duration: Duration(milliseconds: 100),
          child: Center(child: child),
        ),
      ),
    );
  }
}
