import 'package:flutter/material.dart';

enum LoadingState {
  nothing,
  loading,
  success,
  failure,
}

class LoadingIcon extends StatefulWidget {
  final LoadingState state;
  final String errorMessage;

  const LoadingIcon({super.key, required this.state, required this.errorMessage});

  @override
  State<StatefulWidget> createState() => _LoadingIconState();
}

class _LoadingIconState extends State<LoadingIcon> {
  @override
  Widget build(BuildContext context) {
    switch (widget.state) {
      case LoadingState.nothing:
        return Container();
      case LoadingState.loading:
        return const CircularProgressIndicator();
      case LoadingState.success:
        return const Icon(Icons.check);
      case LoadingState.failure:
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.close),
            Text(widget.errorMessage),
          ],
        );
    }
  }
}