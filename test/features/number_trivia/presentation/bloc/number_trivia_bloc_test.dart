
import 'package:dartz/dartz.dart';
import 'package:dtt_clean_architecture/core/presentation/util/input_converter.dart';
import 'package:dtt_clean_architecture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:dtt_clean_architecture/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:dtt_clean_architecture/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:dtt_clean_architecture/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'number_trivia_bloc_test.mocks.dart';

@GenerateMocks([
  GetConcreteNumberTrivia,
  GetRandomNumberTrivia,
  InputConverter
])

void main(){
  late NumberTriviaBloc bloc;
  late MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  late MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  late MockInputConverter mockInputConverter;

  setUp((){
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockInputConverter = MockInputConverter();

    bloc = NumberTriviaBloc(
      concrete: mockGetConcreteNumberTrivia, 
      random: mockGetRandomNumberTrivia, 
      converter: mockInputConverter
    );
  });

  test('initialState should be Empty', () async {
    // Assert
    expect(bloc.state, equals(Empty()));
  });


  group('GetTriviaForConcreteNumber', (){
    final tNumberString = '1';
    final tNumberParse = 1;
    final tNumberTrivia = NumberTrivia(text: 'Text Trivia', number: 1);

    test('should call the InputConverter to validate and convert the string to an unsigned integer', () async {
      // Arrange
      when(mockInputConverter.stringToUnsignedInteger(any))
      .thenReturn(Right(tNumberParse));

      // Act
      bloc.add(GetTriviaForConcreteNumber(numberString: tNumberString));

      //toma un tiempo llamar esta linea a pesar de que es sincrona
      //por eso usamos untilCalled, para esperar a que responda y asi verificar que se llamo
      //en el verify
      await untilCalled(mockInputConverter.stringToUnsignedInteger(tNumberString));
      // Assert
      verify(mockInputConverter.stringToUnsignedInteger(tNumberString));
    });

    test( 'Should emit [Error] when the input is invalid',
      () async {

        // Arrange
        when(mockInputConverter.stringToUnsignedInteger(any))
            .thenReturn(Left(InvalidInputFailure()));

        final expected = [
          Error(errorMessage: INVALID_INPUT_FAILURE_MESSAGE)
        ];

        // Act
        bloc.add(GetTriviaForConcreteNumber(numberString: tNumberString));

        // Assert
        await expectLater(bloc.stream, emitsInOrder(expected));
      },
    );
  
  });

}