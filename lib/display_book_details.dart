import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uni_campus/LibraryManagement/library_crud.dart';
import 'package:uni_campus/Profile/Screens/profile_screen.dart';

import 'Ratings.dart';
import 'styled_image.dart';

class DisplayBookDetail extends StatefulWidget {
  //const DisplayBookDetail({Key? key}) : super(key: key);
  static const routename = 'DisplayBookDetail';

  const DisplayBookDetail({Key? key}) : super(key: key);

  @override
  _DisplayBookDetailState createState() => _DisplayBookDetailState();
}

class _DisplayBookDetailState extends State<DisplayBookDetail> {
  late var book;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var arguments = ModalRoute.of(context)?.settings.arguments as Map;
    book = arguments['book'];
    print("book is ${book['bookId']}");
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 82, 72, 200),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Badge(
              animationType: BadgeAnimationType.fade,
              badgeContent: const Text('3'),
              child: const Icon(
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
                            Ratings(book)
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
  late List l;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    l = ref.read(userCrudProvider).user['favBooks'];
    print("entry ${l}");
    if (l.contains(widget.bookId)) {
      setState(() {
        fav = true;
      });
      print("exit");
    }
  }

  @override
  Widget build(BuildContext context) {
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
            // await Navigator.push(context, MaterialPageRoute(builder: (
            //     BuildContext context) => ()));
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
