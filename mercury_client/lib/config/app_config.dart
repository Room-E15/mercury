abstract class AppConfig {
  // Put any global app developer settings here for easy changing
  static const bool dummyValues = false;
  static const bool isManager = true;

  // Developer setting for use Caching
  static const bool useCaching = true;

  // Time after which we remove an alert from the set of known alerts
  // TODO implement once merged
  static const int forgetAlertAfter = 10;  // minutes
}