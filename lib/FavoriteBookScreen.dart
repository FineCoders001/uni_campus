import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uni_campus/LibraryManagement/Models/book_details.dart';
import 'package:uni_campus/Profile/Screens/profile_screen.dart';

import 'Ratings.dart';
import 'display_book_details.dart';
import 'main.dart';

class FavoriteBookScreen extends StatefulHookConsumerWidget {
  //const FavoriteBookScreen({Key? key}) : super(key: key);
  //   var book;
  // FavoriteBookScreen(this.book);


  @override
  _FavoriteBookScreenState createState() => _FavoriteBookScreenState();
}

class _FavoriteBookScreenState extends ConsumerState<FavoriteBookScreen> {
  late List l;
   List m=[];
  int i=0;

  getFav() async {

    print("fjjf ${i}");

    if(l.length-i+1<7){
      for(i;i<l.length;i++){
        print("i is ${i}");
        FirebaseFirestore.instance. collection("LibraryManagement")
            .doc("Books").collection('AllBooks').where(
            FieldPath.documentId,
            isEqualTo: l[i]
        ).get().then((event) {
          if (event.docs.isNotEmpty) {
            Map<String, dynamic> documentData = event.docs.single.data();
            print("firebase se aa gya ${documentData['bookName']}");
            setState(() {

              m.add(documentData);

            });

            print("favorites are ${m}");
          }
        }).catchError((e) => print("error fetching data: $e"));
      }

    }else{
      int j = i;
      print("j is ${j}");


      for(i;i<j+7;i++){
        print("i is ${i}");
        FirebaseFirestore.instance. collection("LibraryManagement")
            .doc("Books").collection('AllBooks').where(
            FieldPath.documentId,
            isEqualTo: l[i]
        ).get().then((event) {
          if (event.docs.isNotEmpty) {
            Map<String, dynamic> documentData = event.docs.single.data();
            print("firebase se aa gya ${documentData['bookName']}");
            setState(() {

              m.add(documentData);

            });

            print("favorites arex dnud ${m}");
          }
        }).catchError((e) => print("error fetching data: $e"));
      }

    }



  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    l=ref.read(userCrudProvider).user['favBooks'];
    getFav();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 82, 72, 200),
        actions:  [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: (){
                getFav();
              },
                child: Icon(Icons.refresh)
            ),
          )
        ],
      ),
      body: ListView.builder(
        itemCount: m.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () async {

               // var book=BookDetails.fromJson(m[index]);

                Navigator.of(context).pushNamed(DisplayBookDetail.routename, arguments: {'book':m[index]});
              },
              child: Card(
                elevation: 10,
                child: Column(
                  children: [
                    Container(
                      //height: 150,
                      margin: EdgeInsets.only(top: 5),
                      padding: EdgeInsets.all(8),
                      child:  Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            //width: wid*0.75,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 20),
                                  child: Text(m[index]['bookName'] ,
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22,
                                    ),
                                  ),
                                ),
                                // Ratings(),
                                Padding(
                                  padding: const EdgeInsets.only(left:20.0,top: 20),
                                  child: Text('Author: ${m[index]['bookAuthor'] }',
                                    style: TextStyle(
                                      fontSize: 18,

                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left:20.0,top: 20),
                                  child: Text('pages: ${m[index]['bookPages'] }',
                                    style: TextStyle(
                                        fontSize: 18,

                                    ),
                                  ),
                                ),

                              ],
                            ),
                          ),

                          Column(
                            children: [
                              Container(
                                height: 100,
                                width: 70,
                                color: Colors.red,

                                child: Image.network(
                                  m[index]['bookPic'][0],
                                  fit: BoxFit.cover,
                                ),

                              ),

                            ],
                          )
                        ],
                      ),

                    ),

                    Divider(
                      color: Colors.black54,
                      thickness: 1,
                    ),
                    GestureDetector(
                      onTap: (){
                        //cart.removeItem(product.id);
                        showDialog(context: context,
                          builder: (ctx) => AlertDialog(

                            title: Text("Are you sure?"),
                            content: Text('Do you want to remove the item?'),
                            actions: [
                              TextButton(onPressed: (){
                                var item = l[index];
                                try{
                                  m.removeAt(index);
                                 // print("l is ${l}");
                                 ref.read(userCrudProvider).removeFavorite(m);

                                  print("favbooks  is ${ ref.read(userCrudProvider).user['favBooks']}");
                                  setState(() {

                                  });


                                }catch(e){
                                  print("eerror is ${e}");
                                  m.insert(index, item);
                                  ref.read(userCrudProvider).user['favBooks']=l;
                                  var snackBar = SnackBar(
                                      content: Text('Something Went Wrong',
                                          textAlign: TextAlign.center));
                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);

                                }
                                Navigator.pop(context);
                              },
                                  child: Text("Yes")
                              ),
                              TextButton(onPressed: (){

                                Navigator.of(context).pop();
                              },
                                  child: Text("No")
                              )
                            ],
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text('Remove item',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            //fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ),
                  ],
                ),


              ),
            );
          }
          ),

    );
  }
}

