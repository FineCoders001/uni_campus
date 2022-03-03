import 'dart:math';
import 'package:flutter/material.dart';
import 'package:uni_campus/EventManagement/Screens/create_event_screen.dart';
import 'package:uni_campus/EventManagement/Screens/my_event_screen.dart';

class CircularFabWidget extends StatefulWidget {
  const CircularFabWidget({Key? key}) : super(key: key);
  @override
  _CircularFabWidgetState createState() => _CircularFabWidgetState();
}

class _CircularFabWidgetState extends State<CircularFabWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController anicon;
  late Animation<double> controller;
  @override
  void initState() {
    super.initState();
    anicon = AnimationController(
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
  }

  @override
  void dispose() {
    anicon.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Flow(
      delegate: FlowMenuDelegate(controller: anicon),
      children: [
        buildFAB("Add Event", const Icon(Icons.add)),
        buildFAB("My Event", const Icon(Icons.event)),
        buildFAB(null, const Icon(Icons.menu))
      ].toList(),
    );
  }

  Widget buildFAB(var data, Icon e) {
    return SizedBox(
      child: FloatingActionButton(
          heroTag: "btn$data",
          onPressed: () {
            if (data == 'Add Event') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => const CreateEventScreen(),
                ),
              );
            }
            if (data == 'My Event') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => const MyEventScreen(),
                ),
              );
            }

            if (data == null) {
              if (anicon.status == AnimationStatus.completed) {
                anicon.reverse();
              } else {
                anicon.forward();
              }
            } else {
              // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              //   content: Text(data),
              // ));
            }
          },
          tooltip: data,
          child: e),
    );
  }
}

class FlowMenuDelegate extends FlowDelegate {
  final Animation<double> controller;
  const FlowMenuDelegate({required this.controller})
      : super(repaint: controller);
  @override
  void paintChildren(FlowPaintingContext context) {
    final n = context.childCount;
    for (int i = 0; i < n; i++) {
      final last = i == context.childCount - 1;
      Function(dynamic value) setValue;
      setValue = (value) => last ? 0.0 : value;
      final radius = 180.0 * controller.value * 0.5;
      final theta = i * pi * 0.5 / (n - 2);
      final x = (context.size.width - 80) - setValue(radius * cos(theta));
      final y = (context.size.height - 80) - setValue(radius * sin(theta));
      context.paintChild(
        i,
        transform: Matrix4.identity()..translate(x, y, 0),
      );
    }
  }

  @override
  bool shouldRepaint(covariant FlowDelegate oldDelegate) => false;
}
