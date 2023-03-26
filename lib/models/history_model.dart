class HistoryModel {
  final StatusModel statusModel;
  final CompanyModel companyModel;
  final RangingModel rangingModel;
  
  HistoryModel.fromJson(Map<String, dynamic> json)
      : statusModel = StatusModel.fromJson(json['status']),
        companyModel = CompanyModel.fromJson(json['company']),
        rangingModel = RangingModel.fromJson(json['ranging'])
  ;
}

class StatusModel {
  final String name;

  StatusModel.fromJson(Map<String, dynamic> json)
      : name = json['name'] ?? ''
  ;
}

class RangingModel {
  final String interview_date, interview_time, interview_address, interview_comment, order_date;

  RangingModel.fromJson(Map<String, dynamic> json)
      : interview_date = json['interview_date']  ?? '',
        interview_time = json['interview_time']  ?? '',
        interview_comment = json['interview_comment'] ?? '',
        order_date = json['order_date'] ?? '',
        interview_address = json['address'] ?? ''
  ;
}

class CompanyModel {
  final String name, full_address;

  CompanyModel.fromJson(Map<String, dynamic> json)
      : name = json['name'] ?? '',
        full_address = json['full_address']  ?? ''
  ;
}

class QueueModel {
  final int raiting;
  final String full_name;

  QueueModel.fromJson(Map<String, dynamic> json)
      : raiting = json['raiting'] ?? 0,
        full_name = json['full_name']  ?? ''
  ;
}