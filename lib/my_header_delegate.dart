import 'package:flutter/material.dart';
import 'dart:math' as math;

class MyHeaderDelegate extends SliverPersistentHeaderDelegate {
  MyHeaderDelegate({this.minExtent, this.maxExtent});

  static const avatarSizeMax = 48.0;
  static const avatarSizeMin = 16.0;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final topPadding = MediaQuery.of(context).padding.top;
    final shrinkPercentage = shrinkOffset / maxExtent;

    Offset avatarOffset = _getAvatarOffset(shrinkPercentage);
    double avatarSize = _getAvatarRadius(shrinkPercentage);
    double greetingOpacity = _getGreetingOpacity(shrinkPercentage);
    double monthTextOffset = _getMonthTextYPosition(shrinkPercentage);
    Offset chevronLeftOffset = _getChevronLeftOffset(shrinkPercentage);
    Offset chevronRightOffset = _getChevronRightOffset(shrinkPercentage);
    Offset menuOffset = _getMenuOffset(shrinkPercentage);
    Offset searchOffset = _getSearchOffset(shrinkPercentage);

    Color backgroundColor = _getBackgroundColor(shrinkPercentage);

    return Container(
      //color: backgroundColor,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/forest.jpg'),
          fit: BoxFit.fitWidth,
        ),
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment(searchOffset.dx, searchOffset.dy),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.search,
                color: Colors.white60,
              ),
            ),
          ),
          Align(
            alignment: Alignment(menuOffset.dx, menuOffset.dy),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.menu,
                color: Colors.white60,
              ),
            ),
          ),
          Align(
            alignment: Alignment(0, -0.5),
            child: Opacity(
              opacity: greetingOpacity,
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
            child: CircleAvatar(
              radius: avatarSize,
            ),
          ),
          Align(
            alignment: Alignment(0, monthTextOffset),
            child: Text(
              'FEBRUARY',
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
          ),
          Align(
            alignment: Alignment(chevronLeftOffset.dx, chevronLeftOffset.dy),
            child: Icon(
              Icons.chevron_left,
              size: 32,
              color: Colors.white70,
            ),
          ),
          Align(
            alignment: Alignment(chevronRightOffset.dx, chevronRightOffset.dy),
            child: Icon(
              Icons.chevron_right,
              size: 32,
              color: Colors.white70,
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

    return Offset(x * 0.77, -(y));
  }

  double _getAvatarRadius(double shrinkPercentage) {
    double diff = (avatarSizeMax - avatarSizeMin) * shrinkPercentage;
    return avatarSizeMax - diff;
  }

  double _getGreetingOpacity(double shrinkPercentage) {
    return (1 - (shrinkPercentage * 2.0)).clamp(0.0, 1.0);
  }

  double _getMonthTextYPosition(double shrinkPercentage) {
    return 0.85 - (0.45 * shrinkPercentage);
  }

  Offset _getChevronLeftOffset(double shrinkPercentage) {
    double x = -0.95 + (0.5 * shrinkPercentage);
    double y = 0.88 - (0.38 * shrinkPercentage);

    return Offset(x, y);
  }

  Offset _getChevronRightOffset(double shrinkPercentage) {
    double x = 0.95 - (0.5 * shrinkPercentage);
    double y = 0.88 - (0.38 * shrinkPercentage);

    return Offset(x, y);
  }

  Offset _getMenuOffset(double shrinkPercentage) {
    double y = -0.75 + ((0.75 + 0.5) * shrinkPercentage);

    return Offset(-0.95, y);
  }

  Offset _getSearchOffset(double shrinkPercentage) {
    double y = -0.75 + ((0.75 + 0.5) * shrinkPercentage);

    return Offset(0.95, y);
  }

  Color _getBackgroundColor(double shrinkPercentage) {
    return ColorTween(begin: Colors.transparent, end: Colors.blue)
        .transform((shrinkPercentage * 1.5).clamp(0.0, 1.0));
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
