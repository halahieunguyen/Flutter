class Like {
  late int _id;
  late int _type;
  late int _userId;
  late int _postId;
  static const typeNotLike = 0;
  static const typeLike = 1;
  static const typeFavorite = 2;
  static const typeSmile = 3;
  static const typeSad = 4;
  static const typeWow = 5;
  static const typeAngry = 6;
  Like (
    int id,
    int type,
    int userId,
    int postId,
  ) {
    _id = id;
    _type = type;
    _userId = userId;
    _postId = postId;
  }

  Like.ajax(
   Map<String, dynamic> options
  ) {
    if(options['id']!=null) {
      this._id = options['id'];
    };

    if(options['type']!=null) {
      this._type = options['type'];
    };

    if(options['user_id']!=null) {
      this._userId = options['user_id'];
    };

    if(options['post_id']!=null) {
      this._postId = options['post_id'];
    };
  }
  int get getType => _type;
}