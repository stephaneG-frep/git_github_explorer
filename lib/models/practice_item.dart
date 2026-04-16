class PracticeItem {
  const PracticeItem({
    required this.id,
    required this.title,
    required this.steps,
    required this.goal,
  });

  final String id;
  final String title;
  final List<String> steps;
  final String goal;
}
