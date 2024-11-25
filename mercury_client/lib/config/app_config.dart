abstract class AppConfig {
  // Put any global app developer settings here for easy changing
  static const bool dummyValues = false;
  static const bool isManager = true;

  // Developer setting for use Caching
  static const bool useCaching = true;

  // Seconds before the app will refresh the alerts
  static const int alertRefreshRate = 5000;  // seconds
}