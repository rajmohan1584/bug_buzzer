// ignore_for_file: non_constant_identifier_names

import 'dart:async';

import 'package:bug_buzzer/command.dart';
import 'package:bug_buzzer/grid.dart';
import 'package:bug_buzzer/log.dart';
import 'package:bug_buzzer/message.dart';
import 'package:bug_buzzer/server_direct.dart';
import 'package:bug_buzzer/single_multicast.dart';
import 'package:bug_buzzer/widgets.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:multi_split_view/multi_split_view.dart';

const testMode = true;

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool anotherServerIsRunning = false;
  Timer? timer;
  int timerCounter = 0;
  late StreamSubscription<BuzzMsg>? streamSubscription;
  late StreamSubscription<BuzzMsg>? webSocketStreamSubscription;

  List<BuzzMsg> msgs = [];
  List<String> data = [];
  List<String> wsData = [];

  bool disable_S_HBQ = false;
  bool disable_S_HBR = false;
  bool disable_C_HBQ = false;
  bool disable_C_HBR = false;

  @override
  void initState() {
    startTimer();

    streamSubscription =
        StaticSingleMultiCast.controller1.stream.listen(onServerMessage);
    webSocketStreamSubscription =
        ServerDirectReceiver.webSocketQueue.stream.listen(onWebSocketMessage);

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
      timerCounter = 0;
    });
  }

  onServerMessage(BuzzMsg msg) {
    // TODO -  add reveiced date into the msg
    msgs.add(msg);
    if (isFiltered(msg)) return;

    final now = DateTime.now();

    String dt = DateFormat.Hms().format(now);
    final s = "$dt - ${msg.toSocketMsg()}";
    setState(() {
      data.insert(0, s);
    });
    Log.log(s);
  }

  onWebSocketMessage(BuzzMsg msg) {
    // TODO -  add reveiced date into the msg
    msgs.add(msg);
    if (isFiltered(msg)) return;

    final now = DateTime.now();

    String dt = DateFormat.Hms().format(now);
    final s = "$dt - ${msg.toSocketMsg()}";
    setState(() {
      wsData.insert(0, s);
    });
    Log.log(s);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final child1 = MyGrid(data);
    final child2 = MyGrid(wsData);
    final child3 = buildSettings();
    return Scaffold(body: MultiSplitView(children: [child1, child2, child3]));
  }

  onS_HBQ(bool disable) {
    setState(() {
      disable_S_HBQ = disable;
    });
  }

  onS_HBR(bool disable) {
    setState(() {
      disable_S_HBR = disable;
    });
  }

  onC_HBQ(bool disable) {
    setState(() {
      disable_C_HBQ = disable;
    });
  }

  onC_HBR(bool disable) {
    setState(() {
      disable_C_HBR = disable;
    });
  }

  Widget buildSettings() {
return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          WIDGETS.buildSwitch("disable_S_HBQ", disable_S_HBQ, onS_HBQ),
          WIDGETS.buildSwitch("disable_S_HBR", disable_S_HBR, onS_HBR),
          WIDGETS.buildSwitch("disable_C_HBQ", disable_C_HBQ, onC_HBQ),
          WIDGETS.buildSwitch("disable_C_HBR", disable_C_HBR, onC_HBR)
        ]);
  }

  filter() {
    List<String> f = [];

    for (BuzzMsg msg in msgs) {
      if (isFiltered(msg)) {
        f.add(msg.toString());
      }
    }

    setState(() {
      data = f;
    });
}

  bool isFiltered(BuzzMsg msg) {
    if (disable_S_HBQ && msg.source == BuzzCmd.server && msg.cmd == BuzzCmd.hbq) return true;
    if (disable_S_HBR && msg.source == BuzzCmd.server && msg.cmd == BuzzCmd.hbr) return true;
    if (disable_C_HBQ && msg.source == BuzzCmd.client && msg.cmd == BuzzCmd.hbq) return true;
    if (disable_C_HBR && msg.source == BuzzCmd.client && msg.cmd == BuzzCmd.hbr) return true;

    return false;
  }

}
