class User {
  String email;
  List<dynamic> seenSpecies = [];

  User({required this.email, ss}) {
    if (ss != null) {
      seenSpecies = ss;
    }
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['email'],
      ss: json['seenSpecies'],
    );
  }

  Map<String, dynamic> toJson() => {
        'email': email,
        'seenSpecies': seenSpecies,
      };
}
