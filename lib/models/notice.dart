class Notice {
  final int id;
  final String title;
  final String datetime;
  final String author;
  final int category;
  final String url;

  Notice({
    this.id,
    this.title,
    this.datetime,
    this.author,
    this.category,
    this.url,
  });

  factory Notice.fromList(List data) {
    return new Notice(
      id: data[0],
      title: data[1],
      datetime: data[2],
      author: data[3],
      category: data[4],
      url: data[5],
    );
  }
}
