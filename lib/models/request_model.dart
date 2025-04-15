
/// GPT questions model
class RequestModel {
  final String userUid;

  final String request;

  RequestModel({
    required this.userUid,
    required this.request,
  });

  RequestModel copyWith({
    String? userUid,
    String? request,
  }) {
    return RequestModel(
      userUid: userUid ?? this.userUid,
      request: request ?? this.request,
    );
  }

  factory RequestModel.fromJson(Map<String, dynamic> json) {
    return RequestModel(
      userUid: json['userUid'],
      request: json['request'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userUid': userUid,
      'request': request,
    };
  }
}
