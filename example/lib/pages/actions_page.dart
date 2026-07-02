import 'package:flutter/widgets.dart';
import 'package:material_3_expressive/components/buttons/enums/m3e_button_enums.dart';
import 'package:material_3_expressive/components/floating_action_buttons/enums/m3e_fab.dart';
import 'package:material_3_expressive/components/icon_buttons/enums/m3e_icon_button_enums.dart';
import 'package:material_3_expressive/components/segmented_buttons/models/m3e_segment.dart';
import 'package:material_3_expressive/material_3_expressive.dart';

import '../widgets/gallery_section.dart';

/// Demonstrates every component in the Material 3 *Actions* group.
class ActionsPage extends StatefulWidget {
  const ActionsPage({super.key});

  @override
  State<ActionsPage> createState() => _ActionsPageState();
}

class _ActionsPageState extends State<ActionsPage> {
  bool _favorite = false;
  Set<String> _singleView = <String>{'grid'};
  Set<String> _filters = <String>{'new'};
  int _groupIndex = 0;
  int _connectedGroupIndex = 0;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: <Widget>[
        _buttons(),
        _iconButtons(),
        _fabs(),
        _groups(),
        _selection(),
      ],
    );
  }

  Widget _buttons() {
    return GallerySection(
      title: 'Buttons',
      description: 'Five color variants that morph shape when pressed.',
      children: <Widget>[
        DemoRow(
          label: 'Variants',
          children: <Widget>[
            M3EActions.button(
              label: 'Elevated',
              style: M3EButtonStyle.elevated,
              onPressed: () {},
            ),
            M3EActions.button(
              label: 'Filled',
              onPressed: () {},
            ),
            M3EActions.button(
              label: 'Tonal',
              style: M3EButtonStyle.tonal,
              onPressed: () {},
            ),
            M3EActions.button(
              label: 'Outlined',
              style: M3EButtonStyle.outlined,
              onPressed: () {},
            ),
            M3EActions.button(
              label: 'Text',
              style: M3EButtonStyle.text,
              onPressed: () {},
            ),
          ],
        ),
        DemoRow(
          label: 'With icon and sizes',
          children: <Widget>[
            M3EActions.button(
              label: 'Add',
              icon: const Icon(M3EIcons.add),
              size: M3EButtonSize.xs,
              onPressed: () {},
            ),
            M3EActions.button(
              label: 'Add',
              icon: const Icon(M3EIcons.add),
              onPressed: () {},
            ),
            M3EActions.button(
              label: 'Add',
              icon: const Icon(M3EIcons.add),
              size: M3EButtonSize.lg,
              onPressed: () {},
            ),
            M3EActions.button(
              label: 'Disabled',
              onPressed: null,
            ),
          ],
        ),
      ],
    );
  }

  Widget _iconButtons() {
    return GallerySection(
      title: 'Icon buttons',
      children: <Widget>[
        DemoRow(
          label: 'Variants',
          children: <Widget>[
            M3EActions.iconButton(
              icon: const Icon(M3EIcons.edit),
              onPressed: () {},
            ),
            M3EActions.iconButton(
              icon: const Icon(M3EIcons.edit),
              variant: M3EIconButtonVariant.filled,
              onPressed: () {},
            ),
            M3EActions.iconButton(
              icon: const Icon(M3EIcons.edit),
              variant: M3EIconButtonVariant.tonal,
              onPressed: () {},
            ),
            M3EActions.iconButton(
              icon: const Icon(M3EIcons.edit),
              variant: M3EIconButtonVariant.outlined,
              onPressed: () {},
            ),
          ],
        ),
        DemoRow(
          label: 'Toggle',
          children: <Widget>[
            M3EActions.iconButton(
              icon: const Icon(M3EIcons.add),
              selectedIcon: const Icon(M3EIcons.check),
              variant: M3EIconButtonVariant.filled,
              selected: _favorite,
              onPressed: () => setState(() => _favorite = !_favorite),
            ),
          ],
        ),
      ],
    );
  }

  Widget _fabs() {
    return GallerySection(
      title: 'FABs & extended FAB',
      children: <Widget>[
        DemoRow(
          label: 'Sizes',
          children: <Widget>[
            M3EActions.fab(
              icon: const Icon(M3EIcons.add),
              size: M3EFabSize.small,
              onPressed: () {},
            ),
            M3EActions.fab(
              icon: const Icon(M3EIcons.add),
              onPressed: () {},
            ),
            M3EActions.fab(
              icon: const Icon(M3EIcons.add),
              size: M3EFabSize.large,
              color: M3EFabColor.tertiary,
              onPressed: () {},
            ),
          ],
        ),
        DemoRow(
          label: 'Extended & menu',
          children: <Widget>[
            M3EActions.extendedFab(
              label: 'Compose',
              icon: const Icon(M3EIcons.edit),
              onPressed: () {},
            ),
            M3EActions.fabMenu(
              items: <M3EFabMenuItem>[
                M3EFabMenuItem(
                  icon: const Icon(M3EIcons.edit),
                  label: 'Note',
                  onPressed: () {},
                ),
                M3EFabMenuItem(
                  icon: const Icon(M3EIcons.schedule),
                  label: 'Reminder',
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _groups() {
    return GallerySection(
      title: 'Button group',
      description:
          'Standard groups squish neighbours on press; connected groups morph '
          'their inner corners.',
      children: <Widget>[
        DemoRow(
          label: 'Standard (neighbour squish)',
          children: <Widget>[
            M3EActions.buttonGroup(
              selectedIndex: _groupIndex,
              onSelectedIndexChanged: (int? index) =>
                  setState(() => _groupIndex = index ?? _groupIndex),
              actions: const <M3EButtonGroupAction>[
                M3EButtonGroupAction(icon: Icon(M3EIcons.arrow_back)),
                M3EButtonGroupAction(icon: Icon(M3EIcons.remove)),
                M3EButtonGroupAction(icon: Icon(M3EIcons.add)),
                M3EButtonGroupAction(icon: Icon(M3EIcons.arrow_forward)),
              ],
            ),
          ],
        ),
        DemoRow(
          label: 'Connected (corner morph)',
          children: <Widget>[
            M3EActions.buttonGroup(
              type: M3EButtonGroupType.connected,
              selectedIndex: _connectedGroupIndex,
              onSelectedIndexChanged: (int? index) =>
                  setState(() => _connectedGroupIndex = index ?? _connectedGroupIndex),
              actions: const <M3EButtonGroupAction>[
                M3EButtonGroupAction(icon: Icon(M3EIcons.chevron_left)),
                M3EButtonGroupAction(icon: Icon(M3EIcons.menu)),
                M3EButtonGroupAction(icon: Icon(M3EIcons.chevron_right)),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _selection() {
    return GallerySection(
      title: 'Segmented & split buttons',
      children: <Widget>[
        DemoRow(
          label: 'Single select',
          children: <Widget>[
            M3EActions.segmentedButton<String>(
              segments: const <M3ESegment<String>>[
                M3ESegment<String>(value: 'list', label: 'List'),
                M3ESegment<String>(value: 'grid', label: 'Grid'),
              ],
              selected: _singleView,
              onSelectionChanged: (Set<String> value) =>
                  setState(() => _singleView = value),
            ),
          ],
        ),
        DemoRow(
          label: 'Multi select',
          children: <Widget>[
            M3EActions.segmentedButton<String>(
              multiSelect: true,
              segments: const <M3ESegment<String>>[
                M3ESegment<String>(value: 'new', label: 'New'),
                M3ESegment<String>(value: 'sale', label: 'Sale'),
                M3ESegment<String>(value: 'used', label: 'Used'),
              ],
              selected: _filters,
              onSelectionChanged: (Set<String> value) =>
                  setState(() => _filters = value),
            ),
          ],
        ),
        DemoRow(
          label: 'Split button',
          children: <Widget>[
            M3EActions.splitButton<String>(
              label: 'Save',
              leadingIcon: M3EIcons.check,
              onPressed: () {},
              onSelected: (String value) {},
              items: const <M3ESplitButtonItem<String>>[
                M3ESplitButtonItem<String>(
                  value: 'draft',
                  child: Text('Save as draft'),
                ),
                M3ESplitButtonItem<String>(
                  value: 'copy',
                  child: Text('Save a copy'),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
