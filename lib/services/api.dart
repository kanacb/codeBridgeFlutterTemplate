class API {
  // development
  // static const baseUrl = "http://192.168.1.4:3030/";
  // staging
  static const baseUrl = "https://oil-futures.apps.uat.codebridge.live/";
  static const secret =
      "00a11be53e71608c37c1653f28adfd1bcff089abb15e6c0cacbae0da02934d9b";
}

class APIResponse<T> {
  final String? errorMessage;
  final T? data;
    Map<String, dynamic>? response;
  APIResponse({
    required this.errorMessage,
    required this.data,
    this.response
  }) : assert(
          (errorMessage == null && data != null) ||
              (errorMessage != null && data == null),
        );
}
