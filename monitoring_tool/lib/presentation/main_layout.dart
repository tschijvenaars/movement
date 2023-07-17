import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:monitoring_tool/presentation/settings_page.dart';

import '../providers.dart';
import 'app_navigation.dart';
import 'device_page.dart';
import 'errorlog_page.dart';
import 'home_page.dart';
import 'responsive.dart';
import 'signup_page.dart';

class MainLayout extends ConsumerWidget {
  final _pages = <Widget>[GeneralOverview(), ErrorLogOverview(), DeviceOverview(), SignUpOverview(), SettingsOverview()];

  MainLayout({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Responsive(
      mobile: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //const TopAppBar(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Consumer(builder: (context, ref, child) {
                final notifier = ref.watch(appNavigationNotifier);
                return Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      color: Colors.grey,
                    ),
                    width: MediaQuery.of(context).size.width,
                    child: _pages[notifier.currentPage]);
              }),
            ),
          ),
          NavigationPanel(
            axis: Axis.horizontal,
          ),
        ],
      ),
      desktop: Row(
        children: [
          NavigationPanel(
            axis: Axis.vertical,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20.0, right: 10.0, bottom: 20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //const SizedBox(height: 100, child: TopAppBar()),
                Expanded(
                  child: Consumer(builder: (context, ref, child) {
                    final notifier = ref.watch(appNavigationNotifier);
                    return Container(
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        color: Colors.grey,
                      ),
                      width: MediaQuery.of(context).size.width - 120.0,
                      child: _pages[notifier.currentPage],
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
