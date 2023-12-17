class User{
  String? id;
  String? firstName;
  String? lastName;
  String? email;
  int? balance;
  var profilePic;

  User({this.id, this.firstName, this.lastName, this.email, this.balance, this.profilePic});

  factory User.fromJson(Map<String, dynamic> json){
    return User(
      id: json['_id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      balance: json['balance'],
      profilePic: json['profilePic'],
    );
  }
}