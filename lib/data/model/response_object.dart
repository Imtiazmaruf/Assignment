class ResponseObject{
  final bool isSuccess;
  final int statusCode;
  final dynamic responseBody;
  final String? errorMessage;

  ResponseObject({required this.statusCode, required this.responseBody, this.errorMessage = '', required this.isSuccess});
}