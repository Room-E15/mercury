import 'package:flutter/material.dart';

void stub () {}

class LoadingView<T> extends StatelessWidget {
  const LoadingView({
    super.key,
    required this.future,
    this.onFinish = stub,
  });

  static const routeName = '/loading';

  final Future<T> future;
  final Function onFinish;

  Widget _spinnerBuilder(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        value: null,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    future.then((T value) {
      if (context.mounted) {
        onFinish(value);
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
