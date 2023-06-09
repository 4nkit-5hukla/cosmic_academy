class Choice {
  Choice({
    this.choiceKey,
    required this.choice,
    required this.correctAnswer,
    this.position,
  });

  String? choiceKey;
  String choice;
  String correctAnswer;
  String? position;

  Choice copyWith({
    String? choiceKey,
    required String choice,
    required String correctAnswer,
    String? position,
  }) =>
      Choice(
        choiceKey: choiceKey,
        choice: choice,
        correctAnswer: correctAnswer,
        position: position,
      );

  factory Choice.fromMap(Map<String, dynamic> json) => Choice(
        choiceKey: json["choice_key"],
        choice: json["choice"],
        correctAnswer: json["correct_answer"],
        position: json["position"],
      );

  Map<String, dynamic> toMap() => {
        "choice_key": choiceKey,
        "choice": choice,
        "correct_answer": correctAnswer,
        "position": position,
      };
}
