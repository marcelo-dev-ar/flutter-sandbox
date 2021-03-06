import 'package:flutter/material.dart';
import 'package:flutter_sandbox/common/constants/app_padding.dart';
import 'package:flutter_sandbox/common/constants/app_text.dart';
import 'package:flutter_sandbox/common/constants/app_theme.dart';

class DemoScaffold extends StatelessWidget {
  final String title;
  final List<Widget> widgets;
  final FloatingActionButton floatingActionButton;
  final bool isScrollable;

  const DemoScaffold({
    Key key,
    this.title,
    this.widgets,
    this.floatingActionButton,
    this.isScrollable = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.theme.canvasColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppTheme.theme.canvasColor,
        iconTheme: IconThemeData(
          color: AppTheme.theme.primaryColorDark,
        ),
        title: Text(
          title,
          style: AppText.appBar,
        ),
      ),
      body: Padding(
        padding: AppPadding.padding16,
        child: isScrollable
            ? ListView(
                children: widgets,
              )
            : Column(
                children: widgets,
              ),
      ),
      floatingActionButton: floatingActionButton,
    );
  }
}
