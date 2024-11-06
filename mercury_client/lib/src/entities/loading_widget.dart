import 'package:flutter/material.dart';

class LoadingWidget<T> extends StatefulWidget {
  const LoadingWidget({
    super.key,
    required this.future,
    required this.childBuilder,
    this.icon = const Center(
      child: CircularProgressIndicator(
        value: null,
      ),
    ),
  });

  final Future<T> future;
  final Widget Function(BuildContext, T) childBuilder;
  final Widget icon;

  @override
  LoadingWidgetState<T> createState() => LoadingWidgetState<T>();
}

class LoadingWidgetState<T> extends State<LoadingWidget<T>> {
  @override
  Widget build(BuildContext context) {
    Widget child = Center(child: widget.icon);

    widget.future.then((T value) {
      if (context.mounted) {
        setState(() {
          child = widget.childBuilder(context, value);
        });
      }
    });

    return Row(children: [child]);
  }
}
