//IGNORE FILE FOR REVIEW AS THIS IS FOR DEV

import 'package:flutter/material.dart';
import 'package:let_log/let_log.dart';

import 'widgets/api_log_widget.dart';

/// DevScreen
class DevScreen extends StatelessWidget {
  const DevScreen({
    Key? key,
    this.optionalWidget,
    this.headerData,
  }) : super(key: key);

  final Widget? optionalWidget;
  final Widget? headerData;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          titleSpacing: 0,
          title: const TabBar(
            tabs: [
              Tab(child: Text("OPTIONS")),
              Tab(child: Text("LOGS")),
              Tab(child: Text("APIS")),
            ],
          ),
          elevation: 0,
        ),
        body: Column(
          children: [
            headerData ?? const SizedBox(),
            Flexible(
              child: TabBarView(
                children: [
                  optionalWidget ?? _buildOptions(),
                  const LogWidget(),
                  const ApiLogsWidget(),
                ],
              ),
            ),
            const SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptions() {
    return const Center(
      child: Text("Build Options"),
    );
  }
}
