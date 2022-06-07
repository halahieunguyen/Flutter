import 'package:flutter/material.dart';
import 'package:mxh/model/post.dart';
import 'package:mxh/model/like.dart';
import 'package:mxh/src/resources/user/viewUserOptimize.dart';
import 'package:intl/intl.dart';
class ViewPost extends StatefulWidget {
  ViewPost(Post post,{Key? key}) : super(key: key) {
   this._post = post;
  }
  late Post _post;
  @override
  State<ViewPost> createState() => _ViewPostState(_post);
}

class _ViewPostState extends State<ViewPost> {
  _ViewPostState(Post post) {
     this._post = post;
  }
  late Post _post;
  @override
  void initState() {
  }
  @override
  Widget build(BuildContext context) {
    Widget ViewTypeLike(Like? isLike) {
      if (isLike != null) {
        switch(isLike.getType) {
          case Like.typeLike:
            return Row(children: [
                Icon(Icons.thumb_up_alt, size: 20, color: Colors.green),
                Text(" Thích"),
              ],
            );
          case Like.typeFavorite:
             return Row(children: [
                    Text("❤️", style: TextStyle(fontSize: 20),),
                    Text(" Yêu thích"),
                  ],
                  );
          case Like.typeSmile:
             return Row(children: [
                    Text("😆", style: TextStyle(fontSize: 20),),
                    Text(" Haha"),
                  ],
                  );
          case Like.typeSad:
             return Row(children: [
                    Text("😢", style: TextStyle(fontSize: 20),),
                    Text(" Buồn"),
                  ],
                  );
          case Like.typeWow:
             return Row(children: [
                    Text("😯", style: TextStyle(fontSize: 20),),
                    Text(" Wow"),
                  ],
                  );
          case Like.typeAngry:
             return Row(children: [
                    Text("😠", style: TextStyle(fontSize: 20),),
                    Text(" Phẫn nộ"),
                  ],
                  );
        }

      }
      return Row(children: [
                    Icon(Icons.thumb_up_alt_outlined, size: 20, color: Colors.green),
                    Text(" Thích"),
                  ],
                );
    }
    Widget ComponentInteractive() {
      return  Container(
        child: Container(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: GestureDetector(
                  onLongPress:() =>_showListReact()// won't trigger
                  ,
                  child: Container(
                    child:  ViewTypeLike(_post.getIsLike),
                  ),
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  Icon(Icons.comment_outlined,size: 30, color: Colors.green),
                  Text(" Bình luận"),
                ],)
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                  Icon(Icons.share_outlined, size: 30, color: Colors.green),
                  Text(" Chia sẻ"),
                ],)
              ),
            ]
          ),
          padding: EdgeInsets.fromLTRB(0, 10, 0, 8),
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: Colors.black12,
              ),
              bottom: BorderSide(
                color: Colors.black12,
              )
            )
          ),
        ),
      padding: EdgeInsets.fromLTRB(15, 0, 10, 0),
      );
    }
    Widget ComponentStatistic() {
      return  Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (_post.getCountLike > 0)
                Row(
                  children: [
                    Icon(Icons.thumb_up_alt, size: 12, color: Colors.green),
                    Text(" " + NumberFormat.decimalPattern().format(_post.getCountLike) )
                  ]
                ),
                Expanded(
                  child: Row(
                    children: [
                    ]
                  )
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (_post.getCountComment > 0)
                    Text(NumberFormat.decimalPattern().format(_post.getCountComment)+ " bình luận"),
                    if (_post.getCountComment * _post.getCountShare > 0)
                      Padding(
                        child: Icon(Icons.circle, size: 5),
                        padding: EdgeInsets.all(4),
                      ),
                    if (_post.getCountShare > 0)
                    Text(NumberFormat.decimalPattern().format(_post.getCountShare)+ " chia sẻ"),
                  ]
                ),
              ]
            ),
            padding: EdgeInsets.fromLTRB(15, 20, 10, 5),
          );
    }
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ViewUserOptimize(_post.getUser, time: _post.getUpdatedAt ),
            ],
          ),
          Container(
            child: Text(_post.getData),
            padding: EdgeInsets.fromLTRB(15, 20, 50, 5),
          ),
          Container(
            child: Stack(
               children:[
                Column(
                  children: [
                    ComponentStatistic(),
                    ComponentInteractive(),
                  ]
                ),
                Positioned(
                left: 0,
                top: -20,
                child: Container(
                  width: 200,
                  height: 80.0,
                  // child:  Visibility(
                          // visible: true,
                          child: (Row (
                            children: [
                              Icon(Icons.thumb_up_alt, size: 20, color: Colors.green),
                              Text("❤️", style: TextStyle(fontSize: 20),),
                              Text("😆", style: TextStyle(fontSize: 20),),
                              Text("😢", style: TextStyle(fontSize: 20),),
                              Text("😯", style: TextStyle(fontSize: 20),),
                              Text("😠", style: TextStyle(fontSize: 20),),
                            ]
                          )),
                        // ),
                  )
                ),

                ]
            )
          )

        ],
      )
    );
  }
  void _showListReact() {
    print(1);
  }
}