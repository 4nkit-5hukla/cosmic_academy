class ReportAnswer {
  ReportAnswer({
    required this.questionId,
    required this.question,
    required this.answerKey,
    required this.response,
    required this.marksObtained,
  });

  String questionId;
  String question;
  String answerKey;
  String response;
  String marksObtained;

  ReportAnswer copyWith({
    required String questionId,
    required String question,
    required String answerKey,
    required String response,
    required String marksObtained,
  }) =>
      ReportAnswer(
        questionId: questionId,
        question: question,
        answerKey: answerKey,
        response: response,
        marksObtained: marksObtained,
      );

  factory ReportAnswer.fromMap(Map<String, dynamic> json) => ReportAnswer(
        questionId: json["guid"],
        question: json["question"],
        answerKey: json["answer_key"],
        response: json["response"],
        marksObtained: json["marks_obtained"],
      );

  Map<String, dynamic> toMap() => {
        "guid": questionId,
        "question": question,
        "answer_key": answerKey,
        "response": response,
        "marks_obtained": marksObtained,
      };
}
