import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:get/get.dart';
import 'package:cosmic_assessments/controllers/base_controller.dart';
import 'package:cosmic_assessments/models/questions/question.dart';
import 'package:cosmic_assessments/services/base_client.dart';

class TestQuestionsController extends GetxController with BaseController {
  RxBool isLoading = false.obs;
  RxBool loadingQuestions = false.obs;
  RxString currentTestGuid = "".obs;
  List<Question> testQuestions = List<Question>.empty(growable: true).obs;
  List<File?> testQuestionAssets = List<File?>.empty(growable: true).obs;
  late List<dynamic> testAnswers = List.empty(growable: true).obs;
  final Map messages = {
    'QUESTION_ADDED_SUCCESSFULLY': 'Question added successfully.',
    'QUESTION_REMOVED_FROM_TEST': 'Question removed from test.',
  };

  List<Question> getFilteredQuestions(String term) {
    return testQuestions
        .where((element) =>
            element.question.toLowerCase().contains(term.toLowerCase()))
        .toList();
  }

  int getTotalQuestions() => testQuestions.length;

  Question getQuestion(String guid) =>
      testQuestions.firstWhere((question) => guid == question.guid);

  Question getQuestionByIndex(int index) => testQuestions[index];

  File? getQuestionAssetsByIndex(int index) => testQuestionAssets[index];

  Future<String> downloadAssets(String path, String fileName) async {
    final response =
        await BaseClient.requestGetter(Uri.parse("$path$fileName"));
    final bytes = response.bodyBytes;
    final appCacheDir = await getTemporaryDirectory();
    final assetFile = File('${appCacheDir.path}/$fileName');
    await assetFile.writeAsBytes(bytes, flush: true);
    return assetFile.path;
  }

  Future<File?> readAssets(String fileName) async {
    final appCacheDir = await getTemporaryDirectory();
    final assetFile = File('${appCacheDir.path}/$fileName');
    if (await assetFile.exists()) {
      return assetFile;
    }
    return null;
  }

  Future<bool> startCachingAssets() async {
    if (testQuestions.isNotEmpty) {
      for (int i = 0; i < testQuestions.length; i++) {
        Question quest = testQuestions[i];
        if (quest.fileURLPath != null && quest.fileHash != null) {
          File? foundFile = await readAssets(quest.fileHash!);
          if (foundFile == null) {
            await downloadAssets(quest.fileURLPath!, quest.fileHash!);
            File? assetFile = await readAssets(quest.fileHash!);
            testQuestionAssets.add(assetFile);
          } else {
            testQuestionAssets.add(foundFile);
          }
        } // else if(quest.parentFileUrl!=null){}
        else {
          testQuestionAssets.add(null);
        }
      }
      isLoading(false);
      return testQuestionAssets.length == testQuestions.length;
    } else {
      return false;
    }
  }

  Future fetchTestQuestions(
      [bool choices = false, bool? setAnswers = false]) async {
    if (currentTestGuid.isNotEmpty) {
      isLoading(true);
      var res = await BaseClient()
          .get("/tests/preview/$currentTestGuid/${choices ? '1' : '0'}")
          .catchError(handleError);
      if (res == null) return;
      Map data = json.decode(res);
      List<Question> questions = List<Question>.from(
        data['payload'].map(
          (x) => Question.fromMap(
            x,
          ),
        ),
      );
      testQuestions.assignAll(questions);
    }
  }

  Future<String> deleteTestQuestions(dynamic quesData) async {
    if (currentTestGuid.isEmpty) {
      return "";
    }
    var res = await BaseClient()
        .formPost("/tests/remove_question/$currentTestGuid", quesData)
        .catchError(handleError);
    Map data = json.decode(res);
    if (data['success']) {
      return messages[data['message']];
    } else {
      return "";
    }
  }
}
