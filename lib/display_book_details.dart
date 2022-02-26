import 'dart:async';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uni_campus/LibraryManagement/library_crud.dart';
import 'package:uni_campus/Profile/Screens/profile_screen.dart';
import 'package:uni_campus/styled_image.dart';
import 'package:uni_campus/user_crud.dart';
import 'Ratings.dart';

class DisplayBookDetail extends StatefulHookConsumerWidget {
  //const DisplayBookDetail({Key? key}) : super(key: key);
  static const routename = 'DisplayBookDetail';

  @override
  _DisplayBookDetailState createState() => _DisplayBookDetailState();
}

class _DisplayBookDetailState extends ConsumerState<DisplayBookDetail> {
  fetchTask() async {
    await ref.read(userCrudProvider).fetchUserProfile();
  }

  late Timer timer;
  late var book;

  @override
  void initState() {
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
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 28,
                              ),
                            ),
                          ),
                          Ratings(book)
                        ],
                      ),
                      book['bookQuantity'] - book['issuedQuantity'] <= 0
                          ? const Padding(
                              padding: EdgeInsets.only(left: 20.0, right: 8),
                              child: Text(
                                'Out Of Stock',
                                style: TextStyle(
                                  fontSize: 24,
                                  color: Colors.red,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            )
                          : const SizedBox(
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
                            children: const [
                              Text(
                                'Book Details',
                                style: TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.w600),
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
              child: BottomButton(book),
            )
          ],
        ),
      ),
    );
  }

  bookDetailWid(String title, String subtitle) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Expanded(
          flex: 0,
          child: Padding(
            padding: EdgeInsets.only(top: 20.0, left: 10),
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
              ' $title',
              style: const TextStyle(color: Colors.grey, fontSize: 15),
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.only(top: 20.0, right: 10, left: 20),
            child: Text(
              subtitle,
              style: const TextStyle(fontSize: 16, wordSpacing: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}

class BottomButton extends StatefulHookConsumerWidget {
  dynamic book;
  BottomButton(this.book);

  @override
  _BottomButtonState createState() => _BottomButtonState();
}

class _BottomButtonState extends ConsumerState<BottomButton> {
  String isIssued = "Issue Book";
  bool fav = false;
  late UserCrud userCrud;
  late List l;
  late Map<String, dynamic> user;

  @override
  void initState() {
    super.initState();
    l = ref.read(userCrudProvider).user['favBooks'];
    print("entry $l");
    if (l.contains(widget.book['bookId'])) {
      setState(() {
        fav = true;
      });
      print("exit");
    }
  }

  @override
  Future<void> didChangeDependencies() async {
    userCrud = ref.watch(userCrudProvider);
    user = userCrud.user;
    if (widget.book["bookQuantity"] > 0) {
      if (await EditRequest().bookIssued(widget.book['bookId'], user) == true) {
        setState(() {
          isIssued = "Cancel Request";
        });
      }
    } else {
      setState(() {
        isIssued = "Out of Stock";
      });
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    print("book id is ${widget.book['bookId']}");
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () async {
            if (fav == false) {
              try {
                await AddToFav().addToFav(widget.book['bookId'], l);
                setState(() {
                  fav = true;
                });
                var snackBar = const SnackBar(
                    content: Text('Added to favorites',
                        textAlign: TextAlign.center));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              } catch (e) {
                var snackBar = const SnackBar(
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
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.favorite_border,
                  color: Colors.red,
                ),
                fav
                    ? const Text(
                        ' GO TO FAVORITE',
                        style: TextStyle(color: Colors.black),
                      )
                    : const Text(
                        ' ADD TO FAVORITE',
                        style: TextStyle(color: Colors.black),
                      ),
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: () async {
            if (isIssued == "Issue Book") {
              print("here:${widget.book['bookReviewedUsers']}");
              await EditRequest()
                  .requestBook(widget.book["bookId"], user)
                  .then((value) => {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            duration: Duration(seconds: 1),
                            content:
                                Text('Issued', textAlign: TextAlign.center),
                          ),
                        ),
                        setState(() {
                          isIssued = "Cancel Request";
                        }),
                      });
            } else if (isIssued == "Cancel Request") {
              await EditRequest()
                  .deleteRequest(widget.book["bookId"], user)
                  .then((value) => {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            duration: Duration(seconds: 1),
                            content: Text('Request Deleted',
                                textAlign: TextAlign.center),
                          ),
                        ),
                        setState(() {
                          isIssued = "Issue Book";
                        }),
                      });
            } else if (isIssued == "Out of Stock") {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  duration: Duration(seconds: 1),
                  content: Text('Out of Stock', textAlign: TextAlign.center),
                ),
              );
            }
          },
          child: Container(
            color: const Color.fromARGB(255, 82, 72, 200),
            width: (MediaQuery.of(context).size.width) * 0.50,
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.shopping_bag_outlined,
                  color: Colors.white,
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  isIssued,
                  style: const TextStyle(color: Colors.white),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
