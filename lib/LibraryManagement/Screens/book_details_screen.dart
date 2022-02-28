import 'dart:async';
import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uni_campus/LibraryManagement/Screens/favorite_book_screen.dart';
import 'package:uni_campus/LibraryManagement/Widgets/rating_bar.dart';
import 'package:uni_campus/LibraryManagement/Widgets/reviews.dart';
import 'package:uni_campus/LibraryManagement/library_crud.dart';
import 'package:uni_campus/Profile/Screens/profile_screen.dart';
import 'package:uni_campus/Users/user_crud.dart';
import 'package:uni_campus/widgets/ratings.dart';
import 'package:uni_campus/widgets/styled_image.dart';

class BookDetailsScreen extends StatefulHookConsumerWidget {
  //const DisplayBookDetail({Key? key}) : super(key: key);
  static const routename = 'BookDetailScreen';

  const BookDetailsScreen({Key? key}) : super(key: key);

  @override
  _BookDetailsScreenState createState() => _BookDetailsScreenState();
}

class _BookDetailsScreenState extends ConsumerState<BookDetailsScreen> {
  fetchTask() async {
    await ref.read(userCrudProvider).fetchUserProfile();
  }

  late Timer timer;
  late var book;
  bool reviewed = false;
  late List l;

  Map<String, dynamic> m = {'ratings': 0.0, 'ratingsCount': 0.0};

  getRating() async {
    var v = await FirebaseFirestore.instance
        .collection("LibraryManagement")
        .doc("Books")
        .collection('AllBooks')
        .doc(book['bookId'])
        .collection("BookRating")
        .doc("r&r")
        .get();
    m = v.data()!;
    setState(() {});
  }

  @override
  void didChangeDependencies() {
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
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Card(
                    elevation: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 20),
                              child: Text(
                                book['bookName'],
                                style: const TextStyle(
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
                                child: Ratings(
                                    book, m['ratings'], m['ratingsCount']))
                          ],
                        ),
                        book['bookQuantity'] <= 0
                            ? const Padding(
                                padding: EdgeInsets.only(bottom: 8.0),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Out Of Stock',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.red,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : const Padding(
                                padding: EdgeInsets.only(bottom: 8.0),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      'Book In Stock',
                                      style: TextStyle(
                                        fontSize: 20,
                                        color: Colors.green,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10.0, vertical: 4),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: const [
                                  Text(
                                    'Book Details',
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Icon(
                                    Icons.list_alt_outlined,
                                    size: 25,
                                  ),
                                ],
                              ),
                              bookDetailWid("Author", book['bookAuthor']),
                              bookDetailWid("Pages", book['bookPages']),
                              bookDetailWid(
                                  "Publication", book['bookPublication']),
                              bookDetailWid(
                                  "Isbn No", book['isbnNumber'].toString())
                            ],
                          ),
                        ),
                        reviewed
                            ? Padding(
                                padding: const EdgeInsets.all(8.0),
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
                                          "Already Rated and Reviewed",
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w500,
                                              color: Color.fromARGB(
                                                  255, 82, 72, 200)),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            : GestureDetector(
                                onTap: () async {
                                  await showDialog(
                                      context: context,
                                      builder: (ctx) {
                                        return RatingBar(
                                            double.parse(
                                                m['ratings'].toString()),
                                            double.parse(
                                                m['ratingsCount'].toString()),
                                            book['bookReviewedUsers'],
                                            book['bookId']);
                                      });
                                  setState(() {
                                    reviewed = true;
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
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
                                            'Add Reviews',
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          Icon(Icons.rate_review_outlined),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                      ],
                    ),
                  ),
                ),
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
  BottomButton(this.book, {Key? key}) : super(key: key);

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
      } else if (await EditRequest()
              .bookApproved(widget.book['bookId'], user) ==
          true) {
        setState(() {
          isIssued = "Book Approved";
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
                    ? InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  const FavoriteBookScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          ' GO TO FAVORITE',
                          style: TextStyle(color: Colors.black),
                        ),
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
            } else if (isIssued == "Book Approved") {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  duration: Duration(seconds: 1),
                  content: Text('Collect book at the Library',
                      textAlign: TextAlign.center),
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