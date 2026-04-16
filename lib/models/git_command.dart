class GitCommand {
  const GitCommand({
    required this.command,
    required this.category,
    required this.title,
    required this.what,
    required this.when,
    required this.example,
    required this.tip,
  });

  final String command;
  final String category;
  final String title;
  final String what;
  final String when;
  final String example;
  final String tip;
}
