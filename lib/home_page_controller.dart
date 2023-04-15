import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flashcards_app/auth/auth_cubit.dart';
import 'package:flashcards_app/home_add_new_set/create_flashcard_set_form.dart';
import 'package:flashcards_app/home_all_created_sets/flashcard_sets_page.dart';
import 'package:flashcards_app/data/repository/data_repository.dart';
import 'package:flashcards_app/home_search_sets/search_flashcard_sets_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeController extends StatefulWidget {
  HomeController({
    Key? key,
    required this.state,
  }) : super(key: key);

  final SignedInState state;
  final DataRepository repository = DataRepository();

  @override
  State<HomeController> createState() => _HomeControllerState();
}

class _HomeControllerState extends State<HomeController> {
  int _selectedIndex = 0;
  PageController pageController = PageController();

  void onTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flashcards App'),
        backgroundColor: Colors.indigo,
        actions: [
          IconButton(
              onPressed: context.read<AuthCubit>().signOut,
              icon: const Icon(Icons.logout_rounded, color: Colors.white))
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: widget.repository.getStreamForUser(widget.state.email),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const LinearProgressIndicator();
          return PageView(
            onPageChanged: onTapped,
            controller: pageController,
            children: [
              FlashcardSetsPage(
                  state: widget.state,
                  snapshot: snapshot.data?.docs ?? [],
                  context: context),
              SearchFlashcardSetsPage(
                state: widget.state,
                context: context,
              ),
              FlashcardSetForm(state: widget.state),
              Container(
                color: Colors.grey,
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Add'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.indigo,
        unselectedItemColor: Colors.grey,
        onTap: onTapped,
      ),
    );
  }
}
