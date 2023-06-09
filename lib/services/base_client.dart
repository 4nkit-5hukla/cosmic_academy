import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:cosmic_assessments/config/constants.dart';
import 'package:cosmic_assessments/controllers/global_controller.dart';
import 'package:cosmic_assessments/services/app_exceptions.dart';

class BaseClient {
  final globalController = Get.find<GlobalController>();
  static var requestGetter = http.get;
  static var client = http.Client();

  Uri getURI(String api) {
    return api.startsWith("http") ? Uri.parse(api) : Uri.parse(baseUrl + api);
  }

  Future<Uint8List> fetchImageData(String api) async {
    final String token = globalController.token.value;
    final Map<String, String> headers = {"Authorization": "Bearer $token"};
    final Uri uri = getURI(api);
    final response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception('Failed to load image');
    }
  }

  Future<String> fetchTextData(String api) async {
    final String token = globalController.token.value;
    final Map<String, String> headers = {"Authorization": "Bearer $token"};
    final Uri uri = getURI(api);
    final response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to load text');
    }
  }

  Future<Uint8List> fetchVideoData(String api) async {
    final String token = globalController.token.value;
    final Map<String, String> headers = {"Authorization": "Bearer $token"};
    final Uri uri = getURI(api);
    final res = await http.get(uri, headers: headers);
    if (res.statusCode == 200) {
      return res.bodyBytes;
    } else {
      throw Exception('Failed to load video');
    }
  }

  Future<Uint8List> fetchPdfData(String api) async {
    final String token = globalController.token.value;
    final Map<String, String> headers = {"Authorization": "Bearer $token"};
    final Uri uri = getURI(api);
    final response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception('Failed to load PDF');
    }
  }

  //GET
  Future<dynamic> get(String api) async {
    final Uri uri = getURI(api);
    try {
      var request = http.Request('GET', uri);
      if (globalController.token.value.isNotEmpty) {
        request.headers.addAll(
          {
            "Authorization": "Bearer ${globalController.token.value}",
          },
        );
      }
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      if (kDebugMode) {
        print(
          "################################################",
        );
        print(
          "${response.request?.method} ${response.request?.url}",
        );
        print(
          "headers: ${response.request?.headers.toString()}",
        );
        print(
          "status: ${response.statusCode}",
        );
        print(
          "response data: ${utf8.decode(
                response.bodyBytes,
              ).toString()}",
        );
        print(
          "################################################",
        );
      }
      return _processResponse(
        response,
      );
    } on SocketException {
      throw FetchDataException(
        'No Internet connection',
        uri.toString(),
      );
    } on TimeoutException {
      throw ApiNotRespondingException(
        'API not responded in time',
        uri.toString(),
      );
    }
  }

  //POST
  Future<dynamic> post(String api, dynamic payloadObj) async {
    final Uri uri = getURI(api);
    var payload = json.encode(
      payloadObj,
    );
    try {
      var response = await client
          .post(
            uri,
            headers: {
              "Authorization": "Bearer ${globalController.token.value}",
            },
            body: payload,
          )
          .timeout(
            const Duration(
              seconds: timeOutDuration,
            ),
          );
      return _processResponse(
        response,
      );
    } on SocketException {
      throw FetchDataException(
        'No Internet connection',
        uri.toString(),
      );
    } on TimeoutException {
      throw ApiNotRespondingException(
        'API not responded in time',
        uri.toString(),
      );
    }
  }

  Future<dynamic> formPost(
    String api, [
    Map<String, String>? payloadObj,
    String? fieldName,
    String? filePath,
    bool? useAuth = true,
  ]) async {
    final Uri uri = getURI(api);
    try {
      var request = http.MultipartRequest('POST', uri);
      if (useAuth == true) {
        request.headers.addAll(
          {
            "Authorization": "Bearer ${globalController.token.value}",
          },
        );
      }
      if (payloadObj != null) {
        request.fields.addAll(
          payloadObj,
        );
      }
      if (fieldName != null && filePath != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            fieldName,
            filePath,
          ),
        );
      }
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      if (kDebugMode) {
        print(
          "################################################",
        );
        print(
          "${response.request?.method} ${response.request?.url}",
        );
        print(
          "headers: ${response.request?.headers.toString()}",
        );
        print(
          "fields: ${json.encode(request.fields)}",
        );
        if (fieldName != null && filePath != null) {
          print(
            "fieldName: $fieldName",
          );
          print(
            "files: ${request.files[0].filename}",
          );
        }
        print(
          "status: ${response.statusCode}",
        );
        print(
          "response data: ${utf8.decode(
                response.bodyBytes,
              ).toString()}",
        );
        print(
          "################################################",
        );
      }
      return _processResponse(
        response,
      );
    } on SocketException {
      throw FetchDataException(
        'No Internet connection',
        uri.toString(),
      );
    } on TimeoutException {
      throw ApiNotRespondingException(
        'API not responded in time',
        uri.toString(),
      );
    }
  }

  //POST
  Future<dynamic> put(
    String api,
    dynamic payloadObj,
  ) async {
    final Uri uri = getURI(api);
    var payload = json.encode(payloadObj);
    try {
      var response = await client
          .put(
            uri,
            headers: {
              "Authorization": "Bearer ${globalController.token.value}",
            },
            body: payload,
          )
          .timeout(
            const Duration(
              seconds: timeOutDuration,
            ),
          );
      return _processResponse(response);
    } on SocketException {
      throw FetchDataException(
        'No Internet connection',
        uri.toString(),
      );
    } on TimeoutException {
      throw ApiNotRespondingException(
        'API not responded in time',
        uri.toString(),
      );
    }
  }

  //DELETE
  Future<dynamic> delete(String api) async {
    final Uri uri = getURI(api);
    try {
      print(uri);
      var response = await client.delete(
        uri,
        headers: {
          "Authorization": "Bearer ${globalController.token.value}",
        },
      ).timeout(
        const Duration(
          seconds: timeOutDuration,
        ),
      );
      return _processResponse(
        response,
      );
    } on SocketException {
      throw FetchDataException(
        'No Internet connection',
        uri.toString(),
      );
    } on TimeoutException {
      throw ApiNotRespondingException(
        'API not responded in time',
        uri.toString(),
      );
    }
  }

  dynamic _processResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        var responseJson = utf8.decode(
          response.bodyBytes,
        );
        return responseJson;
      case 201:
        var responseJson = utf8.decode(
          response.bodyBytes,
        );
        return responseJson;
      case 400:
        throw BadRequestException(
          utf8.decode(response.bodyBytes),
          response.request!.url.toString(),
        );
      case 401:
      case 403:
        throw UnAuthorizedException(
          utf8.decode(response.bodyBytes),
          response.request!.url.toString(),
        );
      case 422:
        throw BadRequestException(
          utf8.decode(response.bodyBytes),
          response.request!.url.toString(),
        );
      case 500:
      default:
        throw FetchDataException(
          'Error occurred with code : ${response.statusCode}',
          response.request!.url.toString(),
        );
    }
  }
}
