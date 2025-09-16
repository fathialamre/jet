class TodoRequest {
  final String title;
  final String description;
  final bool isCompleted;

  const TodoRequest({
    required this.title,
    required this.description,
    this.isCompleted = false,
  });

  factory TodoRequest.fromJson(Map<String, dynamic> json) => TodoRequest(
    title: json['title'] as String,
    description: json['description'] as String,
    isCompleted: json['isCompleted'] as bool? ?? false,
  );

  Map<String, dynamic> toJson() => {
    'title': title,
    'description': description,
    'isCompleted': isCompleted,
  };
}
