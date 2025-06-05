import 'package:dtt_clean_architecture/features/number_trivia/data/models/number_trivia_model.dart';

abstract class NumberTriviaLocalDatasource {
  
  /// Gets the cached [NumberTriviaModel] which was previously stored.
  ///Throws a [NoLocalDataException] if no cached data is present.
  Future<NumberTriviaModel> getLastNumberTrivia();

  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache);
}