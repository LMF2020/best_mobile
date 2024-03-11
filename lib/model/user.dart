class User {
  final String? id;
  final String? email;
  final int? pmi;
  final String? createdAt;
  final int? userType;
  final String? firstName;
  final String? lastName;
  final String? picUrl;
  final String? displayName;
  final String? zak;
  final String? apiToken;

  User({
    this.id,
    this.email,
    this.pmi,
    this.userType,
    this.createdAt,
    this.firstName,
    this.lastName,
    this.picUrl,
    this.displayName,
    this.zak,
    this.apiToken,
  });

  // Convert a User into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
      'pmi': pmi,
      'type': userType,
      'first_name': firstName,
      'last_name': lastName,
      'created_at': createdAt,
      'zak': zak,
      'api_token': apiToken,
    };
  }

  /// load user from http api
  factory User.fromMap(Map<String, dynamic> map) {
    var firstName = map['first_name'] ?? "";
    var lastName = map['last_name'] ?? "";
    String displayName = (firstName + lastName) ?? map['email'];
    return User(
      id: map['id'],
      email: map['email'],
      pmi: map['pmi'],
      userType: map['type'],
      firstName: firstName,
      lastName: lastName,
      createdAt: map['created_at'],
      picUrl: map['pic_url'],
      displayName: displayName,
      zak: map['zak'],
      apiToken: map['token'],
    );
  }

  @override
  String toString() {
    return 'User{id: $id, email: $email, userType: $userType, createdAt: $createdAt, pmi: $pmi}';
  }
}
