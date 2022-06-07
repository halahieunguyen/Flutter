class User {
  int? _id;
  String? _firstName;
  String? _lastName;
  String? _email;
  String? _phone;
  DateTime? _birdDay;
  String? _address;
  String? _avatar;
  String? _cover;
  String? _story;
  DateTime? _createdAt;

  User (
    int id,
    String firstName,
    String lastName,
    String email,
    String phone,
    DateTime birdDay,
    String address,
    String avatar,
    String cover,
    String story,
    DateTime createdAt
  ) {
    this._id = id;
    this._firstName = firstName;
    this._lastName = lastName;
    this._email = email;
    this._phone = phone;
    this._birdDay = birdDay;
    this._address = address;
    this._avatar = avatar;
    this._cover = cover;
    this._story = story;
    this._createdAt = createdAt;
  }

  User.ajaxOptimize(
   Map<String, dynamic> options
  ) {
    if(options['id']!=null) {
      this._id = options['id'];
    };

    if(options['avatar']!=null) {
      this._avatar = options['avatar'];
    };

    if(options['last_name']!=null) {
      this._lastName = options['last_name'];
    };

    if(options['first_name']!=null) {
      this._firstName = options['first_name'];
    };
  }
  String get getFullname => "$_firstName $_lastName";
  dynamic get getAvatar => _avatar;

}