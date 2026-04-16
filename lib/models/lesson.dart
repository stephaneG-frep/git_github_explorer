class Lesson {
  const Lesson({
    required this.id,
    required this.title,
    required this.summary,
    required this.content,
    required this.level,
    required this.tags,
  });

  final String id;
  final String title;
  final String summary;
  final String content;
  final String level;
  final List<String> tags;
}
