import 'package:flashcards_app/auth/auth_cubit.dart';
import 'package:flashcards_app/data/data_models/flashcard_set.dart';
import 'package:flashcards_app/data/repository/data_repository.dart';
import 'package:flutter/material.dart';

import '../data/data_models/flashcard.dart';
import 'form_submitted.dart';

FlashcardSet model =
    FlashcardSet(flashcards: [], authorsEmail: '', foldersName: '');

class FlashcardSetForm extends StatefulWidget {
  FlashcardSetForm({super.key, required this.state});

  final SignedInState state;
  final DataRepository repository = DataRepository();

  @override
  State<FlashcardSetForm> createState() => _FlashcardSetFormState();
}

class _FlashcardSetFormState extends State<FlashcardSetForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<Widget> listOfFlashcardFields = <Widget>[];
  List<TextEditingController> nativeWordControllers = <TextEditingController>[];
  List<TextEditingController> foreignWordControllers =
      <TextEditingController>[];

  TextEditingController foldersNameController = TextEditingController();

  void initialiseData() {
    model = FlashcardSet(flashcards: [], authorsEmail: '', foldersName: '');

    nativeWordControllers = <TextEditingController>[
      TextEditingController(),
      TextEditingController(),
    ];

    foreignWordControllers = <TextEditingController>[
      TextEditingController(),
      TextEditingController(),
    ];

    foldersNameController = TextEditingController();

    listOfFlashcardFields = <Widget>[
      // =============================== FLASHCARD 1 ================================== //
      Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        child: Column(
          children: [
            // ========= NATIVE WORD ============= //
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: nativeWordControllers.elementAt(0),
                decoration: const InputDecoration(
                    hintText: "native word",
                    hintStyle: TextStyle(color: Colors.grey)),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                onSaved: (String? value) {
                  if (model.flashcards.length <= 0) {
                    model.flashcards.add(Flashcard(
                        native: nativeWordControllers.elementAt(0).text,
                        //native: value ?? '',
                        foreign: '',
                        flashcardID: 0));
                  } else {
                    //model.flashcards[index].native = value ?? '';
                    model.flashcards[0].native =
                        nativeWordControllers.elementAt(0).text;
                  }
                },
              ),
            ),
            // ========= FOREIGN WORD ============= //
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: foreignWordControllers.elementAt(0),
                decoration: const InputDecoration(
                    hintText: "translated word",
                    hintStyle: TextStyle(color: Colors.grey)),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                onSaved: (String? value) {
                  if (model.flashcards.length <= 0) {
                    model.flashcards.add(Flashcard(
                        foreign: foreignWordControllers.elementAt(0).text,
                        // foreign: value ?? '',
                        native: '',
                        flashcardID: 0));
                  } else {
                    model.flashcards[0].foreign =
                        foreignWordControllers.elementAt(0).text;
                    //model.flashcards[index].foreign = value ?? '';
                  }
                },
              ),
            ),
          ],
        ),
      ),
      // =============================== FLASHCARD 2 ================================== //
      Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: nativeWordControllers.elementAt(1),
                decoration: const InputDecoration(
                    hintText: "native word",
                    hintStyle: TextStyle(color: Colors.grey)),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                onSaved: (String? value) {
                  if (model.flashcards.length <= 1) {
                    model.flashcards.add(Flashcard(
                        native: nativeWordControllers.elementAt(1).text,
                        foreign: '',
                        flashcardID: 1));
                  } else {
                    model.flashcards[1].native =
                        nativeWordControllers.elementAt(1).text;
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: foreignWordControllers.elementAt(1),
                decoration: const InputDecoration(
                    hintText: "translated word",
                    hintStyle: TextStyle(color: Colors.grey)),
                validator: (String? value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
                onSaved: (String? value) {
                  if (model.flashcards.length <= 1) {
                    model.flashcards.add(Flashcard(
                        foreign: foreignWordControllers.elementAt(1).text,
                        // foreign: value ?? '',
                        native: '',
                        flashcardID: 1));
                  } else {
                    model.flashcards[1].foreign =
                        foreignWordControllers.elementAt(1).text;
                    //model.flashcards[index].foreign = value ?? '';
                  }
                },
              ),
            ),
          ],
        ),
      ),
    ];
  }

  @override
  void initState() {
    super.initState();
    initialiseData();
  }

  @override
  void dispose() {
    super.dispose();

    for (var item in nativeWordControllers) {
      item.dispose();
    }
    for (var item in foreignWordControllers) {
      item.dispose();
    }
    foldersNameController.dispose();

    listOfFlashcardFields.clear();
  }

  @override
  Widget build(BuildContext context) {
    FocusManager.instance.primaryFocus?.unfocus();

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Form(
        key: _formKey,
        child: Scaffold(
          backgroundColor: Colors.grey.shade300,
          body: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: foldersNameController,
                    decoration: const InputDecoration(
                      hintText: "Folder name",
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                    onSaved: (String? value) {
                      model.authorsEmail = widget.state.email;
                      model.foldersName = foldersNameController.text;
                    },
                  ),
                ),
                ...listOfFlashcardFields,
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Align(
                    alignment: Alignment.center,
                    child: FloatingActionButton(
                        onPressed: () {
                          setState(() {
                            int currentIndex = listOfFlashcardFields.length;

                            nativeWordControllers.add(TextEditingController());
                            foreignWordControllers.add(TextEditingController());

                            listOfFlashcardFields.add(Card(
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4)),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextFormField(
                                      controller: nativeWordControllers
                                          .elementAt(currentIndex),
                                      decoration: const InputDecoration(
                                          hintText: "native word",
                                          hintStyle:
                                              TextStyle(color: Colors.grey)),
                                      validator: (String? value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter some text';
                                        }
                                        return null;
                                      },
                                      onSaved: (String? value) {
                                        if (model.flashcards.length <=
                                            currentIndex) {
                                          model.flashcards.add(Flashcard(
                                              native: nativeWordControllers
                                                  .elementAt(currentIndex)
                                                  .text,
                                              foreign: '',
                                              flashcardID: currentIndex));
                                        } else {
                                          model.flashcards[currentIndex]
                                                  .native =
                                              nativeWordControllers
                                                  .elementAt(currentIndex)
                                                  .text;
                                        }
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: TextFormField(
                                      controller: foreignWordControllers
                                          .elementAt(currentIndex),
                                      decoration: const InputDecoration(
                                          hintText: "translated word",
                                          hintStyle:
                                              TextStyle(color: Colors.grey)),
                                      validator: (String? value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please enter some text';
                                        }
                                        return null;
                                      },
                                      onSaved: (String? value) {
                                        if (model.flashcards.length <=
                                            currentIndex) {
                                          model.flashcards.add(Flashcard(
                                              flashcardID: currentIndex,
                                              foreign: foreignWordControllers
                                                  .elementAt(currentIndex)
                                                  .text,
                                              native: ''));
                                        } else {
                                          model.flashcards[currentIndex]
                                                  .foreign =
                                              foreignWordControllers
                                                  .elementAt(currentIndex)
                                                  .text;
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ));
                          });
                        },
                        child: const Icon(Icons.add)),
                  ),
                ),
                SizedBox(
                  width: double.infinity,
                  height: 70,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    child: ElevatedButton(
                      style: ButtonStyle(
                        elevation: MaterialStateProperty.all(8),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      onPressed: () {
                        String name = foldersNameController.text;

                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState?.save();

                          widget.repository.addFlashcardSet(model);

                          setState(() {
                            foldersNameController.clear();

                            for (var item in nativeWordControllers) {
                              item.clear();
                              item.dispose();
                            }
                            for (var item in foreignWordControllers) {
                              item.clear();
                              item.dispose();
                            }
                            initialiseData();
                          });

                          Navigator.of(context)
                              .push(
                            MaterialPageRoute(
                              builder: ((context) =>
                                  FlashcardSetFormSubmittedPage(
                                    state: widget.state,
                                    flashcardSetName: name,
                                  )),
                            ),
                          )
                              .then((_) {
                            _formKey.currentState!.reset();
                          });
                        }
                      },
                      child: const Text(
                        'Save',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
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
}
