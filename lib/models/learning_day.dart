class LearningDay {
  const LearningDay({
    required this.id,
    required this.dayNumber,
    required this.title,
    required this.task,
    required this.expectedMinutes,
  });

  final String id;
  final int dayNumber;
  final String title;
  final String task;
  final int expectedMinutes;
}
