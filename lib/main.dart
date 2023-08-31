import 'package:flutter/material.dart';
import 'package:sqlite/localDb.dart';
import 'package:sqlite/update.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController fullname = TextEditingController();
  List? _dataBase;

  @override
  void initState() {
    _loadDB();
    super.initState();
  }

  _loadDB() async {
    _dataBase = await LocalDatabase().readAllData();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return (_dataBase == null)
        ? Container(
            color: Colors.white,
            child: const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Colors.blue),
              backgroundColor: Colors.white,
              strokeWidth: 10,
            ),
          )
        : Scaffold(
            floatingActionButton: FloatingActionButton(
              onPressed: () async {
                _loadDB();
              },
              child: const Icon(Icons.refresh),
            ),
            body: SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextFormField(
                        controller: fullname,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          fillColor: Colors.white,
                          filled: true,
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 10.0),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.0),
                              borderSide: const BorderSide(
                                color: Color(0xffe4e4e4),
                              )),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.0),
                            borderSide: const BorderSide(
                              color: Color(0xffe4e4e4),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16.0),
                              borderSide: const BorderSide(
                                color: Color(0xffe4e4e4),
                              )),
                          hintText: 'Enter Full Name',
                          hintStyle: const TextStyle(
                            color: Colors.black26,
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: GestureDetector(
                          onTap: () async {
                            await LocalDatabase()
                                .addDataLocally(Name: fullname.text);
                            await LocalDatabase().readAllData();
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 12, top: 12),
                            padding: const EdgeInsets.all(15),
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(18),
                              boxShadow: const [
                                BoxShadow(
                                  blurRadius: 6,
                                  color: Colors.black12,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                            child: const Text(
                              'Save To Database',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                                color: Colors.white,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ),
                        ),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        controller: ScrollController(),
                        itemCount: _dataBase!.length,
                        itemBuilder: (context, idx) {
                          return Container(
                            decoration: const BoxDecoration(
                                border: Border(
                              bottom: BorderSide(color: Color(0xFF7F7F7F)),
                            )),
                            margin: const EdgeInsets.symmetric(horizontal: 20),
                            height: 60,
                            width: double.infinity,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _dataBase![idx]['Name'],
                                  style: TextStyle(fontSize: 30),
                                ),
                                IconButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => UpdateData(
                                            id: _dataBase![idx]['id']),
                                      ),
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.green,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () async {
                                    await LocalDatabase().deleteId(id: _dataBase![idx]['id']);
                                    _loadDB();
                                  },
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
