import 'package:dtt_clean_architecture/core/platform/network_info.dart';
import 'package:dtt_clean_architecture/features/number_trivia/data/datasources/number_trivia_local_datasource.dart';
import 'package:dtt_clean_architecture/features/number_trivia/data/datasources/number_trivia_remote_datasource.dart';
import 'package:dtt_clean_architecture/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';

import 'number_trivia_repository_impl_test.mocks.dart';

@GenerateMocks(
  [
    NumberTriviaRemoteDatasource, 
    NumberTriviaLocalDatasource,
    NetworkInfo
  ]
)

void main() {
  NumberTriviaRepositoryImpl repository;
  MockNumberTriviaRemoteDatasource mockRemoteDatasource;
  MockNumberTriviaLocalDatasource mockLocalDatasource;
  MockNetworkInfo mockNetworkInfo;

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
}