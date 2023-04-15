import 'package:flashcards_app/home_search_sets/search_flashcard_sets_result_page.dart';
import 'package:flutter/material.dart';

import '../auth/auth_cubit.dart';
import '../data/data_models/flashcard_set.dart';
import '../data/repository/data_repository.dart';

class SearchFlashcardSetsPage extends StatefulWidget {
  const SearchFlashcardSetsPage({
    Key? key,
    required this.state,
    required this.context,
  }) : super(key: key);

  final SignedInState state;

  final BuildContext context;

  @override
  State<SearchFlashcardSetsPage> createState() =>
      _SearchFlashcardSetsPageState();
}

class _SearchFlashcardSetsPageState extends State<SearchFlashcardSetsPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          const Text(
            'Search for flashcard sets',
            style: TextStyle(color: Colors.grey),
          ),
          IconButton(
            iconSize: 40,
            color: Colors.grey,
            onPressed: () {
              showSearch(
                  context: context,
                  delegate: MySearchDelegate(state: widget.state));
            },
            icon: const Icon(Icons.search),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

class MySearchDelegate extends SearchDelegate {
  SignedInState state;
  List<FlashcardSet> searchResults = [];

  MySearchDelegate({required this.state}) {
    var res = DataRepository().getStream();
    List<FlashcardSet> helperList = [];
    res.forEach((element) {
      for (var document in element.docs) {
        var fset = FlashcardSet.fromSnapshot(document);
        helperList.add(fset);
      }
      for (var item in helperList) {
        if (!item.isPrivate && item.authorsEmail != state.email) {
          searchResults.add(item);
        }
      }
    });
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            if (query.isEmpty) {
              close(context, null);
            } else {
              query = '';
            }
          },
          icon: const Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<FlashcardSet> results = [];

    for (var element in searchResults) {
      final result = element.foldersName;
      final input = query.toLowerCase();

      if (result.contains(input)) {
        results.add(element);
      }
    }

    return SearchFlashcardSetsResultPage(
      query: query,
      flashcardSets: results,
      state: state,
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> suggestions = [];

    for (var element in searchResults) {
      final result = element.foldersName;
      final input = query.toLowerCase();

      if (result.contains(input)) {
        suggestions.add(result);
      }
    }

    return ListView.builder(
        itemCount: suggestions.length,
        itemBuilder: ((context, index) {
          final suggestion = suggestions[index];
          return ListTile(
              title: Text(suggestion),
              onTap: () {
                query = suggestion;
                showResults(context);
              });
        }));
  }
}
