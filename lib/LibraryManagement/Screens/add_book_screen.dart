import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uni_campus/LibraryManagement/MethodAssistant/add_book.dart';
import 'package:uni_campus/LibraryManagement/MethodAssistant/fetch_books.dart';

class AddBookScreen extends StatefulWidget {
  const AddBookScreen({Key? key}) : super(key: key);

  @override
  _AddBookScreenState createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  @override
  Widget build(BuildContext context) {
    final TextEditingController name = TextEditingController();
    final TextEditingController author = TextEditingController();
    final TextEditingController department = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text("Add Book")),
      body: Form(
        child: ListView(
          children: [
            TextFormField(
              controller: name,
              decoration: const InputDecoration(hintText: "Book Name"),
            ),
            TextFormField(
              controller: author,
              decoration: const InputDecoration(hintText: "Book author"),
            ),
            TextFormField(
              controller: department,
              decoration: const InputDecoration(hintText: "department"),
            ),
            TextButton(
              onPressed: () async {
                print("iske baad");
                print(await fetchBooks());
                if (name.text.isEmpty) {
                  Fluttertoast.showToast(msg: "Enter Book name");
                } else if (author.text.isEmpty) {
                  Fluttertoast.showToast(msg: "Enter Book Author");
                } else if (department.text.isEmpty) {
                  Fluttertoast.showToast(msg: "Enter Department");
                } else {
                  await addBook(name.text, author.text, department.text)
                      .then((value) => Fluttertoast.showToast(msg: "Added"));
                }
                print(fetchBooks());
              },
              child: const Text("Add"),
            ),
          ],
        ),
      ),
    );
  }
}
