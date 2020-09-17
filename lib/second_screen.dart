import 'package:flutter/material.dart';
import 'package:flutter_login_aheichanka/my_header_delegate.dart';

class SecondScreen extends StatefulWidget {
  static Route<dynamic> route() {
    return PageRouteBuilder(
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return SecondScreen(
        entryAnimation: animation,
      );
    }, pageBuilder: (context, animation, secondaryAnimation) {
      return SecondScreen(
        entryAnimation: animation,
      );
    });
  }

  SecondScreen({this.entryAnimation});

  Animation<double> entryAnimation;

  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  @override
  Widget build(BuildContext context) {
    double paddingTop = MediaQuery.of(context).padding.top;

    return Scaffold(
      body: Container(
        child: CustomScrollView(
          slivers: [
            SliverPersistentHeader(
              pinned: true,
              floating: true,
              delegate: MyHeaderDelegate(
                minExtent: paddingTop + 60,
                maxExtent: 400,
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                return index.isOdd
                    ? Card(
                        margin: EdgeInsets.zero,
                        shape: ContinuousRectangleBorder(),
                        child: ListTile(
                          leading: CircleAvatar(radius: 28),
                          title: Text('New Sub for Janet'),
                          subtitle: Text('8-10 am'),
                        ),
                      )
                    : Divider(
                        height: 1,
                        color: Colors.white60,
                      );
              }, childCount: 100),
            )
          ],
        ),
      ),
    );
  }
}
