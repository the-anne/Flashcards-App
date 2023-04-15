import 'package:flashcards_app/auth/auth_cubit.dart';
import 'package:flashcards_app/data/data_models/flashcard.dart';
import 'package:flashcards_app/flashcard_set_studying/flashcards_finished_page.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'flashcard_view.dart';

class FlashcardsPage extends StatefulWidget {
  FlashcardsPage(
      {super.key,
      required this.flashcards,
      required this.state,
      required this.folderID}) {
    for (var elem in flashcards) {
      elem.statusOfTheCard = FlashcardStatus.cardNotSeen;
    }
  }

  final SignedInState state;
  final List<Flashcard> flashcards;
  final String? folderID;
  // final DataRepository repository = DataRepository();

  @override
  State<FlashcardsPage> createState() => _FlashcardsPageState();
}

class _FlashcardsPageState extends State<FlashcardsPage> {
  int _currentIndex = 0;
  int _correctFlashcardsCount = 0;
  int _failedFlashcardsCount = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '$_failedFlashcardsCount',
                  style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      fontFamily: "Times New Roman"),
                ),
                Text(
                  '$_correctFlashcardsCount',
                  style: const TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      fontFamily: "Times New Roman"),
                )
              ],
            ),
            const SizedBox(height: 24),
            Draggable(
              childWhenDragging: SizedBox(
                width: 400,
                height: 400,
                child: FlipCard(
                  front: FlashcardView(
                    text: '',
                    folderID: widget.folderID ?? '',
                    flashcardID: _currentIndex,
                    state: widget.state,
                  ),
                  back: FlashcardView(
                    text: '',
                    folderID: widget.folderID ?? '',
                    flashcardID: _currentIndex,
                    state: widget.state,
                  ),
                ),
              ),
              feedback: SizedBox(
                width: 400,
                height: 400,
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.indigo, width: 6)),
                  child: FlipCard(
                    front: FlashcardView(
                      text: widget.flashcards[_currentIndex].native,
                      folderID: widget.folderID ?? '',
                      flashcardID: _currentIndex,
                      state: widget.state,
                    ),
                    back: FlashcardView(
                      text: widget.flashcards[_currentIndex].foreign,
                      folderID: widget.folderID ?? '',
                      flashcardID: _currentIndex,
                      state: widget.state,
                    ),
                  ),
                ),
              ),
              child: SizedBox(
                width: 400,
                height: 400,
                child: FlipCard(
                  front: FlashcardView(
                    text: widget.flashcards[_currentIndex].native,
                    folderID: widget.folderID ?? '',
                    flashcardID: _currentIndex,
                    state: widget.state,
                  ),
                  back: FlashcardView(
                    text: widget.flashcards[_currentIndex].foreign,
                    folderID: widget.folderID ?? '',
                    flashcardID: _currentIndex,
                    state: widget.state,
                  ),
                ),
              ),
              onDragEnd: (details) {
                if (details.offset.dx < 0) {
                  incrementFailedFlashcardsCount();
                } else {
                  incrementCorrectFlashcardsCounter();
                }
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                OutlinedButton.icon(
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.white),
                      elevation: MaterialStateProperty.all(4.0)),
                  onPressed: showPreviousCard,
                  icon: const Icon(
                    Icons.undo,
                    color: Colors.indigo,
                  ),
                  label: const Text('Prev',
                      style: TextStyle(color: Colors.indigo)),
                ),
              ],
            ),
            ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.indigo),
                  elevation: MaterialStateProperty.all(10.0)),
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Exit'),
            ),
          ],
        ),
      ),
    );
  }

  void showNextCard() {
    setState(() {
      if (_currentIndex + 1 < widget.flashcards.length) {
        _currentIndex++;
      } else {
        Route route = MaterialPageRoute(
            builder: (context) => FlashcardsFinishedSessionPage(
                  sessionResult: widget.flashcards,
                  state: widget.state,
                  folderID: widget.folderID,
                ));
        Navigator.pushReplacement(context, route);
      }
    });
  }

  void showPreviousCard() {
    setState(() {
      if (_currentIndex - 1 >= 0) {
        _currentIndex--;
      }
    });
  }

  void incrementCorrectFlashcardsCounter() {
    setState(() {
      widget.flashcards[_currentIndex].statusOfTheCard =
          FlashcardStatus.cardCorrect;
      int count = 0;
      int count2 = 0;
      for (int i = 0; i < widget.flashcards.length; i++) {
        if (widget.flashcards[i].statusOfTheCard ==
            FlashcardStatus.cardCorrect) {
          count++;
        } else if (widget.flashcards[i].statusOfTheCard ==
            FlashcardStatus.cardFailed) {
          count2++;
        }
      }
      _correctFlashcardsCount = count;
      _failedFlashcardsCount = count2;
    });
    showNextCard();
  }

  void incrementFailedFlashcardsCount() {
    setState(() {
      widget.flashcards[_currentIndex].statusOfTheCard =
          FlashcardStatus.cardFailed;
      int count = 0;
      int count2 = 0;
      for (int i = 0; i < widget.flashcards.length; i++) {
        if (widget.flashcards[i].statusOfTheCard ==
            FlashcardStatus.cardFailed) {
          count++;
        } else if (widget.flashcards[i].statusOfTheCard ==
            FlashcardStatus.cardCorrect) {
          count2++;
        }
      }
      _failedFlashcardsCount = count;
      _correctFlashcardsCount = count2;
    });
    showNextCard();
  }
}
