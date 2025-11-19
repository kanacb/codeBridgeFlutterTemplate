class Result<T> {
  final T? data;
  final String? error ;
  final int? statusCode;

  Result({this.data, this.error, this.statusCode});

  bool get isSuccess => error == null;
}