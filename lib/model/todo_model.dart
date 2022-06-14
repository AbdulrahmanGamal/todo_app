import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:todo_app/common/extension.dart';

part 'todo_model.g.dart';

@JsonSerializable()
class Todo extends Equatable {
  const Todo({
    this.id,
    required this.subject,
    required this.finalDate,
    this.isCompleted = false,
  });

  factory Todo.fromJson(Map<String, dynamic> json) => _$TodoFromJson(json);

  @JsonKey(includeIfNull: false)
  final String? id;

  final String subject;

  @JsonKey(fromJson: _intFromJson, toJson: _intToJson)
  final DateTime finalDate;

  final bool isCompleted;

  Map<String, dynamic> toJson() => _$TodoToJson(this);

  Todo copyWith({
    String? id,
    String? subject,
    DateTime? finalDate,
    bool? isCompleted,
  }) =>
      Todo(
        id: id ?? this.id,
        subject: subject ?? this.subject,
        finalDate: finalDate ?? this.finalDate,
        isCompleted: isCompleted ?? this.isCompleted,
      );

  @override
  List<Object?> get props => [id, subject, finalDate, isCompleted];

  static DateTime _intFromJson(int milliseconds) =>
      milliseconds.millisecondsToDate;

  static int _intToJson(DateTime finalDate) => finalDate.millisecondsSinceEpoch;
}
