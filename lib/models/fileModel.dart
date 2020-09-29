class FileModel {
  int id;
  String url;
  String type;
  String duration;

  FileModel(
      {this.id,
        this.url,
        this.type,
        this.duration
      });

  FileModel.fromJson(Map<String, dynamic> item) {
    this.id = item['id'];
    this.url = item['url'];
    this.type = item['type'];
    this.duration = item['duration'];
  }
}