
import 'package:todo_app/model/validation_text_model.dart';

class Utils {
  static ValidationText validateEmpty(String value) => value.isNotEmpty
      ? ValidationText(text: value)
      : const ValidationText(message: 'This filed is empty');
}
