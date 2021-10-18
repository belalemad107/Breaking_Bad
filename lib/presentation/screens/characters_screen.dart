import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:movies/bssiness_logic/cubit/characters_cubit.dart';
import 'package:movies/constants/my_colors.dart';
import 'package:movies/data/models/characters.dart';
import 'package:movies/presentation/widgets/characters_item.dart';

class Characters_screen extends StatefulWidget {
  @override
  State<Characters_screen> createState() => _Characters_screenState();
}

class _Characters_screenState extends State<Characters_screen> {
  late List<Character> allCharacters;
  late List<Character> searchForCharacters;
  bool isSearching = false;
  final searchTextController = TextEditingController();
  Widget buildSearchField() {
    return TextField(
      style: TextStyle(color: MyColors.myGrey, fontSize: 18),
      controller: searchTextController,
      cursorColor: MyColors.myGrey,
      decoration: InputDecoration(
        border: InputBorder.none,
        hintText: 'Find a charachter',
        hintStyle: TextStyle(color: MyColors.myGrey, fontSize: 18),
      ),
      onChanged: (searchedCharacter) {
        addSearchedForItemsToSearchedList(searchedCharacter);
      },
    );
  }

  void addSearchedForItemsToSearchedList(String searchedCharacter) {
    searchForCharacters = allCharacters
        .where((character) =>
            character.name.toLowerCase().startsWith(searchedCharacter))
        .toList();
    setState(() {});
  }

  List<Widget> buildAppBarActions() {
    if (isSearching) {
      return [
        IconButton(
          onPressed: () {
            clearSearch();
            Navigator.pop(context);
          },
          icon: Icon(Icons.clear),
          color: MyColors.myGrey,
        )
      ];
    } else {
      return [
        IconButton(
          onPressed: startSearch,
          icon: Icon(Icons.search),
          color: MyColors.myGrey,
        )
      ];
    }
  }

  void startSearch() {
    ModalRoute.of(context)!
        .addLocalHistoryEntry(LocalHistoryEntry(onRemove: stopSearch));
    setState(() {
      isSearching = true;
    });
  }

  void stopSearch() {
    clearSearch();
    setState(() {
      isSearching = false;
    });
  }

  void clearSearch() {
    searchTextController.clear();
  }

  @override
  void initState() {
    super.initState();
    BlocProvider.of<CharactersCubit>(context).getAllCharacters();
  }

  Widget buildBlocWidget() {
    return BlocBuilder<CharactersCubit, CharactersState>(
        builder: (context, state) {
      if (state is CharactersLoaded) {
        allCharacters = (state).characters;
        return buildLoadedListWidget();
      } else {
        return showLoadingIndicator();
      }
    });
  }

  Widget showLoadingIndicator() {
    return Center(
      child: CircularProgressIndicator(
        color: MyColors.myYellow,
      ),
    );
  }

  Widget buildLoadedListWidget() {
    return SingleChildScrollView(
      child: Container(
        color: MyColors.myGrey,
        child: Column(
          children: [buildCharactersList()],
        ),
      ),
    );
  }

  Widget buildNoInternetWidget() {
    return Center(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 20,
            ),
            Text(
              'Can\'t connect .. check internet',
              style: TextStyle(fontSize: 22, color: MyColors.myGrey),
            ),
            Image.asset('assets/images/offline.png'),
          ],
        ),
        color: MyColors.myWhite,
      ),
    );
  }

  Widget buildCharactersList() {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 2 / 3,
          crossAxisSpacing: 1,
          mainAxisSpacing: 1),
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const ClampingScrollPhysics(),
      itemBuilder: (context, index) {
        return CharacterItem(
          character: searchTextController.text.isEmpty
              ? allCharacters[index]
              : searchForCharacters[index],
        );
      },
      itemCount: searchTextController.text.isEmpty
          ? allCharacters.length
          : searchForCharacters.length,
    );
  }

  Widget buildAppBarTitle() {
    return Text(
      'Characters',
      style: TextStyle(
        color: MyColors.myGrey,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: MyColors.myYellow,
          title: isSearching ? buildSearchField() : buildAppBarTitle(),
          actions: buildAppBarActions(),
          leading: isSearching
              ? BackButton(
                  color: MyColors.myGrey,
                )
              : Container(),
        ),
        body: OfflineBuilder(
            child: showLoadingIndicator(),
            connectivityBuilder: (
              BuildContext context,
              ConnectivityResult connectivity,
              Widget child,
            ) {
              final bool connected = connectivity != ConnectivityResult.none;
              if (connected) {
                return buildBlocWidget();
              } else {
                return buildNoInternetWidget();
              }
            }));
  }
}
