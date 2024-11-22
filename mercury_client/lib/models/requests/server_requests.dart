abstract class ServerRequests {
  // Instead of changing these variables, please create "env_dev.json" in mercury_client,
  //  then run 'flutter run' with the argument '--dart-define-from-file=env_dev.json'
  static const String _address = String.fromEnvironment('ADDRESS', defaultValue: 'localhost');
  static const String _port = String.fromEnvironment('PORT', defaultValue: '8080');
  static const String _hostname = "$_address:$_port";
  static const String baseURL = "http://$_hostname";
}