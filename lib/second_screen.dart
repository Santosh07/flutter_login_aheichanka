import 'package:flutter/material.dart';
import 'package:flutter_login_aheichanka/model/list_model.dart';
import 'package:flutter_login_aheichanka/my_header_delegate.dart';

import 'model/todo.dart';

class SecondScreen extends StatefulWidget {
  static Route<dynamic> route() {
    return PageRouteBuilder(
        transitionDuration: Duration(milliseconds: 500),
        pageBuilder: (context, animation, secondaryAnimation) {
          return SecondScreen(
            entryAnimation: animation,
          );
        });
  }

  SecondScreen({this.entryAnimation});

  final Animation<double> entryAnimation;

  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  final GlobalKey<SliverAnimatedListState> _key =
      GlobalKey<SliverAnimatedListState>();
  ListModel<Todo> _list;

  List<Todo> initialList = <Todo>[
    Todo(title: 'New subpage for Janet', time: '8 - 10am'),
    Todo(title: 'Catch up with Tom', time: '11 - 12am'),
    Todo(title: 'Launch with Diane', time: '12am'),
    Todo(title: 'New subpage for Janet', time: '8 - 10am'),
    Todo(title: 'Catch up with Tom', time: '11 - 12am'),
    Todo(title: 'Launch with Diane', time: '12am'),
    Todo(title: 'New subpage for Janet', time: '8 - 10am'),
    Todo(title: 'Catch up with Tom', time: '11 - 12am'),
    Todo(title: 'Launch with Diane', time: '12am'),
    Todo(title: 'New subpage for Janet', time: '8 - 10am'),
    Todo(title: 'Catch up with Tom', time: '11 - 12am'),
    Todo(title: 'Launch with Diane', time: '12am')
  ];

  @override
  void initState() {
    super.initState();

    _list = ListModel<Todo>(
        stateKey: _key, onDeleteCallback: null, initialList: <Todo>[]);

    Stream.periodic(Duration(milliseconds: 100), (i) => initialList[i])
        .take(initialList.length)
        .listen((todoItem) => _list.insertItem(_list.length, todoItem));
  }

  Widget _buildTodoList(
      BuildContext context, int index, Animation<double> animation) {
    return TodoCard(
      animation: animation,
      todo: _list[index],
    );
  }

  @override
  Widget build(BuildContext context) {
    double paddingTop = MediaQuery.of(context).padding.top;

    return Stack(
      children: [
        Scaffold(
          body: Container(
            child: CustomScrollView(
              slivers: [
                SliverPersistentHeader(
                  pinned: true,
                  floating: false,
                  delegate: MyHeaderDelegate(
                    minExtent: paddingTop + 60,
                    maxExtent: 400,
                    entryAnimation: widget.entryAnimation,
                  ),
                ),
                SliverAnimatedList(
                  key: _key,
                  initialItemCount: _list.length,
                  itemBuilder: _buildTodoList,
                ),
              ],
            ),
          ),
        ),
        AnimatedBuilder(
          animation: widget.entryAnimation,
          builder: (context, child) {
            final double width = MediaQuery.of(context).size.width;
            final double translateWidth =
                widget.entryAnimation.value != 1 ? 0 : width;

            return Positioned(
              left: translateWidth,
              child: Opacity(
                opacity: (1 - widget.entryAnimation.value),
                child: Container(
                  color: Colors.pink,
                ),
              ),
            );
          },
        )
      ],
    );
  }
}

class TodoCard extends StatelessWidget {
  static const height = 88.0;

  final Animation<double> animation;
  final Todo todo;

  final Tween yTweenAvatar = Tween(begin: -1.5, end: 0.0);
  final Tween xTweenAvatar = Tween(begin: -1.0, end: -0.9);
  final Tween yTweenText = Tween(begin: height * 0.01, end: height * 0.22);
  final Tween avatarSizeTween = Tween(begin: 72.0, end: 54.0);
  final Tween titleTextSizeTween = Tween(begin: 24.0, end: 17.0);
  final Tween timeTextSizeTween = Tween(begin: 22.0, end: 14.0);
  final Tween opacityTween = Tween(begin: 0.5, end: 1.0);

  TodoCard({this.animation, this.todo});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    final Tween xTweenText = Tween(begin: width * 0.35, end: width * 0.25);

    return Container(
      margin: const EdgeInsets.only(bottom: 2.0),
      child: SizedBox(
        height: 88,
        child: Card(
          margin: EdgeInsets.zero,
          shape: ContinuousRectangleBorder(),
          child: AnimatedBuilder(
            animation: animation,
            builder: (context, child) {
              return Opacity(
                opacity: opacityTween.evaluate(animation),
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment(xTweenAvatar.evaluate(animation),
                          yTweenAvatar.evaluate(animation)),
                      child: Container(
                        height: avatarSizeTween.evaluate(animation),
                        width: avatarSizeTween.evaluate(animation),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: Colors.red),
                        //radius: avatarSizeTween.evaluate(animation),
                      ),
                    ),
                    Positioned(
                      left: xTweenText.evaluate(animation),
                      top: yTweenText.evaluate(animation),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            todo.title,
                            style: TextStyle(
                                fontSize:
                                    titleTextSizeTween.evaluate(animation)),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            todo.time,
                            style: TextStyle(
                                fontSize: timeTextSizeTween.evaluate(animation),
                                color: Colors.black45),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
