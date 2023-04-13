import 'package:flutter/material.dart';

class MyGrid extends StatelessWidget {
  final List<String> data;
  MyGrid(this.data);

  @override
  Widget build(BuildContext context) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1, childAspectRatio: 10),
          itemCount: data.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              color: Colors.amber,
              child: Text(data[index]),
            );
          }),
    );
  }
}
