import 'package:flutter/material.dart';
// import "dart:math";
import 'dart:async';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Schulte Table Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

int level = 8;

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key key, this.size = 0}) : super(key: key);

  final int size;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<int> randomList = List.generate(25, (index) => index + 1)..shuffle();
  Map<int, bool> pressedValues = Map.fromIterable(
    List.generate(26, (int idx) => idx),
    key: (item) => item,
    value: (item) => true,
  );

  int time = 0;
  Timer timer;
  startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (t) {
      setState(() {
        time = time + 1;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  showResult() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text("Best Time!!!"),
        content: Text(
          "Time $time",
          style: Theme.of(context).textTheme.display2,
        ),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => MyHomePage(
                    size: level,
                  ),
                ),
              );
              level *= 2;
            },
            child: Text("NEXT"),
          ),
        ],
      ),
    );
  }

  int i = 1;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
      ),
      body: Column(
        children: [
          Container(
            child: Text("Time: $time"),
          ),
          Center(
            child: Container(
              width: 200,
              height: 200,
              child: GridView.count(
                  crossAxisCount: 5,
                  // crossAxisSpacing: 1,
                  // mainAxisSpacing: 1,
                  children: randomList
                      .map(
                        (int val) => Container(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                // List<int> value =
                                //     List.generate(25, (index) => index)
                                //       ..shuffle();
                                // value.sort();

                                if (val == i) {
                                  if (pressedValues[val])
                                    pressedValues[val] = !pressedValues[val];
                                  i++;
                                }
                                if (val == 25) {
                                  print("Won");
                                  showResult();
                                }
                              });
                            },
                            child: Container(
                              height: 56.0,
                              color: pressedValues[val]
                                  ? Colors.red
                                  : Colors.green,
                              child: Center(
                                child: pressedValues[val]
                                    ? Text(val.toString())
                                    : Text(val.toString()),
                              ),
                            ),
                          ),
                        ),
                      )
                      .toList()),
            ),
          )
        ],
      ),
    );
  }
}
