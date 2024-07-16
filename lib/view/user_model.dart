class User {
  final String? id;
  final String? name;
  final String? email;
  final String? mobile_number;
  final String? date;
  final String? days;

  const User( {this.id,this.email, this.name, this.mobile_number, this.days, this.date});

  factory User.fromMap(Map<String, dynamic> json) => User(
      id: json["id"],
      name: json["name"],
      email: json["email"],
      mobile_number: json["mobile_number"],
      days: json["days"],
      date: json["date"]);

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'mobile_number': mobile_number,
      'days': days,
      'date': date,
    };
  }
}
