import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movieapp/api/getDataApi.dart';
import 'package:movieapp/model/MovieModel.dart';
import 'package:movieapp/routes/appRoutes.dart';
import 'package:movieapp/screens/homescreen/homecontroller.dart';
import 'package:movieapp/utils/Utils.dart';

class SearchScreen extends StatelessWidget {
  final controller = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF8E725B),
          title: Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (text) => controller.onSearchTextChanged(text),
              decoration: const InputDecoration(
                hintText: 'Enter search term...',
                border: InputBorder.none,
              ),
            ),
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF8E725B), Color(0xFF5C3E2B), Color(0xFF3B2417)],
            ),
          ),
          child: controller.searchText.value.isEmpty
              ? const Center(child: Text('Enter a search term'))
              : FutureBuilder<List<MovieModel>>(
                  future: GetDataApi.searchMovies(controller.searchText.value),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      return const Center(
                        child: Text('No movies found'),
                      );
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                        child: Text('No movies found'),
                      );
                    } else {
                      final List<MovieModel> searchResults = snapshot.data!;
                      return GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: Utils.calculateCrossAxisCount(),
                          crossAxisSpacing: 8.0,
                          mainAxisSpacing: 8.0,
                        ),
                        padding:
                            EdgeInsets.symmetric(horizontal: Get.width * 0.02),
                        itemBuilder: (context, index) {
                          final MovieModel movie = searchResults[index];
                          return GestureDetector(
                            onTap: () {
                              Get.toNamed(AppRoutes.detailScreen,
                                  arguments: movie);
                            },
                            child: Card(
                              elevation: 4.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: customImage(imgUrl: movie.imageUrl),
                            ),
                          );
                        },
                        itemCount: snapshot.data?.length ?? 0,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                      );
                    }
                  },
                ),
        ),
      ),
    );
  }

  Widget customImage({required String imgUrl}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: CachedNetworkImage(
        imageUrl: imgUrl,
        fit: BoxFit.cover,
      ),
    );
  }
}
