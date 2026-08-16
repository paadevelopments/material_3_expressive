import 'package:material_3_expressive/material_3_expressive.dart';

import '../pages/playground/do/button_group_playground.dart';
import '../pages/playground/do/buttons_playground.dart';
import '../pages/playground/do/fab_menu_playground.dart';
import '../pages/playground/do/fabs_playground.dart';
import '../pages/playground/do/icon_buttons_playground.dart';
import '../pages/playground/do/segmented_button_playground.dart';
import '../pages/playground/do/split_button_playground.dart';
import '../pages/playground/find/badges_playground.dart';
import '../pages/playground/find/loading_indicator_playground.dart';
import '../pages/playground/find/progress_playground.dart';
import '../pages/playground/find/refresh_indicator_playground.dart';
import '../pages/playground/find/search_playground.dart';
import '../pages/playground/find/snackbar_playground.dart';
import '../pages/playground/find/text_fields_playground.dart';
import '../pages/playground/find/tooltips_playground.dart';
import '../pages/playground/nav/app_bars_playground.dart';
import '../pages/playground/nav/menu_playground.dart';
import '../pages/playground/nav/navigation_bar_playground.dart';
import '../pages/playground/nav/navigation_drawer_playground.dart';
import '../pages/playground/nav/navigation_rail_playground.dart';
import '../pages/playground/nav/tabs_playground.dart';
import '../pages/playground/nav/toolbar_playground.dart';
import '../pages/playground/pick/checkbox_playground.dart';
import '../pages/playground/pick/chips_playground.dart';
import '../pages/playground/pick/date_pickers_playground.dart';
import '../pages/playground/pick/dropdown_menu_playground.dart';
import '../pages/playground/pick/radio_playground.dart';
import '../pages/playground/pick/sliders_playground.dart';
import '../pages/playground/pick/switch_playground.dart';
import '../pages/playground/pick/time_pickers_playground.dart';
import '../pages/playground/view/bottom_sheet_playground.dart';
import '../pages/playground/view/cards_playground.dart';
import '../pages/playground/view/carousel_playground.dart';
import '../pages/playground/view/dialogs_playground.dart';
import '../pages/playground/view/dividers_playground.dart';
import '../pages/playground/view/lists_playground.dart';
import '../pages/playground/view/selection_playground.dart';
import '../pages/playground/view/shapes_playground.dart';
import '../pages/playground/view/side_sheet_playground.dart';
import 'm3e_demo_entry.dart';
import 'm3e_demo_section.dart';

/// Catalog of all example playground entries.
abstract final class M3EDemoCatalog {
  const M3EDemoCatalog._();

  /// All entries.
  static final List<M3EDemoEntry> all = <M3EDemoEntry>[
    ...doEntries,
    ...pickEntries,
    ...viewEntries,
    ...navEntries,
    ...findEntries,
  ];

  /// Entries for [section].
  static List<M3EDemoEntry> forSection(M3EDemoSection section) {
    return all.where((M3EDemoEntry e) => e.section == section).toList();
  }

  /// Do (Actions).
  static final List<M3EDemoEntry> doEntries = <M3EDemoEntry>[
    M3EDemoEntry(
      id: 'buttons',
      title: 'Buttons',
      subtitle: 'Filled, tonal, elevated, outlined, text',
      icon: M3EIcons.smart_button,
      section: M3EDemoSection.doSection,
      playgroundBuilder: (_) => const ButtonsPlayground(),
    ),
    M3EDemoEntry(
      id: 'icon_buttons',
      title: 'Icon buttons',
      subtitle: 'Variants, sizes, toggle, badge',
      icon: M3EIcons.favorite,
      section: M3EDemoSection.doSection,
      playgroundBuilder: (_) => const IconButtonsPlayground(),
    ),
    M3EDemoEntry(
      id: 'fabs',
      title: 'FABs',
      subtitle: 'FAB and extended FAB',
      icon: M3EIcons.add,
      section: M3EDemoSection.doSection,
      playgroundBuilder: (_) => const FabsPlayground(),
    ),
    M3EDemoEntry(
      id: 'fab_menu',
      title: 'FAB menu',
      subtitle: 'Speed-dial style menu',
      icon: M3EIcons.apps,
      section: M3EDemoSection.doSection,
      playgroundBuilder: (_) => const FabMenuPlayground(),
    ),
    M3EDemoEntry(
      id: 'button_group',
      title: 'Button group',
      subtitle: 'Connected groups and toggle buttons',
      icon: M3EIcons.view_week,
      section: M3EDemoSection.doSection,
      playgroundBuilder: (_) => const ButtonGroupPlayground(),
    ),
    M3EDemoEntry(
      id: 'segmented_button',
      title: 'Segmented button',
      subtitle: 'Single and multi select segments',
      icon: M3EIcons.view_column,
      section: M3EDemoSection.doSection,
      playgroundBuilder: (_) => const SegmentedButtonPlayground(),
    ),
    M3EDemoEntry(
      id: 'split_button',
      title: 'Split button',
      subtitle: 'Primary action plus menu',
      icon: M3EIcons.arrow_drop_down,
      section: M3EDemoSection.doSection,
      playgroundBuilder: (_) => const SplitButtonPlayground(),
    ),
  ];

  /// Pick (Selection).
  static final List<M3EDemoEntry> pickEntries = <M3EDemoEntry>[
    M3EDemoEntry(
      id: 'checkbox',
      title: 'Checkbox',
      subtitle: 'Binary, tristate, error',
      icon: M3EIcons.check_box,
      section: M3EDemoSection.pickSection,
      playgroundBuilder: (_) => const CheckboxPlayground(),
    ),
    M3EDemoEntry(
      id: 'radio',
      title: 'Radio',
      subtitle: 'Exclusive selection',
      icon: M3EIcons.radio_button_checked,
      section: M3EDemoSection.pickSection,
      playgroundBuilder: (_) => const RadioPlayground(),
    ),
    M3EDemoEntry(
      id: 'switch',
      title: 'Switch',
      subtitle: 'On/off with optional icons',
      icon: M3EIcons.toggle_on,
      section: M3EDemoSection.pickSection,
      playgroundBuilder: (_) => const SwitchPlayground(),
    ),
    M3EDemoEntry(
      id: 'chips',
      title: 'Chips',
      subtitle: 'Assist, filter, input, suggestion',
      icon: M3EIcons.label,
      section: M3EDemoSection.pickSection,
      playgroundBuilder: (_) => const ChipsPlayground(),
    ),
    M3EDemoEntry(
      id: 'dropdown_menu',
      title: 'Dropdown menu',
      subtitle: 'Single, multi, search, async',
      icon: M3EIcons.arrow_drop_down_circle,
      section: M3EDemoSection.pickSection,
      playgroundBuilder: (_) => const DropdownMenuPlayground(),
    ),
    M3EDemoEntry(
      id: 'sliders',
      title: 'Sliders',
      subtitle: 'Continuous, discrete, range, wavy',
      icon: M3EIcons.linear_scale,
      section: M3EDemoSection.pickSection,
      playgroundBuilder: (_) => const SlidersPlayground(),
    ),
    M3EDemoEntry(
      id: 'date_pickers',
      title: 'Date pickers',
      subtitle: 'Calendar and dialogs',
      icon: M3EIcons.calendar_today,
      section: M3EDemoSection.pickSection,
      playgroundBuilder: (_) => const DatePickersPlayground(),
    ),
    M3EDemoEntry(
      id: 'time_pickers',
      title: 'Time pickers',
      subtitle: 'Dial and dialog',
      icon: M3EIcons.schedule,
      section: M3EDemoSection.pickSection,
      playgroundBuilder: (_) => const TimePickersPlayground(),
    ),
  ];

  /// View (Containment).
  static final List<M3EDemoEntry> viewEntries = <M3EDemoEntry>[
    M3EDemoEntry(
      id: 'cards',
      title: 'Cards',
      subtitle: 'Elevated, filled, outlined',
      icon: M3EIcons.crop_square,
      section: M3EDemoSection.viewSection,
      playgroundBuilder: (_) => const CardsPlayground(),
    ),
    M3EDemoEntry(
      id: 'carousel',
      title: 'Carousel',
      subtitle: 'Hero and contained layouts',
      icon: M3EIcons.view_carousel,
      section: M3EDemoSection.viewSection,
      playgroundBuilder: (_) => const CarouselPlayground(),
    ),
    M3EDemoEntry(
      id: 'lists',
      title: 'Lists',
      subtitle: 'Item, card, dismissible, expandable',
      icon: M3EIcons.list,
      section: M3EDemoSection.viewSection,
      playgroundBuilder: (_) => const ListsPlayground(),
    ),
    M3EDemoEntry(
      id: 'selection',
      title: 'Selection',
      subtitle: 'Multi-select host and app bar',
      icon: M3EIcons.select_all,
      section: M3EDemoSection.viewSection,
      playgroundBuilder: (_) => const SelectionPlayground(),
    ),
    M3EDemoEntry(
      id: 'dividers',
      title: 'Dividers',
      subtitle: 'Horizontal and vertical',
      icon: M3EIcons.horizontal_rule,
      section: M3EDemoSection.viewSection,
      playgroundBuilder: (_) => const DividersPlayground(),
    ),
    M3EDemoEntry(
      id: 'shapes',
      title: 'Shapes',
      subtitle: 'Expressive clip catalog',
      icon: M3EIcons.category,
      section: M3EDemoSection.viewSection,
      playgroundBuilder: (_) => const ShapesPlayground(),
    ),
    M3EDemoEntry(
      id: 'dialogs',
      title: 'Dialogs',
      subtitle: 'Basic, selection, full-screen',
      icon: M3EIcons.chat_bubble,
      section: M3EDemoSection.viewSection,
      playgroundBuilder: (_) => const DialogsPlayground(),
    ),
    M3EDemoEntry(
      id: 'bottom_sheet',
      title: 'Bottom sheet',
      subtitle: 'Modal sheet with drag handle',
      icon: M3EIcons.vertical_align_bottom,
      section: M3EDemoSection.viewSection,
      playgroundBuilder: (_) => const BottomSheetPlayground(),
    ),
    M3EDemoEntry(
      id: 'side_sheet',
      title: 'Side sheet',
      subtitle: 'Side panel with actions',
      icon: M3EIcons.vertical_split,
      section: M3EDemoSection.viewSection,
      playgroundBuilder: (_) => const SideSheetPlayground(),
    ),
  ];

  /// Nav (Navigation).
  static final List<M3EDemoEntry> navEntries = <M3EDemoEntry>[
    M3EDemoEntry(
      id: 'app_bars',
      title: 'App bars',
      subtitle: 'Top, search, sliver, bottom',
      icon: M3EIcons.web_asset,
      section: M3EDemoSection.navSection,
      playgroundBuilder: (_) => const AppBarsPlayground(),
    ),
    M3EDemoEntry(
      id: 'tabs',
      title: 'Tabs',
      subtitle: 'Primary and secondary',
      icon: M3EIcons.tab,
      section: M3EDemoSection.navSection,
      playgroundBuilder: (_) => const TabsPlayground(),
    ),
    M3EDemoEntry(
      id: 'navigation_bar',
      title: 'Navigation bar',
      subtitle: 'Bottom destinations',
      icon: M3EIcons.space_dashboard,
      section: M3EDemoSection.navSection,
      playgroundBuilder: (_) => const NavigationBarPlayground(),
    ),
    M3EDemoEntry(
      id: 'navigation_rail',
      title: 'Navigation rail',
      subtitle: 'Side rail with sections',
      icon: M3EIcons.view_sidebar,
      section: M3EDemoSection.navSection,
      playgroundBuilder: (_) => const NavigationRailPlayground(),
    ),
    M3EDemoEntry(
      id: 'navigation_drawer',
      title: 'Navigation drawer',
      subtitle: 'Modal drawer destinations',
      icon: M3EIcons.menu,
      section: M3EDemoSection.navSection,
      playgroundBuilder: (_) => const NavigationDrawerPlayground(),
    ),
    M3EDemoEntry(
      id: 'toolbar',
      title: 'Toolbar',
      subtitle: 'Floating and docked toolbars',
      icon: M3EIcons.build,
      section: M3EDemoSection.navSection,
      playgroundBuilder: (_) => const ToolbarPlayground(),
    ),
    M3EDemoEntry(
      id: 'menu',
      title: 'Menu',
      subtitle: 'Anchored expressive menus',
      icon: M3EIcons.more_vert,
      section: M3EDemoSection.navSection,
      playgroundBuilder: (_) => const MenuPlayground(),
    ),
  ];

  /// Find (Feedback / input).
  static final List<M3EDemoEntry> findEntries = <M3EDemoEntry>[
    M3EDemoEntry(
      id: 'badges',
      title: 'Badges',
      subtitle: 'Dot and count badges',
      icon: M3EIcons.notifications,
      section: M3EDemoSection.findSection,
      playgroundBuilder: (_) => const BadgesPlayground(),
    ),
    M3EDemoEntry(
      id: 'progress',
      title: 'Progress indicators',
      subtitle: 'Linear, circular, wavy',
      icon: M3EIcons.hourglass_empty,
      section: M3EDemoSection.findSection,
      playgroundBuilder: (_) => const ProgressPlayground(),
    ),
    M3EDemoEntry(
      id: 'loading_indicator',
      title: 'Loading indicator',
      subtitle: 'Expressive loading',
      icon: M3EIcons.autorenew,
      section: M3EDemoSection.findSection,
      playgroundBuilder: (_) => const LoadingIndicatorPlayground(),
    ),
    M3EDemoEntry(
      id: 'refresh_indicator',
      title: 'Refresh indicator',
      subtitle: 'Pull to refresh',
      icon: M3EIcons.refresh,
      section: M3EDemoSection.findSection,
      playgroundBuilder: (_) => const RefreshIndicatorPlayground(),
    ),
    M3EDemoEntry(
      id: 'tooltips',
      title: 'Tooltips',
      subtitle: 'Plain and rich tooltips',
      icon: M3EIcons.info,
      section: M3EDemoSection.findSection,
      playgroundBuilder: (_) => const TooltipsPlayground(),
    ),
    M3EDemoEntry(
      id: 'snackbar',
      title: 'Snackbar',
      subtitle: 'Transient messages',
      icon: M3EIcons.message,
      section: M3EDemoSection.findSection,
      playgroundBuilder: (_) => const SnackbarPlayground(),
    ),
    M3EDemoEntry(
      id: 'text_fields',
      title: 'Text fields',
      subtitle: 'Filled and outlined',
      icon: M3EIcons.text_fields,
      section: M3EDemoSection.findSection,
      playgroundBuilder: (_) => const TextFieldsPlayground(),
    ),
    M3EDemoEntry(
      id: 'search',
      title: 'Search',
      subtitle: 'Search bar and anchor',
      icon: M3EIcons.search,
      section: M3EDemoSection.findSection,
      playgroundBuilder: (_) => const SearchPlayground(),
    ),
  ];
}
