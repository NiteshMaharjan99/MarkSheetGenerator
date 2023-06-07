import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:marksheet_generator/model/marksheet.dart';
import 'package:marksheet_generator/view_model/marksheet_viewmodel.dart';

class AddMark extends ConsumerStatefulWidget {
  const AddMark({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AddMarkState();
}

class _AddMarkState extends ConsumerState<AddMark> {
  TextEditingController fnameController = TextEditingController();
  TextEditingController lnameController = TextEditingController();
  TextEditingController marksController = TextEditingController();

  List<String> modules = ["Flutter", "Web API", "Design Thinking", "IOT"];
  var gap = const SizedBox(
    height: 12,
  );

  String selectedmodule = "";

  @override
  Widget build(BuildContext context) {
    var data = ref.watch(markSheetViewModelProvider);

    final totalMarks = data.marksheets
        .fold(0, (sum, markSheet) => sum + (markSheet.mark ?? 0));
    final result = totalMarks >= 40 ? 'Pass' : 'Fail';
    String division;
    if (totalMarks >= 60) {
      division = 'First Division';
    } else if (totalMarks >= 50) {
      division = 'Second Division';
    } else if (totalMarks >= 40) {
      division = 'Third Division';
    } else {
      division = "Fail";
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("Marksheet App"),
      ),
      body: Column(
        children: [
          gap,
          TextFormField(
            controller: fnameController,
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
              labelText: ("First Name"),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(12),
                ),
              ),
            ),
          ),
          gap,
          TextFormField(
            controller: lnameController,
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
              labelText: ("Last Name"),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(12),
                ),
              ),
            ),
          ),
          gap,
          DropdownButtonFormField(
            validator: (value) {
              if (value == null) {
                return 'Please select a module';
              }
              return null;
            },
            decoration: const InputDecoration(
              labelText: 'Module',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(12),
                ),
              ),
            ),
            items: modules
                .map(
                  (module) => DropdownMenuItem(
                    value: module,
                    child: Text(module),
                  ),
                )
                .toList(),
            onChanged: (value) {
              setState(() {
                selectedmodule = value!;
              });
            },
          ),
          gap,
          TextFormField(
            controller: marksController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: ("Marks"),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(12),
                ),
              ),
            ),
          ),
          gap,
          ElevatedButton(
            onPressed: () {
              MarkSheet markSheet = MarkSheet(
                fname: fnameController.text,
                lname: lnameController.text,
                module: selectedmodule,
                mark: int.parse(marksController.text),
              );

              ref.read(markSheetViewModelProvider.notifier).addMark(markSheet);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Student Added Successfully'),
                  duration: Duration(seconds: 1),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text("Add"),
          ),
          data.marksheets.isNotEmpty
              ? Expanded(
                child: SingleChildScrollView(
                  child: Column(
                      children: [
                        FittedBox(
                          child: DataTable(
                            columns: const [
                              DataColumn(label: Text('First Name')),
                              DataColumn(label: Text('Last Name')),
                              DataColumn(label: Text('Module')),
                              DataColumn(label: Text('Marks')),
                              DataColumn(label: Text('Action')),
                            ],
                            rows: data.marksheets.map((markSheet) {
                              return DataRow(
                                cells: [
                                  DataCell(Text(markSheet.fname!)),
                                  DataCell(Text(markSheet.lname!)),
                                  DataCell(Text(markSheet.module!)),
                                  DataCell(Text(markSheet.mark.toString())),
                                  DataCell(
                                    IconButton(
                                      onPressed: () {
                                        ref
                                            .read(markSheetViewModelProvider
                                                .notifier)
                                            .deleteMarkSheet(markSheet);
                                      },
                                      icon: const Icon(Icons.delete),
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                        FittedBox(
                          child: Container(
                            alignment: Alignment.bottomRight,
                            margin: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text('Total Marks: $totalMarks'),
                                Text('Result: $result'),
                                Text('Division: $division'),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                ),
              )
              : const Text("No Data"),
        ],
      ),
    );
  }
}
