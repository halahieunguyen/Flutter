class Relationship {
    static const noFollow = 0;
    static const doubleFollow = 1;
    static const follow = 2;
    static const followed = 3;

    static const noFriend = 0;
    static const friend = 1;
    static const requestFriend = 2;
    static const requestFriended = 3;
    static const prevent = 4;
    static const prevented = 5;

  int? _id;
  int? _userId1;
  late int _userId2;
  late int _typeFollow;
  late int _typeFriend;
  DateTime?  _dateAccept;

  Relationship (
    int id,
    int userId1,
    int userId2,
    int typeFollow,
    int typeFriend,
    DateTime  dateAccept,
  ) {
    _id = id;
    _userId1 = userId1;
    _userId2 = userId2;
    _typeFollow = typeFollow;
    _typeFriend = typeFriend;
    _dateAccept = dateAccept;
  }
  Relationship.empty (
    int userId
  ) {
    _userId2 = userId;
    _typeFollow = noFollow;
    _typeFriend = noFriend;
  }
  Relationship.ajax(
   Map<String, dynamic> options
  ) {
    if(options['id']!=null) {
      this._id = options['id'];
    };
    if(options['user_id_1']!=null) {
      this._userId1 = options['user_id_1'];
    };
    if(options['user_id_2']!=null) {
      this._userId2 = options['user_id_2'];
    };
    if(options['type_follow']!=null) {
      this._typeFollow = options['type_follow'];
    };
    if(options['type_friend']!=null) {
      this._typeFriend = options['type_friend'];
    };
    if(options['date_accept']!=null) {
      this._dateAccept = DateTime.parse(options['date_accept']);
    };


  }
  int get getId => _id ?? 0;
  int get getTypeFriend => _typeFriend;
  int get getTypeFollow => _typeFollow;
  int get getUserId1 => _userId1 ?? 0;

  set setTypeFriend(typeFriend) {
    _typeFriend = typeFriend;
  }
  set setTypeFollow(typeFollow) {
    _typeFollow = typeFollow;
  }

}