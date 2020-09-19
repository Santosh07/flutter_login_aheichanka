import 'package:flutter/material.dart';

class ListModel<E> {
  ListModel(
      {@required this.stateKey,
      @required this.onDeleteCallback,
      Iterable<E> initialList})
      : _list = List<E>.from(initialList ?? <E>[]);

  final GlobalKey<SliverAnimatedListState> stateKey;
  final List<E> _list;
  final dynamic onDeleteCallback;

  void insertItem(int index, E item) {
    _list.add(item);
    stateKey.currentState.insertItem(index);
  }

  E removeItem(int index) {
    E removedItem = _list.removeAt(index);
    if (removedItem != null) {
      stateKey.currentState
          .removeItem(index, (context, animation) => onDeleteCallback);
    }
    return removedItem;
  }

  int get length => _list.length;

  E operator [](int index) => _list.elementAt(index);

  int indexOf(E item) => _list.indexOf(item);
}
