/// This is the interface file for project.g.dart
/// Import this file rather than importing project.g.dart directly

export 'package:katikati_ui_lib/datatypes/project.g.dart';

// Add hand coded adjustments and modifications here rather than modifying the generated file.

import 'dart:convert';

import 'package:katikati_ui_lib/datatypes/project.g.dart';

class ProjectConfigurationFieldInfo {
  String name;
  String description;
  String Function(Project) getter;
  void Function(Project, String) setter;

  ProjectConfigurationFieldInfo(this.name, this.description, this.getter, this.setter);
}

final projectConfigurationInfo = [
  ProjectConfigurationFieldInfo(
      "Project name",
      "The project name as it will appear in the title and project selector.",
      (Project project) => project.projectName,
      (Project project, value) => project.projectName = value),

  ProjectConfigurationFieldInfo(
      "First language",
      """The first language used by this project.
Use shortened version as this appear better within the UI, e.g. "en" for English.""",
      (Project project) => project.firstLanguage,
      (Project project, value) => project.firstLanguage = value),

  ProjectConfigurationFieldInfo(
      "Second language",
      """The second language used by this project. If empty, the second button won't appear.
Use shortened version as this appear better within the UI, e.g. "en" for English.""",
      (Project project) => project.secondLanguage,
      (Project project, value) => project.secondLanguage = value),

  ProjectConfigurationFieldInfo(
      "Message characters limit",
      """The number of characters to which messages should be restricted to.
For example, 160 is the maximum number of characters in an SMS, while a message in telegram needs to be smaller than 4096.""",
      (Project project) => project.messageCharacterLimit.toString(),
      (Project project, value) => project.messageCharacterLimit = int.parse(value)),

  ProjectConfigurationFieldInfo(
      "Allowed email domains",
      """Use to restrict login domains (by default, all domains are allowed).
Expected format: {"<domain_name>": "<domain_url>"[, ...]}
For example: {"Katikati": "katikati.world", "Gmail": "gmail.com"}""",
      (Project project) => project.allowedEmailDomainsMap == null || project.allowedEmailDomainsMap.isEmpty
          ? ""
          : json.encode(project.allowedEmailDomainsMap),
      (Project project, value) => value == null || value.isEmpty
          ? project.allowedEmailDomainsMap = <String, String>{}
          : project.allowedEmailDomainsMap = Map<String, String>.from(json.decode(value))),
];
