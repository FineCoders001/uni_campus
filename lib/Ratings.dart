import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class Ratings extends StatefulWidget {
  var book;
  double ratings;
  double ratingsCount;
  Ratings(this.book,this.ratings,this.ratingsCount);

  @override
  _RatingsState createState() => _RatingsState();
}

class _RatingsState extends State<Ratings> {


  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    //getRating();
  }
  @override
  Widget build(BuildContext context) {
    //var num =['ratings'];
    var num = widget.ratings;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal:20.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical:5.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              color: Color.fromRGBO(232, 207, 9,0.9),
              padding: EdgeInsets.all(5),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right:3.0),
                    child: Text('${(num.toStringAsFixed(1))}',style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),),
                  ),
                  Icon(Icons.star,color: Colors.white,size: 13,),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left:8.0),
              child: Text('${widget.ratingsCount} ratings',style: TextStyle(
                fontSize: 13,
                color: Colors.grey,
              ),),
            ),


          ],
        ),
      ),
    );
  }
}
