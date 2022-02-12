import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:photo_manager/photo_manager.dart';

class LocalImageGrid extends ConsumerWidget {
  final List<AssetEntity> assetGroup;

  const LocalImageGrid({Key? key, required this.assetGroup}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<Uint8List?> getThumbData(AssetEntity asset) async {
      var thumbData = await asset.thumbData;

      return thumbData;
    }

    return SliverGrid(
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 5.0, mainAxisSpacing: 5),
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return FutureBuilder<Uint8List?>(
            future: getThumbData(assetGroup[index]),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return GestureDetector(
                  onTap: () {},
                  child: Image.memory(
                    snapshot.data!,
                    fit: BoxFit.cover,
                    width: 512,
                    height: 512,
                    cacheHeight: 250,
                  ),
                );
              } else {
                return Container(
                  width: 512,
                  height: 512,
                  color: Colors.grey[400],
                );
              }
            },
          );
        },
        childCount: assetGroup.length,
      ),
    );
  }
}
