import 'package:flutter/material.dart';

class MyPopUpMenuItem<T> extends PopupMenuItem<T> {
  final Widget child;
  final Function onClick;
  MyPopUpMenuItem({@required this.child, @required this.onClick});
  @override
  PopupMenuItemState<T, PopupMenuItem<T>> createState() {
    return MyPopUpMenuItemState();
  }
}

class MyPopUpMenuItemState<T, PopMenuItem>
    extends PopupMenuItemState<T, MyPopUpMenuItem<T>> {
  @override
  void handleTap() {
    widget.onClick();
  }
}
