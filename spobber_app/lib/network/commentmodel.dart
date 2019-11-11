class ObjectComment {
  final String username;
  final String content;

  ObjectComment({
    this.username,
    this.content,
  });

  ObjectComment fromJson(Map<String, dynamic> json) {
    return ObjectComment(
        username: json['username'],
        content: json['content']);
  }
}
