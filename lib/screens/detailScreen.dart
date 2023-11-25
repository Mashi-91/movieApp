import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:movieapp/model/MovieModel.dart';
import 'package:movieapp/screens/homescreen/homecontroller.dart';
import 'package:movieapp/utils/Utils.dart';

import '../routes/appRoutes.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final arguments = Get.arguments;
    final data = arguments as MovieModel;
    final releaseDate = data.releaseDate.split('-');
    final controller = Get.find<HomeController>();
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          InkWell(
              onTap: () {
                Get.toNamed(AppRoutes.searchScreen);
              },
              child: const Icon(Icons.search)),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: Get.width * 0.04),
              child: Card(
                child: Container(
                  width: double.infinity,
                  height: 400,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: CachedNetworkImageProvider(data.imageUrl),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: Get.height * 0.01),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: Get.width * 0.02),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Utils.customText(
                      text: data.name,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 26,
                    ),
                    Utils.customText(
                      text: 'Release Date: ${releaseDate[0]}',
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                    SizedBox(height: Get.height * 0.01),
                    Row(
                      children: [
                        Container(
                            padding: const EdgeInsets.all(4),
                            color: Colors.red,
                            child: const Icon(
                              Icons.thumb_up,
                              color: Colors.white,
                              size: 16,
                            )),
                        SizedBox(width: Get.width * 0.02),
                        Utils.customText(
                          text: 'Most Liked',
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        )
                      ],
                    ),
                    SizedBox(height: Get.height * 0.01),
                    Utils.customText(
                      text: data.summary
                          .replaceAll('<p>', '')
                          .replaceAll('<b>', '')
                          .replaceAll('</p>', '')
                          .replaceAll('</b>', ''),
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: Get.height * 0.01),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  height: 0.3,
                  color: Colors.white,
                ),
                Container(
                  margin: EdgeInsets.only(left: Get.width * 0.02),
                  width: Get.width * 0.3,
                  height: 4,
                  color: Colors.red,
                ),
                SizedBox(height: Get.height * 0.01),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: Get.width * 0.04),
                  child: Utils.customText(
                    text: 'More Like This',
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: Utils.calculateCrossAxisCount(),
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemBuilder: (context, index) {
                final List<MovieModel> shuffledMovies =
                    controller.movies.toList()..shuffle();
                final MovieModel movie = shuffledMovies[index];
                return GestureDetector(
                  onTap: () {
                    // Handle movie tap
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
              itemCount: controller.movies.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
            )
          ],
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
