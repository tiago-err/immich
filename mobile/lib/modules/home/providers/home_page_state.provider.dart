import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:immich_mobile/modules/home/models/home_page_state.model.dart';
import 'package:immich_mobile/shared/models/backup_asset.model.dart';

class HomePageStateNotifier extends StateNotifier<HomePageState> {
  HomePageStateNotifier()
      : super(
          HomePageState(
            isMultiSelectEnable: false,
            selectedItems: {},
            selectedDateGroup: {},
          ),
        );

  void addSelectedDateGroup(String dateGroupTitle) {
    state = state.copyWith(selectedDateGroup: {...state.selectedDateGroup, dateGroupTitle});
  }

  void removeSelectedDateGroup(String dateGroupTitle) {
    var currentDateGroup = state.selectedDateGroup;

    currentDateGroup.removeWhere((e) => e == dateGroupTitle);

    state = state.copyWith(selectedDateGroup: currentDateGroup);
  }

  void enableMultiSelect(Set<BackupAsset> selectedItems) {
    state = state.copyWith(isMultiSelectEnable: true, selectedItems: selectedItems);
  }

  void disableMultiSelect() {
    state = state.copyWith(isMultiSelectEnable: false, selectedItems: {}, selectedDateGroup: {});
  }

  void addSingleSelectedItem(BackupAsset asset) {
    state = state.copyWith(selectedItems: {...state.selectedItems, asset});
  }

  void addMultipleSelectedItems(List<BackupAsset> assets) {
    state = state.copyWith(selectedItems: {...state.selectedItems, ...assets});
  }

  void removeSingleSelectedItem(BackupAsset asset) {
    Set<BackupAsset> currentList = state.selectedItems;

    currentList.removeWhere((e) => e.id == asset.id);

    state = state.copyWith(selectedItems: currentList);
  }

  void removeMultipleSelectedItem(List<BackupAsset> assets) {
    Set<BackupAsset> currentList = state.selectedItems;

    for (BackupAsset asset in assets) {
      currentList.removeWhere((e) => e.id == asset.id);
    }

    state = state.copyWith(selectedItems: currentList);
  }
}

final homePageStateProvider =
    StateNotifierProvider<HomePageStateNotifier, HomePageState>(((ref) => HomePageStateNotifier()));
