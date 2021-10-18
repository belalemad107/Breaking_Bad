import 'package:movies/data/models/characters.dart';
import 'package:movies/data/models/quote.dart';
import 'package:movies/data/web_services/characters_web_services.dart';

class CharactersRepository {
  final CharactersWebServices charactersWebServices;
  CharactersRepository(
    this.charactersWebServices,
  );
  Future<List<Character>> getAllCharacters() async {
    final characters = await charactersWebServices.getAllCharacters();
    return characters
        .map((character) => Character.fromJson(character))
        .toList();
  }

  Future<List<Quote>> getAllQuotes(String charName) async {
    final quotes = await charactersWebServices.getAllQuotes(charName);
    return quotes.map((charQuotes) => Quote.fromJson(charQuotes)).toList();
  }
}
