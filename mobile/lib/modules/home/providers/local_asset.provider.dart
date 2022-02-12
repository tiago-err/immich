import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:immich_mobile/modules/home/services/asset.service.dart';
import 'package:immich_mobile/modules/home/services/local_asset.service.dart';
import 'package:immich_mobile/shared/models/immich_asset.model.dart';
import 'package:photo_manager/photo_manager.dart';

// class UltimateAsset {
//   final assetId;
//   final deviceId;
// }

class LocalAssetNotifier extends StateNotifier<List<AssetEntity>> {
  LocalAssetNotifier() : super([]);

  final LocalAssetService _localAssetService = LocalAssetService();
  final AssetService _assetService = AssetService();

  getLocalAsset() async {
    List<AssetEntity>? localAssets = await _localAssetService.getLocalAsset();

    // for (var asset in localAssets!) {
    //   print(asset.id);
    // }

    state = [...localAssets!];

    print("Local Asset ${state.length}");
    List<ImmichAsset>? backupAsset = await _assetService.getAllRawAsset();
  }
}

final localAssetProvider = StateNotifierProvider<LocalAssetNotifier, List<AssetEntity>>((ref) {
  return LocalAssetNotifier();
});
