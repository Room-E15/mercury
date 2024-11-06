import 'package:flutter/material.dart';

class LoadingWidget<T> extends StatefulWidget {
  const LoadingWidget({
    super.key,
    required this.future,
    required this.childBuilder,
  });

  final Future<T> future;
  final Widget Function(BuildContext, T) childBuilder;

  @override
  LoadingWidgetState<T> createState() => LoadingWidgetState<T>();
}

class LoadingWidgetState<T> extends State<LoadingWidget<T>> {
  Widget child = const Center(
    child: CircularProgressIndicator(
      value: null,
    ),
  );

  @override
  Widget build(BuildContext context) {
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
