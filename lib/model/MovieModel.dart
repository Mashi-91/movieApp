class MovieModel {
  int id;
  String name;
  String imageUrl; // Use this property to store the image URL
  String summary;
  String releaseDate;

  MovieModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.summary,
    required this.releaseDate,
  });

  factory MovieModel.fromJson(Map<String, dynamic> json) {
    return MovieModel(
      id: json['id'] as int,
      name: json['name'] as String,
      imageUrl: json['image']['original'] as String,
      summary: json['summary'] as String,
      releaseDate: json['premiered'] as String,
    );
  }
}
