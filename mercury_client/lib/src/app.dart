import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'settings/settings_controller.dart';
import 'settings/settings_view.dart';
import 'profile/profile_view.dart';
import 'home/home_view.dart';
import 'join_server_prompt/join_server_prompt_view.dart';

/// The Widget that configures your application.
class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    required this.settingsController,
  });

  static const Widget logo = Row(mainAxisSize: MainAxisSize.min, children: [
    Text('MERCURY', style: TextStyle(fontSize: 32, fontFamily: 'SF Pro')),
    Icon(Icons.apple, color: Colors.deepPurple)
  ]);

  final SettingsController settingsController;

  ThemeData getTheme(final ColorScheme colorScheme) {
    return ThemeData(
      colorScheme: colorScheme,
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: colorScheme.surfaceContainerHighest,
          foregroundColor: colorScheme.onSurface,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorSchemeLight = ColorScheme.fromSeed(
      brightness: Brightness.light,
      seedColor: Colors.indigo,
    );
    final ColorScheme colorSchemeDark = ColorScheme.fromSeed(
      brightness: Brightness.dark,
      seedColor: Colors.indigo,
    );

    // Glue the SettingsController to the MaterialApp.
    //
    // The ListenableBuilder Widget listens to the SettingsController for changes.
    // Whenever the user updates their settings, the MaterialApp is rebuilt.
    return ListenableBuilder(
      listenable: settingsController,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          // Providing a restorationScopeId allows the Navigator built by the
          // MaterialApp to restore the navigation stack when a user leaves and
          // returns to the app after it has been killed while running in the
          // background.
          restorationScopeId: 'app',

          // Provide the generated AppLocalizations to the MaterialApp. This
          // allows descendant Widgets to display the correct translations
          // depending on the user's locale.
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', ''), // English, no country code
          ],

          // Use AppLocalizations to configure the correct application title
          // depending on the user's locale.
          //
          // The appTitle is defined in .arb files found in the localization
          // directory.
          onGenerateTitle: (BuildContext context) =>
              AppLocalizations.of(context)!.appTitle,

          // Define a light and dark color theme. Then, read the user's
          // preferred ThemeMode (light, dark, or system default) from the
          // SettingsController to display the correct theme.
          theme: getTheme(colorSchemeLight),
          darkTheme: getTheme(colorSchemeDark),
          themeMode: settingsController.themeMode,

          // Define a function to handle named routes in order to support
          // Flutter web url navigation and deep linking.
          onGenerateRoute: (RouteSettings routeSettings) {
            return MaterialPageRoute<void>(
              settings: routeSettings,
              builder: (BuildContext context) {
                switch (routeSettings.name) {
                  case ProfileView.routeName:
                    return const ProfileView(profileName: "Davide Falessi", profilePhone: "+1 123 456 7890");
                  case SettingsView.routeName:
                    return SettingsView(controller: settingsController);
                  case HomeView.routeName:
                    return const HomeView(logo: MyApp.logo);
                  case JoinServerPromptView.routeName:
                    return JoinServerPromptView(logo: MyApp.logo);
                  default:
                    return const HomeView(logo: MyApp.logo);
                }
              },
            );
          },
          home: const HomeView(logo: MyApp.logo),
        );
      },
    );
  }
}
