import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:marksheet_generator/model/marksheet.dart';

import '../state/marksheet_state.dart';

final markSheetViewModelProvider =
    StateNotifierProvider<MarkSheetViewModel, MarkSheetState>(
  (ref) => MarkSheetViewModel(),
);

class MarkSheetViewModel extends StateNotifier<MarkSheetState> {
  MarkSheetViewModel() : super(MarkSheetState.initialState()) {
    getAllMarkSheet();
  }

  void getAllMarkSheet() {
    state.marksheets.add(
        MarkSheet(fname: "John", lname: "asd", module: "Flutter", mark: 60));
    state.marksheets.add(
        MarkSheet(fname: "John", lname: "asd", module: "Web API", mark: 60));
    state.marksheets.add(MarkSheet(
        fname: "John", lname: "asd", module: "Design Thinking", mark: 60));
    state.marksheets
        .add(MarkSheet(fname: "John", lname: "asd", module: "IOT", mark: 60));
  }

  void deleteMarkSheet(MarkSheet markSheet) {
    // Add logic to delete the mark sheet from the data source
    // For example:
    state = state.copyWith(isLoading: true);
    final updatedMarksheets =
        state.marksheets.where((ms) => ms != markSheet).toList();
    state = state.copyWith(marksheets: updatedMarksheets);
    state = state.copyWith(isLoading: false);
  }

  void addMark(MarkSheet markSheet) {
    state = state.copyWith(isLoading: true);
    state.marksheets.add(markSheet);
    state = state.copyWith(isLoading: false);
  }
}
