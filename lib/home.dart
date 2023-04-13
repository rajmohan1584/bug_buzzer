import 'dart:async';

import 'package:bug_buzzer/log.dart';
import 'package:bug_buzzer/message.dart';
import 'package:bug_buzzer/single_multicast.dart';
import 'package:flutter/material.dart';

const testMode = true;

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final FocusNode focusNode = FocusNode();
  String mode = "idk"; // client, server
  bool allowServerLogin = false;
  final maxlen = 6;
  String passkey = "";
  final secretKey = "135246";
  bool anotherServerIsRunning = false;
  Timer? timer;
  int timerCounter = 0;
  late StreamSubscription<BuzzMsg>? streamSubscription;

  @override
  void initState() {
    startTimer();
    streamSubscription =
        StaticSingleMultiCast.controller1.stream.listen(onServerMessage);
    super.initState();
  }

  @override
  dispose() {
    stoptTimer();
    super.dispose();
  }

  startTimer() {
    Log.log('Home - StartTimer');
    const dur = Duration(milliseconds: 500);
    timer = Timer.periodic(dur, onTimer);
  }

  onTimer(_) async {
    // For 10 seconds keep radar spinning
    timerCounter++;
  }

  stoptTimer() {
    Log.log('Home - StopTimer');
    timer?.cancel();
  }

  resetAll() {
    setState(() {
      passkey = "";
      mode = "idk";
      anotherServerIsRunning = false;
      allowServerLogin = false;
      timerCounter = 0;
    });

  }

  onServerMessage(BuzzMsg msg) {
    // Assert that there is no cross talk.
  }


  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return const Scaffold(
      body:Center(
            child:Text('TODO')));
  }
}
