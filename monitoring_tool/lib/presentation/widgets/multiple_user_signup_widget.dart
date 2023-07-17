import 'dart:convert';
import 'dart:typed_data';

import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monitoring_tool/providers.dart';

import '../../infrastructure/notifiers/signup_notifier.dart';

class MultiUserSignup extends ConsumerWidget {
  const MultiUserSignup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Load Signup CSV File', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              // Row(
              //   children: [
              //     const Text('Username: '),
              //     Expanded(
              //       child: Padding(
              //         padding: const EdgeInsets.only(left: 8.0),
              //         child: TextField(
              //           decoration: const InputDecoration(
              //             border: OutlineInputBorder(
              //               borderSide:
              //                   BorderSide(color: Colors.blue, width: 2.0),
              //             ),
              //           ),
              //         ),
              //       ),
              //     )
              //   ],
              // ),
              Center(
                child: Consumer(
                  builder: (context, ref, child) {
                    final notifier = ref.watch(signupNotifier);
                    return ElevatedButton(
                      onPressed: () async {
                        FilePickerResult? csvFile =
                            await FilePicker.platform.pickFiles(allowedExtensions: ['csv'], type: FileType.custom, allowMultiple: false, withData: true);
                        if (csvFile != null && csvFile.files[0].name.endsWith('.csv')) {
                          final bytes = utf8.decode(csvFile.files[0].bytes!);
                          List<List<dynamic>> convertedLoginInfo = const CsvToListConverter().convert(bytes);
                          notifier.loadSignupInfo(convertedLoginInfo);
                        } else {
                          notifier.setFileLoadingError(SignupError.ERROR);
                        }
                      },
                      child: const Text(
                        'Choose a file...',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.grey, // background
                        onPrimary: Colors.white24, // foreground
                      ),
                    );
                  },
                ),
              ),

              const Text(
                'Format: Username, Password',
                style: TextStyle(fontStyle: FontStyle.italic, fontSize: 12.0),
              ),
              Consumer(builder: (context, ref, child) {
                final notifier = ref.watch(signupNotifier);
                if (notifier.errorFileLoading == SignupError.ERROR) {
                  return const Text(
                    'Failed to load .csv, please put in the right format',
                    style: TextStyle(color: Colors.red, fontSize: 12.0),
                  );
                } else if (notifier.errorFileLoading == SignupError.NOERROR) {
                  return const Text(
                    'CSV loading completed!',
                    style: TextStyle(color: Colors.green, fontSize: 12.0),
                  );
                } else {
                  return Container();
                }
              }),
              const SizedBox(height: 12.0),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      final notifier = ref.watch(signupNotifier);
                      notifier.signupBatch();
                    },
                    child: const Text('Sign Up Batch'),
                  ),
                  Container(width: 12.0),
                  Consumer(
                    builder: ((context, ref, child) {
                      final notifier = ref.watch(signupNotifier);
                      if (notifier.errorBatchSignup == SignupError.ERROR) {
                        return const Text(
                          'Could not Signup. Bad Batch Credentials (Wrong Format).',
                          style: TextStyle(color: Colors.red, fontSize: 10.0, fontStyle: FontStyle.italic),
                        );
                      } else if (notifier.errorBatchSignup == SignupError.NOERROR) {
                        return const Text(
                          'Batch Credentials Signed Up!',
                          style: TextStyle(color: Colors.green, fontSize: 10.0, fontStyle: FontStyle.italic),
                        );
                      } else {
                        return Container();
                      }
                    }),
                  ),
                ],
              )
            ],
          ),
        ));
  }
}
