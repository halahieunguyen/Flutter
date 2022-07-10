import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:mxh/src/resources/dialog/MessageDialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mxh/extension/http.dart' as httpMXH;
import 'package:mxh/model/post.dart';

import '../../../blocs/PostBloc.dart';
import '../../../model/user.dart';
import '../dialog/LoadingDialog.dart';
import '../dialog/flashMessage.dart';
import '../ui/paddingTop.dart';

class ViewFormPost extends StatefulWidget {
  ViewFormPost({Key? key, this.pushNewPostCallBack}) : super(key: key);
  final pushNewPostCallBack;
  @override
  State<ViewFormPost> createState() => _ViewFormPostState();
}

class _ViewFormPostState extends State<ViewFormPost> {
  @override
  User? _user;
  void initState() {
    super.initState();
    getUserInfo();
  }
   Future<void> getUserInfo() async {
     final prefs = await SharedPreferences.getInstance();
     setState(() {
       this._user =   User.currentUser;
     });
  }
  @override
   Widget getAvatar() {
  return (_user?.getAvatar != null)
    ? Image.network(
      httpMXH.hostImg + _user?.getAvatar,
    )
    : Image.asset('assets/images/nullAvatar.png');
  }
  void createPost() async{
      Post newPost = await Navigator.push(context, MaterialPageRoute(builder: (context) => PageCreatePost(_user)));
      if (newPost != null) {
        widget.pushNewPostCallBack(newPost);
      }
  }
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: (
      Row(children: [
        Container(
          height: 40,
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(25)),
            child: getAvatar(),
          ),
        ),
         Expanded(
           child: FlatButton(
            onPressed: createPost,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                color: Colors.black,
                width: 1.0,
                style: BorderStyle.solid),
            ),
              height: 40, width: double.infinity, child: Align(alignment: Alignment.center, child:
                Text("Bạn đang nghĩ gì?", style: TextStyle(fontSize: 16,  color: Color.fromARGB(255, 155, 147, 147),),)
                // Text.rich(
                //   TextSpan(
                //     text:"Bạn đang nghĩ gì?",
                //     style: TextStyle(fontSize: 16,  color: Color.fromARGB(255, 155, 147, 147),),
                //     recognizer: TapGestureRecognizer()
                //       ..onTap = () {
                //         Navigator.push(context, MaterialPageRoute(builder: (context) => PageCreatePost(_user)));
                //       },
                //   )
                // )
              )),
            ),
         )
      ],)
      ),
    );
  }
}

class PageCreatePost extends StatefulWidget {
  PageCreatePost(User? user, {Key? key}) : super(key: key) {
    if (user!=null) _user = user;
  }
  late User _user;
  @override
  State<PageCreatePost> createState() => _PageCreatePostState(_user);
}

class _PageCreatePostState extends State<PageCreatePost> {
   _PageCreatePostState(User user) {
     _user = user;
  }
  @override
  TextEditingController _dataController = new TextEditingController();
  late User _user;
  PostBloc _postBloc = new PostBloc();
  List<XFile> _fileImages = <XFile>[];
  @override
   Widget getAvatar() {
  return (_user.getAvatar != null)
    ? Image.network(
      httpMXH.hostImg + _user.getAvatar,
    )
    : Image.asset('assets/images/nullAvatar.png');
  }

  Future<void> ajaxCreatePost() async {
    Post? post =  await _postBloc.createPost(
      images: _fileImages,
      data: _dataController.text,
      typeShow: Post.typeShow['public'],
      onError: (msg) {
          MessageDialog.showMessageDialog(context, 'Bạn bè', msg);
      },
      onSuccess: (msg) {
          FlashMessage.showMessageTop(context, msg);
        }
    );
    if (post != null) {
      Navigator.pop(context, post);
    }
  }
  Future<void> cropImage(int index) async {
    XFile xFile = _fileImages[index];
    CroppedFile? cropped= await ImageCropper().cropImage(
      sourcePath: xFile.path ?? "",

    );
    setState(() {
      _fileImages[index] = (cropped?.path != null ) ? XFile(cropped!.path) : xFile;
    });
  }
  Future<void> pickImage(ImageSource source) async {
    XFile? selected= await ImagePicker().pickImage(source: source);
    if (selected != null)
    setState(() {
      _fileImages.add(selected);
    });
  }
  void clearImage(XFile xFile) {
    setState(() {
      _fileImages.remove(xFile);
    });
  }
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body:Container(
          child: Container(
            color:Colors.white,
            child: Column(
              children: [
                PaddingTop(),
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.of(context).pop(this);
                    },
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.all(15),
                      child: Column(
                        children: [
                          Container(
                            height: 40,
                            child: Row(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.all(Radius.circular(25)),
                                  child: getAvatar(),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 7),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(_user.getFullname, overflow: TextOverflow.ellipsis,style: TextStyle(fontWeight:FontWeight.bold,)),
                                      Text("Chế độđăng", overflow: TextOverflow.ellipsis,style: TextStyle(fontWeight:FontWeight.bold,)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          TextField(
                            controller: _dataController,
                            maxLines: null, //
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Bạn đang nghĩ gì?"
                            )
                          ),
                          for (XFile image in _fileImages)
                          Image.file(
                            File(image!.path),
                            fit: BoxFit.contain,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(15),
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          IconButton(
                            icon: Icon(Icons.photo_camera),
                            onPressed: () async {
                              await pickImage(ImageSource.camera);
                              cropImage(_fileImages.length - 1);
                            }
                            ),
                            IconButton(
                            icon: Icon(Icons.photo_library),
                            onPressed: () async {
                              await pickImage(ImageSource.gallery);
                              cropImage(_fileImages.length - 1);
                            }
                            ),
                            Expanded(
                              child: Container()
                            ),
                            RaisedButton(
                              color: Colors.green,
                              child: Text("Đăng", style: TextStyle(fontSize: 20, color: Colors.white),),
                              onPressed: () async {
                                ajaxCreatePost();
                              }
                            ),

                        ],)
                      ],
                    ),
                  ),
                )
              ],
            ),
          )
        )
      )
    );
  }
}