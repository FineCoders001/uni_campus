import 'package:file_picker/file_picker.dart';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uni_campus/LibraryManagement/LibraryCrud.dart';
import 'package:uni_campus/LibraryManagement/Models/book_details.dart';
import 'dart:io';

class AddBookScreen extends StatefulWidget {
  const AddBookScreen({Key? key}) : super(key: key);

  @override
  _AddBookScreenState createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  TextEditingController bookName = TextEditingController();
  TextEditingController bookAuthor = TextEditingController();
  TextEditingController bookPages = TextEditingController();
  TextEditingController bookGenre = TextEditingController();
  TextEditingController bookPublication = TextEditingController();
  TextEditingController bookISBN = TextEditingController();
  TextEditingController bookQuantity = TextEditingController();
  final _form = GlobalKey<FormState>();
  late String downloadLink;
  List<String> bookPic = [];
  var isLoading = false;
  BookDetails book = BookDetails(
      bookName: "",
      bookAuthor: "",
      bookGenre: "",
      bookPages: "",
      bookPic: [],
      bookPublication: "",
      isbnNumber: 0,
      bookQuantity: 0);

  Future<void> _saveForm(context) async {
    final isValid = _form.currentState?.validate();
    if (!isValid!) {
      return;
    }
    _form.currentState?.save();

    if (bookPic.length == 0) {
      var snackBar = const SnackBar(
          content: Text("Image upload pending", textAlign: TextAlign.center));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    book = BookDetails(
        bookName: book.bookName,
        bookAuthor: book.bookAuthor,
        bookGenre: book.bookGenre,
        bookPages: book.bookPages,
        bookPic: bookPic,
        bookPublication: book.bookPublication,
        isbnNumber: book.isbnNumber,
        bookQuantity: book.bookQuantity);
    print("idhar: ${book.isbnNumber}");

    try {
      AddBooks().addBook(book);
      Navigator.pop(context);
    } catch (e) {
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Oops!'),
          content: const Text('Something went wrong'),
          actions: <Widget>[
            TextButton(
              child: const Text('Okay'),
              onPressed: () {
                Navigator.of(ctx).pop();
                //return;
              },
            )
          ],
        ),
      );
      Navigator.pop(context);
    }

    // Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/Background.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: Form(
                key: _form,
                child: Padding(
                    padding:
                        const EdgeInsets.only(left: 10, right: 10, top: 20),
                    child: ListView(children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: const Icon(
                                Icons.arrow_back,
                                // color: Colors.white,
                              )),
                        ],
                      ),
                      Card(
                        elevation: 5,
                        child: Container(
                          decoration: const BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("assets/images/Card.png"),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Column(
                            children: [
                              Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Container(
                                      alignment: Alignment.centerLeft,
                                      // print("entered");

                                      child: const Text(
                                        "Book",
                                        style: TextStyle(fontSize: 24),
                                      ))),
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: TextFormField(
                                    controller: bookName,
                                    decoration: const InputDecoration(
                                      fillColor: Colors.white,
                                      filled: true,
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.grey, width: 2.0),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.grey,
                                          width: 2.0,
                                        ),
                                      ),
                                      hintText: "bookName",
                                    ),
                                    validator: (value) {
                                      if (value != null && value.isEmpty) {
                                        return 'Please provide a value!';
                                      }
                                      return null;
                                    },
                                    onSaved: (value) {
                                      book = BookDetails(
                                          bookName: value.toString().trim(),
                                          bookAuthor: book.bookAuthor,
                                          bookGenre: book.bookGenre,
                                          bookPages: book.bookPages,
                                          bookPic: book.bookPic,
                                          bookPublication: book.bookPublication,
                                          isbnNumber: book.isbnNumber,
                                          bookQuantity: book.bookQuantity);
                                    }),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: TextFormField(
                                  controller: bookAuthor,
                                  decoration: const InputDecoration(
                                    fillColor: Colors.white,
                                    filled: true,
                                    hintText: "Author",
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.grey, width: 2.0),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.grey, width: 2.0),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value != null && value.isEmpty) {
                                      return 'Please provide a value!';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    book = BookDetails(
                                        bookName: book.bookName,
                                        bookAuthor: value.toString().trim(),
                                        bookGenre: book.bookGenre,
                                        bookPages: book.bookPages,
                                        bookPic: book.bookPic,
                                        bookPublication: book.bookPublication,
                                        isbnNumber: book.isbnNumber,
                                        bookQuantity: book.bookQuantity);
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: TextFormField(
                                  controller: bookPages,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    fillColor: Colors.white,
                                    filled: true,
                                    contentPadding: EdgeInsets.all(15),
                                    hintText: "Pages",
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.grey, width: 2.0),
                                    ),
                                  ),
                                  validator: (value) {
                                    if (value != null && value.isEmpty) {
                                      return 'Please enter a description.';
                                    }
                                    if (value != null && value.isEmpty) {
                                      return 'enter no of pages';
                                    }
                                    return null;
                                  },
                                  onSaved: (value) {
                                    book = BookDetails(
                                        bookName: book.bookName,
                                        bookAuthor: book.bookAuthor,
                                        bookGenre: book.bookGenre,
                                        bookPages: value.toString().trim(),
                                        bookPic: book.bookPic,
                                        bookPublication: book.bookPublication,
                                        isbnNumber: book.isbnNumber,
                                        bookQuantity: book.bookQuantity);
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  controller: bookGenre,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Please enter a valid value";
                                    } else {
                                      return null;
                                    }
                                  },
                                  keyboardType: TextInputType.text,
                                  decoration: const InputDecoration(
                                    fillColor: Colors.white,
                                    filled: true,
                                    hintText: "Genre",
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              Color.fromARGB(255, 73, 128, 255),
                                          width: 2.5),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              Color.fromARGB(255, 73, 128, 255),
                                          width: 2.5),
                                    ),
                                  ),
                                  onSaved: (value) {
                                    book = BookDetails(
                                        bookName: book.bookName,
                                        bookAuthor: book.bookAuthor,
                                        bookGenre: value.toString().trim(),
                                        bookPages: book.bookPages,
                                        bookPic: book.bookPic,
                                        bookPublication: book.bookPublication,
                                        isbnNumber: book.isbnNumber,
                                        bookQuantity: book.bookQuantity);
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  controller: bookPublication,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Please enter a valid value";
                                    } else {
                                      return null;
                                    }
                                  },
                                  keyboardType: TextInputType.text,
                                  decoration: const InputDecoration(
                                    fillColor: Colors.white,
                                    filled: true,
                                    hintText: "Publication",
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              Color.fromARGB(255, 73, 128, 255),
                                          width: 2.5),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              Color.fromARGB(255, 73, 128, 255),
                                          width: 2.5),
                                    ),
                                  ),
                                  onSaved: (value) {
                                    book = BookDetails(
                                        bookName: book.bookName,
                                        bookAuthor: book.bookAuthor,
                                        bookGenre: book.bookGenre,
                                        bookPages: book.bookPages,
                                        bookPic: book.bookPic,
                                        bookPublication:
                                            value.toString().trim(),
                                        isbnNumber: book.isbnNumber,
                                        bookQuantity: book.bookQuantity);
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  controller: bookISBN,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Please enter a valid value";
                                    } else {
                                      return null;
                                    }
                                  },
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    fillColor: Colors.white,
                                    filled: true,
                                    hintText: "isbn number",
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              Color.fromARGB(255, 73, 128, 255),
                                          width: 2.5),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              Color.fromARGB(255, 73, 128, 255),
                                          width: 2.5),
                                    ),
                                  ),
                                  onSaved: (value) {
                                    print(int.parse(value.toString()));
                                    book = BookDetails(
                                        bookName: book.bookName,
                                        bookAuthor: book.bookAuthor,
                                        bookGenre: book.bookGenre,
                                        bookPages: book.bookPages,
                                        bookPic: book.bookPic,
                                        bookPublication: book.bookPublication,
                                        isbnNumber: int.parse(value.toString()),
                                        //isbnNumber: int.parse(value!),
                                        bookQuantity: book.bookQuantity);
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: TextFormField(
                                  controller: bookQuantity,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Please enter a valid value";
                                    } else {
                                      return null;
                                    }
                                  },
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    fillColor: Colors.white,
                                    filled: true,
                                    hintText: "Quantity",
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              Color.fromARGB(255, 73, 128, 255),
                                          width: 2.5),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              Color.fromARGB(255, 73, 128, 255),
                                          width: 2.5),
                                    ),
                                  ),
                                  onSaved: (value) {
                                    book = BookDetails(
                                        bookName: book.bookName,
                                        bookAuthor: book.bookAuthor,
                                        bookGenre: book.bookGenre,
                                        bookPages: book.bookPages,
                                        bookPic: book.bookPic,
                                        bookPublication: book.bookPublication,
                                        isbnNumber: book.isbnNumber,
                                        bookQuantity: int.parse(value!));
                                  },
                                ),
                              ),
                              GestureDetector(
                                  onTap: () async {
                                    upload();
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.all(15),
                                    alignment: Alignment.center,
                                    decoration: const BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topRight,
                                        end: Alignment.bottomLeft,
                                        colors: [
                                          Colors.blue,
                                          Colors.cyan,
                                        ],
                                      ),

                                      // border: Border.all(width: 5.0, color: Colors.grey),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(5.0),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Text(
                                        "Upload book's image",
                                        style: GoogleFonts.ubuntu(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  )),
                              //Text("${}"),
                              const SizedBox(
                                height: 2,
                              ),
                              GestureDetector(
                                onTap: () async {
                                  //context.read(eventProvider)
                                  setState(() {
                                    isLoading = true;
                                  });
                                  await _saveForm(context);
                                  setState(() {
                                    isLoading = false;
                                  });
                                },
                                child: Container(
                                  margin: const EdgeInsets.all(15),
                                  alignment: Alignment.center,
                                  decoration: const BoxDecoration(
                                    // image: const DecorationImage(
                                    //   image: AssetImage("assets/images/Card.png"),
                                    //   fit: BoxFit.cover,
                                    // ),
                                    gradient: LinearGradient(
                                      begin: Alignment.topRight,
                                      end: Alignment.bottomLeft,
                                      colors: [
                                        Colors.blue,
                                        Colors.cyan,
                                      ],
                                    ),

                                    // border: Border.all(width: 5.0, color: Colors.grey),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(5.0),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Text(
                                      "Add Book",
                                      style: GoogleFonts.ubuntu(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ])))));
  }

  Future<void> upload() async {
    try {
      FilePickerResult? result = await FilePicker.platform
          .pickFiles(type: FileType.image, allowMultiple: true);

      if (result != null) {
        setState(() {
          isLoading = true;
          bookName.text = bookName.text;
          bookAuthor.text = bookAuthor.text;
          bookQuantity.text = bookQuantity.text;
          bookPublication.text = bookPublication.text;
          bookPages.text = bookPages.text;
          bookISBN.text = bookISBN.text;
          bookGenre.text = bookGenre.text;

          if (isLoading == true) {
            showDialog(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                  title: Text(
                    'Uploading Image',
                    style: GoogleFonts.ubuntu(fontSize: 25),
                  ),
                  content: Container(
                    child: CircularProgressIndicator(),
                    alignment: Alignment.center,
                    height: MediaQuery.of(context).size.height / 9,
                  )),
            );
          }
        });
        // PlatformFile file = result.files.first;
        List<File> files =
            result.paths.map((path) => File(path.toString())).toList();
        List filename = result.names.map((name) => name).toList();
        firebase_storage.Reference ref;

        for (int i = 0; i < files.length; i++) {
          ref = firebase_storage.FirebaseStorage.instance
              .ref()
              .child('bookPics')
              .child(filename[i]);
          UploadTask task = ref.putFile(files[i]);

          final snapshot = await task.whenComplete(() => null);
          downloadLink = await snapshot.ref.getDownloadURL();
          bookPic.add(downloadLink);
        }

        var snackBar = const SnackBar(
            content: Text('Image  Uploaded Successfully',
                textAlign: TextAlign.center));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        setState(() {
          isLoading = false;
          bookName.text = bookName.text;
          bookAuthor.text = bookAuthor.text;
          bookQuantity.text = bookQuantity.text;
          bookPublication.text = bookPublication.text;
          bookPages.text = bookPages.text;
          bookISBN.text = bookISBN.text;
          bookGenre.text = bookGenre.text;
          if (isLoading == false) {
            Navigator.pop(context);
          }
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        bookName.text = bookName.text;
        bookAuthor.text = bookAuthor.text;
        bookQuantity.text = bookQuantity.text;
        bookPublication.text = bookPublication.text;
        bookPages.text = bookPages.text;
        bookISBN.text = bookISBN.text;
        bookGenre.text = bookGenre.text;

        if (isLoading == false) {
          Navigator.pop(context);
        }
      });
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Oops!'),
          content: const Text('Something went wrong'),
          actions: <Widget>[
            TextButton(
              child: const Text('Okay'),
              onPressed: () {
                Navigator.of(ctx).pop();
                //return;
              },
            )
          ],
        ),
      );
    }
  }
}
