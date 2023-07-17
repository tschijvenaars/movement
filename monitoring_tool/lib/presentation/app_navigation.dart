import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/enums/menu_items.dart';
import '../providers.dart';
import 'widgets/elements/app_navigation_item.dart';

class NavigationPanel extends ConsumerWidget {
  final Axis axis;

  NavigationPanel({Key? key, required this.axis}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Consumer(builder: (context, ref, child) {
      final notifier = ref.watch(appNavigationNotifier);
      return Container(
        constraints: const BoxConstraints(minWidth: 80),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        margin:
            const EdgeInsets.all(10), // Responsive.isDesktop(context) ? const EdgeInsets.symmetric(horizontal: 30, vertical: 20) : const EdgeInsets.all(10),
        child: axis == Axis.vertical
            ? Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Image.asset("cbs_logo.png", height: 50),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: NavigationItems.values
                        .map(
                          (e) => NavigationButton(
                            onPressed: () {
                              notifier.setPage(e.index);
                            },
                            icon: e.icon,
                            toolTipText: e.name,
                            isActive: e.index == notifier.currentPage,
                          ),
                        )
                        .toList(),
                  ),
                  Container()
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Image.asset("cbs_logo.png", height: 20),
                  Row(
                    children: NavigationItems.values
                        .map(
                          (e) => NavigationButton(
                            onPressed: () {
                              notifier.setPage(e.index);
                            },
                            icon: e.icon,
                            toolTipText: e.name,
                            isActive: e.index == notifier.currentPage,
                          ),
                        )
                        .toList(),
                  ),
                  Container()
                ],
              ),
      );
    });
  }
}
