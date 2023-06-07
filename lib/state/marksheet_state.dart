import 'package:marksheet_generator/model/marksheet.dart';

class MarkSheetState {
  bool isLoading;
  List<MarkSheet> marksheets;

  MarkSheetState({required this.isLoading, required this.marksheets});

  MarkSheetState.initialState()
      : this(
          isLoading: false,
          marksheets: [],
        );

  MarkSheetState copyWith({
    bool? isLoading,
    List<MarkSheet>? marksheets,
  }) {
    return MarkSheetState(
      isLoading: isLoading ?? this.isLoading,
      marksheets: marksheets ?? this.marksheets,
    );
  }
}
