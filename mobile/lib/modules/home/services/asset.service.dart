import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:immich_mobile/modules/home/models/get_all_asset_respose.model.dart';
import 'package:immich_mobile/shared/models/backup_asset.model.dart';
import 'package:immich_mobile/shared/models/immich_asset_with_exif.model.dart';
import 'package:immich_mobile/shared/services/network.service.dart';
import 'package:photo_manager/photo_manager.dart';

class AssetService {
  final NetworkService _networkService = NetworkService();
  Future<List<AssetEntity>?> getLocalAsset() async {
    var getPhotoAccessResult = await PhotoManager.requestPermissionExtend();

    if (getPhotoAccessResult.isAuth) {
      await PhotoManager.clearFileCache();
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

  Future<List<BackupAsset>?> getBackupAsset() async {
    var res = await _networkService.getRequest(url: "asset/allRaw");
    try {
      List<dynamic> decodedData = jsonDecode(res.toString());

      List<BackupAsset> result = List.from(decodedData.map((a) => BackupAsset.fromMap(a)));
      return result;
    } catch (e) {
      debugPrint("Error getAllAsset  ${e.toString()}");
    }
    return null;
  }

  Future<GetAllAssetResponse?> getAllAsset() async {
    var res = await _networkService.getRequest(url: "asset/all");
    try {
      Map<String, dynamic> decodedData = jsonDecode(res.toString());

      GetAllAssetResponse result = GetAllAssetResponse.fromMap(decodedData);
      return result;
    } catch (e) {
      debugPrint("Error getAllAsset  ${e.toString()}");
    }
    return null;
  }

  Future<GetAllAssetResponse?> getOlderAsset(String? nextPageKey) async {
    try {
      var res = await _networkService.getRequest(
        url: "asset/all?nextPageKey=$nextPageKey",
      );

      Map<String, dynamic> decodedData = jsonDecode(res.toString());

      GetAllAssetResponse result = GetAllAssetResponse.fromMap(decodedData);
      if (result.count != 0) {
        return result;
      }
    } catch (e) {
      debugPrint("Error getAllAsset  ${e.toString()}");
    }
    return null;
  }

  Future<List<BackupAsset>> getNewAsset(String latestDate) async {
    try {
      var res = await _networkService.getRequest(
        url: "asset/new?latestDate=$latestDate",
      );

      List<dynamic> decodedData = jsonDecode(res.toString());

      List<BackupAsset> result = List.from(decodedData.map((a) => BackupAsset.fromMap(a)));
      if (result.isNotEmpty) {
        return result;
      }

      return [];
    } catch (e) {
      debugPrint("Error getAllAsset  ${e.toString()}");
      return [];
    }
  }

  Future<ImmichAssetWithExif?> getAssetById(String assetId) async {
    try {
      var res = await _networkService.getRequest(
        url: "asset/assetById/$assetId",
      );

      Map<String, dynamic> decodedData = jsonDecode(res.toString());

      ImmichAssetWithExif result = ImmichAssetWithExif.fromMap(decodedData);
      print("result $result");
      return result;
    } catch (e) {
      debugPrint("Error getAllAsset  ${e.toString()}");
      return null;
    }
  }
}
