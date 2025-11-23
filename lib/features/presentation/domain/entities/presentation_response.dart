class PresentationResponse {
  final bool success;
  final String? url;
  final String message;

  PresentationResponse({
    required this.success,
    this.url,
    required this.message,
  });

  factory PresentationResponse.fromJson(Map<String, dynamic> json) {
    return PresentationResponse(
      success: json['success'] ?? false,
      url: json['data']?['url'],
      message: json['message'] ?? '',
    );
  }
}