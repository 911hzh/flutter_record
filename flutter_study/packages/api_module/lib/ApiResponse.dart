class ApiResponse<T> {
  final int code;
  final String message;
  final T data;
  ApiResponse({required this.code, required this.message, required this.data});
}
