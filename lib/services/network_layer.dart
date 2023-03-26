import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:qamtu/urls.dart';

class NetworkLayer {
  Future<dynamic> makeRequest({required String url, bool isPost = false, Map<String, String>? headers, Map<String, String>? body, required String language, Map<String, String>? parameters}) async {
    String requestURL = '$MID_URL/$language$url';
    try {
      final response = isPost ? await http.post(
          Uri.http(BASE_URL, requestURL),
          headers: headers,
          body: body
      ) : await http.get(Uri.http(BASE_URL, requestURL, parameters),
          headers: headers);

      if(response.statusCode == 200) {
        return response;
      } else if(response.statusCode == 401) {
        return 401;
      } else {
        final Map<String, dynamic> answerMap = responseToMap(response);
        if (answerMap.containsKey('message')) {
          return answerMap['message'];
        } else {
          return language == 'kk' ? 'Белгісіз ақау' : 'Неизвестная ошибка';
        }
      }
    } catch (e) {

      if(e is SocketException){
        return language == 'kk' ? 'Интернет байланысын тексеріңіз' : 'Проверьте интернет подключение';
      }
      else if(e is TimeoutException){
        return language == 'kk' ? 'Ұзақ жүктеу, қайталап көріңіз' : 'Долгая загрузка';
      }
      else {
        return language == 'kk' ? 'Белгісіз ақау' : 'Неизвестная ошибка';
      }
    }
  }

  Map<String, dynamic> responseToMap(Response response) {
    final utfDecoded = utf8.decode(response.bodyBytes);
    final decodedJson = jsonDecode(utfDecoded);
    final Map<String, dynamic> answerMap = decodedJson;

    return answerMap;
  }

  Future<dynamic> refreshToken(String refreshToken, String language) async {
    String requestURL = '$MID_URL/$language$REFRESH_TOKEN_URL';
    try {
      final response = await http.post(
          Uri.http(BASE_URL, requestURL),
          body: {'refreshToken': refreshToken}
      );
      if(response.statusCode == 200) {
        final Map<String, dynamic> answerMap = responseToMap(response);
        if(answerMap.containsKey('access_token') && answerMap.containsKey('refresh_token')) {
          return answerMap;
        } else {
          return null;
        }
      } else if(response.statusCode == 401) {
        return null;
      } else {
        return language == 'kk' ? 'Белгісіз ақау' : 'Неизвестная ошибка';
      }
    } catch (e) {
      if(e is SocketException){
        return language == 'kk' ? 'Интернет байланысын тексеріңіз' : 'Проверьте интернет подключение';
      }
      else if(e is TimeoutException) {
        return language == 'kk' ? 'Ұзақ жүктеу, қайталап көріңіз' : 'Долгая загрузка';
      }
      else {
        return language == 'kk' ? 'Белгісіз ақау' : 'Неизвестная ошибка';
      }
    }
  }
}