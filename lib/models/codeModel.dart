class CodeModel {
  int id;
  String codes;
  dynamic tokens;

  CodeModel(
      {this.id,
        this.codes,
        this.tokens,
      });

  CodeModel.fromJson(Map<String, dynamic> item) {
    this.id = item['id'];
    this.codes = item['codes'];
    this.tokens = item['tokens'];
  }
}