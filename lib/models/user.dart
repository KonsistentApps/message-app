class User {
  final String id;
  final String fullName;
  final String email;
  final String userRole;
  final List discussions;

  User({this.id, this.fullName, this.email, this.userRole, this.discussions});

  User.fromData(Map<String, dynamic> data)
      : id = data['id'],
        fullName = data['fullName'],
        email = data['email'],
        userRole = data['userRole'],
        discussions = data['disussions'];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'email': email,
      'userRole': userRole,
      'discussions': discussions,
    };
  }
}
