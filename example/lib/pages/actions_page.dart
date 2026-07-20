import 'package:flutter/widgets.dart';
import 'package:material_3_expressive/components/buttons/enums/m3e_button_enums.dart';
import 'package:material_3_expressive/components/floating_action_buttons/enums/m3e_fab.dart';
import 'package:material_3_expressive/components/icon_buttons/enums/m3e_icon_button_enums.dart';
import 'package:material_3_expressive/components/split_buttons/models/m3e_split_button_item.dart';
import 'package:material_3_expressive/components/toggle_button_group/models/m3e_button_group_action.dart';
import 'package:material_3_expressive/material_3_expressive.dart';

import '../widgets/gallery_section.dart';

/// Demonstrates every component in the Material 3 *Actions* group.
class ActionsPage extends StatefulWidget {
  const ActionsPage({super.key});

  @override
  State<ActionsPage> createState() => _ActionsPageState();
}

class _ActionsPageState extends State<ActionsPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  bool _favorite = false;
  Set<String> _singleView = <String>{'grid'};
  Set<String> _filters = <String>{'new'};
  int _groupIndex = 0;
  int _connectedGroupIndex = 0;
  bool _toggleFilled = false;
  bool _toggleOutlined = true;
  bool _toggleText = false;

  @override
  Widget build(BuildContext context) {
    super.build(context);
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
            M3EButton(
              style: M3EButtonStyle.elevated,
              onPressed: () {},
              child: const Text('Elevated'),
            ),
            M3EButton(
              onPressed: () {},
              child: const Text('Filled'),
            ),
            M3EButton(
              style: M3EButtonStyle.tonal,
              onPressed: () {},
              child: const Text('Tonal'),
            ),
            M3EButton(
              style: M3EButtonStyle.outlined,
              onPressed: () {},
              child: const Text('Outlined'),
            ),
            M3EButton(
              style: M3EButtonStyle.text,
              onPressed: () {},
              child: const Text('Text'),
            ),
          ],
        ),
        DemoRow(
          label: 'With icon and sizes',
          children: <Widget>[
            M3EButton.icon(
              icon: const Icon(M3EIcons.add),
              label: const Text('Add'),
              size: M3EButtonSize.xs,
              onPressed: () {},
            ),
            M3EButton.icon(
              icon: const Icon(M3EIcons.add),
              label: const Text('Add'),
              onPressed: () {},
            ),
            M3EButton.icon(
              icon: const Icon(M3EIcons.add),
              label: const Text('Add'),
              size: M3EButtonSize.lg,
              onPressed: () {},
            ),
            const M3EButton(
              onPressed: null,
              child: Text('Disabled'),
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
            M3EIconButton(
              icon: const Icon(M3EIcons.edit),
              onPressed: () {},
            ),
            M3EIconButton(
              icon: const Icon(M3EIcons.edit),
              variant: M3EIconButtonVariant.filled,
              onPressed: () {},
            ),
            M3EIconButton(
              icon: const Icon(M3EIcons.edit),
              variant: M3EIconButtonVariant.tonal,
              onPressed: () {},
            ),
            M3EIconButton(
              icon: const Icon(M3EIcons.edit),
              variant: M3EIconButtonVariant.outlined,
              onPressed: () {},
            ),
          ],
        ),
        DemoRow(
          label: 'Toggle',
          children: <Widget>[
            M3EIconButton(
              icon: const Icon(M3EIcons.add),
              selectedIcon: const Icon(M3EIcons.check),
              variant: M3EIconButtonVariant.filled,
              isSelected: _favorite,
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
            M3EFab(
              icon: const Icon(M3EIcons.add),
              size: M3EFabSize.small,
              onPressed: () {},
            ),
            M3EFab(
              icon: const Icon(M3EIcons.add),
              onPressed: () {},
            ),
            M3EFab(
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
            M3EExtendedFab(
              label: 'Compose',
              icon: const Icon(M3EIcons.edit),
              onPressed: () {},
            ),
            M3EFabMenu(
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
            M3EButtonGroup(
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
            M3EButtonGroup(
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
        DemoRow(
          label: 'Toggle buttons (round <-> square morph)',
          children: <Widget>[
            M3EToggleButton.filled(
              icon: const Icon(M3EIcons.favorite_border),
              checkedIcon: const Icon(M3EIcons.favorite),
              checked: _toggleFilled,
              onCheckedChange: (bool value) =>
                  setState(() => _toggleFilled = value),
            ),
            M3EToggleButton.outlined(
              icon: const Icon(M3EIcons.star_border),
              checkedIcon: const Icon(M3EIcons.star),
              checked: _toggleOutlined,
              onCheckedChange: (bool value) =>
                  setState(() => _toggleOutlined = value),
            ),
            M3EToggleButton.text(
              label: const Text('Bold'),
              checked: _toggleText,
              onCheckedChange: (bool value) =>
                  setState(() => _toggleText = value),
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
            M3ESegmentedButton<String>(
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
            M3ESegmentedButton<String>(
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
            M3ESplitButton<String>(
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
