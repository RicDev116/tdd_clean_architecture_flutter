import 'package:dartz/dartz.dart';
import 'package:dtt_clean_architecture/core/error/exceptions.dart';
import 'package:dtt_clean_architecture/core/error/failure.dart';
import 'package:dtt_clean_architecture/core/platform/network_info.dart';
import 'package:dtt_clean_architecture/features/number_trivia/data/datasources/number_trivia_local_datasource.dart';
import 'package:dtt_clean_architecture/features/number_trivia/data/datasources/number_trivia_remote_datasource.dart';
import 'package:dtt_clean_architecture/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:dtt_clean_architecture/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:dtt_clean_architecture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'number_trivia_repository_impl_test.mocks.dart';

@GenerateMocks(
  [
    NumberTriviaRemoteDatasource, 
    NumberTriviaLocalDatasource,
    NetworkInfo
  ]
)

void main() {
  late NumberTriviaRepositoryImpl repository;
  late MockNumberTriviaRemoteDatasource mockRemoteDatasource;
  late MockNumberTriviaLocalDatasource mockLocalDatasource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDatasource = MockNumberTriviaRemoteDatasource();
    mockLocalDatasource = MockNumberTriviaLocalDatasource();
    mockNetworkInfo = MockNetworkInfo();
    repository = NumberTriviaRepositoryImpl(
      remoteDataSource: mockRemoteDatasource,
      localDataSource: mockLocalDatasource,
      networkInfo: mockNetworkInfo,
    );
  });

  void runTestsOnline(Function body) {
    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      });

      body();
    });
    
  }

  void runTestsOffline(Function body) {
    group('device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      });

      body();
    });
  }

  group('getConcreteNumberTrivia', (){

    final tNumber = 1;
    final tNumberTriviaModel = NumberTriviaModel(text: 'test trivia', number: tNumber);
    final NumberTrivia tNumberTrivia = tNumberTriviaModel;

    test('should check if the device is online', ()async{

      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteDatasource.getConcreteNumberTrivia(any))
          .thenAnswer((_) async => tNumberTriviaModel);

      // act
      repository.getConcreteNumberTrivia(tNumber);

      // assert
      verify(mockNetworkInfo.isConnected);
    });

    runTestsOnline(
      (){

        setUp(() {
          when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        });

        test('should return remote data when the call to remote data source is succesfull', ()async{

          // arrange
          when(mockRemoteDatasource.getConcreteNumberTrivia(any))
              .thenAnswer((_) async => tNumberTriviaModel);

          // act
          final result = await repository.getConcreteNumberTrivia(tNumber);

          // assert
          verify(mockRemoteDatasource.getConcreteNumberTrivia(tNumber));
          expect(result, equals(Right(tNumberTrivia)));
        });

        test('should chache the  data locally when the call to remote data source is succesfull', ()async{

          // arrange
          when(mockRemoteDatasource.getConcreteNumberTrivia(any))
              .thenAnswer((_) async => tNumberTriviaModel);

          // act
          await repository.getConcreteNumberTrivia(tNumber);

          // assert
          //Verify sirve para verificar que se llamo a un metodo
          verify(mockRemoteDatasource.getConcreteNumberTrivia(tNumber));
          verify(mockLocalDatasource.cacheNumberTrivia(tNumberTriviaModel));
        });

        test('should return server failure when the call to remote data source is unsuccesfull', ()async{

          // arrange
          when(mockRemoteDatasource.getConcreteNumberTrivia(any))
              .thenThrow(ServerException());

          // act
          final result = await repository.getConcreteNumberTrivia(tNumber);

          // assert
          verify(mockRemoteDatasource.getConcreteNumberTrivia(tNumber));
          verifyZeroInteractions(mockLocalDatasource);
          expect(result, equals(left(ServerFailure())));
        });

      }
    );

    runTestsOffline(
      (){

        setUp(() {
          when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
        });

        test('should return last locally cached data when the cached data is present', () async {

          // Arrange
          when(mockLocalDatasource.getLastNumberTrivia())
              .thenAnswer((_) async => tNumberTriviaModel);      

          // Act
          final result = await repository.getConcreteNumberTrivia(tNumber);

          // Assert
          verifyZeroInteractions(mockRemoteDatasource);
          verify(mockLocalDatasource.getLastNumberTrivia());
          expect(result, equals(Right(tNumberTrivia)));
        });

        test('should return cache failure when there is no cached data present', () async {

          // Arrange
          when(mockLocalDatasource.getLastNumberTrivia())
              .thenThrow(CacheException());      

          // Act
          final result = await repository.getConcreteNumberTrivia(tNumber);

          // Assert
          verifyZeroInteractions(mockRemoteDatasource);
          verify(mockLocalDatasource.getLastNumberTrivia());
          expect(result, equals(Left(CacheFailure())));
        });

      }
    );

  });





  group('getRandomTrivia', (){

    final tNumberTriviaModel = NumberTriviaModel(text: 'test trivia', number: 123);
    final NumberTrivia tNumberTrivia = tNumberTriviaModel;

    test('should check if the device is online', ()async{

      // arrange
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);

      when(mockRemoteDatasource.getRandomNumberTrivia())
          .thenAnswer((_) async => tNumberTriviaModel);

      // act
      repository.getRandomNumberTrivia();

      // assert
      verify(mockNetworkInfo.isConnected);
    });

    runTestsOnline(
      (){

        setUp(() {
          when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        });

        test('should return remote data when the call to remote data source is succesfull', ()async{

          // arrange
          when(mockRemoteDatasource.getRandomNumberTrivia())
              .thenAnswer((_) async => tNumberTriviaModel);

          // act
          final result = await repository.getRandomNumberTrivia();

          // assert
          verify(mockRemoteDatasource.getRandomNumberTrivia());
          expect(result, equals(Right(tNumberTrivia)));
        });

        test('should chache the  data locally when the call to remote data source is succesfull', ()async{

          // arrange
          when(mockRemoteDatasource.getRandomNumberTrivia())
              .thenAnswer((_) async => tNumberTriviaModel);

          // act
          await repository.getRandomNumberTrivia();

          // assert
          //Verify sirve para verificar que se llamo a un metodo
          verify(mockRemoteDatasource.getRandomNumberTrivia());
          verify(mockLocalDatasource.cacheNumberTrivia(tNumberTriviaModel));
        });

        test('should return server failure when the call to remote data source is unsuccesfull', ()async{

          // arrange
          when(mockRemoteDatasource.getRandomNumberTrivia())
              .thenThrow(ServerException());

          // act
          final result = await repository.getRandomNumberTrivia();

          // assert
          verify(mockRemoteDatasource.getRandomNumberTrivia());
          verifyZeroInteractions(mockLocalDatasource);
          expect(result, equals(left(ServerFailure())));
        });

      }
    );

    runTestsOffline(
      (){

        setUp(() {
          when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
        });

        test('should return last locally cached data when the cached data is present', () async {

          // Arrange
          when(mockLocalDatasource.getLastNumberTrivia())
              .thenAnswer((_) async => tNumberTriviaModel);      

          // Act
          final result = await repository.getRandomNumberTrivia();

          // Assert
          verifyZeroInteractions(mockRemoteDatasource);
          verify(mockLocalDatasource.getLastNumberTrivia());
          expect(result, equals(Right(tNumberTrivia)));
        });

        test('should return cache failure when there is no cached data present', () async {

          // Arrange
          when(mockLocalDatasource.getLastNumberTrivia())
              .thenThrow(CacheException());      

          // Act
          final result = await repository.getRandomNumberTrivia();

          // Assert
          verifyZeroInteractions(mockRemoteDatasource);
          verify(mockLocalDatasource.getLastNumberTrivia());
          expect(result, equals(Left(CacheFailure())));
        });
        
      }
    );

  });


}