import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:cosmic_assessments/services/base_client.dart';

class MemImage extends StatelessWidget {
  final String fileHash;
  const MemImage({super.key, required this.fileHash});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List>(
      future: BaseClient().fetchImageData(
        '/lesson/content/get_file?file_hash=$fileHash',
      ),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Image.memory(snapshot.data!);
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
