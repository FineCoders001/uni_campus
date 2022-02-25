
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Reviews extends StatefulWidget {
  var book;
  Reviews(this.book);
  @override
  _ReviewsState createState() => _ReviewsState();
}

class _ReviewsState extends State<Reviews> {
  @override
  Widget build(BuildContext context) {
    //print("reviews of product is ${}");
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 82, 72, 200),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(icon: Icon(Icons.arrow_back,color: Colors.black,), onPressed: (){
          Navigator.pop(context);
        }),
        title: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Text('Reviews',
            style: TextStyle(
                color: Colors.white,
                fontSize: 30,

                fontWeight: FontWeight.w500
            ),

          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.black12,
              //height: (MediaQuery.of(context).size.height )*0.8,
              //height: MediaQuery.of(context).size.height *0.9,
              padding: EdgeInsets.all(10),

              child: ListView.builder(
                itemCount: widget.book['bookReviews'].length,
                shrinkWrap: true,
                itemBuilder: (ctx , index) => Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 20.0 , top:10),
                              child: Text('verified student',
                                style: TextStyle(
                                    color: Colors.black45,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500
                                ),

                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0 , top:10),
                              child: Icon(Icons.assignment_turned_in_sharp),
                            ),
                          ],
                        ),
                        //Ratings(widget.loadedProduct),
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0, right: 20 , top: 20, bottom: 20),
                          child: Text(widget.book['bookReviews'][index], style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                          ),),
                        ),

                      ]
                  ),
                ),



              ),
            ),
          ),
        ],
      )
      ,
    );
  }
}
