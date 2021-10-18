import 'dart:math';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/bssiness_logic/cubit/characters_cubit.dart';
import 'package:movies/constants/my_colors.dart';
import 'package:movies/data/models/characters.dart';

class CharactersDetailsScreen extends StatelessWidget {
  final Character character;

  const CharactersDetailsScreen({Key? key, required this.character})
      : super(key: key);
  //const CharactersDetailsScreen({Key? key}) : super(key: key);
  Widget checkIfQuotesAreLoaded(CharactersState state) {
    if (state is QuotesLoaded) {
      return displayRandomQuotesOrEmptySpace(state);
    } else {
      return showProgressIndicator();
    }
  }

  Widget showProgressIndicator() {
    return Center(
      child: CircularProgressIndicator(
        color: MyColors.myYellow,
      ),
    );
  }

  Widget displayRandomQuotesOrEmptySpace(state) {
    var quotes = (state).quotes;
    if (quotes.length != 0) {
      int randomQuotesIndex = Random().nextInt(quotes.length - 1);
      return Center(
        child: DefaultTextStyle(
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20, color: MyColors.myWhite, shadows: [
            Shadow(
                blurRadius: 7, color: MyColors.myYellow, offset: Offset(0, 0))
          ]),
          child: AnimatedTextKit(
            repeatForever: true,
            animatedTexts: [
              FlickerAnimatedText(quotes[randomQuotesIndex].quote)
            ],
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  Widget buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 600,
      pinned: true,
      stretch: true,
      backgroundColor: MyColors.myGrey,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          character.nickName,
          style: TextStyle(color: MyColors.myWhite),
        ),
        centerTitle: true,
        background: Hero(
          tag: character.charId,
          child: Image.network(
            character.image,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget characterInfo(String title, String value) {
    return RichText(
      text: TextSpan(children: [
        TextSpan(
            text: title,
            style: TextStyle(
                color: MyColors.myWhite,
                fontWeight: FontWeight.bold,
                fontSize: 18)),
        TextSpan(
            text: value,
            style: TextStyle(color: MyColors.myWhite, fontSize: 16)),
      ]),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget buildDivider(double endIndent) {
    return Divider(
      color: MyColors.myYellow,
      endIndent: endIndent,
      height: 30,
      thickness: 2,
    );
  }

  @override
  Widget build(BuildContext context) {
    BlocProvider.of<CharactersCubit>(context).getAllQoutes(character.name);
    return Scaffold(
      backgroundColor: MyColors.myGrey,
      body: CustomScrollView(
        slivers: [
          buildSliverAppBar(),
          SliverList(
              delegate: SliverChildListDelegate([
            Container(
              margin: EdgeInsets.fromLTRB(14, 14, 14, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  characterInfo('Job : ', character.jobs.join('/')),
                  buildDivider(330),
                  characterInfo('Appeared In : ', character.category),
                  buildDivider(275),
                  characterInfo('Seasons : ', character.appearance.join('/')),
                  buildDivider(290),
                  characterInfo('Status : ', character.status),
                  buildDivider(300),
                  character.betterCallSaulAppearance.isEmpty
                      ? Container()
                      : characterInfo('Better Call Saul : ',
                          character.betterCallSaulAppearance.join('/')),
                  character.betterCallSaulAppearance.isEmpty
                      ? Container()
                      : buildDivider(150),
                  characterInfo('Actor/Actress : ', character.actorName),
                  buildDivider(235),
                  SizedBox(
                    height: 20,
                  ),
                  BlocBuilder<CharactersCubit, CharactersState>(
                      builder: (context, state) {
                    return checkIfQuotesAreLoaded(state);
                  })
                ],
              ),
            ),
            SizedBox(
              height: 500,
            ),
          ]))
        ],
      ),
    );
  }
}
