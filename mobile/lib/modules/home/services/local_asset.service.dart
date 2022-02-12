import 'package:photo_manager/photo_manager.dart';

class LocalAssetService {
  Future<List<AssetEntity>?> getLocalAsset() async {
    var getPhotoAccessResult = await PhotoManager.requestPermissionExtend();

    if (getPhotoAccessResult.isAuth) {
      await PhotoManager.clearFileCache();
      // await PhotoManager.presentLimited();
      // Gather assets info
      List<AssetPathEntity> list =
          await PhotoManager.getAssetPathList(hasAll: true, onlyAll: true, type: RequestType.common);

      int totalAsset = list[0].assetCount;
      List<AssetEntity> localAssets = await list[0].getAssetListRange(start: 0, end: totalAsset);

      return localAssets;
    } else {
      PhotoManager.openSetting();
      return null;
    }
  }
}
