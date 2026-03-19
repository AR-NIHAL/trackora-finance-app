import 'package:flutter/material.dart';
import '../../../../shared/widgets/primary_card.dart';

class SettingsTile extends StatelessWidget {
  final String title;
  final Widget trailing;

  const SettingsTile({super.key, required this.title, required this.trailing});

  @override
  Widget build(BuildContext context) {
    return PrimaryCard(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(title), trailing],
      ),
    );
  }
}
