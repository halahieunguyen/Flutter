import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';

class ControlPage extends StatefulWidget {
  const ControlPage({Key? key}) : super(key: key);

  @override
  State<ControlPage> createState() => _ControlPageState();
}

class _ControlPageState extends State<ControlPage> {
  @override
  Widget build(BuildContext context) {
return Scaffold(
      appBar: AppBar(
        title: Text('AppBar'),
        leading: IconButton(
          icon: Icon(Icons.ac_unit),
          onPressed: () {
            // print('Đang ấn vào Icon');
          },
        )
      ),
      body: Center(
        child: Text(
          'Chào mọi người, đây là Cotrl đầu tiên của mình',
          style: TextStyle(
            color: Colors.red,
            overflow: TextOverflow.ellipsis,
            fontWeight: FontWeight.bold,
            fontSize: 10,
          )
        )
      )
    );
  }
}