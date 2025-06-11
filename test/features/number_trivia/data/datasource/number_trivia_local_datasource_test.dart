import 'dart:convert';

import 'package:dtt_clean_architecture/core/error/exceptions.dart';
import 'package:dtt_clean_architecture/features/number_trivia/data/datasources/number_trivia_local_datasource.dart';
import 'package:dtt_clean_architecture/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../fixtures/fixture_reader.dart';
import 'number_trivia_local_datasource_test.mocks.dart';


@GenerateMocks(
  [
    SharedPreferences
  ]
)

void main(){

  late MockSharedPreferences mockSharedPreferences;
  late NumberTriviaLocalDatasourceImpl datasource;

  setUp((){
    mockSharedPreferences = MockSharedPreferences();
    datasource =  NumberTriviaLocalDatasourceImpl(sharedPreferences: mockSharedPreferences);
  });

  group('getLastNumberTrivia', (){

    final tNumberTriviaModel = NumberTriviaModel.fromJson(json.decode(fixture('trivia_cached.json')));
    test(
      'should return NumberTrivia from SharedPreferences when there is one in the cache',
      ()async{

        //Arrange
        when(mockSharedPreferences.getString(any))
        .thenReturn(fixture('trivia_cached.json'));

        //Act
        final result = await datasource.getLastNumberTrivia(); 

        //Assert
        verify(mockSharedPreferences.getString(CACHED_NUMBER_TRIVIA));
        expect(result, equals(tNumberTriviaModel));
      }
    );

    test(
      'should throw a CacheExeption when there is not a cached value',
      ()async{

        //Arrange
        when(mockSharedPreferences.getString(any))
        .thenReturn(null);

        // Esto ejecuta la excepción antes de que expect pueda capturarla.

        //Act
        // final result = await datasource.getLastNumberTrivia(); 

        //asert
        // expect(result, throwsA(TypeMatcher<CacheException>()));

        // Act & Assert
        expect(
          () async => await datasource.getLastNumberTrivia(),
          throwsA(TypeMatcher<CacheException>())
        );
      }
    );
  });

  group('cacheNumberTrivia', (){
    final tNumberTriviaModel = NumberTriviaModel(number: 1,text: 'Text Trivia');
    test('should call sharedPreferences to cache de data', () async {

      // Assert
      final spectedJsonString = json.encode(tNumberTriviaModel.toJson());
      when(mockSharedPreferences.setString(CACHED_NUMBER_TRIVIA,spectedJsonString))
      .thenAnswer((_) async => true);

      // Act
      datasource.cacheNumberTrivia(tNumberTriviaModel);
  
      // Assert
      verify(mockSharedPreferences.setString(CACHED_NUMBER_TRIVIA, spectedJsonString));
    });

    test('should return true when', () async {

      // Assert
      final spectedJsonString = json.encode(tNumberTriviaModel.toJson());
      when(mockSharedPreferences.setString(CACHED_NUMBER_TRIVIA,spectedJsonString))
      .thenAnswer((_) async => true);

      // Act
      datasource.cacheNumberTrivia(tNumberTriviaModel);
  
      // Assert
      verify(mockSharedPreferences.setString(CACHED_NUMBER_TRIVIA, spectedJsonString));
    });
  });
}