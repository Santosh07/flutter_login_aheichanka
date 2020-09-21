import 'package:flutter/material.dart';
import 'dart:math' as math;

class MyHeaderDelegate extends SliverPersistentHeaderDelegate {
  Animation<double> entryAnimation;

  MyHeaderDelegate({this.minExtent, this.maxExtent, this.entryAnimation});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final shrinkPercentage = shrinkOffset / maxExtent;

    return Container(
      //color: backgroundColor,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/forest.jpg'),
          fit: BoxFit.fitWidth,
        ),
      ),
      child: AnimatedBuilder(
        animation: entryAnimation,
        builder: (context, child) {
          return AppBarFlexibleHeaderWidget(
            shrinkPercentage: shrinkPercentage,
            entryOpacity: entryAnimation.value,
          );
        },
      ),
    );
  }

  @override
  double maxExtent;

  @override
  double minExtent;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return true;
  }
}

class AppBarFlexibleHeaderWidget extends StatelessWidget {
  AppBarFlexibleHeaderWidget(
      {Key key, this.shrinkPercentage, this.entryOpacity})
      : super(key: key);

  final double shrinkPercentage;
  final double entryOpacity;

  final avatarSizeTween = Tween(begin: 88.0, end: 32.0);
  final greetingOpacityTween = Tween(begin: 1.0, end: 0.0);
  final menuAlignTween =
      Tween(begin: Offset(-0.95, -0.75), end: Offset(-0.95, 0.6));
  final searchAlignTween =
      Tween(begin: Offset(0.95, -0.75), end: Offset(0.95, 0.6));
  final monthTextYAlignTween = Tween(begin: 0.85, end: 0.35);
  final leftChevronAlignTween =
      Tween(begin: Offset(-0.95, 0.92), end: Offset(-0.45, 0.5));
  final rightChevronAlignTween =
      Tween(begin: Offset(0.95, 0.92), end: Offset(0.45, 0.5));

  @override
  Widget build(BuildContext context) {
    Offset avatarOffset = _getAvatarOffset(shrinkPercentage);

    return Opacity(
      opacity: entryOpacity,
      child: Stack(
        children: [
          Align(
            alignment: Alignment(
                searchAlignTween.transform(shrinkPercentage).dx,
                searchAlignTween.transform(shrinkPercentage).dy),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                onPressed: () {},
                icon: Icon(Icons.search),
                color: Colors.white60,
              ),
            ),
          ),
          Align(
            alignment: Alignment(
              menuAlignTween.transform(shrinkPercentage).dx,
              menuAlignTween.transform(shrinkPercentage).dy,
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: Icon(Icons.menu),
                color: Colors.white60,
              ),
            ),
          ),
          Align(
            alignment: Alignment(0, -0.4),
            child: Opacity(
              opacity: greetingOpacityTween
                  .transform(shrinkPercentage * 2)
                  .clamp(0.0, 1.0),
              child: Text(
                'Good Morning!',
                style: TextStyle(
                  fontSize: 28,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment(avatarOffset.dx, avatarOffset.dy),
            child: Container(
              width: avatarSizeTween.transform(shrinkPercentage),
              height: avatarSizeTween.transform(shrinkPercentage),
              alignment: Alignment.center,
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: Colors.blue),
            ),
          ),
          Align(
            alignment:
                Alignment(0, monthTextYAlignTween.transform(shrinkPercentage)),
            child: Text(
              'FEBRUARY',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
          ),
          Align(
            alignment: Alignment(
              leftChevronAlignTween.transform(shrinkPercentage).dx,
              leftChevronAlignTween.transform(shrinkPercentage).dy,
            ),
            child: IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.chevron_left,
                size: 32,
                color: Colors.white70,
              ),
            ),
          ),
          Align(
            alignment: Alignment(
              rightChevronAlignTween.transform(shrinkPercentage).dx,
              rightChevronAlignTween.transform(shrinkPercentage).dy,
            ),
            child: IconButton(
              icon: Icon(
                Icons.chevron_right,
                size: 32,
                color: Colors.white70,
              ),
              onPressed: () {},
            ),
          )
        ],
      ),
    );
  }

  Offset _getAvatarOffset(double shrinkPercentage) {
    final t = shrinkPercentage;
    final x = math.pow(t, 2);
    final yWithoutOffset = (-1.2 * math.pow(t, 2)) + (2.4 * t) - 0.2;
    final y = yWithoutOffset - (1.4 * shrinkPercentage);

    return Offset(x * 0.66, -(y));
  }
}
