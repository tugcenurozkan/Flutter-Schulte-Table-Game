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

  cancelTimer() {
    return timer.cancel();
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
        title: Text("!!!YOU DID IT!!!"),
        content: Text(
          "Your Score : $time",
          style: Theme.of(context).textTheme.display2,
        ),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                //burda yapılan işlem bize oyundaki önceki skorlara geri giderek görmeyi sağlar.
                MaterialPageRoute(
                  builder: (context) => MyHomePage(
                    size: level,
                  ),
                ),
              );
              level *= 2;
            },
            child: Text("RESTART"),
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
      body: Container(
        padding: const EdgeInsets.all(50.0),
        child: Row(
          children: [
            Column(children: [
              Container(
                padding: const EdgeInsets.fromLTRB(1, 90, 50, 50),
                child: Text("Time: $time"),
              )
            ]),
            Column(
              children: [
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
                                      if (val == i) {
                                        if (pressedValues[val])
                                          pressedValues[val] =
                                              !pressedValues[val];
                                        i++;

                                        if (val == 25) {
                                          print("Won");
                                          showResult();
                                          cancelTimer();
                                        }
                                      }
                                    });
                                  },
                                  child: Container(
                                    height: 56.0,
                                    color: pressedValues[val]
                                        ? Colors.grey[400]
                                        : Colors.grey[700],
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
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
