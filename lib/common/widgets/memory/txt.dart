import 'package:flutter/material.dart';

import 'package:cosmic_assessments/services/base_client.dart';

class MemTxt extends StatelessWidget {
  final String fileHash;
  const MemTxt({super.key, required this.fileHash});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: BaseClient().fetchTextData(
        '/lesson/content/get_file?file_hash=$fileHash',
      ),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Text(snapshot.data!);
        } else if (snapshot.hasError) {
          return Text("${snapshot.error}");
        } else {
          return const Center(
            child: Text(
              'Loading...',
            ),
          );
        }
      },
    );
  }
}
