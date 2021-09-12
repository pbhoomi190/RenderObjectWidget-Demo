import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'custom_range_displayer/progress_viewer.dart';

void main() {
  // debugRepaintRainbowEnabled = true;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
    );
  }
}


class Home extends StatelessWidget {

 // StreamController _controller = StreamController<double>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Custom render object demo"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(30.0),
            child: CustomProgressRangeViewer(
                barColor: Colors.grey,
                thumbColor: Colors.grey,
                breakPoints: [0, 15, 54, 75, 100],
                activeThumbColor: Colors.red,
                activeIndex: 1),
          )
        ],
      ),
    );
  }
}
