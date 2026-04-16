class VisualConcept {
  const VisualConcept({
    required this.id,
    required this.title,
    required this.description,
    required this.nodes,
  });

  final String id;
  final String title;
  final String description;
  final List<String> nodes;
}
