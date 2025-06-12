import 'dart:convert';

import 'package:dtt_clean_architecture/core/error/exceptions.dart';
import 'package:dtt_clean_architecture/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';

import 'package:dtt_clean_architecture/features/number_trivia/data/datasources/number_trivia_remote_datasource.dart';
import 'package:mockito/mockito.dart';
import '../../../../fixtures/fixture_reader.dart';
import 'nuber_trivia_remote_datasource_test.mocks.dart';



@GenerateMocks(
  [
    NumberTriviaRemoteDataSourceImpl,
    http.Client
  ]
)

void main(){

  late NumberTriviaRemoteDataSourceImpl dataSource;
  late MockClient mockHttpClient;

  setUp((){
    mockHttpClient = MockClient();
    dataSource = NumberTriviaRemoteDataSourceImpl(client:mockHttpClient);
  });

  void setUpHttpClientSuccess200(){
    //No importa que headers ni que url me mandes, siempre responde igual
    when(mockHttpClient.get(any,headers: anyNamed('headers')))
    .thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));
  }

  void setUpHttpClientFailure404(){
    when(mockHttpClient.get(any,headers: anyNamed('headers')))
    .thenAnswer((_) async => http.Response('Something whent wrong',404));
  }

  group('getConcreteNumberTrivia', (){

    final tNumber = 1;
    final tNumberTriviaModel = NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));

      test(
        '''
          should perform a GET request on a URL with number being the 
          endpoint and with application/json header
        ''', 
        () async {

          // Arrange
          setUpHttpClientSuccess200();

          // Act
          dataSource.getConcreteNumberTrivia(tNumber);
      
          // Assert
          // Si me importa que mandes a llamar con la url correcta y con los headers correctos
          verify(mockHttpClient.get(
            Uri.parse('http://numbersapi.com/$tNumber'),
            headers: {
              'Content-Type':'application/json'
            }
          ));

        }
      );


        test(
          'should return numberTrivia when the response code is 200', 
          () async {
            // Arrange
            setUpHttpClientSuccess200();
      
            // Act
            final result = await dataSource.getConcreteNumberTrivia(tNumber);
        
            // Assert
            expect(result, equals(tNumberTriviaModel));
        });


          test('should throw a ServerException when the response code is 404 or other', () async {
            // Arrange
            setUpHttpClientFailure404();
        
            // Act
            final call = dataSource.getConcreteNumberTrivia;
        
            // Assert
            expect(() => call(tNumber), throwsA(TypeMatcher<ServerException>()));
          });
    
  });



  group('getRandomNumberTrivia', (){

    final tNumberTriviaModel = NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));

      test(
        '''
          should perform a GET request on a URL with number being the 
          endpoint and with application/json header
        ''', 
        () async {

          // Arrange
          setUpHttpClientSuccess200();

          // Act
          dataSource.getRandomNumberTrivia();
      
          // Assert
          // Si me importa que mandes a llamar con la url correcta y con los headers correctos
          verify(mockHttpClient.get(
            Uri.parse('http://numbersapi.com/random'),
            headers: {
              'Content-Type':'application/json'
            }
          ));

        }
      );


        test(
          'should return numberTrivia when the response code is 200', 
          () async {
            // Arrange
            setUpHttpClientSuccess200();
      
            // Act
            final result = await dataSource.getRandomNumberTrivia();
        
            // Assert
            expect(result, equals(tNumberTriviaModel));
        });


          test('should throw a ServerException when the response code is 404 or other', () async {
            // Arrange
            setUpHttpClientFailure404();
        
            // Act
            final call = dataSource.getRandomNumberTrivia;
        
            // Assert
            expect(() => call(), throwsA(TypeMatcher<ServerException>()));
          });
    
  });



  

}