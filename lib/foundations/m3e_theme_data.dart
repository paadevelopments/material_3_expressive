import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show Brightness, IconThemeData, TargetPlatform, Theme, ThemeData, VisualDensity;
import 'package:flutter/widgets.dart';

import 'm3e_color_scheme.dart';
import 'm3e_spacing.dart';
import 'm3e_typography.dart';
import '../components/app_bars/styles/m3e_app_bar_theme.dart';
import '../components/badges/styles/m3e_badge_theme.dart';
import '../components/bottom_sheets/styles/m3e_bottom_sheet_theme.dart';
import '../components/buttons/styles/m3e_button_theme.dart';
import '../components/cards/styles/m3e_card_theme.dart';
import '../components/carousel/styles/m3e_carousel_theme.dart';
import '../components/checkbox/styles/m3e_checkbox_theme.dart';
import '../components/chips/styles/m3e_chip_theme.dart';
import '../components/date_pickers/styles/m3e_date_picker_theme.dart';
import '../components/dialogs/styles/m3e_dialog_theme.dart';
import '../components/divider/styles/m3e_divider_theme.dart';
import '../components/fab_menu/styles/m3e_fab_menu_theme.dart';
import '../components/floating_action_buttons/styles/m3e_fab_theme.dart';
import '../components/icon_buttons/styles/m3e_icon_button_theme.dart';
import '../components/lists/styles/m3e_list_theme.dart';
import '../components/loading_indicator/styles/m3e_loading_indicator_theme.dart';
import '../components/menus/styles/m3e_menu_theme.dart';
import '../components/navigation_bar/styles/m3e_navigation_bar_theme.dart';
import '../components/navigation_drawer/styles/m3e_navigation_drawer_theme.dart';
import '../components/navigation_rail/styles/m3e_navigation_rail_theme.dart';
import '../components/progress_indicators/styles/m3e_progress_indicator_theme.dart';
import '../components/radio_button/styles/m3e_radio_theme.dart';
import '../components/refresh_indicator/styles/m3e_refresh_indicator_theme.dart';
import '../components/search/styles/m3e_search_bar_theme.dart';
import '../components/segmented_buttons/styles/m3e_segmented_button_theme.dart';
import '../components/side_sheets/styles/m3e_side_sheet_theme.dart';
import '../components/sliders/styles/m3e_slider_theme.dart';
import '../components/snackbar/styles/m3e_snackbar_theme.dart';
import '../components/split_buttons/styles/m3e_split_button_theme.dart';
import '../components/switch_control/styles/m3e_switch_theme.dart';
import '../components/tabs/styles/m3e_tab_theme.dart';
import '../components/text_fields/styles/m3e_text_field_theme.dart';
import '../components/time_pickers/styles/m3e_time_picker_theme.dart';
import '../components/toggle_button/styles/m3e_toggle_button_theme.dart';
import '../components/toggle_button_group/styles/m3e_toggle_button_group_theme.dart';
import '../components/toolbars/styles/m3e_toolbar_theme.dart';
import '../components/tooltips/styles/m3e_tooltip_theme.dart';

/// Immutable bundle of expressive design tokens and per-component themes.
@immutable
class M3EThemeData {
  M3EThemeData({
    M3EColorScheme? colorScheme,
    M3ETypeScale? typeScale,
    this.spacing = const M3ESpacing.regular(),
    this.visualDensity = 0,
    this.platform,
    this.useMaterial3 = true,
    this.appBarTheme = M3EAppBarTheme.defaults,
    this.badgeTheme = M3EBadgeTheme.defaults,
    this.bottomSheetTheme = M3EBottomSheetTheme.defaults,
    this.buttonTheme = M3EButtonTheme.defaults,
    this.cardTheme = M3ECardTheme.defaults,
    this.carouselTheme = M3ECarouselTheme.defaults,
    this.checkboxTheme = M3ECheckboxTheme.defaults,
    this.chipTheme = M3EChipTheme.defaults,
    this.datePickerTheme = M3EDatePickerTheme.defaults,
    this.dialogTheme = M3EDialogTheme.defaults,
    this.dividerTheme = M3EDividerTheme.defaults,
    this.fabTheme = M3EFabTheme.defaults,
    this.fabMenuTheme = M3EFabMenuTheme.defaults,
    this.iconButtonTheme = M3EIconButtonTheme.defaults,
    this.listTheme = M3EListTheme.defaults,
    this.loadingIndicatorTheme = M3ELoadingIndicatorTheme.defaults,
    this.menuTheme = M3EMenuTheme.defaults,
    this.navigationBarTheme = M3ENavigationBarTheme.defaults,
    this.navigationDrawerTheme = M3ENavigationDrawerTheme.defaults,
    this.navigationRailTheme = M3ENavigationRailTheme.defaults,
    this.progressIndicatorTheme = M3EProgressIndicatorTheme.defaults,
    this.radioTheme = M3ERadioTheme.defaults,
    this.refreshIndicatorTheme = M3ERefreshIndicatorTheme.defaults,
    this.searchBarTheme = M3ESearchBarTheme.defaults,
    this.segmentedButtonTheme = M3ESegmentedButtonTheme.defaults,
    this.sideSheetTheme = M3ESideSheetTheme.defaults,
    this.sliderTheme = M3ESliderTheme.defaults,
    this.snackBarTheme = M3ESnackbarTheme.defaults,
    this.splitButtonTheme = M3ESplitButtonTheme.defaults,
    this.switchTheme = M3ESwitchTheme.defaults,
    this.tabTheme = M3ETabTheme.defaults,
    this.textFieldTheme = M3ETextFieldTheme.defaults,
    this.timePickerTheme = M3ETimePickerTheme.defaults,
    this.toggleButtonTheme = M3EToggleButtonTheme.defaults,
    this.toggleButtonGroupTheme = M3EToggleButtonGroupTheme.defaults,
    this.toolbarTheme = M3EToolbarTheme.defaults,
    this.tooltipTheme = M3ETooltipTheme.defaults,
  })  : colorScheme = colorScheme ?? M3EColorScheme.light(),
        typeScale = typeScale ?? M3ETypeScale.baseline(),
        brightness = (colorScheme ?? M3EColorScheme.light()).brightness;

  factory M3EThemeData.light({Color? seedColor}) {
    return M3EThemeData(
      colorScheme: seedColor == null
          ? M3EColorScheme.light()
          : M3EColorScheme.fromSeed(seedColor),
    );
  }

  factory M3EThemeData.dark({Color? seedColor}) {
    return M3EThemeData(
      colorScheme: seedColor == null
          ? M3EColorScheme.dark()
          : M3EColorScheme.fromSeed(seedColor, brightness: Brightness.dark),
    );
  }

  factory M3EThemeData.fromMaterial(ThemeData theme) {
    final M3EThemeData? cached = _materialCache[theme];
    if (cached != null) {
      return cached;
    }
    final data = M3EThemeData(
      colorScheme: M3EColorScheme.fromColorScheme(theme.colorScheme),
      typeScale: M3ETypeScale.fromTextTheme(theme.textTheme),
      visualDensity: theme.visualDensity.vertical,
      platform: theme.platform,
      useMaterial3: theme.useMaterial3,
    );
    _materialCache[theme] = data;
    return data;
  }

  final M3EColorScheme colorScheme;
  final M3ETypeScale typeScale;
  final M3ESpacing spacing;
  final double visualDensity;
  final TargetPlatform? platform;
  final bool useMaterial3;
  final Brightness brightness;

  final M3EAppBarTheme appBarTheme;
  final M3EBadgeTheme badgeTheme;
  final M3EBottomSheetTheme bottomSheetTheme;
  final M3EButtonTheme buttonTheme;
  final M3ECardTheme cardTheme;
  final M3ECarouselTheme carouselTheme;
  final M3ECheckboxTheme checkboxTheme;
  final M3EChipTheme chipTheme;
  final M3EDatePickerTheme datePickerTheme;
  final M3EDialogTheme dialogTheme;
  final M3EDividerTheme dividerTheme;
  final M3EFabTheme fabTheme;
  final M3EFabMenuTheme fabMenuTheme;
  final M3EIconButtonTheme iconButtonTheme;
  final M3EListTheme listTheme;
  final M3ELoadingIndicatorTheme loadingIndicatorTheme;
  final M3EMenuTheme menuTheme;
  final M3ENavigationBarTheme navigationBarTheme;
  final M3ENavigationDrawerTheme navigationDrawerTheme;
  final M3ENavigationRailTheme navigationRailTheme;
  final M3EProgressIndicatorTheme progressIndicatorTheme;
  final M3ERadioTheme radioTheme;
  final M3ERefreshIndicatorTheme refreshIndicatorTheme;
  final M3ESearchBarTheme searchBarTheme;
  final M3ESegmentedButtonTheme segmentedButtonTheme;
  final M3ESideSheetTheme sideSheetTheme;
  final M3ESliderTheme sliderTheme;
  final M3ESnackbarTheme snackBarTheme;
  final M3ESplitButtonTheme splitButtonTheme;
  final M3ESwitchTheme switchTheme;
  final M3ETabTheme tabTheme;
  final M3ETextFieldTheme textFieldTheme;
  final M3ETimePickerTheme timePickerTheme;
  final M3EToggleButtonTheme toggleButtonTheme;
  final M3EToggleButtonGroupTheme toggleButtonGroupTheme;
  final M3EToolbarTheme toolbarTheme;
  final M3ETooltipTheme tooltipTheme;

  M3EThemeData copyWith({
    M3EColorScheme? colorScheme,
    M3ETypeScale? typeScale,
    M3ESpacing? spacing,
    double? visualDensity,
    TargetPlatform? platform,
    bool? useMaterial3,
    M3EAppBarTheme? appBarTheme,
    M3EBadgeTheme? badgeTheme,
    M3EBottomSheetTheme? bottomSheetTheme,
    M3EButtonTheme? buttonTheme,
    M3ECardTheme? cardTheme,
    M3ECarouselTheme? carouselTheme,
    M3ECheckboxTheme? checkboxTheme,
    M3EChipTheme? chipTheme,
    M3EDatePickerTheme? datePickerTheme,
    M3EDialogTheme? dialogTheme,
    M3EDividerTheme? dividerTheme,
    M3EFabTheme? fabTheme,
    M3EFabMenuTheme? fabMenuTheme,
    M3EIconButtonTheme? iconButtonTheme,
    M3EListTheme? listTheme,
    M3ELoadingIndicatorTheme? loadingIndicatorTheme,
    M3EMenuTheme? menuTheme,
    M3ENavigationBarTheme? navigationBarTheme,
    M3ENavigationDrawerTheme? navigationDrawerTheme,
    M3ENavigationRailTheme? navigationRailTheme,
    M3EProgressIndicatorTheme? progressIndicatorTheme,
    M3ERadioTheme? radioTheme,
    M3ERefreshIndicatorTheme? refreshIndicatorTheme,
    M3ESearchBarTheme? searchBarTheme,
    M3ESegmentedButtonTheme? segmentedButtonTheme,
    M3ESideSheetTheme? sideSheetTheme,
    M3ESliderTheme? sliderTheme,
    M3ESnackbarTheme? snackBarTheme,
    M3ESplitButtonTheme? splitButtonTheme,
    M3ESwitchTheme? switchTheme,
    M3ETabTheme? tabTheme,
    M3ETextFieldTheme? textFieldTheme,
    M3ETimePickerTheme? timePickerTheme,
    M3EToggleButtonTheme? toggleButtonTheme,
    M3EToggleButtonGroupTheme? toggleButtonGroupTheme,
    M3EToolbarTheme? toolbarTheme,
    M3ETooltipTheme? tooltipTheme,
  }) {
    return M3EThemeData(
      colorScheme: colorScheme ?? this.colorScheme,
      typeScale: typeScale ?? this.typeScale,
      spacing: spacing ?? this.spacing,
      visualDensity: visualDensity ?? this.visualDensity,
      platform: platform ?? this.platform,
      useMaterial3: useMaterial3 ?? this.useMaterial3,
      appBarTheme: appBarTheme ?? this.appBarTheme,
      badgeTheme: badgeTheme ?? this.badgeTheme,
      bottomSheetTheme: bottomSheetTheme ?? this.bottomSheetTheme,
      buttonTheme: buttonTheme ?? this.buttonTheme,
      cardTheme: cardTheme ?? this.cardTheme,
      carouselTheme: carouselTheme ?? this.carouselTheme,
      checkboxTheme: checkboxTheme ?? this.checkboxTheme,
      chipTheme: chipTheme ?? this.chipTheme,
      datePickerTheme: datePickerTheme ?? this.datePickerTheme,
      dialogTheme: dialogTheme ?? this.dialogTheme,
      dividerTheme: dividerTheme ?? this.dividerTheme,
      fabTheme: fabTheme ?? this.fabTheme,
      fabMenuTheme: fabMenuTheme ?? this.fabMenuTheme,
      iconButtonTheme: iconButtonTheme ?? this.iconButtonTheme,
      listTheme: listTheme ?? this.listTheme,
      loadingIndicatorTheme: loadingIndicatorTheme ?? this.loadingIndicatorTheme,
      menuTheme: menuTheme ?? this.menuTheme,
      navigationBarTheme: navigationBarTheme ?? this.navigationBarTheme,
      navigationDrawerTheme: navigationDrawerTheme ?? this.navigationDrawerTheme,
      navigationRailTheme: navigationRailTheme ?? this.navigationRailTheme,
      progressIndicatorTheme: progressIndicatorTheme ?? this.progressIndicatorTheme,
      radioTheme: radioTheme ?? this.radioTheme,
      refreshIndicatorTheme: refreshIndicatorTheme ?? this.refreshIndicatorTheme,
      searchBarTheme: searchBarTheme ?? this.searchBarTheme,
      segmentedButtonTheme: segmentedButtonTheme ?? this.segmentedButtonTheme,
      sideSheetTheme: sideSheetTheme ?? this.sideSheetTheme,
      sliderTheme: sliderTheme ?? this.sliderTheme,
      snackBarTheme: snackBarTheme ?? this.snackBarTheme,
      splitButtonTheme: splitButtonTheme ?? this.splitButtonTheme,
      switchTheme: switchTheme ?? this.switchTheme,
      tabTheme: tabTheme ?? this.tabTheme,
      textFieldTheme: textFieldTheme ?? this.textFieldTheme,
      timePickerTheme: timePickerTheme ?? this.timePickerTheme,
      toggleButtonTheme: toggleButtonTheme ?? this.toggleButtonTheme,
      toggleButtonGroupTheme: toggleButtonGroupTheme ?? this.toggleButtonGroupTheme,
      toolbarTheme: toolbarTheme ?? this.toolbarTheme,
      tooltipTheme: tooltipTheme ?? this.tooltipTheme,
    );
  }

  ThemeData toThemeData() {
    return ThemeData(
      useMaterial3: useMaterial3,
      colorScheme: colorScheme.toColorScheme(),
      textTheme: typeScale.toTextTheme(),
      visualDensity: VisualDensity(
        horizontal: visualDensity,
        vertical: visualDensity,
      ),
      platform: platform,
    );
  }
}

final Expando<M3EThemeData> _materialCache = Expando<M3EThemeData>();
