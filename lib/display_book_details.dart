import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uni_campus/FavoriteBookScreen.dart';

import 'package:uni_campus/LibraryManagement/Models/book_details.dart';
import 'package:uni_campus/Profile/Screens/profile_screen.dart';
import 'package:uni_campus/RatingBar.dart';
import 'package:uni_campus/Reviews.dart';
import 'package:uni_campus/styled_image.dart';

import 'LibraryManagement/library_crud.dart';
import 'Ratings.dart';
import 'book_home_screen.dart';

class DisplayBookDetail extends StatefulWidget {
  //const DisplayBookDetail({Key? key}) : super(key: key);
  static const routename = 'DisplayBookDetail';

  @override
  _DisplayBookDetailState createState() => _DisplayBookDetailState();
}

class _DisplayBookDetailState extends State<DisplayBookDetail> {
  late var book;
  bool reviewed = false;
  late List l;


  Map<String,dynamic> m={'ratings':0.0,'ratingsCount':0.0};

  getRating()async{
    var v =await FirebaseFirestore.instance
        .collection("LibraryManagement")
        .doc("Books")
        .collection('AllBooks')
        .doc(book['bookId'])
        .collection("BookRating").doc("r&r").get();
    m=v.data()!;
    setState(() {

    });
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    var arguments = ModalRoute.of(context)?.settings.arguments as Map;
    book = arguments['book'];
    getRating();
  }

  @override
  Widget build(BuildContext context) {
    print("book is ${book['bookId']}");
    l = book['bookReviewedUsers'];
    if (l.contains(FirebaseAuth.instance.currentUser?.uid)) {
      reviewed = true;
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 82, 72, 200),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Badge(
              animationType: BadgeAnimationType.fade,
              badgeContent: Text('3'),
              child: Icon(
                Icons.favorite_border,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(flex: 5, child: StyledImage(book['bookPic'])),
              Expanded(
                flex: 4,
                child: SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10.0, vertical: 20),
                              child: Text(
                                book['bookName'],
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 28,
                                ),
                              ),
                            ),
                            GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          Reviews(book['bookId']),
                                    ),
                                  );
                                },
                                child: Ratings(book,m['ratings'],m['ratingsCount']))
                          ],
                        ),
                        book['bookQuantity'] - book['issuedQuantity'] <= 0
                            ? Padding(
                                padding:
                                    const EdgeInsets.only(left: 20.0, right: 8),
                                child: Text(
                                  'Out Of Stock',
                                  style: TextStyle(
                                    fontSize: 24,
                                    color: Colors.red,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              )
                            : Container(
                                width: double.infinity,
                                child: Align(
                                  alignment: Alignment.center,
                                  child: Text(
                                    'Book In Stock',
                                    style: TextStyle(
                                      fontSize: 24,
                                      color: Colors.green,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                        reviewed
                            ? Card(
                                elevation: 5,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 20.0, horizontal: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Already Rated and Reviewed",
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500,
                                            color: const Color.fromARGB(
                                                255, 82, 72, 200)),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : GestureDetector(
                                onTap: () async {
                                  await showDialog(
                                      context: context,
                                      builder: (ctx) {
                                        return RatingBar(
                                            double.parse(m['ratings'].toString()),
                                            double.parse(m['ratingsCount'].toString()),
                                            book['bookReviewedUsers'],
                                            book['bookId']);
                                      });
                                  setState(() {
                                    reviewed=true;
                                  });
                                },
                                child: Card(
                                  elevation: 5,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 20.0, horizontal: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Add Reviews',
                                          style: TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        Icon(Icons
                                            .arrow_drop_down_circle_outlined),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                        Card(
                          elevation: 5,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 20.0, horizontal: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Book Details',
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w600),
                                ),
                                Icon(Icons.arrow_drop_down_circle_outlined),
                              ],
                            ),
                          ),
                        ),
                        bookDetailWid("Author", book['bookAuthor']),
                        bookDetailWid("Pages", book['bookPages']),
                        bookDetailWid("Publication", book['bookPublication']),
                        bookDetailWid("Isbn No", book['isbnNumber'].toString())
                      ]),
                ),
              ),
              Expanded(
                flex: 1,
                child: BottomButton(book['bookId']),
              )
            ]),
      ),
    );
  }

  bookDetailWid(String title, String subtitle) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 0,
          child: Padding(
            padding: const EdgeInsets.only(top: 20.0, left: 10),
            child: Text(
              '👉',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Padding(
            padding: const EdgeInsets.only(top: 20.0, left: 5),
            child: Text(
              ' ${title}',
              style: TextStyle(color: Colors.grey, fontSize: 15),
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.only(top: 20.0, right: 10, left: 20),
            child: Text(
              '${subtitle}',
              style: TextStyle(fontSize: 16, wordSpacing: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}

class BottomButton extends StatefulHookConsumerWidget {
  String bookId;

  BottomButton(this.bookId);

  @override
  _BottomButtonState createState() => _BottomButtonState();
}

class _BottomButtonState extends ConsumerState<BottomButton> {
  bool fav = false;


@override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

  }
  @override
  void initState() {
    // TODO: implement initState

  }

  @override
  Widget build(BuildContext context) {

    List l = ref.watch(userCrudProvider).user['favBooks'];
    print("entry ${l}");
    if (l.contains(widget.bookId)) {

      fav = true;

      print("exit");
    }else{
      fav=false;
    }

    print("book id is ${widget.bookId}");
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      GestureDetector(
        onTap: () async {
          if (fav == false) {
            try {
              await AddToFav().addToFav(widget.bookId, l);
              setState(() {
                fav = true;
              });
              var snackBar = SnackBar(
                  content:
                      Text('Added to favorites', textAlign: TextAlign.center));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            } catch (e) {
              var snackBar = SnackBar(
                  content: Text('Something Went Wrong',
                      textAlign: TextAlign.center));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              print(e);
            }
          } else {
            await Navigator.push(context, MaterialPageRoute(builder: (
                BuildContext context) => FavoriteBookScreen()));
          }
        },
        child: Container(
          width: (MediaQuery.of(context).size.width) * 0.50,
          color: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.favorite_border,
                color: Colors.red,
              ),
              fav
                  ? Text(
                      ' GO TO FAVORITE',
                      style: TextStyle(color: Colors.black),
                    )
                  : Text(
                      ' ADD TO FAVORITE',
                      style: TextStyle(color: Colors.black),
                    ),
            ],
          ),
        ),
      ),
      GestureDetector(
          onTap: () async {},
          child: Container(
              color: const Color.fromARGB(255, 82, 72, 200),
              width: (MediaQuery.of(context).size.width) * 0.50,
              padding: EdgeInsets.symmetric(vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.work,
                    color: Colors.white,
                  ),
                  Text(
                    ' ISSUE BOOK',
                    style: TextStyle(color: Colors.white),
                  )
                ],
              ))),
    ]);
  }
}
