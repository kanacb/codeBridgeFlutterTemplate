class Response<T> {
  final T? data;
  final String? error;
  final String? subClass;
  final int? statusCode;
  final String msg;

  Response({required this.msg, this.error, this.subClass,  this.statusCode, this.data});

  bool get isSuccess => error == null;
}