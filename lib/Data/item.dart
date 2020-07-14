import 'package:meta/meta.dart';

class Item {
  Item({
    @required this.title,
    @required this.subtitle,
    this.withButton = false,
  });

  final String title;
  final String subtitle;
  bool withButton = false;
}

final List<Item> items = <Item>[
  Item(
    title: 'Create User',
    subtitle: 'Creating User',
    withButton: true,
  ),
  Item(
    title: 'Create Event',
    subtitle: 'Creating Event',
    withButton: true
  ),
  Item(
    title: 'Events',
    subtitle: 'Listing Events',
    withButton: false
  ),
  Item(
    title: 'Users',
    subtitle: 'Displaying Users',
  ),
  Item(
    title: 'Orders',
    subtitle: 'Displaying Orders',
  ),
];