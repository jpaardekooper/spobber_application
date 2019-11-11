class ObjectComment {
  final String username;
  final String content;
  final DateTime time;

  ObjectComment({
    this.username,
    this.content,
    this.time,
  });

  ObjectComment fromJson(Map<String, dynamic> json) {
    return ObjectComment(
        username: json['username'],
        content: json['content'],
        time: json['time']);
  }
}
