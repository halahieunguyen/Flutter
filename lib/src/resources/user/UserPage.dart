import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:mxh/blocs/UserBloc.dart';
import 'package:mxh/model/Relationship.dart';
import 'package:mxh/model/user.dart';
import 'package:mxh/extension/http.dart' as httpMXH;
import 'package:mxh/src/resources/dialog/MessageDialog.dart';
import 'package:mxh/src/resources/post/ListImage.dart';
import 'package:mxh/src/resources/user/itemListUser.dart';
import '../../../blocs/PostBloc.dart';
import '../../../model/post.dart';
import '../dialog/LoadingDialog.dart';
import '../dialog/flashMessage.dart';
import '../post/formPost.dart';
import '../post/post.dart';
import '../ui/paddingTop.dart';


class UserPage extends StatefulWidget {
  late int _userId;
  UserPage(int id, {Key? key}) : super(key: key) {
    this._userId = id;
  }
   @override
  State<UserPage> createState() => _UserPageState(_userId);
}
class _UserPageState extends State<UserPage> {
  UserBloc _userBloc = new UserBloc();
  List<User> _listUser = <User>[];
  _UserPageState(int id) {
    this._userId = id;
  }
  late int _userId;

  int _page = 1;
  User? _user;
  bool loadingPage = false;
  List<Post> _listPost = <Post>[];
  List<User>_listFriendCustom = [];
  @override
  void initState() {
    if (_userId == User.currentUser?.getId) {
      setState(() {
          this._user = User.currentUser;
      });
    } else {
       getInfo();
    };
    print("1111111111111111111111111111111111111111111111111111111111");
    if (_user?.getCountFollowed == null) {
      getCountFollowed();
    }
    print("22222222222222222222222222222222222222222222222222222222");
    ajaxLoadListFriend();
    ajaxLoadListPost(1);

    super.initState();
  }
  PostBloc _postBloc = new PostBloc();
   Future<void> ajaxLoadListPost(int page) async {
       _listPost += await _postBloc.ajaxLoadListPost(page, () {}, (msg) {
          MessageDialog.showMessageDialog(context, 'Trang chủ', msg);
        }, userId: _userId);
      setState(() {
        _listPost;
        loadingPage= false;
    });
  }
  Future<void> ajaxLoadListFriend() async {
       _listFriendCustom = await _userBloc.ajaxGetList(1, () {}, (msg) {
            MessageDialog.showMessageDialog(context, 'Bạn bè', msg);
          },
          type: "listFriend",
        );
      setState(() {
        _listFriendCustom;
    },
    );
  }
  getInfo () async{
    _user = await _userBloc.getUserInfo(_userId, () {}, (msg) {
            MessageDialog.showMessageDialog(context, 'Bạn bè', msg);
        }
      );

}
  getCountFollowed () async{
    int count = await _userBloc.getCountFollowed(_userId, () {}, (msg) {
            MessageDialog.showMessageDialog(context, 'Bạn bè', msg);
          }
        );

      setState(() {
          _user?.setCountFollowed = count;
      });
  }
  @override
  Widget TopProfile() {
    return Container(
      height: 350,
      child: Stack(children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: 200,
          child: (_user?.getCover != null)
          ? Image.network(
            httpMXH.hostImg + _user?.getCover, fit: BoxFit.cover
          )
          : Image.asset('assets/images/nullAvatar.png', fit: BoxFit.cover)
        ),
        Positioned.fill(
          top: 50,
          child: Align(
            alignment: Alignment.center,
            child:
              Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blueAccent,
                  border: Border.all(
                      color: Colors.white,
                      width: 3.0,
                      style: BorderStyle.solid),
                  image:  DecorationImage(
                    fit: BoxFit.cover,
                    image:  (_user?.getAvatar != null)
                        ? NetworkImage(httpMXH.hostImg + _user?.getAvatar,)
                        : AssetImage('assets/images/nullAvatar.png') as ImageProvider,
                  ),
                ),
              ),
          ),
        ),
        Positioned.fill(
          bottom: 10,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 55,
              child: Column(children: [
                Text(_user?.getFullname ?? "",style: TextStyle(fontSize: 24, fontWeight:FontWeight.bold)),
                SizedBox(height: 7),
                Text(_user?.getStory ?? "",style: TextStyle(fontSize: 16))
              ],),
            )
          )
        )
      ],)
    );
  }
  Widget IntroAndFriend() {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Column(children: [
              Row(children:[
                Padding(
                  padding: const EdgeInsets.only(bottom: 8, right: 8),
                  child: Icon(
                    Icons.location_city_outlined,
                    size: 30.0,
                  ),
                ),
                Text.rich(TextSpan(text: "Sống tại " ,children: [
                    TextSpan(text: _user?.getAddress ?? "", style: TextStyle(fontWeight: FontWeight.bold))
                ])
              )
              ]),

               Row(children:[
                Padding(
                  padding: const EdgeInsets.only(bottom: 8, right: 8),
                  child: Icon(
                    Icons.person_outline_sharp,
                    size: 30.0,
                  ),
                ),
                Text.rich(TextSpan(text: _user?.getCountFollowed.toString() ?? "0",style: TextStyle(fontWeight: FontWeight.bold) ,children: [
                    TextSpan(text:" người theo dõi", style: TextStyle(fontWeight: FontWeight.normal))
                ])
              )
              ]),
              Row(children:[
                Padding(
                  padding: const EdgeInsets.only(bottom: 8, right: 8),
                  child: Icon(
                    Icons.more_horiz,
                    size: 30.0,
                  ),
                ),
                Text("Xem thêm thông tin của " + ((_userId == User.currentUser?.getId) ? "bạn" : _user?.getLastName ?? "" ))
              ])
            ],),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            decoration:BoxDecoration(
              border: Border(top:
                BorderSide( //
                color: Color.fromARGB(255, 179, 163, 163),
                width: 0.5,
              ))
            ),
            padding: EdgeInsets.all(8.0),
            margin: EdgeInsets.only(top: 5.0, left: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Bạn bè',textAlign: TextAlign.left,style: TextStyle(fontSize: 20, fontWeight:FontWeight.bold,)),
              ),
              Wrap(
                children: [
                  if (_listFriendCustom.length > 0)
                  for (int i = 0; i <= ((_listFriendCustom.length < 6) ? _listFriendCustom.length : 5); i++)
                    Container(
                      width: MediaQuery.of(context).size.width/3 - 10,
                      height: MediaQuery.of(context).size.width/3 + 30,
                      child: Center(
                        child: Column(
                          children:[
                              ClipRRect(
                                borderRadius: BorderRadius.all(Radius.circular(10)),
                                child: (_listFriendCustom[i].getAvatar != null)
                            ? Image.network(
                                httpMXH.hostImg + _listFriendCustom[i].getAvatar,
                        width: MediaQuery.of(context).size.width/3 - 15,
                        height: MediaQuery.of(context).size.width/3 - 15,
                                fit: BoxFit.fill,
                              )
                              : Image.asset('assets/images/nullAvatar.png',
                        width: MediaQuery.of(context).size.width/3 - 15,
                        height: MediaQuery.of(context).size.width/3 - 15,
                                fit: BoxFit.fill,
                              ),),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(_listFriendCustom[i].getFullname, style: TextStyle(fontWeight: FontWeight.bold, fontSize:12), overflow: TextOverflow.ellipsis,),
                              )
                          ]),
                      )
                    )

                ]
               ),
               Container(
                  margin: EdgeInsets.only(right: 8.0),
                  child: RaisedButton(
                    color:  Color.fromARGB(184, 228, 231, 228),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(25))
                    ),
                    onPressed:() {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ListImage()));
                    },
                    child: Text("Ảnh")
                  ),
                ),
            ]),
          ),
        ],
      ),

    );
  }
  Widget build(BuildContext context) {
    return LazyLoadScrollView(
      onEndOfPage: () => {
        setState(() {
          loadingPage = true;
          _page++;
          ajaxLoadListPost(_page);
        })
      },
    child: SingleChildScrollView(
        child: Container(
          color:Colors.white,
          child: Column(
            children: [
              PaddingTop(),
              TopProfile(),
              IntroAndFriend(),
              ViewFormPost(),
              Column(
              mainAxisAlignment: MainAxisAlignment.start,
                children : [
                  for (Post postItem in _listPost) ViewPost(postItem),
                ]
              ),
              if (loadingPage) LoadingDialog.ajaxLoadListView(),
            ]
          )
        )
      )
    );
  }

}

