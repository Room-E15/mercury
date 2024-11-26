import 'package:flutter/material.dart';


FutureBuilder<T> loadingWidgetBuilder<T>({
  required BuildContext context,
  required Future<T> futureIcon,
  Widget loadingIcon =
      const Center(child: CircularProgressIndicator(value: null)),
  Widget errorIcon = const Center(child: Text('Error loading')),
}) {
  return FutureBuilder(
    future: futureIcon,
    builder: (context, snapshot) {
      if (snapshot.hasData && snapshot.data != null) {
        return snapshot.data as Widget;
      } else if (snapshot.hasError) {
        return errorIcon;
      }
      return loadingIcon;
    },
  );
}
