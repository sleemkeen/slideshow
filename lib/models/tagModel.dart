class TagModel {
  int id;
  String tag;
  String code_id;

  TagModel(
      {this.id,
        this.tag,
        this.code_id,
      });

  TagModel.fromJson(Map<String, dynamic> item) {
    this.id = item['id'];
    this.tag = item['tag'];
    this.code_id = item['code_id'];
  }
}