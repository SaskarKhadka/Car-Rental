class User {
  late String name;
  late String id;
  late String email;
  late String phoneNumber;

  User.fromData({required Map<String, dynamic> userData, required this.id}) {
    name = userData["name"];
    email = userData["email"];
    phoneNumber = userData["phoneNumber"];
  }

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phoneNumber,
  });

  Map<String, dynamic> get toJson => {
        "id": id,
        "name": name,
        "email": email,
        "phoneNumber": phoneNumber,
      };
}
