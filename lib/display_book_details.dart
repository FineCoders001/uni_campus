import 'package:flutter/material.dart';

class DisplayBookDetail extends StatefulWidget {
  const DisplayBookDetail({Key? key}) : super(key: key);

  @override
  _DisplayBookDetailState createState() => _DisplayBookDetailState();
}

class _DisplayBookDetailState extends State<DisplayBookDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                height: MediaQuery
                    .of(context)
                    .size
                    .height,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    Expanded(
                      flex: 4,
                      child: Container(
                          decoration: const BoxDecoration(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(40),
                              ),
                              color: Colors.white),
                          child: SingleChildScrollView(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceBetween,
                                  children: const [
                                    Expanded(
                                      flex: 1,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20.0, vertical: 20),
                                        child: Text(
                                          "DBMS",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 28,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      //child: Ratings(loadedProduct),
                                      child: Text("4"),
                                    )
                                  ],
                                ),

                                // loadedProduct.discount > 0
                                //     ? Price(loadedProduct)
                                //     : SizedBox(height: 0,),
                                //
                                // loadedProduct.availableQuantity <= 0 ? Padding(
                                //   padding: const EdgeInsets.only(left: 20.0, right: 8),
                                //   child: Text('Out Of Stock',
                                //
                                //     style: TextStyle(
                                //       fontSize: 24,
                                //       color: Colors.red,
                                //       fontWeight: FontWeight.w500,
                                //
                                //     ),
                                //   ),
                                // ) : SizedBox(height: 0,),

                                SizedBox(
                                  width: double.infinity,
                                  //padding: EdgeInsets.all(10),
                                  child: Card(
                                    elevation: 3,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 20.0, horizontal: 10),
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: const [
                                          Text(
                                            'Product Details',
                                            style: TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          Icon(Icons.arrow_forward_ios_rounded),
                                        ],
                                      ),
                                    ),

                                  ),
                                ),
                                const Expanded(
                                  flex: 1,
                                  child:BottomButton(),

                                )


                              ],
                            ),
                          )
                      ),
                    )
                  ],
                ),
              )
            ]
        )
    );
  }
}

class BottomButton extends StatefulWidget {
  const BottomButton({Key? key}) : super(key: key);

  @override
  _BottomButtonState createState() => _BottomButtonState();
}

class _BottomButtonState extends State<BottomButton> {
  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () async {

            },
            child: Container(

              width: (MediaQuery
                  .of(context)
                  .size
                  .width) * 0.50,
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.favorite_border, color: Colors.red,),
                  Text(
                    'ADD TO FAVORITE',
                    style: TextStyle(color: Colors.black),),
                ],
              ),
            ),
          ),

          GestureDetector(
              onTap: () async {

              },
              child: Container(
                  color: Colors.deepOrange,
                  width: (MediaQuery
                      .of(context)
                      .size
                      .width) * 0.50,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.work, color: Colors.white,),
                      Text('BUY NOW',
                        style: TextStyle(color: Colors.white),)
                    ],
                  ))
          )
        ]
    );
  }
}
