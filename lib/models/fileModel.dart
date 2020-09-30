class FileModel {
  int id;
  String url;
  String type;
  String duration;
  String video_duration;

  FileModel(
      {this.id,
        this.url,
        this.type,
        this.duration,
        this.video_duration
      });

  FileModel.fromJson(Map<String, dynamic> item) {
    this.id = item['id'];
    this.url = item['url'];
    this.type = item['type'];
    this.duration = item['duration'];
    this.video_duration = item['video_duration'];
  }
}