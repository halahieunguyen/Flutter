import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:mxh/model/post.dart';
import 'package:intl/intl.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import '../../../blocs/PostBloc.dart';
import '../../../model/comment.dart';
import '../dialog/LoadingDialog.dart';
import '../dialog/MessageDialog.dart';
import 'package:mxh/extension/http.dart' as httpMXH;
import '../dialog/flashMessage.dart';
import '../ui/paddingTop.dart';
class ViewComment extends StatefulWidget {
  ViewComment(Post post,{Key? key}) : super(key: key) {
   this._post = post;
  }
  late Post _post;
  @override
  State<ViewComment> createState() => View_CommentState(_post);
}

class View_CommentState extends State<ViewComment> {
  View_CommentState(Post post) {
     this._post = post;
  }
  PostBloc _postBloc = new PostBloc();
  FocusNode focusPostComment = FocusNode();
  int _page = 1;
  bool loadingPage = false;
  Comment? focusComment = null;
  late Post _post;
  TextEditingController _dataController = new TextEditingController();
  final _key = GlobalKey();
  XFile? _fileImage;
  @override
  void initState() {
    int countLoadComment = _post.getComments.length;
    if (countLoadComment == 0) {
      _page = 1;
    } else {
      _page = countLoadComment~/5 + 2;
    }
     super.initState();
     if (_post.stillComment) {
      ajaxLoadComments();
     }
  }
  @override
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
                  child: LazyLoadScrollView(
                    onEndOfPage: () => {
                      setState(() {
                        ajaxLoadComments();
                      })
                    },
                    child: SingleChildScrollView(
                      child: GestureDetector(
                        onTap: () { //here
                          FocusScope.of(context).unfocus();
                        },
                        child:
                        Column(
                          children: [
                            for (Comment comment in _post.getComments)
                                Container(
                                    child:Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          height: 50,
                                          padding: EdgeInsets.all(5),
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.all(Radius.circular(25)),
                                            child: (comment.getUser.getAvatar != null)
                                              ? Image.network(
                                              httpMXH.hostImg + comment.getUser.getAvatar,
                                            )
                                            : Image.asset('assets/images/nullAvatar.png'),
                                          ),
                                        ),
                                        Container(
                                           child: Column(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                               ClipRRect(
                                                 borderRadius: BorderRadius.all(Radius.circular(5)),
                                                 child: Container(
                                                  padding: EdgeInsets.all(5),
                                                   width: MediaQuery.of(context).size.width-100,
                                                   color: Color(0xFFf0f2f5),
                                                   child: Column(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(comment.getUser.getFullname, overflow: TextOverflow.ellipsis,style: TextStyle(fontWeight:FontWeight.bold,)),
                                                        Text(comment.getData, overflow: TextOverflow.clip,)
                                                      ]
                                                    ),
                                                 ),
                                               ),
                                              if (comment.getImage != null) Container(
                                                padding: EdgeInsets.only(top: 8),
                                                child: LimitedBox(
                                                  maxWidth: MediaQuery.of(context).size.width / 2,
                                                  maxHeight: MediaQuery.of(context).size.width / 2,
                                                  child: Image.network(
                                                    httpMXH.hostImg + (comment.getImage ??  ""),
                                                    fit: BoxFit.contain,
                                                  ),
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  Text(DateFormat('HH:mm dd-MM-yyyy').format(comment.getUpdatedAt), overflow: TextOverflow.ellipsis,textAlign: TextAlign.left,),
                                                  Container(
                                                    margin: EdgeInsets.only(left:15.0),
                                                    child: Text.rich(
                                                      TextSpan(
                                                        text: "Phản hồi",
                                                        recognizer: TapGestureRecognizer()
                                                        ..onTap = () {
                                                          setState(() {
                                                          focusComment = comment;
                                                          });
                                                          new Future.delayed(const Duration(milliseconds: 10), () {
                                                            focusPostComment.requestFocus();
                                                          });
                                                        },
                                                        style: TextStyle(fontWeight:FontWeight.bold,)
                                                      )
                                                    )
                                                  ),
                                                ]
                                              ),
                                            ],
                                          ),
                                        ),
                                      ]
                                    ),
                                ),
                                if (loadingPage) LoadingDialog.ajaxLoadListView(),
                          ]
                        ),
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
                        Container(
                          height: (focusComment != null) ? 50 : 0,
                          width: MediaQuery.of(context).size.width - 30,
                          child: (focusComment != null) ? Row(
                            children: [
                              Text("Đang trả lời " + (focusComment?.getUser.getFullname ?? ""), overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 12, fontWeight:FontWeight.w600),),
                              Container(
                                margin: EdgeInsets.only(left:15.0),
                                child: Text.rich(
                                  TextSpan(
                                    text: "Hủy",
                                    recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      setState(() {
                                        focusComment = null;
                                      });
                                    },
                                    style: TextStyle(fontWeight:FontWeight.bold,)
                                  )
                                )
                              ),
                            ]
                          ) : SizedBox.shrink(),
                        ),
                        Container(
                          height: 50,
                          padding: EdgeInsets.all(5),
                          width: MediaQuery.of(context).size.width - 30,
                          child: TextField(
                            controller: _dataController,
                            focusNode: focusPostComment,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: "Nhập bình luận"
                            )
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(5),
                          height: (_fileImage != null) ? 70 : 0,
                          width:  70,
                          child: (_fileImage != null)
                          ? Container(
                            child: Stack(
                              alignment: AlignmentDirectional.topEnd,
                              children: [
                                Image.file(File(_fileImage!.path), key: _key),
                                Container(
                                  width:20,
                                  height:20,
                                  child: IconButton(
                                    color: Colors.red,
                                    icon: Icon(Icons.remove_circle_outline_outlined),
                                    padding: EdgeInsets.all(0),
                                    iconSize: 20,
                                    onPressed: () async {
                                      clearImage();
                                    }
                                  ),
                                ),
                              ],
                            )
                            )
                          : Container(),
                        ),
                        Row(children: [
                          IconButton(
                            icon: Icon(Icons.photo_camera),
                            onPressed: () async {
                              await pickImage(ImageSource.camera);
                              cropImage();
                            }
                            ),
                            IconButton(
                            icon: Icon(Icons.photo_library),
                            onPressed: () async {
                              await pickImage(ImageSource.gallery);
                              cropImage();
                            }
                            ),
                            Expanded(
                              child: Container()
                            ),
                            IconButton(
                              icon: Icon(Icons.send),
                              onPressed: () async {
                                sendComment();
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

  Future<void> pickImage(ImageSource source) async {
    XFile? selected= await ImagePicker().pickImage(source: source);
    setState(() {
      _fileImage = selected;
    });
  }

  Future<void> sendComment() async {
    List<XFile>? images = <XFile>[];
    if (_fileImage != null) {
      images.add(_fileImage!);
    }
    Comment? comment =  await _postBloc.createComment(
      commentId: focusComment?.getId,
      postId: (focusComment==null) ? _post.getId : null,
      images: images,
      data: _dataController.text,
      onError: (msg) {
          MessageDialog.showMessageDialog(context, 'Bình luận', msg);
      },
      onSuccess: (msg) {
          FlashMessage.showMessageTop(context, msg);
          _dataController.text = "";
          _fileImage = null;
        }
    );
    if (comment != null) {
      setState(() {
        _post.createComment(comment);
      });
    }
  }
  Future<void> cropImage() async {
    CroppedFile? cropped= await ImageCropper().cropImage(
      sourcePath: _fileImage?.path ?? "",

    );
    setState(() {
      _fileImage = (cropped?.path != null ) ? XFile(cropped!.path) : _fileImage;
    });
  }
  void clearImage() {
    setState(() {
      _fileImage = null;
    });
  }
  Future<void> ajaxLoadComments() async {
    if (loadingPage) return;
    loadingPage = true;
    if (!_post.stillComment) {
      loadingPage = false;
      return;
    }
    List<Comment>? comments = await _postBloc.loadComment(_page, () {
      _page++;
      if (_page < 3) {
        loadingPage= false;
        ajaxLoadComments();
      }
    }, (msg) {
              MessageDialog.showMessageDialog(context, 'Bài viết', msg);
            },
      postId: _post.getId
      );
      if (comments!=null) {
        setState(() {
            _post.pushComments(comments);
            loadingPage= false;

          });
      }
  }
}