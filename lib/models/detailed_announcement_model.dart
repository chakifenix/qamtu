class DetailedAnnouncementModel {
  final int id;
  final String title, anons, body, image;

  DetailedAnnouncementModel.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        anons = json['anons'],
        body = json['body'],
        image = json['image']
  ;
}