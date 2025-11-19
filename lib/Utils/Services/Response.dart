class Response<T> {
  final T? data;
  final String? error;
  final int? statusCode;
  final String msg;

  Response({required this.msg, this.error, this.statusCode, this.data});

  bool get isSuccess => error == null;
}