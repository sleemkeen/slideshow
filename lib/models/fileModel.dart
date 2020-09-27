class FileModel {
  int id;
  String url;
  String type;
  String size;
  int duration;

  FileModel(
      {this.id,
        this.url,
        this.type,
        this.duration
      });

  FileModel.fromJson(Map<String, dynamic> item) {
    this.id = item['id'];
    this.url = item['url'];
    this.size = item['size'];
    this.duration = item['duration'];

  }
}