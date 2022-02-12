import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:immich_mobile/modules/home/ui/thumbnail_image.dart';
import 'package:immich_mobile/shared/models/immich_asset.model.dart';

class LocalImageGrid extends ConsumerWidget {
  final List<ImmichAsset> assetGroup;

  const LocalImageGrid({Key? key, required this.assetGroup}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    Future<Uint8List?> getThumbData(ImmichAsset asset) async {
      if (asset.type == 'local') {
        var thumbData = await asset.localAsset!.thumbData;
        return thumbData;
      }
      return null;
    }

    return SliverGrid(
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, crossAxisSpacing: 5.0, mainAxisSpacing: 5),
      delegate: SliverChildBuilderDelegate(
        (BuildContext context, int index) {
          return assetGroup[index].type == 'local'
              ? FutureBuilder<Uint8List?>(
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
                )
              : ThumbnailImage(asset: assetGroup[index].backupAsset!);
        },
        childCount: assetGroup.length,
      ),
    );
  }
}
