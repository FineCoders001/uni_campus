import 'dart:async';
import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:uni_campus/LibraryManagement/Widgets/rating_bar.dart';
import 'package:uni_campus/LibraryManagement/Widgets/reviews.dart';
import 'package:uni_campus/LibraryManagement/library_crud.dart';
import 'package:uni_campus/Profile/Screens/profile_screen.dart';
import 'package:uni_campus/Users/user_crud.dart';
import 'package:uni_campus/widgets/ratings.dart';
import 'package:uni_campus/widgets/styled_image.dart';
import 'favorite_book_screen.dart';

class BookDetailsScreen extends StatefulHookConsumerWidget {
  //const DisplayBookDetail({Key? key}) : super(key: key);
  static const routename = 'BookDetailsScreen';

  const BookDetailsScreen({Key? key}) : super(key: key);

  @override
  _BookDetailsScreenState createState() => _BookDetailsScreenState();
}

class _BookDetailsScreenState extends ConsumerState<BookDetailsScreen> {
  fetchTask() async {
    await ref.read(userCrudProvider).fetchUserProfile();
  }

  late Timer timer;
  late dynamic book;
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
          GestureDetector(
            onTap: () async {
              await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) =>
                          const FavoriteBookScreen()));
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Badge(
                animationType: BadgeAnimationType.fade,
                badgeContent: Text(
                    '${ref.watch(userCrudProvider).user['favBooks'].length}'),
                child: const Icon(
                  Icons.favorite_border,
                  color: Colors.white,
                ),
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
                    elevation: 3.0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 25.0, vertical: 20),
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
                        book['bookQuantity'] - book['issuedQuantity'] <= 0
                            ? const Padding(
                          padding: EdgeInsets.symmetric(vertical: 8.0),
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
                              padding: EdgeInsets.symmetric(vertical:8.0),
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
                        Card(
                          elevation: 7,
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
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
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: RatingBar(
                              double.parse(m['ratings'].toString()),
                              double.parse(m['ratingsCount'].toString()),
                              book['bookReviewedUsers'],
                              book['bookId'],
                              reviewed),
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
  final dynamic book;
  const BottomButton(this.book, {Key? key}) : super(key: key);

  @override
  _BottomButtonState createState() => _BottomButtonState();
}

class _BottomButtonState extends ConsumerState<BottomButton> {
  String isIssued = "Issue Book";
  //bool fav = false;
  late UserCrud userCrud;
  late List l;
  late Map<String, dynamic> user;
  bool hasInternet = true;
  @override
  void initState() {
    super.initState();
    InternetConnectionChecker().onStatusChange.listen((status) {
      print("status is $status");
      setState(() {
        switch (status) {
          case InternetConnectionStatus.connected:
            print('Data connection is available.');
            hasInternet = true;

            break;
          case InternetConnectionStatus.disconnected:
            print('You are disconnected from the internet.');
            hasInternet = false;

            break;
        }
        // hasInternet = status as bool;
      });
    });
  }

  @override
  Future<void> didChangeDependencies() async {
    userCrud = ref.watch(userCrudProvider);
    user = userCrud.user;
    if (widget.book["bookQuantity"] - widget.book["issuedQuantity"] > 0) {
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
    // l=user['favBooks'];
    // if (l.contains(widget.book['bookId'])) {
    //   setState(() {
    //     fav = true;
    //   });
    //   print("exit");
    // }else{
    //   setState(() {
    //     fav=false;
    //   });
    // }

    super.didChangeDependencies();
    bool result = await InternetConnectionChecker().hasConnection;
    if(result == true) {
      setState(() {
        hasInternet=true;
      });
      print('YAY! Free cute dog pics!');
    } else {
      setState(() {
        hasInternet=false;
      });
      print('No internet :( Reason:');

    }
  }

  @override
  Widget build(BuildContext context) {
    print("book id is ${widget.book['bookId']}");
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () async {
            if (!hasInternet) {
              var snackBar = const SnackBar(
                  content: Text('Check Your Internet Connection',
                      textAlign: TextAlign.center));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              return;
            }
            if (userCrud.user['favBooks'].contains(widget.book['bookId']) ==
                false) {
              try {
                await userCrud.addToFav(
                    widget.book['bookId'], userCrud.user['favBooks']);

                // ref.read(userCrudProvider).user['favBooks'].add(widget.book['bookId']);

                var snackBar = const SnackBar(
                    content: Text('Added to favorites',
                        textAlign: TextAlign.center));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              } catch (e) {
                var snackBar = const SnackBar(
                  content:
                      Text('Something Went Wrong', textAlign: TextAlign.center),
                  padding: EdgeInsets.all(12),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                print(e);
              }
            } else {
              await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) =>
                          const FavoriteBookScreen()));
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
                userCrud.user['favBooks'].contains(widget.book['bookId'])
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
            if (!hasInternet) {
              var snackBar = const SnackBar(
                  content: Text('Check Your Internet Connection',
                      textAlign: TextAlign.center));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              return;
            }
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
