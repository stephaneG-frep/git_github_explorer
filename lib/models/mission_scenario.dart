class MissionScenario {
  const MissionScenario({
    required this.id,
    required this.title,
    required this.context,
    required this.options,
    required this.correctIndex,
    required this.explanation,
  });

  final String id;
  final String title;
  final String context;
  final List<String> options;
  final int correctIndex;
  final String explanation;
}
