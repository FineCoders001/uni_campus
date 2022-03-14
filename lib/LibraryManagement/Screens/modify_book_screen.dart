import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:provider/provider.dart';
import 'package:uni_campus/LibraryManagement/Models/book_details.dart';
import 'package:uni_campus/LibraryManagement/Screens/add_book_screen.dart';
import 'package:uni_campus/LibraryManagement/library_crud.dart';
import 'package:uni_campus/Provider/internet_provider.dart';
import 'package:uni_campus/Widgets/no_internet_screen.dart';

class ModifyBookScreen extends StatefulWidget {
  const ModifyBookScreen({Key? key}) : super(key: key);

  @override
  _ModifyBookScreenState createState() => _ModifyBookScreenState();
}

class _ModifyBookScreenState extends State<ModifyBookScreen> {
  final queryBook = FirebaseFirestore.instance
      .collection("LibraryManagement")
      .doc("Books")
      .collection('AllBooks')
      .withConverter(
        fromFirestore: (snapshot, _) => BookDetails.fromJson(snapshot.data()!),
        toFirestore: (bookDetails, _) => bookDetails.toJson(),
      );
  
  @override
  void initState() {
    context.read<Internet>().checkInternet();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return context.watch<Internet>().getInternet == false
        ? const NoInternetScreen()
        : Scaffold(
            appBar: AppBar(
              backgroundColor: const Color.fromARGB(255, 82, 72, 200),
              title: const Text("Library"),
              centerTitle: true,
            ),
            body: FirestoreListView<BookDetails>(
              pageSize: 2,
              query: queryBook,
              itemBuilder: (context, snapshot) {
                final book = snapshot.data();

                return Container(
                  margin: const EdgeInsets.all(12),
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.grey,
                        // offset: Offset(0.0, 1.0), //(x,y)
                        blurRadius: 6.0,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        title: Text(
                          book.bookName,
                          style: const TextStyle(fontSize: 20),
                        ),
                        subtitle: Text(book.bookAuthor),
                        leading: Image.network(
                          book.bookPic[0],
                          fit: BoxFit.cover,
                        ),

                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                                margin: const EdgeInsets.all(8),
                                //padding: EdgeInsets.all(8),
                                child: CircleAvatar(
                                  backgroundColor: Colors.amberAccent,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: InkWell(
                                        onTap: () {
                                          Navigator.of(context).pushNamed(
                                              AddBookScreen.routeName,
                                              arguments: {
                                                'bookName': book.bookName,
                                                'bookAuthor': book.bookAuthor,
                                                'bookDepartment':
                                                    book.bookDepartment,
                                                'bookPages': book.bookPages,
                                                'bookPublication':
                                                    book.bookPublication,
                                                'isbnNumber': book.isbnNumber,
                                                'bookQuantity':
                                                    book.bookQuantity,
                                                'bookPic': book.bookPic,
                                                'bookId': book.bookId,
                                                'isInit': true
                                              });
                                        },
                                        child: const Icon(
                                          Icons.edit,
                                          color: Colors.white,
                                        )),
                                  ),
                                )),
                            Container(
                              margin: const EdgeInsets.all(8),
                              //padding: EdgeInsets.all(8),
                              child: CircleAvatar(
                                backgroundColor: Colors.red,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: InkWell(
                                      onTap: () async {
                                        showDialog(
                                          context: context,
                                          builder: (ctx) => AlertDialog(
                                            title: const Text("Are you sure?"),
                                            content: const Text(
                                                'Do you want to remove  the book?'),
                                            actions: [
                                              TextButton(
                                                  onPressed: () async {
                                                    try {
                                                      await DeleteBooks()
                                                          .deleteBooks(book);
                                                    } catch (e) {
                                                      var snackBar = const SnackBar(
                                                          content: Text(
                                                              'Something Went Wrong',
                                                              textAlign:
                                                                  TextAlign
                                                                      .center));
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                              snackBar);
                                                    }
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text("Yes")),
                                              TextButton(
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text("No"))
                                            ],
                                          ),
                                        );
                                      },
                                      child: const Icon(
                                        Icons.delete,
                                        color: Colors.white,
                                      )),
                                ),
                              ),
                            ),
                          ],
                        ),
                        //leading: Icon(Icons.event),
                      ),
                    ],
                  ),
                );
              },
            ),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () {
                Navigator.of(context).pushNamed(AddBookScreen.routeName,
                    arguments: {'isInit': false});
              },
              label: const Text(
                "Add Book",
              ),
              icon: const Icon(
                Icons.add,
              ),
            ),
          );
  }
}
