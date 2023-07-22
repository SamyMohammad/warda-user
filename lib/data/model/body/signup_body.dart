class SignUpBody {
  String? fName;
  String? lName;
  String? username;
  String? phone;
  String? email;
  String? password;
  String? refCode;

  SignUpBody(
      {this.fName,
      this.lName,
      this.phone,
      this.email = '',
      this.password,
      this.refCode = '',
      this.username = ''});

  SignUpBody.fromJson(Map<String, dynamic> json) {
    fName = json['f_name'];
    lName = json['l_name'];
    phone = json['phone'];
    email = json['email'];
    username = json['username'];
    password = json['password'];
    refCode = json['ref_code'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['f_name'] = fName;
    data['l_name'] = lName;
    data['phone'] = phone;
    data['username'] = username;
    data['email'] = email;
    data['password'] = password;
    data['ref_code'] = refCode;
    return data;
  }
}
