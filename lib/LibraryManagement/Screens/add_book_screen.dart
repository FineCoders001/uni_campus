import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:uni_campus/LibraryManagement/library_crud.dart';
import 'package:uni_campus/LibraryManagement/Models/book_details.dart';
import 'package:uni_campus/Provider/internet_provider.dart';
import 'package:uni_campus/Widgets/no_internet_screen.dart';

class AddBookScreen extends StatefulWidget {
  static const routeName = 'AddBookScreen';

  const AddBookScreen({Key? key}) : super(key: key);

  @override
  _AddBookScreenState createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  TextEditingController bookName = TextEditingController();
  TextEditingController bookAuthor = TextEditingController();
  TextEditingController bookPages = TextEditingController();
  TextEditingController bookDepartment = TextEditingController();
  TextEditingController bookPublication = TextEditingController();
  TextEditingController bookISBN = TextEditingController();
  TextEditingController bookQuantity = TextEditingController();
  final _bookAuthorNode = FocusNode();
  final _bookPagesNode = FocusNode();
  final _bookDepartmentNode = FocusNode();
  final _bookPublicationNode = FocusNode();
  final _bookISBNNode = FocusNode();
  final _bookQuantityNode = FocusNode();
  final _form = GlobalKey<FormState>();
  late String downloadLink;
  // List<String> bookPic = [];
  var isLoading = false;

  BookDetails book = BookDetails(
    bookName: "",
    bookAuthor: "",
    bookDepartment: "",
    bookPages: "",
    bookPic: [],
    bookPublication: "",
    isbnNumber: 0,
    bookQuantity: 0,
    bookReviews: [],
    bookReviewedUsers: [],
  );
  dynamic arguments;
  // Map _initValues = {
  //   'bookName': "",
  //   'bookAuthor': "",
  //   'bookDepartment': "",
  //   'bookPages': "",
  //   'bookPublication': "",
  //   'isbnNumber': 0,
  //   'bookQuantity': 0,
  // };
  

  @override
  void didChangeDependencies() {
    context.read<Internet>().checkInternet();
    super.didChangeDependencies();

    arguments = ModalRoute.of(context)?.settings.arguments as Map;
    if (arguments['isInit'] == true) {
      // _initValues = {
      //   'bookName': arguments["bookName"],
      //   'bookAuthor': arguments["bookAuthor"],
      //   'bookDepartment': arguments["bookDepartment"],
      //   'bookPages': arguments['bookPages'],
      //   'bookPublication': arguments['bookPublication'],
      //   'isbnNumber': arguments['isbnNumber'],
      //   'bookQuantity': arguments['bookQuantity'],
      // };
      print("arguments are ${arguments["bookName"]}");
      bookName.text = arguments["bookName"];
      bookAuthor.text = arguments["bookAuthor"];
      bookDepartment.text = arguments["bookDepartment"];
      bookPages.text = arguments['bookPages'];
      bookPublication.text = arguments['bookPublication'];
      bookISBN.text = arguments['isbnNumber'].toString();
      bookQuantity.text = arguments['bookQuantity'].toString();
      book.bookPic = arguments['bookPic'];
    }
  }

  Future<void> _saveForm(context) async {
    final isValid = _form.currentState?.validate();
    if (!isValid!) {
      return;
    }
    _form.currentState?.save();

    book = BookDetails(
        bookName: book.bookName,
        bookAuthor: book.bookAuthor,
        bookDepartment: book.bookDepartment,
        bookPages: book.bookPages,
        bookPic: book.bookPic,
        bookPublication: book.bookPublication,
        isbnNumber: book.isbnNumber,
        bookQuantity: book.bookQuantity,
        bookReviews: book.bookReviews,
        bookReviewedUsers: book.bookReviewedUsers);
    print("idhar: ${book.isbnNumber}");

    try {
      if (arguments['isInit'] == false) {
        if (book.bookPic.isEmpty) {
          var snackBar = const SnackBar(
              content:
                  Text("Image upload pending", textAlign: TextAlign.center));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          return;
        }

        AddBooks().addBook(book);
      } else {
        print("book pic is ${book.bookPic}");
        UpdateBook().updateBooks(arguments['bookId'], book);
      }
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
    print("entered build ${book.bookPic.length}");
    return context.watch<Internet>().getInternet == false
        ? const NoInternetScreen()
        : Scaffold(
            appBar: AppBar(
              backgroundColor: const Color.fromARGB(255, 82, 72, 200),
              elevation: 0,
              centerTitle: true,
              title: arguments['isInit'] == true
                  ? const Text(
                      "Edit Book Details",
                      style: TextStyle(fontSize: 23),
                    )
                  : const Text(
                      "Add Book Details",
                      style: TextStyle(fontSize: 23),
                    ),
              leading: IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 25,
                  )),
            ),
            body: Container(
              decoration: const BoxDecoration(
                  // image: DecorationImage(
                  //   image: AssetImage("assets/images/Background.png"),
                  //   fit: BoxFit.cover,
                  // ),
                  ),
              child: Form(
                key: _form,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10, top: 20),
                  child: ListView(
                    children: [
                      Card(
                        elevation: 5,
                        child: Container(
                          decoration: const BoxDecoration(
                              // image: DecorationImage(
                              //   image: AssetImage("assets/images/Card.png"),
                              //   fit: BoxFit.cover,
                              // ),
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
                                    //initialValue: _initValues['bookName'],
                                    controller: bookName,
                                    decoration: const InputDecoration(
                                      fillColor: Colors.white,
                                      filled: true,
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color.fromARGB(
                                                255, 73, 128, 255),
                                            width: 2.0),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.grey, width: 2.5),
                                      ),
                                      hintText: "Book Name",
                                    ),
                                    onFieldSubmitted: (_) {
                                      FocusScope.of(context)
                                          .requestFocus(_bookAuthorNode);
                                    },
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
                                          bookDepartment: book.bookDepartment,
                                          bookPages: book.bookPages,
                                          bookPic: book.bookPic,
                                          bookPublication: book.bookPublication,
                                          isbnNumber: book.isbnNumber,
                                          bookQuantity: book.bookQuantity,
                                          bookReviews: book.bookReviews,
                                          bookReviewedUsers:
                                              book.bookReviewedUsers);
                                    }),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: TextFormField(
                                  //initialValue: _initValues['bookAuthor'],
                                  controller: bookAuthor,
                                  focusNode: _bookAuthorNode,
                                  decoration: const InputDecoration(
                                    fillColor: Colors.white,
                                    filled: true,
                                    hintText: "Author",
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              Color.fromARGB(255, 73, 128, 255),
                                          width: 2.0),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.grey, width: 2.5),
                                    ),
                                  ),
                                  onFieldSubmitted: (_) {
                                    FocusScope.of(context)
                                        .requestFocus(_bookPagesNode);
                                  },
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
                                        bookDepartment: book.bookDepartment,
                                        bookPages: book.bookPages,
                                        bookPic: book.bookPic,
                                        bookPublication: book.bookPublication,
                                        isbnNumber: book.isbnNumber,
                                        bookQuantity: book.bookQuantity,
                                        bookReviews: book.bookReviews,
                                        bookReviewedUsers:
                                            book.bookReviewedUsers);
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: TextFormField(
                                  // initialValue: _initValues['bookPages'],
                                  controller: bookPages,
                                  focusNode: _bookPagesNode,
                                  keyboardType: TextInputType.number,
                                  decoration: const InputDecoration(
                                    fillColor: Colors.white,
                                    filled: true,
                                    hintText: "Pages",
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              Color.fromARGB(255, 73, 128, 255),
                                          width: 2.0),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.grey, width: 2.5),
                                    ),
                                  ),

                                  onFieldSubmitted: (_) {
                                    FocusScope.of(context)
                                        .requestFocus(_bookDepartmentNode);
                                  },
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
                                        bookDepartment: book.bookDepartment,
                                        bookPages: value.toString().trim(),
                                        bookPic: book.bookPic,
                                        bookPublication: book.bookPublication,
                                        isbnNumber: book.isbnNumber,
                                        bookQuantity: book.bookQuantity,
                                        bookReviews: book.bookReviews,
                                        bookReviewedUsers:
                                            book.bookReviewedUsers);
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: TextFormField(
                                  //initialValue: _initValues['bookDepartment'],
                                  controller: bookDepartment,
                                  focusNode: _bookDepartmentNode,
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
                                    hintText: "Department",
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              Color.fromARGB(255, 73, 128, 255),
                                          width: 2.0),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.grey, width: 2.5),
                                    ),
                                  ),
                                  onFieldSubmitted: (_) {
                                    FocusScope.of(context)
                                        .requestFocus(_bookPublicationNode);
                                  },
                                  onSaved: (value) {
                                    book = BookDetails(
                                        bookName: book.bookName,
                                        bookAuthor: book.bookAuthor,
                                        bookDepartment: value.toString().trim(),
                                        bookPages: book.bookPages,
                                        bookPic: book.bookPic,
                                        bookPublication: book.bookPublication,
                                        isbnNumber: book.isbnNumber,
                                        bookQuantity: book.bookQuantity,
                                        bookReviews: book.bookReviews,
                                        bookReviewedUsers:
                                            book.bookReviewedUsers);
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: TextFormField(
                                  // initialValue: _initValues['bookPublication'],
                                  controller: bookPublication,
                                  focusNode: _bookPublicationNode,
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
                                          width: 2.0),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.grey, width: 2.5),
                                    ),
                                  ),
                                  onFieldSubmitted: (_) {
                                    FocusScope.of(context)
                                        .requestFocus(_bookISBNNode);
                                  },
                                  onSaved: (value) {
                                    book = BookDetails(
                                        bookName: book.bookName,
                                        bookAuthor: book.bookAuthor,
                                        bookDepartment: book.bookDepartment,
                                        bookPages: book.bookPages,
                                        bookPic: book.bookPic,
                                        bookPublication:
                                            value.toString().trim(),
                                        isbnNumber: book.isbnNumber,
                                        bookQuantity: book.bookQuantity,
                                        bookReviews: book.bookReviews,
                                        bookReviewedUsers:
                                            book.bookReviewedUsers);
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: TextFormField(
                                  //  initialValue: _initValues['isbnNumber'],
                                  focusNode: _bookISBNNode,
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
                                    hintText: "ISBN Number",
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              Color.fromARGB(255, 73, 128, 255),
                                          width: 2.0),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.grey, width: 2.5),
                                    ),
                                  ),
                                  onFieldSubmitted: (_) {
                                    FocusScope.of(context)
                                        .requestFocus(_bookQuantityNode);
                                  },
                                  onSaved: (value) {
                                    print(int.parse(value.toString()));
                                    book = BookDetails(
                                        bookName: book.bookName,
                                        bookAuthor: book.bookAuthor,
                                        bookDepartment: book.bookDepartment,
                                        bookPages: book.bookPages,
                                        bookPic: book.bookPic,
                                        bookPublication: book.bookPublication,
                                        isbnNumber: int.parse(value.toString()),
                                        //isbnNumber: int.parse(value!),
                                        bookQuantity: book.bookQuantity,
                                        bookReviews: book.bookReviews,
                                        bookReviewedUsers:
                                            book.bookReviewedUsers);
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: TextFormField(
                                  // initialValue: _initValues['bookQuantity'],
                                  controller: bookQuantity,
                                  focusNode: _bookQuantityNode,
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return "Please enter a valid value";
                                    } else if (int.parse(value) < 1) {
                                      return "Book Quantity can't be negative";
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
                                          width: 2.0),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.grey, width: 2.5),
                                    ),
                                  ),
                                  onSaved: (value) {
                                    book = BookDetails(
                                        bookName: book.bookName,
                                        bookAuthor: book.bookAuthor,
                                        bookDepartment: book.bookDepartment,
                                        bookPages: book.bookPages,
                                        bookPic: book.bookPic,
                                        bookPublication: book.bookPublication,
                                        isbnNumber: book.isbnNumber,
                                        bookQuantity: int.parse(value!),
                                        bookReviews: book.bookReviews,
                                        bookReviewedUsers:
                                            book.bookReviewedUsers);
                                  },
                                ),
                              ),

                              Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  for (int i = 0; i < book.bookPic.length; i++)
                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 12),
                                      child: ListTile(
                                        leading: Image.network(
                                          book.bookPic[i],
                                          fit: BoxFit.cover,
                                        ),
                                        title: Text("Image $i"),
                                        trailing: InkWell(
                                            onTap: () {
                                              setState(() {
                                                book.bookPic.removeAt(i);
                                              });
                                            },
                                            child: const Icon(Icons.delete)),
                                        tileColor: Colors.white,
                                      ),
                                    )
                                ],
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
                                    child: arguments['isInit'] == true
                                        ? Text(
                                            "Save Book Details",
                                            style: GoogleFonts.ubuntu(
                                              fontSize: 25,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                            ),
                                          )
                                        : Text(
                                            "Add Book Details",
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
                    ],
                  ),
                ),
              ),
            ),
          );
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
          bookDepartment.text = bookDepartment.text;

          if (isLoading == true) {
            showDialog(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                  title: Text(
                    'Uploading Image',
                    style: GoogleFonts.ubuntu(fontSize: 25),
                  ),
                  content: Container(
                    child: const CircularProgressIndicator(),
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
          book.bookPic.add(downloadLink);
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
          bookDepartment.text = bookDepartment.text;
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
        bookDepartment.text = bookDepartment.text;

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
