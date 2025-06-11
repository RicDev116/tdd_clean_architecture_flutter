import 'dart:convert';

import 'package:dtt_clean_architecture/core/error/exceptions.dart';
import 'package:dtt_clean_architecture/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class NumberTriviaLocalDatasource {
  
  /// Gets the cached [NumberTriviaModel] which was previously stored.
  ///Throws a [NoLocalDataException] if no cached data is present.
  Future<NumberTriviaModel> getLastNumberTrivia();

  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache);
}

// ignore: constant_identifier_names
const CACHED_NUMBER_TRIVIA = 'CACHED_NUMBER_TRIVIA';

class NumberTriviaLocalDatasourceImpl implements NumberTriviaLocalDatasource{

  final SharedPreferences sharedPreferences;

  NumberTriviaLocalDatasourceImpl({required this.sharedPreferences});

  @override
  Future<NumberTriviaModel> getLastNumberTrivia() {
    final jsonString = sharedPreferences.getString(CACHED_NUMBER_TRIVIA);
    if(jsonString != null){
      return Future.value(NumberTriviaModel.fromJson(json.decode(jsonString)));
    }else{
      throw CacheException();
    }
  }

  @override
  Future<bool> cacheNumberTrivia(NumberTriviaModel triviaToCache) async{
    return await sharedPreferences.setString(
      CACHED_NUMBER_TRIVIA, 
      json.encode(triviaToCache)
    );
  }

}