import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movieapp/api/getDataApi.dart';
import 'package:movieapp/model/MovieModel.dart';

class HomeController extends GetxController {
  List<MovieModel> movies = <MovieModel>[];
  final searchText = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  void onSearchTextChanged(String text) {
    searchText.value = text; // Update the search text
  }

  Future<List<MovieModel>?> fetchData() async {
    try {
      final List<MovieModel> result = await GetDataApi.fetchData();
      movies.assignAll(result);
      return result;
    } catch (error) {
      // Handle error (e.g., show a message to the user)
      log('Error fetching data: $error');
    }
    return null;
  }
}
