class ProfileModel {
  final String fullName, birthdate, email, phone_number, position, family_status, privilege, image_url;
  final int age;

  ProfileModel.fromJson(Map<String, dynamic> json)
      : fullName = json['full_name'] ?? '',
        birthdate = json['birthdate']  ?? '',
        email = json['email']  ?? '',
        phone_number = json['phone_number']  ?? '',
        position = json['position']  ?? '',
        age = json['age']  ?? 0,
        family_status = json['family_status']  ?? '',
        privilege = json['privilege']  ?? '',
        image_url = json['image_url']  ?? ''
  ;
}