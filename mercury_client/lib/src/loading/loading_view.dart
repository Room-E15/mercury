import 'package:flutter/material.dart';

class LoadingView extends StatefulWidget {
  const LoadingView({
    super.key,
    required this.future,
  });

  static const routeName = '/loading';

  final Future<void> future;

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
    return Scaffold(
        appBar: AppBar(
          title: const Text('Loading'),
          automaticallyImplyLeading: false,
        ),
        body: Builder(builder: _spinnerBuilder),
      );
  }
}
