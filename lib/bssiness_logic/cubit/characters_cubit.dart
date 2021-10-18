import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:movies/data/models/characters.dart';
import 'package:movies/data/models/quote.dart';
import 'package:movies/data/repositories/characters_repository.dart';

part 'characters_state.dart';

class CharactersCubit extends Cubit<CharactersState> {
  final CharactersRepository characterRepository;
  List<Character> characters = [];
  CharactersCubit(this.characterRepository) : super(CharactersInitial());
  List<Character> getAllCharacters() {
    characterRepository.getAllCharacters().then((characters) {
      emit(
        CharactersLoaded(characters),
      );
      this.characters = characters;
    });
    return characters;
  }

  void getAllQoutes(String charName) {
    characterRepository.getAllQuotes(charName).then((quotes) {
      emit(
        QuotesLoaded(quotes),
      );
    });
  }
}
