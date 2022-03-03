import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../EventManagement/Models/all_events.dart';

class ShowDialog{

  show(context) async {

    await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
      title: const Text('Oops!'),
      content: const Text('Something went wrong'),
      actions: <Widget>[
        TextButton(
          child: const Text('Okay'),
          onPressed: () {
            Navigator.of(ctx).pop();
            //return;
          },
        )
      ],
    ),
    );
  }

  showBottomSheet(context ,post,date){
     showModalBottomSheet(
        shape: const RoundedRectangleBorder(
        borderRadius:
        BorderRadius.vertical(top: Radius.circular(25))),
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return Container(
          padding: const EdgeInsets.symmetric(
              vertical: 12, horizontal: 12),
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const CircleAvatar(
                            backgroundColor: Colors.red,
                            child: Icon(
                              Icons.clear_rounded,
                              color: Colors.white,
                            ))),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        post.eventName,
                        style: GoogleFonts.ubuntu(
                            fontSize: 38, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "About Event",
                        style: GoogleFonts.ubuntu(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        post.description,
                        style: GoogleFonts.ubuntu(
                            fontSize: 18, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Venue",
                        style: GoogleFonts.ubuntu(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        post.venue,
                        style: GoogleFonts.ubuntu(
                            fontSize: 18, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Event Type",
                        style: GoogleFonts.ubuntu(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        post.deptLevel.split('.')[1],
                        style: GoogleFonts.ubuntu(
                            fontSize: 18, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.date_range),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              RichText(
                                text: TextSpan(
                                  text: ' ${date.day} ',
                                  style: GoogleFonts.abrilFatface(
                                    fontSize: 22,
                                    color: Colors.black,
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: ' ${monthName[date.month]}',
                                      style: GoogleFonts.zillaSlab(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    //TextSpan(text: ' world!'),
                                  ],
                                ),
                              ),
                              Text(
                                "${weekDayName[date.weekday]}",
                                style: GoogleFonts.zillaSlab(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey),
                              )
                            ],
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(Icons.access_time),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                '   ${post.eventStartTime.split('(')[1]
                                    .substring(0,
                                    post.eventStartTime.split('(')[1].length -
                                        1)}',
                                style: GoogleFonts.abrilFatface(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                post.eventDuration,
                                style: GoogleFonts.zillaSlab(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey),
                              )
                            ],
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ]
          )
      );
    }
    );
  }


}