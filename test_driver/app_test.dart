import 'package:flutter_driver/flutter_driver.dart';
import 'package:flutter_sandbox/models/demo_names.dart';
import 'package:test/test.dart';

void main() {
  FlutterDriver driver;
  // Connect to the FlutterDriver
  setUpAll(() async {
    driver = await FlutterDriver.connect();
  });
  // After tests are done, close the driver
  tearDownAll(() async {
    if (driver != null) {
      await driver.close();
    }
  });
  group('Dismissible Demo Test', () {
    // Find Dismissible demo card
    final findDimissibleCard = find.text('Dismissible');
    // Run tests
    test('Tapping Dismissible demo card navigates to Dismissible demo page',
        () async {
      await driver.tap(findDimissibleCard);
      final findDismissibleTile = find.byValueKey('dismissible_1_text');
      expect(await driver.getText(findDismissibleTile),
          'Swipe to dismiss (basic)');
      // Tap the back arrow to get back to home page
      await driver.tap(find.byTooltip('Back'));
    });
  });
  group('HomePage Test', () {
    // Find the vertical scroll list
    final findCategoryList = find.byValueKey('widget_category_list');
    final demoNames = DemoNames.allDemos;
    test('Verify that the category list contains all demo pages', () async {
      // Record a performance timeline as the app performs scrolling actions
      final timeline = await driver.traceAction(() async {
        // Verify that the category list contains all subcategories
        for (final category in demoNames.keys) {
          final findCategory = find.text(category);
          await driver.scrollUntilVisible(findCategoryList, findCategory,
              dyScroll: -50);
          expect(await driver.getText(findCategory), category);
          // Verify that each subcategory list contains all demo pages
          final demoPages = demoNames[category];
          final findDemoList = find.byValueKey(category + '_demos_list');
          for (final demo in demoPages) {
            final findDemo = find.text(demo);
            await driver.scrollUntilVisible(findDemoList, findDemo,
                dxScroll: 50);
            expect(await driver.getText(findDemo), demo);
          }
        }
      });
      // Convert timeline to easily readible summary
      final summary = TimelineSummary.summarize(timeline);
      // Write the summary to file
      await summary.writeSummaryToFile('homepage_scrolling', pretty: true);
      // Also write the entire JSON timeline to file
      await summary.writeTimelineToFile('homepage_scrolling', pretty: true);
    });
  });
  group('TodoListPage Test', () {
    // Find TodoList demo card
    final findTodoListDemo = find.text('BLoC');
    final task = 'This is sample task';
    test('Add items to TodoList', () async {
      await driver.tap(findTodoListDemo);
      await driver.tap(find.byType('TextField'));
      for (var i = 0; i < 20; i++) {
        await driver.enterText('$task $i');
        await driver.waitFor(find.text('$task $i'));
        await driver.tap(find.byValueKey('add_task_button'));
      }
    });
    test('Scroll through list of tasks', () async {
      await driver.scrollUntilVisible(
          find.byValueKey('task_list'), find.text('$task 18'),
          dyScroll: -50);
    });
  });
}
