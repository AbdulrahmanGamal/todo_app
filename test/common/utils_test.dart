import 'package:flutter_test/flutter_test.dart';
import 'package:todo_app/common/utils.dart';
import 'package:todo_app/model/validation_text_model.dart';

void main() {
  group('Validation TextFields', () {
    test('Validate if text is Empty', () {
      const textEmpty = '';
   
      final textValidation = Utils.validateEmpty(textEmpty);

      expect(
        textValidation,
        const ValidationText(message: 'Field is empty'),
      );
      expect(textValidation, isA<ValidationText>());
    });

    test('Validate if text is not empty', () {

      const textEmpty = 'Este es mi nombre';


      final textValidation = Utils.validateEmpty(textEmpty);


      expect(
        textValidation,
        const ValidationText(text: textEmpty),
      );
      expect(textValidation, isA<ValidationText>());
    });



    test('Check if ValidationText model can clone the message', () {
      const initialTextValidation = ValidationText(text: '');

      final newTextValidation = Utils.validateEmpty(
        initialTextValidation.text!,
      );

      final cloneTextValidation = initialTextValidation.copyWith(
        message: newTextValidation.message,
      );

      expect(cloneTextValidation, isA<ValidationText>());
      expect(cloneTextValidation.text, isNotNull);
      expect(cloneTextValidation.message, isNotNull);
    });

    test('Check if ValidationText model can clone the text', () {
      const initialTextValidation = ValidationText(text: '', message: '');

      final newTextValidation = Utils.validateEmpty(
        initialTextValidation.text!,
      );

      final cloneTextValidation = initialTextValidation.copyWith(
        text: newTextValidation.text,
      );

      expect(cloneTextValidation, isA<ValidationText>());
      expect(cloneTextValidation.text, isNotNull);
      expect(cloneTextValidation.message, isNotNull);
    });
  });
}
