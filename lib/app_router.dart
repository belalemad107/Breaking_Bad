import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movies/bssiness_logic/cubit/characters_cubit.dart';
import 'package:movies/constants/strings.dart';
import 'package:movies/data/models/characters.dart';
import 'package:movies/data/repositories/characters_repository.dart';
import 'package:movies/data/web_services/characters_web_services.dart';
import 'package:movies/presentation/screens/characters_deatails.dart';
import 'package:movies/presentation/screens/characters_screen.dart';

class AppRouter {
  late CharactersRepository charactersRepository;
  late CharactersCubit charactersCubit;
  AppRouter() {
    charactersRepository = CharactersRepository(CharactersWebServices());
    charactersCubit = CharactersCubit(charactersRepository);
  }
  Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                  create: (BuildContext context) => charactersCubit,
                  child: Characters_screen(),
                ));
      case charactersScreenDetails:
        final character = settings.arguments as Character;
        return MaterialPageRoute(
            builder: (_) => BlocProvider(
                  create: (context) => CharactersCubit(charactersRepository),
                  child: CharactersDetailsScreen(character: character),
                ));
    }
  }
}
