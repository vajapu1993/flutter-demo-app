import 'dart:convert';
import 'dart:io';

import 'package:gherkin/gherkin.dart';
import 'package:http/http.dart' as http;

class GetStatus extends Hook {
  Map<String, String> scenarios = new Map();
  String status = "fail";

  /// Run after a step has executed
  @override
  Future<void> onAfterStep(World world, String step, StepResult stepResult) async {
    if (stepResult.result == StepExecutionResult.fail) {
      status = "fail";
    } else if (stepResult.result == StepExecutionResult.pass) {
      status = "pass";
    } else if (stepResult.result == StepExecutionResult.skipped) {
      status = "skipped";
    }
  }

  /// Run after a scenario has executed
  @override
  Future<void> onAfterScenario(
    TestConfiguration config,
    String scenario,
    Iterable<Tag> tags,
  ) {
    scenarios.putIfAbsent(scenario, () => status);
  }

  @override
  Future<void> onAfterRun(TestConfiguration config) async {
    // File file = new File('../reports/my_file.txt');
    // file.writeAsString("hello");
    int fail = 0, pass = 0, skipped = 0;
    for (String v in scenarios.keys) {
      if (scenarios[v] == "fail") {
        ++fail;
      } else if (scenarios[v]  == "pass") {
        ++pass;
      } else if (scenarios[v]  == "skipped") {
        ++skipped;
      }
    }
    // final reportPath = "./test_driver/reports";
    // new Directory(reportPath).create(recursive: true);
    // File file = new File('${reportPath}/status.txt');
    // await file.writeAsString('');
    await http.post(
      'https://outlook.office.com/webhook/0014f1e9-7208-4810-adf0-91c2ad2a033c@e89cb837-f118-407d-98fe-4c32b11a8ab9/IncomingWebhook/f6cfbe7aa73c4afdb0c3ad874f80c31f/41880cbe-c55f-4640-9fe5-f54c9366101e',
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        "@type": "MessageCard",
        "@context": "http://schema.org/extensions",
        "themeColor": "0076D7",
        "summary": "Larry Bryant created a new task",
        "sections": [
          {
            "activityTitle": "![TestImage](https://pbs.twimg.com/profile_images/1034823190659379200/x6fwUdFD_400x400.jpg)Created Build",
            "activitySubtitle": "On Azure",
            "activityImage": "https://pbs.twimg.com/profile_images/1034823190659379200/x6fwUdFD_400x400.jpg",
            "facts": [
              {"name": "More Info", "value": "https://dev.azure.com/UdayaVajapu/Bottomline/_build/results?buildId=${Platform.environment['Build.BuildId']}&view=results"},
              {"name": "Pass", "value": "${pass}"},
              {"name": "Fail", "value": "${fail}"},
              {"name": "Skipped", "value": "${skipped}"}
            ],
            "markdown": true
          }
        ]
      }),
    );
  }
}
