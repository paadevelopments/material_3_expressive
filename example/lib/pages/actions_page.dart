import 'package:flutter/widgets.dart';
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
              variant: M3EButtonVariant.elevated,
              onPressed: () {},
            ),
            M3EActions.button(
              label: 'Filled',
              onPressed: () {},
            ),
            M3EActions.button(
              label: 'Tonal',
              variant: M3EButtonVariant.filledTonal,
              onPressed: () {},
            ),
            M3EActions.button(
              label: 'Outlined',
              variant: M3EButtonVariant.outlined,
              onPressed: () {},
            ),
            M3EActions.button(
              label: 'Text',
              variant: M3EButtonVariant.text,
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
              size: M3EButtonSize.extraSmall,
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
              size: M3EButtonSize.large,
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
      children: <Widget>[
        M3EActions.buttonGroup(
          items: <M3EButtonGroupItem>[
            M3EButtonGroupItem(
              icon: const Icon(M3EIcons.arrowBack),
              onPressed: () {},
            ),
            M3EButtonGroupItem(
              icon: const Icon(M3EIcons.remove),
              onPressed: () {},
            ),
            M3EButtonGroupItem(
              icon: const Icon(M3EIcons.add),
              onPressed: () {},
            ),
            M3EButtonGroupItem(
              icon: const Icon(M3EIcons.arrowForward),
              onPressed: () {},
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
            M3EActions.splitButton(
              label: 'Save',
              leadingIcon: const Icon(M3EIcons.check),
              onPressed: () {},
              onMenuPressed: () {},
            ),
          ],
        ),
      ],
    );
  }
}
