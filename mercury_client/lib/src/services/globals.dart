// Wondering where to put your API endpoint URL? Create a file in mercury_client called envc_dev.json and add the following:
// {
//     "ADDRESS":"127.0.0.1"
// }

const String address = String.fromEnvironment('ADDRESS', defaultValue: 'localhost');
const String port = String.fromEnvironment('PORT', defaultValue: '8080');
const String baseURL = "http://${address}:${port}";
const Map<String, String> headers = {"Content-Type": "application/json"};