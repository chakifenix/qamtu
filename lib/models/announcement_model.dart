class AnnouncementModel {
  final int id;
  final String title;
  final String anons;
  final String image;

  AnnouncementModel.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        anons = json['anons'],
        id = json['id'],
        image = json['image']
  ;
}