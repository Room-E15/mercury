import 'package:flutter/material.dart';

void stub () {}

class LoadingView extends StatefulWidget {
  const LoadingView({
    super.key,
    required this.future,
    this.onFinish = stub,
  });

  static const routeName = '/loading';

  final Future<void> future;
  final Function onFinish;

  @override
  State<LoadingView> createState() => _LoadingViewState();
}

class _LoadingViewState extends State<LoadingView> {
  Widget _spinnerBuilder(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        value: null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    widget.future.then((value) {
      if (context.mounted) {
        widget.onFinish(value);
      }
    });

    return Scaffold(
        appBar: AppBar(
          title: const Text('Loading'),
          automaticallyImplyLeading: false,
        ),
        body: Builder(builder: _spinnerBuilder),
      );
  }
}
