import 'package:meta/meta.dart';

class MasterItem {
  MasterItem({
    @required this.title,
    @required this.subtitle,
    @required this.withCreateButton,
  });

  final String title;
  final String subtitle;
  final bool withCreateButton;
}

final List<MasterItem> items = <MasterItem>[
  MasterItem(
    title: 'Create User',
    subtitle: 'Creating User',
    withCreateButton: true,
  ),
  MasterItem(
      title: 'Create Event',
      subtitle: 'Creating Event',
      withCreateButton: true),
  MasterItem(
      title: 'Events', subtitle: 'Listing Events', withCreateButton: false),
  MasterItem(
      title: 'Users', subtitle: 'Displaying Users', withCreateButton: false),
  MasterItem(
      title: 'Orders', subtitle: 'Displaying Orders', withCreateButton: false),
];
