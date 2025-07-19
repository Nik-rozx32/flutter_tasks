class User {
  final String id;
  final String title;

  User({required this.id, required this.title});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(id: json['id'].toString(), title: json['title']);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'title': title};
  }
}
