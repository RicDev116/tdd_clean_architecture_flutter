import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'network_info_test.mocks.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:dtt_clean_architecture/core/network/network_info.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';


@GenerateMocks([
  InternetConnectionChecker,
])
void main(){
  late MockInternetConnectionChecker mockDataConnectionChecker;
  late NetworkInfoImpl networkInfoImpl;

  setUp((){
    mockDataConnectionChecker = MockInternetConnectionChecker();
    networkInfoImpl = NetworkInfoImpl(connectionChecker: mockDataConnectionChecker);
  });

  group("isConnected", (){
      test('should forward the call to InternetConnectionChecker.instance.hasConnection', () async {

        final tHasConnectionFuture = Future.value(true);

        // Arrange
        when(mockDataConnectionChecker.hasConnection)
        .thenAnswer((_) => tHasConnectionFuture);
    
        // Act
        final result = networkInfoImpl.isConnected;
    
        // Assert
        verify(mockDataConnectionChecker.hasConnection);
        expect(result, tHasConnectionFuture);
      });
  });
}