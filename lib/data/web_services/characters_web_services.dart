import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:movies/constants/strings.dart';

class CharactersWebServices {
  late Dio dio;
  CharactersWebServices() {
    BaseOptions options = BaseOptions(
        baseUrl: baseUrl,
        receiveDataWhenStatusError: true,
        connectTimeout: 20 * 1000,
        receiveTimeout: 20 * 1000);
    dio = Dio(options);
  }
  Future<List<dynamic>> getAllCharacters() async {
    try {
      Response response = await dio.get('characters');
      print(response.data.toString());
      return response.data;
    } catch (error) {
      print(error.toString());
      return [];
    }
  }

  Future<List<dynamic>> getAllQuotes(String charName) async {
    try {
      Response response =
          await dio.get('quote', queryParameters: {'author': charName});
      print(response.data.toString());
      return response.data;
    } catch (error) {
      print(error.toString());
      return [];
    }
  }
}
