class PostResponse {
  final int id;
  final String title;
  final String body;

  PostResponse({required this.id, required this.title, required this.body});

  factory PostResponse.fromJson(Map<String, dynamic> json) {
    return PostResponse(
      id: json['id'],
      title: json['title'],
      body: json['body'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
    };
  }
}
