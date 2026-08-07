// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static String m0(count) =>
      "${Intl.plural(count, one: '1 day ago', other: '${count} days ago')}";

  static String m1(label) =>
      "Are you sure you want to delete the selected ${label}?";

  static String m2(label) =>
      "Are you sure you want to delete the current ${label}?";

  static String m3(label) => "${label} details";

  static String m4(label) => "${label} cannot be empty";

  static String m5(label) => "Current ${label} already exists";

  static String m6(count) =>
      "${Intl.plural(count, one: '1 hour ago', other: '${count} hours ago')}";

  static String m7(target) => "${target} is an invalid policy";

  static String m8(proxyName) => "${proxyName} is an invalid proxy";

  static String m9(providerName) =>
      "${providerName} is an invalid proxy provider";

  static String m10(subRule) => "${subRule} is an invalid SUB_RULE";

  static String m11(appName) =>
      "1. Open System Settings > Privacy & Security\n2. Choose Location Services\n3. Find and check ${appName} in the right list\n\nAfter completing the setup, return to the app and use it normally. Thank you for your cooperation.";

  static String m12(count) =>
      "${Intl.plural(count, one: '1 minute ago', other: '${count} minutes ago')}";

  static String m13(count) =>
      "${Intl.plural(count, one: '1 month ago', other: '${count} months ago')}";

  static String m14(label) => "No ${label} yet";

  static String m15(label) => "${label} must be a number";

  static String m16(label) => "${label} must be between 1024 and 49151";

  static String m17(count) => "${count} items have been selected";

  static String m18(label) => "${label} must be a url";

  static String m19(p0) => "Activation failed: ${p0}";

  static String m20(p0) => "Available commission: ${p0}";

  static String m21(p0) => "Buy now ${p0}";

  static String m22(p0) => "Cancel the order \"${p0}\"?";

  static String m23(p0) => "${p0} copied";

  static String m24(p0) => "Current balance: ${p0}";

  static String m25(p0) => "Current plan: ${p0} · ";

  static String m26(p0) => "Current plan: ${p0}";

  static String m27(p0, p1, p2) => "Device: ${p0} ${p1} · Android ${p2}";

  static String m28(p0) => "Duration ${p0}";

  static String m29(p0) => "${p0} expired";

  static String m30(p0, p1) =>
      "${p0}\\n\\n=== Diagnostics (attached automatically) ===\\n${p1}";

  static String m31(p0) => "From ${p0}";

  static String m32(p0) =>
      "${p0}; traffic is still carried by System Proxy (compatibility mode).";

  static String m33(p0) => "Last updated · today ${p0}";

  static String m34(p0, p1) => "Last updated · ${p0} ${p1}";

  static String m35(p0) => "Loading failed: ${p0}";

  static String m36(p0, p1) => "Loading failed: ${p0} (code ${p1})";

  static String m37(p0) =>
      "Local environment is healthy; Voguesly is in control via ${p0}.";

  static String m38(p0) =>
      "The local port is held by ${p0}, so the Voguesly core may fail to bind — consider switching to another port.";

  static String m39(p0) => "Local port ${p0}";

  static String m40(p0) => "${p0} billing cycles available";

  static String m41(p0) => "${p0} days";

  static String m42(p0) => "${p0} months";

  static String m43(p0) => "${p0} people";

  static String m44(p0) => "${p0} years";

  static String m45(p0) => "Network error: ${p0}";

  static String m46(p0) => "Version ${p0} available";

  static String m47(p0) => "Could not place the order: ${p0}";

  static String m48(p0) => "Order no.: ${p0}";

  static String m49(p0) =>
      "Another proxy is running (${p0}). Close it before connecting Voguesly.";

  static String m50(p0) =>
      "Another proxy is running (${p0}). Voguesly\'s TUN will stay off this time.";

  static String m51(p0) => "Could not start the payment: ${p0}";

  static String m52(p0) => "Your plan allows ${p0} simultaneous devices;";

  static String m53(p0) => "Points to Voguesly · ${p0}";

  static String m54(p0, p1) =>
      "${p0} is holding ${p1}, so the Voguesly core cannot bind — this is exactly the \"shows connected but no internet\"";

  static String m55(p0) =>
      "Public traffic is going through ${p0}, which is not Voguesly\'s virtual NIC — ";

  static String m56(p0) => "Sending failed: ${p0}";

  static String m57(p0) => "Speed limit ${p0} Mbps";

  static String m58(p0) => "Submission failed: ${p0}";

  static String m59(p0) => "${p0} (compatibility)";

  static String m60(p0, p1) =>
      "A machine has only one system proxy setting and the last writer wins — right now it points to ${p0}, not Voguesly\'s ${p1}.";

  static String m61(p0) => "Taken by another app · ${p0}";

  static String m62(p0) => "Occupied by another process · ${p0}";

  static String m63(p0) => "Tap to disconnect  ·  ${p0}";

  static String m64(p0) =>
      "${p0}; System Proxy (compatibility mode) has been enabled temporarily to keep you online.";

  static String m65(p0) => "Ticket #${p0}";

  static String m66(p0) => "Data ${p0} GB";

  static String m67(p0) => "${p0} (device-wide)";

  static String m68(p0, p1) => "Version: ${p0}+${p1}";

  static String m69(p0) => "Version: ${p0}";

  static String m70(p0) => "v${p0} · tap to check for updates";

  static String m71(p0) => "Voguesly in control · ${p0}";

  static String m72(p0) => "WebView failed to initialise: ${p0}";

  static String m73(count) =>
      "${Intl.plural(count, one: '1 year ago', other: '${count} years ago')}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "about": MessageLookupByLibrary.simpleMessage("About"),
    "accessControl": MessageLookupByLibrary.simpleMessage("AccessControl"),
    "accessControlAllowDesc": MessageLookupByLibrary.simpleMessage(
      "Only allow selected app to enter VPN",
    ),
    "accessControlDesc": MessageLookupByLibrary.simpleMessage(
      "Configure application access proxy",
    ),
    "accessControlNotAllowDesc": MessageLookupByLibrary.simpleMessage(
      "The selected application will be excluded from VPN",
    ),
    "accessControlSettings": MessageLookupByLibrary.simpleMessage(
      "Access Control Settings",
    ),
    "account": MessageLookupByLibrary.simpleMessage("Account"),
    "action": MessageLookupByLibrary.simpleMessage("Action"),
    "action_mode": MessageLookupByLibrary.simpleMessage("Switch mode"),
    "action_proxy": MessageLookupByLibrary.simpleMessage("System proxy"),
    "action_start": MessageLookupByLibrary.simpleMessage("Start/Stop"),
    "action_tun": MessageLookupByLibrary.simpleMessage("TUN"),
    "action_view": MessageLookupByLibrary.simpleMessage("Show/Hide"),
    "add": MessageLookupByLibrary.simpleMessage("Add"),
    "addProfile": MessageLookupByLibrary.simpleMessage("Add Profile"),
    "addProxies": MessageLookupByLibrary.simpleMessage("Add proxies"),
    "addProxyGroup": MessageLookupByLibrary.simpleMessage("Add proxy group"),
    "addProxyProviders": MessageLookupByLibrary.simpleMessage(
      "Add proxy providers",
    ),
    "addRule": MessageLookupByLibrary.simpleMessage("Add rule"),
    "addSsid": MessageLookupByLibrary.simpleMessage("Add SSID"),
    "addedRules": MessageLookupByLibrary.simpleMessage("Added rules"),
    "additionalParameters": MessageLookupByLibrary.simpleMessage(
      "Additional parameters",
    ),
    "address": MessageLookupByLibrary.simpleMessage("Address"),
    "addressHelp": MessageLookupByLibrary.simpleMessage(
      "WebDAV server address",
    ),
    "addressTip": MessageLookupByLibrary.simpleMessage(
      "Please enter a valid WebDAV address",
    ),
    "advancedConfig": MessageLookupByLibrary.simpleMessage(
      "Advanced configuration",
    ),
    "advancedConfigDesc": MessageLookupByLibrary.simpleMessage(
      "Provide diverse configuration options",
    ),
    "advancedTools": MessageLookupByLibrary.simpleMessage("Advanced"),
    "agree": MessageLookupByLibrary.simpleMessage("Agree"),
    "allowBypass": MessageLookupByLibrary.simpleMessage(
      "Allow applications to bypass VPN",
    ),
    "allowBypassDesc": MessageLookupByLibrary.simpleMessage(
      "Some apps can bypass VPN when turned on",
    ),
    "allowLan": MessageLookupByLibrary.simpleMessage("AllowLan"),
    "allowLanDesc": MessageLookupByLibrary.simpleMessage(
      "Allow access proxy through the LAN",
    ),
    "app": MessageLookupByLibrary.simpleMessage("App"),
    "appAccessControl": MessageLookupByLibrary.simpleMessage(
      "App access control",
    ),
    "appendSystemDns": MessageLookupByLibrary.simpleMessage(
      "Append System DNS",
    ),
    "appendSystemDnsTip": MessageLookupByLibrary.simpleMessage(
      "Forcefully append system DNS to the configuration",
    ),
    "application": MessageLookupByLibrary.simpleMessage("Application"),
    "applicationDesc": MessageLookupByLibrary.simpleMessage(
      "Modify application related settings",
    ),
    "authorized": MessageLookupByLibrary.simpleMessage("Authorized"),
    "auto": MessageLookupByLibrary.simpleMessage("Auto"),
    "autoCheckUpdate": MessageLookupByLibrary.simpleMessage(
      "Auto check updates",
    ),
    "autoCheckUpdateDesc": MessageLookupByLibrary.simpleMessage(
      "Auto check for updates when the app starts",
    ),
    "autoCloseConnections": MessageLookupByLibrary.simpleMessage(
      "Auto close connections",
    ),
    "autoCloseConnectionsDesc": MessageLookupByLibrary.simpleMessage(
      "Auto close connections after change node",
    ),
    "autoLaunch": MessageLookupByLibrary.simpleMessage("Auto launch"),
    "autoLaunchDesc": MessageLookupByLibrary.simpleMessage(
      "Follow the system self startup",
    ),
    "autoRun": MessageLookupByLibrary.simpleMessage("AutoRun"),
    "autoRunDesc": MessageLookupByLibrary.simpleMessage(
      "Auto run when the application is opened",
    ),
    "autoSetSystemDns": MessageLookupByLibrary.simpleMessage(
      "Auto set system DNS",
    ),
    "autoUpdate": MessageLookupByLibrary.simpleMessage("Auto update"),
    "autoUpdateInterval": MessageLookupByLibrary.simpleMessage(
      "Auto update interval (minutes)",
    ),
    "backup": MessageLookupByLibrary.simpleMessage("Backup"),
    "backupAndRestore": MessageLookupByLibrary.simpleMessage(
      "Backup and Restore",
    ),
    "backupAndRestoreDesc": MessageLookupByLibrary.simpleMessage(
      "Sync data via WebDAV or files",
    ),
    "backupSuccess": MessageLookupByLibrary.simpleMessage("Backup success"),
    "basicConfig": MessageLookupByLibrary.simpleMessage("Basic configuration"),
    "basicConfigDesc": MessageLookupByLibrary.simpleMessage(
      "Modify the basic configuration globally",
    ),
    "basicInfo": MessageLookupByLibrary.simpleMessage("Basic info"),
    "basicStrategy": MessageLookupByLibrary.simpleMessage("Basic strategy"),
    "batteryOptimizationDesc": MessageLookupByLibrary.simpleMessage(
      "To ensure background operation, please disable battery optimization for this app. Tap to go to settings.",
    ),
    "batteryOptimizationStatusTip": MessageLookupByLibrary.simpleMessage(
      "Affected by the system, this status may not always be accurate.",
    ),
    "bind": MessageLookupByLibrary.simpleMessage("Bind"),
    "blacklistMode": MessageLookupByLibrary.simpleMessage("Blacklist mode"),
    "bypassDomain": MessageLookupByLibrary.simpleMessage("Bypass domain"),
    "bypassDomainDesc": MessageLookupByLibrary.simpleMessage(
      "Only takes effect when the system proxy is enabled",
    ),
    "cacheCorrupt": MessageLookupByLibrary.simpleMessage(
      "The cache is corrupt. Do you want to clear it?",
    ),
    "cancel": MessageLookupByLibrary.simpleMessage("Cancel"),
    "cancelSelectAll": MessageLookupByLibrary.simpleMessage(
      "Cancel select all",
    ),
    "checkUpdate": MessageLookupByLibrary.simpleMessage("Check for updates"),
    "checkUpdateError": MessageLookupByLibrary.simpleMessage(
      "The current application is already the latest version",
    ),
    "clearData": MessageLookupByLibrary.simpleMessage("Clear Data"),
    "clipboardExport": MessageLookupByLibrary.simpleMessage("Export clipboard"),
    "clipboardImport": MessageLookupByLibrary.simpleMessage("Clipboard import"),
    "color": MessageLookupByLibrary.simpleMessage("Color"),
    "colorSchemes": MessageLookupByLibrary.simpleMessage("Color schemes"),
    "columns": MessageLookupByLibrary.simpleMessage("Columns"),
    "compatible": MessageLookupByLibrary.simpleMessage("Compatibility mode"),
    "configDataDetected": MessageLookupByLibrary.simpleMessage(
      "Data detected in configuration",
    ),
    "confirm": MessageLookupByLibrary.simpleMessage("Confirm"),
    "confirmClearAllData": MessageLookupByLibrary.simpleMessage(
      "Are you sure you want to clear all data?",
    ),
    "confirmDeleteProxyGroup": MessageLookupByLibrary.simpleMessage(
      "Are you sure you want to delete the current proxy group?",
    ),
    "confirmExitWindow": MessageLookupByLibrary.simpleMessage(
      "Are you sure you want to exit the current window?",
    ),
    "confirmForceCrashCore": MessageLookupByLibrary.simpleMessage(
      "Are you sure you want to force crash the core?",
    ),
    "confirmOverwriteTip": MessageLookupByLibrary.simpleMessage(
      "Existing data will be overwritten after confirmation",
    ),
    "connected": MessageLookupByLibrary.simpleMessage("Connected"),
    "connecting": MessageLookupByLibrary.simpleMessage("Connecting..."),
    "connection": MessageLookupByLibrary.simpleMessage("Connection"),
    "connections": MessageLookupByLibrary.simpleMessage("Connections"),
    "connectionsDesc": MessageLookupByLibrary.simpleMessage(
      "View current connections data",
    ),
    "connectivity": MessageLookupByLibrary.simpleMessage("Connectivity："),
    "content": MessageLookupByLibrary.simpleMessage("Content"),
    "contentNotEmpty": MessageLookupByLibrary.simpleMessage(
      "Content cannot be empty",
    ),
    "contentScheme": MessageLookupByLibrary.simpleMessage("Content"),
    "controlGlobalAddedRules": MessageLookupByLibrary.simpleMessage(
      "Control global added rules",
    ),
    "copy": MessageLookupByLibrary.simpleMessage("Copy"),
    "copyEnvVar": MessageLookupByLibrary.simpleMessage(
      "Copying environment variables",
    ),
    "copyLink": MessageLookupByLibrary.simpleMessage("Copy link"),
    "copySuccess": MessageLookupByLibrary.simpleMessage("Copy success"),
    "core": MessageLookupByLibrary.simpleMessage("Core"),
    "coreStatus": MessageLookupByLibrary.simpleMessage("Core status"),
    "country": MessageLookupByLibrary.simpleMessage("Country"),
    "crashTest": MessageLookupByLibrary.simpleMessage("Crash test"),
    "crashlytics": MessageLookupByLibrary.simpleMessage("Crash Analysis"),
    "crashlyticsTip": MessageLookupByLibrary.simpleMessage(
      "When enabled, automatically uploads crash logs without sensitive information when the app crashes",
    ),
    "create": MessageLookupByLibrary.simpleMessage("Create"),
    "createProfile": MessageLookupByLibrary.simpleMessage("Create Profile"),
    "creationTime": MessageLookupByLibrary.simpleMessage("Creation time"),
    "custom": MessageLookupByLibrary.simpleMessage("Custom"),
    "cut": MessageLookupByLibrary.simpleMessage("Cut"),
    "dark": MessageLookupByLibrary.simpleMessage("Dark"),
    "dashboard": MessageLookupByLibrary.simpleMessage("Dashboard"),
    "dataChangedSave": MessageLookupByLibrary.simpleMessage(
      "Data changes detected, do you want to save?",
    ),
    "dataCollectionContent": MessageLookupByLibrary.simpleMessage(
      "This app uses Firebase Crashlytics to collect crash information to improve app stability.\nThe collected data includes device information and crash details, but does not contain personal sensitive data.\nYou can disable this feature in settings.",
    ),
    "dataCollectionTip": MessageLookupByLibrary.simpleMessage(
      "Data Collection Notice",
    ),
    "daysAgo": m0,
    "defaultNameserver": MessageLookupByLibrary.simpleMessage(
      "Default nameserver",
    ),
    "defaultNameserverDesc": MessageLookupByLibrary.simpleMessage(
      "For resolving DNS server",
    ),
    "defaultText": MessageLookupByLibrary.simpleMessage("Default"),
    "delay": MessageLookupByLibrary.simpleMessage("Delay"),
    "delayTest": MessageLookupByLibrary.simpleMessage("Delay Test"),
    "delete": MessageLookupByLibrary.simpleMessage("Delete"),
    "deleteMultipTip": m1,
    "deleteTip": m2,
    "desc": MessageLookupByLibrary.simpleMessage(
      "A multi-platform proxy client based on ClashMeta, simple and easy to use, open-source and ad-free.",
    ),
    "destination": MessageLookupByLibrary.simpleMessage("Destination"),
    "destinationGeoIP": MessageLookupByLibrary.simpleMessage(
      "Destination GeoIP",
    ),
    "destinationIPASN": MessageLookupByLibrary.simpleMessage(
      "Destination IPASN",
    ),
    "details": m3,
    "detectionTip": MessageLookupByLibrary.simpleMessage(
      "Relying on third-party api is for reference only",
    ),
    "developerMode": MessageLookupByLibrary.simpleMessage("Developer mode"),
    "developerModeEnableTip": MessageLookupByLibrary.simpleMessage(
      "Developer mode is enabled.",
    ),
    "direct": MessageLookupByLibrary.simpleMessage("Direct"),
    "disableUDP": MessageLookupByLibrary.simpleMessage("Disable UDP"),
    "disclaimer": MessageLookupByLibrary.simpleMessage("Disclaimer"),
    "disclaimerDesc": MessageLookupByLibrary.simpleMessage(
      "This software is only used for non-commercial purposes such as learning exchanges and scientific research. It is strictly prohibited to use this software for commercial purposes. Any commercial activity, if any, has nothing to do with this software.",
    ),
    "disconnected": MessageLookupByLibrary.simpleMessage("Disconnected"),
    "discoverNewVersion": MessageLookupByLibrary.simpleMessage(
      "Discover the new version",
    ),
    "dnsDesc": MessageLookupByLibrary.simpleMessage(
      "Update DNS related settings",
    ),
    "dnsHijacking": MessageLookupByLibrary.simpleMessage("DNS hijacking"),
    "dnsMode": MessageLookupByLibrary.simpleMessage("DNS mode"),
    "doYouWantToPass": MessageLookupByLibrary.simpleMessage(
      "Do you want to pass",
    ),
    "domain": MessageLookupByLibrary.simpleMessage("Domain"),
    "download": MessageLookupByLibrary.simpleMessage("Download"),
    "edit": MessageLookupByLibrary.simpleMessage("Edit"),
    "editGlobalRules": MessageLookupByLibrary.simpleMessage(
      "Edit global rules",
    ),
    "editProxy": MessageLookupByLibrary.simpleMessage("Edit proxy"),
    "editProxyGroup": MessageLookupByLibrary.simpleMessage("Edit proxy group"),
    "editRule": MessageLookupByLibrary.simpleMessage("Edit rule"),
    "editSsid": MessageLookupByLibrary.simpleMessage("Edit SSID"),
    "emptyTip": m4,
    "en": MessageLookupByLibrary.simpleMessage("English"),
    "entries": MessageLookupByLibrary.simpleMessage(" entries"),
    "exclude": MessageLookupByLibrary.simpleMessage("Hidden from recent tasks"),
    "excludeDesc": MessageLookupByLibrary.simpleMessage(
      "When the app is in the background, the app is hidden from the recent task",
    ),
    "excludeProxyFilter": MessageLookupByLibrary.simpleMessage(
      "Exclude proxy filter",
    ),
    "excludeSsids": MessageLookupByLibrary.simpleMessage("Exclude SSIDs"),
    "excludeSsidsDesc": MessageLookupByLibrary.simpleMessage(
      "When connected to an excluded SSID Wi-Fi, the app running state will be automatically switched.",
    ),
    "excludeType": MessageLookupByLibrary.simpleMessage("Exclude type"),
    "existsTip": m5,
    "exit": MessageLookupByLibrary.simpleMessage("Exit"),
    "expand": MessageLookupByLibrary.simpleMessage("Standard"),
    "expectedStatus": MessageLookupByLibrary.simpleMessage("Expected status"),
    "exportFile": MessageLookupByLibrary.simpleMessage("Export file"),
    "exportLogs": MessageLookupByLibrary.simpleMessage("Export logs"),
    "exportSuccess": MessageLookupByLibrary.simpleMessage("Export Success"),
    "expressiveScheme": MessageLookupByLibrary.simpleMessage("Expressive"),
    "externalController": MessageLookupByLibrary.simpleMessage(
      "ExternalController",
    ),
    "externalControllerDesc": MessageLookupByLibrary.simpleMessage(
      "Once enabled, the Clash kernel can be controlled on port 9090",
    ),
    "externalFetch": MessageLookupByLibrary.simpleMessage("External fetch"),
    "externalLink": MessageLookupByLibrary.simpleMessage("External link"),
    "fakeipFilter": MessageLookupByLibrary.simpleMessage("Fakeip filter"),
    "fakeipRange": MessageLookupByLibrary.simpleMessage("Fakeip range"),
    "fallback": MessageLookupByLibrary.simpleMessage("Fallback"),
    "fallbackDesc": MessageLookupByLibrary.simpleMessage(
      "Generally use offshore DNS",
    ),
    "fallbackFilter": MessageLookupByLibrary.simpleMessage("Fallback filter"),
    "fidelityScheme": MessageLookupByLibrary.simpleMessage("Fidelity"),
    "file": MessageLookupByLibrary.simpleMessage("File"),
    "fileDesc": MessageLookupByLibrary.simpleMessage("Directly upload profile"),
    "fileIsUpdate": MessageLookupByLibrary.simpleMessage(
      "The file has been modified. Do you want to save the changes?",
    ),
    "findProcessMode": MessageLookupByLibrary.simpleMessage("Find process"),
    "findProcessModeDesc": MessageLookupByLibrary.simpleMessage(
      "There is a certain performance loss after opening",
    ),
    "fontFamily": MessageLookupByLibrary.simpleMessage("FontFamily"),
    "forceRestartCoreTip": MessageLookupByLibrary.simpleMessage(
      "Are you sure you want to force restart the core?",
    ),
    "fruitSaladScheme": MessageLookupByLibrary.simpleMessage("FruitSalad"),
    "general": MessageLookupByLibrary.simpleMessage("General"),
    "geodataLoader": MessageLookupByLibrary.simpleMessage(
      "Geo Low Memory Mode",
    ),
    "geodataLoaderDesc": MessageLookupByLibrary.simpleMessage(
      "Enabling will use the Geo low memory loader",
    ),
    "geoipCode": MessageLookupByLibrary.simpleMessage("Geoip code"),
    "global": MessageLookupByLibrary.simpleMessage("Global"),
    "go": MessageLookupByLibrary.simpleMessage("Go"),
    "goDownload": MessageLookupByLibrary.simpleMessage("Go to download"),
    "goToConfigureScript": MessageLookupByLibrary.simpleMessage(
      "Go to configure script",
    ),
    "hasCacheChange": MessageLookupByLibrary.simpleMessage(
      "Do you want to cache the changes?",
    ),
    "hideFromList": MessageLookupByLibrary.simpleMessage("Hide from list"),
    "host": MessageLookupByLibrary.simpleMessage("Host"),
    "hostsDesc": MessageLookupByLibrary.simpleMessage("Add Hosts"),
    "hotkeyConflict": MessageLookupByLibrary.simpleMessage("Hotkey conflict"),
    "hotkeyManagement": MessageLookupByLibrary.simpleMessage(
      "Hotkey Management",
    ),
    "hotkeyManagementDesc": MessageLookupByLibrary.simpleMessage(
      "Use keyboard to control applications",
    ),
    "hoursAgo": m6,
    "icon": MessageLookupByLibrary.simpleMessage("Icon"),
    "iconRecords": MessageLookupByLibrary.simpleMessage("Icon records"),
    "iconStyle": MessageLookupByLibrary.simpleMessage("Icon style"),
    "iconUrl": MessageLookupByLibrary.simpleMessage("Icon URL"),
    "ignoreBatteryOptimization": MessageLookupByLibrary.simpleMessage(
      "Ignore Battery Optimization",
    ),
    "import": MessageLookupByLibrary.simpleMessage("Import"),
    "importFile": MessageLookupByLibrary.simpleMessage("Import from file"),
    "importFromURL": MessageLookupByLibrary.simpleMessage("Import from URL"),
    "importUrl": MessageLookupByLibrary.simpleMessage("Import from URL"),
    "includeAllProxies": MessageLookupByLibrary.simpleMessage(
      "Include all proxies",
    ),
    "includeAllProxiesTip": MessageLookupByLibrary.simpleMessage(
      "Import all proxies not containing proxy groups, additional proxy groups can be added below",
    ),
    "includeAllProxyProviders": MessageLookupByLibrary.simpleMessage(
      "Include all proxy providers",
    ),
    "includeAllProxyProvidersTip": MessageLookupByLibrary.simpleMessage(
      "When enabled, it will override the imported proxy providers",
    ),
    "infiniteTime": MessageLookupByLibrary.simpleMessage("Long term effective"),
    "init": MessageLookupByLibrary.simpleMessage("Init"),
    "inputCorrectHotkey": MessageLookupByLibrary.simpleMessage(
      "Please enter the correct hotkey",
    ),
    "inputProxyGroupName": MessageLookupByLibrary.simpleMessage(
      "Input proxy group name",
    ),
    "inputRuleContent": MessageLookupByLibrary.simpleMessage(
      "Input rule content",
    ),
    "intelligentSelected": MessageLookupByLibrary.simpleMessage(
      "Intelligent selection",
    ),
    "internet": MessageLookupByLibrary.simpleMessage("Internet"),
    "interval": MessageLookupByLibrary.simpleMessage("Interval"),
    "intranetIP": MessageLookupByLibrary.simpleMessage("Intranet IP"),
    "invalidBackupFile": MessageLookupByLibrary.simpleMessage(
      "Invalid backup file",
    ),
    "invalidPolicy": m7,
    "invalidProxy": m8,
    "invalidProxyProvider": m9,
    "invalidSubRule": m10,
    "ipcidr": MessageLookupByLibrary.simpleMessage("Ipcidr"),
    "ipv6Desc": MessageLookupByLibrary.simpleMessage(
      "When turned on it will be able to receive IPv6 traffic",
    ),
    "ipv6InboundDesc": MessageLookupByLibrary.simpleMessage(
      "Allow IPv6 inbound",
    ),
    "ja": MessageLookupByLibrary.simpleMessage("Japanese"),
    "justNow": MessageLookupByLibrary.simpleMessage("Just now"),
    "keepAliveIntervalDesc": MessageLookupByLibrary.simpleMessage(
      "Tcp keep alive interval",
    ),
    "key": MessageLookupByLibrary.simpleMessage("Key"),
    "language": MessageLookupByLibrary.simpleMessage("Language"),
    "layout": MessageLookupByLibrary.simpleMessage("Layout"),
    "light": MessageLookupByLibrary.simpleMessage("Light"),
    "list": MessageLookupByLibrary.simpleMessage("List"),
    "listen": MessageLookupByLibrary.simpleMessage("Listen"),
    "loadTest": MessageLookupByLibrary.simpleMessage("Load test"),
    "loading": MessageLookupByLibrary.simpleMessage("Loading..."),
    "local": MessageLookupByLibrary.simpleMessage("Local"),
    "localBackupDesc": MessageLookupByLibrary.simpleMessage(
      "Backup local data to local",
    ),
    "locationPermission": MessageLookupByLibrary.simpleMessage(
      "Location Permission",
    ),
    "locationPermissionDeniedMessage": MessageLookupByLibrary.simpleMessage(
      "Location permission was denied, so the current Wi-Fi name cannot be obtained. Please open location permission manually in system settings.",
    ),
    "locationPermissionDesc": MessageLookupByLibrary.simpleMessage(
      "According to system requirements, obtaining the Wi-Fi name requires you to grant location permission.",
    ),
    "locationPermissionGuide": m11,
    "locationPermissionRequired": MessageLookupByLibrary.simpleMessage(
      "Location Permission Required",
    ),
    "log": MessageLookupByLibrary.simpleMessage("Log"),
    "logLevel": MessageLookupByLibrary.simpleMessage("LogLevel"),
    "logcat": MessageLookupByLibrary.simpleMessage("Logcat"),
    "logcatDesc": MessageLookupByLibrary.simpleMessage(
      "Disabling will hide the log entry",
    ),
    "logs": MessageLookupByLibrary.simpleMessage("Logs"),
    "logsDesc": MessageLookupByLibrary.simpleMessage("Log capture records"),
    "logsTest": MessageLookupByLibrary.simpleMessage("Logs test"),
    "loopback": MessageLookupByLibrary.simpleMessage("Loopback unlock tool"),
    "loopbackDesc": MessageLookupByLibrary.simpleMessage(
      "Used for UWP loopback unlocking",
    ),
    "loose": MessageLookupByLibrary.simpleMessage("Loose"),
    "matchSourceIp": MessageLookupByLibrary.simpleMessage("Match source IP"),
    "maxFailedTimes": MessageLookupByLibrary.simpleMessage("Max failed times"),
    "memoryInfo": MessageLookupByLibrary.simpleMessage("Memory info"),
    "messageTest": MessageLookupByLibrary.simpleMessage("Message test"),
    "messageTestTip": MessageLookupByLibrary.simpleMessage(
      "This is a message.",
    ),
    "min": MessageLookupByLibrary.simpleMessage("Min"),
    "minimizeOnExit": MessageLookupByLibrary.simpleMessage("Minimize on exit"),
    "minimizeOnExitDesc": MessageLookupByLibrary.simpleMessage(
      "Modify the default system exit event",
    ),
    "minutesAgo": m12,
    "mixedPort": MessageLookupByLibrary.simpleMessage("Mixed Port"),
    "mode": MessageLookupByLibrary.simpleMessage("Mode"),
    "monochromeScheme": MessageLookupByLibrary.simpleMessage("Monochrome"),
    "monthsAgo": m13,
    "more": MessageLookupByLibrary.simpleMessage("More"),
    "name": MessageLookupByLibrary.simpleMessage("Name"),
    "nameserver": MessageLookupByLibrary.simpleMessage("Nameserver"),
    "nameserverDesc": MessageLookupByLibrary.simpleMessage(
      "For resolving domain",
    ),
    "nameserverPolicy": MessageLookupByLibrary.simpleMessage(
      "Nameserver policy",
    ),
    "nameserverPolicyDesc": MessageLookupByLibrary.simpleMessage(
      "Specify the corresponding nameserver policy",
    ),
    "network": MessageLookupByLibrary.simpleMessage("Network"),
    "networkDesc": MessageLookupByLibrary.simpleMessage(
      "Modify network-related settings",
    ),
    "networkDetection": MessageLookupByLibrary.simpleMessage(
      "Network detection",
    ),
    "networkException": MessageLookupByLibrary.simpleMessage(
      "Network exception, please check your connection and try again",
    ),
    "networkSpeed": MessageLookupByLibrary.simpleMessage("Network speed"),
    "networkType": MessageLookupByLibrary.simpleMessage("Network type"),
    "neutralScheme": MessageLookupByLibrary.simpleMessage("Neutral"),
    "noData": MessageLookupByLibrary.simpleMessage("No data"),
    "noHotKey": MessageLookupByLibrary.simpleMessage("No HotKey"),
    "noInfo": MessageLookupByLibrary.simpleMessage("No info"),
    "noLongerRemind": MessageLookupByLibrary.simpleMessage(
      "Don\'t remind again",
    ),
    "noNetwork": MessageLookupByLibrary.simpleMessage("No network"),
    "noNetworkApp": MessageLookupByLibrary.simpleMessage("No network APP"),
    "noRecords": MessageLookupByLibrary.simpleMessage("No records"),
    "noResolve": MessageLookupByLibrary.simpleMessage("No resolve IP"),
    "noResolveHostname": MessageLookupByLibrary.simpleMessage(
      "No resolve hostname",
    ),
    "none": MessageLookupByLibrary.simpleMessage("none"),
    "notSelectedTip": MessageLookupByLibrary.simpleMessage(
      "The current proxy group cannot be selected.",
    ),
    "nullProfileDesc": MessageLookupByLibrary.simpleMessage(
      "No profile, Please add a profile",
    ),
    "nullTip": m14,
    "numberTip": m15,
    "onDemand": MessageLookupByLibrary.simpleMessage("On Demand"),
    "onDemandDesc": MessageLookupByLibrary.simpleMessage(
      "Configure the program running state for specific scenarios",
    ),
    "onlyIcon": MessageLookupByLibrary.simpleMessage("Icon"),
    "onlyStatisticsProxy": MessageLookupByLibrary.simpleMessage(
      "Only statistics proxy",
    ),
    "onlyStatisticsProxyDesc": MessageLookupByLibrary.simpleMessage(
      "When turned on, only statistics proxy traffic",
    ),
    "optional": MessageLookupByLibrary.simpleMessage("Optional"),
    "options": MessageLookupByLibrary.simpleMessage("Options"),
    "other": MessageLookupByLibrary.simpleMessage("Other"),
    "otherContributors": MessageLookupByLibrary.simpleMessage(
      "Other contributors",
    ),
    "outboundMode": MessageLookupByLibrary.simpleMessage("Outbound mode"),
    "override": MessageLookupByLibrary.simpleMessage("Override"),
    "overrideDns": MessageLookupByLibrary.simpleMessage("Override Dns"),
    "overrideDnsDesc": MessageLookupByLibrary.simpleMessage(
      "Turning it on will override the DNS options in the profile",
    ),
    "overrideMode": MessageLookupByLibrary.simpleMessage("Override mode"),
    "overrideScript": MessageLookupByLibrary.simpleMessage("Override script"),
    "overwriteTypeCustom": MessageLookupByLibrary.simpleMessage("Custom"),
    "overwriteTypeCustomDesc": MessageLookupByLibrary.simpleMessage(
      "Custom mode, fully customize proxy groups and rules",
    ),
    "palette": MessageLookupByLibrary.simpleMessage("Palette"),
    "password": MessageLookupByLibrary.simpleMessage("Password"),
    "paste": MessageLookupByLibrary.simpleMessage("Paste"),
    "pleaseBindWebDAV": MessageLookupByLibrary.simpleMessage(
      "Please bind WebDAV",
    ),
    "pleaseEnterScriptName": MessageLookupByLibrary.simpleMessage(
      "Please enter a script name",
    ),
    "pleaseInputAdminPassword": MessageLookupByLibrary.simpleMessage(
      "Please enter the admin password",
    ),
    "pleaseUploadValidQrcode": MessageLookupByLibrary.simpleMessage(
      "Please upload a valid QR code",
    ),
    "port": MessageLookupByLibrary.simpleMessage("Port"),
    "portConflictTip": MessageLookupByLibrary.simpleMessage(
      "Please enter a different port",
    ),
    "portTip": m16,
    "preferH3Desc": MessageLookupByLibrary.simpleMessage(
      "Prioritize the use of DOH\'s http/3",
    ),
    "prerequisites": MessageLookupByLibrary.simpleMessage("Prerequisites"),
    "pressKeyboard": MessageLookupByLibrary.simpleMessage(
      "Please press the keyboard.",
    ),
    "preview": MessageLookupByLibrary.simpleMessage("Preview"),
    "process": MessageLookupByLibrary.simpleMessage("Process"),
    "profile": MessageLookupByLibrary.simpleMessage("Profile"),
    "profileAutoUpdateIntervalInvalidValidationDesc":
        MessageLookupByLibrary.simpleMessage(
          "Please input a valid interval time format",
        ),
    "profileAutoUpdateIntervalNullValidationDesc":
        MessageLookupByLibrary.simpleMessage(
          "Please enter the auto update interval time",
        ),
    "profileHasUpdate": MessageLookupByLibrary.simpleMessage(
      "The profile has been modified. Do you want to disable auto update?",
    ),
    "profileNameNullValidationDesc": MessageLookupByLibrary.simpleMessage(
      "Please input the profile name",
    ),
    "profileUrlInvalidValidationDesc": MessageLookupByLibrary.simpleMessage(
      "Please input a valid profile URL",
    ),
    "profileUrlNullValidationDesc": MessageLookupByLibrary.simpleMessage(
      "Please input the profile URL",
    ),
    "profiles": MessageLookupByLibrary.simpleMessage("My subscription"),
    "profilesSort": MessageLookupByLibrary.simpleMessage("Profiles sort"),
    "project": MessageLookupByLibrary.simpleMessage("Project"),
    "providers": MessageLookupByLibrary.simpleMessage("Providers"),
    "proxies": MessageLookupByLibrary.simpleMessage("Routes"),
    "proxiesEmpty": MessageLookupByLibrary.simpleMessage("Proxies is empty"),
    "proxyChains": MessageLookupByLibrary.simpleMessage("Proxy chains"),
    "proxyDetectedAbnormal": MessageLookupByLibrary.simpleMessage(
      "Detected selected proxies are abnormal",
    ),
    "proxyFilter": MessageLookupByLibrary.simpleMessage("Proxy filter"),
    "proxyGroup": MessageLookupByLibrary.simpleMessage("Proxy group"),
    "proxyGroupDetectedAbnormal": MessageLookupByLibrary.simpleMessage(
      "Detected current proxy group is abnormal",
    ),
    "proxyGroupEmpty": MessageLookupByLibrary.simpleMessage(
      "Proxy group is empty",
    ),
    "proxyGroupNameDuplicate": MessageLookupByLibrary.simpleMessage(
      "Proxy group name is duplicate",
    ),
    "proxyGroupNameEmpty": MessageLookupByLibrary.simpleMessage(
      "Proxy group name cannot be empty",
    ),
    "proxyNameserver": MessageLookupByLibrary.simpleMessage("Proxy nameserver"),
    "proxyNameserverDesc": MessageLookupByLibrary.simpleMessage(
      "Domain for resolving proxy nodes",
    ),
    "proxyPort": MessageLookupByLibrary.simpleMessage("ProxyPort"),
    "proxyProviderDetectedAbnormal": MessageLookupByLibrary.simpleMessage(
      "Detected selected proxy providers are abnormal",
    ),
    "proxyProviders": MessageLookupByLibrary.simpleMessage("Proxy providers"),
    "proxyProvidersEmpty": MessageLookupByLibrary.simpleMessage(
      "Proxy providers is empty",
    ),
    "proxyProvidersNotEmpty": MessageLookupByLibrary.simpleMessage(
      "Proxy providers cannot be empty",
    ),
    "proxyType": MessageLookupByLibrary.simpleMessage("Proxy type"),
    "pruneCache": MessageLookupByLibrary.simpleMessage("Prune cache"),
    "pureBlackMode": MessageLookupByLibrary.simpleMessage("Pure black mode"),
    "qrcode": MessageLookupByLibrary.simpleMessage("QR code"),
    "qrcodeDesc": MessageLookupByLibrary.simpleMessage(
      "Scan QR code to obtain profile",
    ),
    "quickFill": MessageLookupByLibrary.simpleMessage("Quick fill"),
    "rainbowScheme": MessageLookupByLibrary.simpleMessage("Rainbow"),
    "redirPort": MessageLookupByLibrary.simpleMessage("Redir Port"),
    "redo": MessageLookupByLibrary.simpleMessage("redo"),
    "remote": MessageLookupByLibrary.simpleMessage("Remote"),
    "remoteBackupDesc": MessageLookupByLibrary.simpleMessage(
      "Backup local data to WebDAV",
    ),
    "remoteDestination": MessageLookupByLibrary.simpleMessage(
      "Remote destination",
    ),
    "remove": MessageLookupByLibrary.simpleMessage("Remove"),
    "rename": MessageLookupByLibrary.simpleMessage("Rename"),
    "request": MessageLookupByLibrary.simpleMessage("Request"),
    "requests": MessageLookupByLibrary.simpleMessage("Requests"),
    "requestsDesc": MessageLookupByLibrary.simpleMessage(
      "View recently request records",
    ),
    "reset": MessageLookupByLibrary.simpleMessage("Reset"),
    "resetPageChangesTip": MessageLookupByLibrary.simpleMessage(
      "The current page has changes. Are you sure you want to reset?",
    ),
    "resetTip": MessageLookupByLibrary.simpleMessage("Make sure to reset"),
    "resources": MessageLookupByLibrary.simpleMessage("Resources"),
    "resourcesDesc": MessageLookupByLibrary.simpleMessage(
      "External resource related info",
    ),
    "respectRules": MessageLookupByLibrary.simpleMessage("Respect rules"),
    "respectRulesDesc": MessageLookupByLibrary.simpleMessage(
      "DNS connection following rules, need to configure proxy-server-nameserver",
    ),
    "restart": MessageLookupByLibrary.simpleMessage("Restart"),
    "restartCoreTip": MessageLookupByLibrary.simpleMessage(
      "Are you sure you want to restart the core?",
    ),
    "restore": MessageLookupByLibrary.simpleMessage("Restore"),
    "restoreAllData": MessageLookupByLibrary.simpleMessage("Restore all data"),
    "restoreException": MessageLookupByLibrary.simpleMessage(
      "Recovery exception",
    ),
    "restoreFromFileDesc": MessageLookupByLibrary.simpleMessage(
      "Restore data via file",
    ),
    "restoreFromWebDAVDesc": MessageLookupByLibrary.simpleMessage(
      "Restore data via WebDAV",
    ),
    "restoreOnlyConfig": MessageLookupByLibrary.simpleMessage(
      "Restore configuration files only",
    ),
    "restoreStrategy": MessageLookupByLibrary.simpleMessage("Restore strategy"),
    "restoreStrategy_compatible": MessageLookupByLibrary.simpleMessage(
      "Compatible",
    ),
    "restoreStrategy_override": MessageLookupByLibrary.simpleMessage(
      "Override",
    ),
    "restoreSuccess": MessageLookupByLibrary.simpleMessage("Restore success"),
    "routeAddress": MessageLookupByLibrary.simpleMessage("Route address"),
    "routeAddressDesc": MessageLookupByLibrary.simpleMessage(
      "Config listen route address",
    ),
    "routeMode": MessageLookupByLibrary.simpleMessage("Route mode"),
    "routeMode_bypassPrivate": MessageLookupByLibrary.simpleMessage(
      "Bypass private route address",
    ),
    "routeMode_config": MessageLookupByLibrary.simpleMessage("Use config"),
    "ru": MessageLookupByLibrary.simpleMessage("Russian"),
    "rule": MessageLookupByLibrary.simpleMessage("Rule"),
    "ruleActionAndDesc": MessageLookupByLibrary.simpleMessage(
      "Logical rule AND",
    ),
    "ruleActionDomainDesc": MessageLookupByLibrary.simpleMessage(
      "Match full domain",
    ),
    "ruleActionDomainKeywordDesc": MessageLookupByLibrary.simpleMessage(
      "Match domain keyword",
    ),
    "ruleActionDomainRegexDesc": MessageLookupByLibrary.simpleMessage(
      "Wildcard match, only supports * and ? wildcards",
    ),
    "ruleActionDomainSuffixDesc": MessageLookupByLibrary.simpleMessage(
      "Match domain suffix",
    ),
    "ruleActionDscpDesc": MessageLookupByLibrary.simpleMessage(
      "Match DSCP mark (tproxy udp inbound only)",
    ),
    "ruleActionDstPortDesc": MessageLookupByLibrary.simpleMessage(
      "Match request target port range",
    ),
    "ruleActionGeoipDesc": MessageLookupByLibrary.simpleMessage(
      "Match IP\'s country code",
    ),
    "ruleActionGeositeDesc": MessageLookupByLibrary.simpleMessage(
      "Match domains within Geosite",
    ),
    "ruleActionInNameDesc": MessageLookupByLibrary.simpleMessage(
      "Match inbound name",
    ),
    "ruleActionInPortDesc": MessageLookupByLibrary.simpleMessage(
      "Match inbound port",
    ),
    "ruleActionInTypeDesc": MessageLookupByLibrary.simpleMessage(
      "Match inbound type",
    ),
    "ruleActionInUserDesc": MessageLookupByLibrary.simpleMessage(
      "Match inbound username, supports multiple usernames separated by /",
    ),
    "ruleActionIpAsnDesc": MessageLookupByLibrary.simpleMessage(
      "Match IP\'s ASN",
    ),
    "ruleActionIpCidr6Desc": MessageLookupByLibrary.simpleMessage(
      "Match IP address range, IP-CIDR6 is just an alias",
    ),
    "ruleActionIpCidrDesc": MessageLookupByLibrary.simpleMessage(
      "Match IP address range",
    ),
    "ruleActionIpSuffixDesc": MessageLookupByLibrary.simpleMessage(
      "Match IP suffix range",
    ),
    "ruleActionMatchDesc": MessageLookupByLibrary.simpleMessage(
      "Match all requests, no conditions needed",
    ),
    "ruleActionNetworkDesc": MessageLookupByLibrary.simpleMessage(
      "Match TCP or UDP",
    ),
    "ruleActionNotDesc": MessageLookupByLibrary.simpleMessage(
      "Logical rule NOT",
    ),
    "ruleActionOrDesc": MessageLookupByLibrary.simpleMessage("Logical rule OR"),
    "ruleActionProcessNameDesc": MessageLookupByLibrary.simpleMessage(
      "Match using process name, matches package name on Android",
    ),
    "ruleActionProcessNameRegexDesc": MessageLookupByLibrary.simpleMessage(
      "Match using process name regex, matches package name on Android",
    ),
    "ruleActionProcessPathDesc": MessageLookupByLibrary.simpleMessage(
      "Match using full process path",
    ),
    "ruleActionProcessPathRegexDesc": MessageLookupByLibrary.simpleMessage(
      "Match using process path regex",
    ),
    "ruleActionRuleSetDesc": MessageLookupByLibrary.simpleMessage(
      "Reference rule set, requires rule-providers configuration",
    ),
    "ruleActionSrcGeoipDesc": MessageLookupByLibrary.simpleMessage(
      "Match source IP\'s country code",
    ),
    "ruleActionSrcIpAsnDesc": MessageLookupByLibrary.simpleMessage(
      "Match source IP\'s ASN",
    ),
    "ruleActionSrcIpCidrDesc": MessageLookupByLibrary.simpleMessage(
      "Match source IP address range",
    ),
    "ruleActionSrcIpSuffixDesc": MessageLookupByLibrary.simpleMessage(
      "Match source IP suffix range",
    ),
    "ruleActionSrcPortDesc": MessageLookupByLibrary.simpleMessage(
      "Match request source port range",
    ),
    "ruleActionSubRuleDesc": MessageLookupByLibrary.simpleMessage(
      "Match to sub-rule, pay attention to the use of parentheses",
    ),
    "ruleActionUidDesc": MessageLookupByLibrary.simpleMessage(
      "Match Linux USER ID",
    ),
    "ruleEmpty": MessageLookupByLibrary.simpleMessage("Rule is empty"),
    "ruleName": MessageLookupByLibrary.simpleMessage("Rule name"),
    "ruleProviders": MessageLookupByLibrary.simpleMessage("Rule providers"),
    "ruleSet": MessageLookupByLibrary.simpleMessage("Rule set"),
    "ruleTarget": MessageLookupByLibrary.simpleMessage("Rule target"),
    "save": MessageLookupByLibrary.simpleMessage("Save"),
    "saveChanges": MessageLookupByLibrary.simpleMessage(
      "Do you want to save the changes?",
    ),
    "script": MessageLookupByLibrary.simpleMessage("Script"),
    "scriptModeDesc": MessageLookupByLibrary.simpleMessage(
      "Script mode, use external extension scripts, provide one-click override configuration capability",
    ),
    "search": MessageLookupByLibrary.simpleMessage("Search"),
    "seconds": MessageLookupByLibrary.simpleMessage("Seconds"),
    "selectAll": MessageLookupByLibrary.simpleMessage("Select all"),
    "selectProxies": MessageLookupByLibrary.simpleMessage("Select proxies"),
    "selectProxyProviders": MessageLookupByLibrary.simpleMessage(
      "Select proxy providers",
    ),
    "selectRuleSet": MessageLookupByLibrary.simpleMessage(
      "Please select rule set",
    ),
    "selectSplitStrategy": MessageLookupByLibrary.simpleMessage(
      "Please select split strategy",
    ),
    "selectSubRule": MessageLookupByLibrary.simpleMessage(
      "Please select sub rule",
    ),
    "selected": MessageLookupByLibrary.simpleMessage("Selected"),
    "selectedCountTitle": m17,
    "settings": MessageLookupByLibrary.simpleMessage("Settings"),
    "show": MessageLookupByLibrary.simpleMessage("Show"),
    "shrink": MessageLookupByLibrary.simpleMessage("Shrink"),
    "silentLaunch": MessageLookupByLibrary.simpleMessage("SilentLaunch"),
    "silentLaunchDesc": MessageLookupByLibrary.simpleMessage(
      "Start in the background",
    ),
    "size": MessageLookupByLibrary.simpleMessage("Size"),
    "socksPort": MessageLookupByLibrary.simpleMessage("Socks Port"),
    "sort": MessageLookupByLibrary.simpleMessage("Sort"),
    "source": MessageLookupByLibrary.simpleMessage("Source"),
    "sourceIp": MessageLookupByLibrary.simpleMessage("Source IP"),
    "specialProxy": MessageLookupByLibrary.simpleMessage("Special proxy"),
    "specialRules": MessageLookupByLibrary.simpleMessage("special rules"),
    "speedStatistics": MessageLookupByLibrary.simpleMessage("Speed statistics"),
    "splitStrategy": MessageLookupByLibrary.simpleMessage("Split strategy"),
    "splitStrategyNotEmpty": MessageLookupByLibrary.simpleMessage(
      "Split strategy cannot be empty",
    ),
    "ssidsEmpty": MessageLookupByLibrary.simpleMessage("SSIDs is empty"),
    "stackMode": MessageLookupByLibrary.simpleMessage("Stack mode"),
    "standard": MessageLookupByLibrary.simpleMessage("Standard"),
    "standardModeDesc": MessageLookupByLibrary.simpleMessage(
      "Standard mode, override basic configuration, provide simple rule addition capability",
    ),
    "start": MessageLookupByLibrary.simpleMessage("Start"),
    "startVpn": MessageLookupByLibrary.simpleMessage("Starting VPN..."),
    "status": MessageLookupByLibrary.simpleMessage("Status"),
    "statusDesc": MessageLookupByLibrary.simpleMessage(
      "System DNS will be used when turned off",
    ),
    "stop": MessageLookupByLibrary.simpleMessage("Stop"),
    "stopVpn": MessageLookupByLibrary.simpleMessage("Stopping VPN..."),
    "style": MessageLookupByLibrary.simpleMessage("Style"),
    "subRule": MessageLookupByLibrary.simpleMessage("Sub rule"),
    "subRuleEmpty": MessageLookupByLibrary.simpleMessage("Sub rule is empty"),
    "subRuleNotEmpty": MessageLookupByLibrary.simpleMessage(
      "Sub rule cannot be empty",
    ),
    "submit": MessageLookupByLibrary.simpleMessage("Submit"),
    "suspended": MessageLookupByLibrary.simpleMessage("Suspended..."),
    "sync": MessageLookupByLibrary.simpleMessage("Sync"),
    "system": MessageLookupByLibrary.simpleMessage("System"),
    "systemApp": MessageLookupByLibrary.simpleMessage("System APP"),
    "systemProxy": MessageLookupByLibrary.simpleMessage("System proxy"),
    "systemProxyDesc": MessageLookupByLibrary.simpleMessage(
      "Attach HTTP proxy to VpnService",
    ),
    "tab": MessageLookupByLibrary.simpleMessage("Tab"),
    "tabAnimation": MessageLookupByLibrary.simpleMessage("Tab animation"),
    "tabAnimationDesc": MessageLookupByLibrary.simpleMessage(
      "Effective only in mobile view",
    ),
    "tapToAuthorize": MessageLookupByLibrary.simpleMessage("Tap to authorize"),
    "tcpConcurrent": MessageLookupByLibrary.simpleMessage("TCP concurrent"),
    "tcpConcurrentDesc": MessageLookupByLibrary.simpleMessage(
      "Enabling it will allow TCP concurrency",
    ),
    "testInterval": MessageLookupByLibrary.simpleMessage("Test interval"),
    "testUrl": MessageLookupByLibrary.simpleMessage("Test url"),
    "testWhenUsed": MessageLookupByLibrary.simpleMessage("Test when used"),
    "textScale": MessageLookupByLibrary.simpleMessage("Text Scaling"),
    "theme": MessageLookupByLibrary.simpleMessage("Theme"),
    "themeColor": MessageLookupByLibrary.simpleMessage("Theme color"),
    "themeDesc": MessageLookupByLibrary.simpleMessage(
      "Set dark mode,adjust the color",
    ),
    "themeMode": MessageLookupByLibrary.simpleMessage("Theme mode"),
    "tight": MessageLookupByLibrary.simpleMessage("Tight"),
    "time": MessageLookupByLibrary.simpleMessage("Time"),
    "timeout": MessageLookupByLibrary.simpleMessage("Timeout"),
    "tip": MessageLookupByLibrary.simpleMessage("tip"),
    "toggle": MessageLookupByLibrary.simpleMessage("Toggle"),
    "tonalSpotScheme": MessageLookupByLibrary.simpleMessage("TonalSpot"),
    "tools": MessageLookupByLibrary.simpleMessage("Me"),
    "tproxyPort": MessageLookupByLibrary.simpleMessage("Tproxy Port"),
    "trafficUsage": MessageLookupByLibrary.simpleMessage("Traffic usage"),
    "tun": MessageLookupByLibrary.simpleMessage("TUN"),
    "tunDesc": MessageLookupByLibrary.simpleMessage(
      "Enable so Telegram, some games and apps work (password required the first time); otherwise only apps like browsers get through",
    ),
    "turnOff": MessageLookupByLibrary.simpleMessage("Turn Off"),
    "turnOn": MessageLookupByLibrary.simpleMessage("Turn On"),
    "undo": MessageLookupByLibrary.simpleMessage("undo"),
    "unifiedDelay": MessageLookupByLibrary.simpleMessage("Unified delay"),
    "unifiedDelayDesc": MessageLookupByLibrary.simpleMessage(
      "Remove extra delays such as handshaking",
    ),
    "unknown": MessageLookupByLibrary.simpleMessage("Unknown"),
    "unknownNetworkError": MessageLookupByLibrary.simpleMessage(
      "Unknown network error",
    ),
    "unnamed": MessageLookupByLibrary.simpleMessage("Unnamed"),
    "update": MessageLookupByLibrary.simpleMessage("Update"),
    "updateSubscription": MessageLookupByLibrary.simpleMessage("Update"),
    "upload": MessageLookupByLibrary.simpleMessage("Upload"),
    "url": MessageLookupByLibrary.simpleMessage("URL"),
    "urlDesc": MessageLookupByLibrary.simpleMessage(
      "Obtain profile through URL",
    ),
    "urlTip": m18,
    "useHosts": MessageLookupByLibrary.simpleMessage("Use hosts"),
    "useSystemHosts": MessageLookupByLibrary.simpleMessage("Use system hosts"),
    "value": MessageLookupByLibrary.simpleMessage("Value"),
    "vgAboutTagline": MessageLookupByLibrary.simpleMessage(
      "Voguesly · US residential IP proxy\\nStable access to ChatGPT, Claude, OKX and other global services",
    ),
    "vgAccelerationMode": MessageLookupByLibrary.simpleMessage(
      "Acceleration mode",
    ),
    "vgAccelerationSkipped": MessageLookupByLibrary.simpleMessage(
      "Acceleration skipped",
    ),
    "vgAccountBalance": MessageLookupByLibrary.simpleMessage("Account balance"),
    "vgActionFailedRetry": MessageLookupByLibrary.simpleMessage(
      "Something went wrong. Please try again later.",
    ),
    "vgActivateFailedRetry": MessageLookupByLibrary.simpleMessage(
      "Activation failed, please try again later",
    ),
    "vgActivateFailedWith": m19,
    "vgActivateFreeTrialNow": MessageLookupByLibrary.simpleMessage(
      "Activate the free trial now",
    ),
    "vgActivatedImportFailed": MessageLookupByLibrary.simpleMessage(
      "Activated, but the subscription import failed (possibly a brief network drop). Tap \"Retry import\" below.",
    ),
    "vgActivatedTapCircle": MessageLookupByLibrary.simpleMessage(
      "✅ Activated — tap the centre circle to connect",
    ),
    "vgActivatingEllipsis": MessageLookupByLibrary.simpleMessage(
      "Activating...",
    ),
    "vgAlipay": MessageLookupByLibrary.simpleMessage("Alipay"),
    "vgAllEndpointsUnreachable": MessageLookupByLibrary.simpleMessage(
      "No endpoint is reachable",
    ),
    "vgAllowLoginItemHint": MessageLookupByLibrary.simpleMessage(
      "Allow Voguesly\'s background item under System Settings → General → Login Items & Extensions,",
    ),
    "vgAllowLoginItemHint2": MessageLookupByLibrary.simpleMessage(
      "then come back to Voguesly and tap TUN once more — no password needed afterwards.",
    ),
    "vgAlreadyBoughtRefresh": MessageLookupByLibrary.simpleMessage(
      "Already bought? Refresh subscription",
    ),
    "vgAlreadyClaimedBuyStarter": MessageLookupByLibrary.simpleMessage(
      "Already claimed? Buy the ¥3.9 starter pack · 3 GB, no time limit",
    ),
    "vgAlreadyHave": MessageLookupByLibrary.simpleMessage("Already have"),
    "vgAlreadyHaveAccount": MessageLookupByLibrary.simpleMessage(
      "Already have an account?",
    ),
    "vgAndroidOneVpnHint": MessageLookupByLibrary.simpleMessage(
      "Android allows only one VPN at a time. When you start Voguesly the system stops the other VPN",
    ),
    "vgAndroidOneVpnHint2": MessageLookupByLibrary.simpleMessage(
      "and asks you to confirm — so there is never a silent conflict where both think they are running.",
    ),
    "vgAnnouncements": MessageLookupByLibrary.simpleMessage("Announcements"),
    "vgAnnouncementsSubtitle": MessageLookupByLibrary.simpleMessage(
      "Latest announcements and maintenance notices",
    ),
    "vgAppFeedbackLogs": MessageLookupByLibrary.simpleMessage(
      "App feedback / logs",
    ),
    "vgAutoSelecting": MessageLookupByLibrary.simpleMessage(
      "Selecting automatically…",
    ),
    "vgAvailableCommission": MessageLookupByLibrary.simpleMessage(
      "Available commission",
    ),
    "vgAvailableCommissionWith": m20,
    "vgBack": MessageLookupByLibrary.simpleMessage("Back"),
    "vgBaidu": MessageLookupByLibrary.simpleMessage("Baidu"),
    "vgBalance": MessageLookupByLibrary.simpleMessage("Balance"),
    "vgBiliHkMoTw": MessageLookupByLibrary.simpleMessage("Bilibili (HK/MO/TW)"),
    "vgBiliMainland": MessageLookupByLibrary.simpleMessage(
      "Bilibili (Mainland)",
    ),
    "vgBilibili": MessageLookupByLibrary.simpleMessage("Bilibili"),
    "vgBuyNow": MessageLookupByLibrary.simpleMessage("Buy now"),
    "vgBuyNowWith": m21,
    "vgBuyOrRenew": MessageLookupByLibrary.simpleMessage("Buy / renew"),
    "vgBuyOrRenewPlan": MessageLookupByLibrary.simpleMessage(
      "Buy / renew a plan",
    ),
    "vgBuyRenewShort": MessageLookupByLibrary.simpleMessage("Buy / renew"),
    "vgBuyStarterForFullTest": MessageLookupByLibrary.simpleMessage(
      "Buy the starter pack for a full test",
    ),
    "vgBuyStarterPack": MessageLookupByLibrary.simpleMessage(
      "Buy the ¥3.9 starter pack",
    ),
    "vgCancel": MessageLookupByLibrary.simpleMessage("Cancel"),
    "vgCancelFailedRetry": MessageLookupByLibrary.simpleMessage(
      "Could not cancel, please try again later",
    ),
    "vgCancelOrder": MessageLookupByLibrary.simpleMessage("Cancel order"),
    "vgCancelOrderConfirm": m22,
    "vgCannotOpenBrowser": MessageLookupByLibrary.simpleMessage(
      "Cannot open the browser",
    ),
    "vgCannotOpenSupportManually": MessageLookupByLibrary.simpleMessage(
      "Support could not be opened. Please visit the support page manually.",
    ),
    "vgChangeFailedCheckOldPassword": MessageLookupByLibrary.simpleMessage(
      "Change failed (check your current password)",
    ),
    "vgChangePassword": MessageLookupByLibrary.simpleMessage("Change password"),
    "vgChargingEllipsis": MessageLookupByLibrary.simpleMessage("Charging…"),
    "vgCheck": MessageLookupByLibrary.simpleMessage("Check"),
    "vgCheckAll": MessageLookupByLibrary.simpleMessage("Check all"),
    "vgCheckFailed": MessageLookupByLibrary.simpleMessage("Check failed"),
    "vgCheckFailedConnectFirst": MessageLookupByLibrary.simpleMessage(
      "Check failed. Connect first, then try again.",
    ),
    "vgCheckForUpdate": MessageLookupByLibrary.simpleMessage(
      "Check for updates",
    ),
    "vgCheckItem": MessageLookupByLibrary.simpleMessage("Check"),
    "vgCheckingLocalEnv": MessageLookupByLibrary.simpleMessage(
      "Checking local environment…",
    ),
    "vgChooseBillingCycle": MessageLookupByLibrary.simpleMessage(
      "Choose a billing cycle",
    ),
    "vgChoosePaymentMethod": MessageLookupByLibrary.simpleMessage(
      "Choose a payment method",
    ),
    "vgCity": MessageLookupByLibrary.simpleMessage("City"),
    "vgCloseFailedRetry": MessageLookupByLibrary.simpleMessage(
      "Could not close, please try again later",
    ),
    "vgCloseTicket": MessageLookupByLibrary.simpleMessage("Close ticket"),
    "vgCloseTicketConfirm": MessageLookupByLibrary.simpleMessage(
      "Once closed you cannot reply again. Is the issue resolved?",
    ),
    "vgCodeSent": MessageLookupByLibrary.simpleMessage(
      "Verification code sent",
    ),
    "vgCoexistFine": MessageLookupByLibrary.simpleMessage(
      "Voguesly will not touch them (some may be your corporate network tunnel). As long as the three items above are fine, coexisting is not a problem.",
    ),
    "vgCollapse": MessageLookupByLibrary.simpleMessage("Collapse"),
    "vgCompatModeOnlyProxyAware": MessageLookupByLibrary.simpleMessage(
      "Note: compatibility mode only covers apps that honour the system proxy; Telegram and similar apps may still not connect;",
    ),
    "vgCompatModeTakenOver": MessageLookupByLibrary.simpleMessage(
      "System Proxy (compatibility mode) has been taken over by another proxy app, so Voguesly\'s compatibility mode is not active.",
    ),
    "vgConfigParseFailed": MessageLookupByLibrary.simpleMessage(
      "Could not read the configuration. Update your subscription or contact support.",
    ),
    "vgConfirmChange": MessageLookupByLibrary.simpleMessage("Confirm change"),
    "vgConfirmNewPassword": MessageLookupByLibrary.simpleMessage(
      "Confirm new password",
    ),
    "vgConnectTimeoutRetry": MessageLookupByLibrary.simpleMessage(
      "Connection timed out. Please try again later.",
    ),
    "vgConnectTimeoutTryAnotherRoute": MessageLookupByLibrary.simpleMessage(
      "Connection timed out. Check your network, or pick another route under \"Current route\".",
    ),
    "vgConnected": MessageLookupByLibrary.simpleMessage("Connected"),
    "vgContactSupport": MessageLookupByLibrary.simpleMessage("Contact support"),
    "vgContinuePayment": MessageLookupByLibrary.simpleMessage(
      "Continue payment",
    ),
    "vgCopiedSuffix": m23,
    "vgCopy": MessageLookupByLibrary.simpleMessage("Copy"),
    "vgCopyReferralLink": MessageLookupByLibrary.simpleMessage(
      "Copy referral link",
    ),
    "vgCoreFailedToBindPort": MessageLookupByLibrary.simpleMessage(
      "The Voguesly core failed to bind its port.",
    ),
    "vgCountryRegion": MessageLookupByLibrary.simpleMessage("Country / region"),
    "vgCreateAccount": MessageLookupByLibrary.simpleMessage("Create account"),
    "vgCreditCard": MessageLookupByLibrary.simpleMessage("Credit card"),
    "vgCurrentBalanceWith": m24,
    "vgCurrentPassword": MessageLookupByLibrary.simpleMessage(
      "Current password",
    ),
    "vgCurrentPlanPrefixWith": m25,
    "vgCurrentPlanWith": m26,
    "vgCurrentRoute": MessageLookupByLibrary.simpleMessage("Current route"),
    "vgDailyUsageThisMonth": MessageLookupByLibrary.simpleMessage(
      "Daily usage this month",
    ),
    "vgDataExhaustedRenew": MessageLookupByLibrary.simpleMessage(
      "Data used up · please renew",
    ),
    "vgDataUsage": MessageLookupByLibrary.simpleMessage("Data usage"),
    "vgDataUsageSubtitle": MessageLookupByLibrary.simpleMessage(
      "Day-by-day data usage",
    ),
    "vgDeviceInfoWith": m27,
    "vgDeviceLimitHint": MessageLookupByLibrary.simpleMessage(
      "if you see a connection-limit message, fully quit the other clients and reconnect",
    ),
    "vgDirectModeSummary": MessageLookupByLibrary.simpleMessage(
      "⚠️ Direct · not accelerated, traffic does not use any node (not private)",
    ),
    "vgDmgOpenedQuitting": MessageLookupByLibrary.simpleMessage(
      "The DMG is open and Voguesly is quitting safely. Drag the new version into Applications to replace the old one.",
    ),
    "vgDomestic": MessageLookupByLibrary.simpleMessage("Domestic"),
    "vgDoneOrClose": MessageLookupByLibrary.simpleMessage("I\'m done / close"),
    "vgDouyin": MessageLookupByLibrary.simpleMessage("Douyin"),
    "vgDownloadFailed": MessageLookupByLibrary.simpleMessage("Download failed"),
    "vgDownloadFailedRetry": MessageLookupByLibrary.simpleMessage(
      "Download failed, please try again later",
    ),
    "vgDownloadFailedRetryFull": MessageLookupByLibrary.simpleMessage(
      "Download failed, please try again later",
    ),
    "vgDownloadingUpdate": MessageLookupByLibrary.simpleMessage(
      "Downloading update",
    ),
    "vgDurationWith": m28,
    "vgEmail": MessageLookupByLibrary.simpleMessage("Email"),
    "vgEmailCode": MessageLookupByLibrary.simpleMessage(
      "Email verification code",
    ),
    "vgEmptyResponseRetry": MessageLookupByLibrary.simpleMessage(
      "Empty response, please try again",
    ),
    "vgEncrypted": MessageLookupByLibrary.simpleMessage("Encrypted"),
    "vgEnterCode": MessageLookupByLibrary.simpleMessage(
      "Please enter the verification code",
    ),
    "vgEnterCredentials": MessageLookupByLibrary.simpleMessage(
      "Enter your credentials to continue",
    ),
    "vgEnterPassword": MessageLookupByLibrary.simpleMessage(
      "Please enter your password",
    ),
    "vgEnterPayoutAccount": MessageLookupByLibrary.simpleMessage(
      "Please enter your payout account",
    ),
    "vgEnterValidEmail": MessageLookupByLibrary.simpleMessage(
      "Please enter a valid email",
    ),
    "vgEnterValidEmailFirst": MessageLookupByLibrary.simpleMessage(
      "Please enter a valid email first",
    ),
    "vgExit": MessageLookupByLibrary.simpleMessage("Exit"),
    "vgExpandFullText": MessageLookupByLibrary.simpleMessage("Read more"),
    "vgExpiredRenew": MessageLookupByLibrary.simpleMessage(
      "Expired · please renew",
    ),
    "vgExpiredSuffix": m29,
    "vgExpiryDate": MessageLookupByLibrary.simpleMessage("Expires"),
    "vgFeedbackBodyWith": m30,
    "vgFeedbackHint": MessageLookupByLibrary.simpleMessage(
      "Describe the problem you ran into. We attach your device info and recent logs automatically to help pinpoint it.",
    ),
    "vgFeedbackPlaceholder": MessageLookupByLibrary.simpleMessage(
      "For example: pages won\'t load after connecting / a node won\'t connect…",
    ),
    "vgFlClashOriginal": MessageLookupByLibrary.simpleMessage(
      "FlClash (original)",
    ),
    "vgForgotPassword": MessageLookupByLibrary.simpleMessage(
      "Forgot password?",
    ),
    "vgFreeTrialActivated": MessageLookupByLibrary.simpleMessage(
      "Free trial activated",
    ),
    "vgFreeTrialImportToConnect": MessageLookupByLibrary.simpleMessage(
      "Free trial activated — import nodes to connect",
    ),
    "vgFromPrice": m31,
    "vgGlobalAccelDesc1": MessageLookupByLibrary.simpleMessage(
      "All traffic uses the single route you picked; nothing is split automatically.",
    ),
    "vgGlobalAccelDesc2": MessageLookupByLibrary.simpleMessage(
      "If you pick a datacentre route, IP checks will show a datacentre IP;",
    ),
    "vgGlobalAccelDesc3": MessageLookupByLibrary.simpleMessage(
      "for a residential IP, pick a residential node under \"Routes\", or use smart routing.",
    ),
    "vgGlobalAcceleration": MessageLookupByLibrary.simpleMessage(
      "Global acceleration",
    ),
    "vgGlobalModeDialog1": MessageLookupByLibrary.simpleMessage(
      "In global mode all traffic uses the single route you picked under \"Routes\", instead of splitting by AI / banking /",
    ),
    "vgGlobalModeDialog2": MessageLookupByLibrary.simpleMessage(
      "domestic sites automatically.\\n\\n",
    ),
    "vgGlobalModeDialog3": MessageLookupByLibrary.simpleMessage(
      "If you picked a datacentre route, IP-check sites will show a datacentre IP. For a US residential IP,",
    ),
    "vgGlobalModeDialog4": MessageLookupByLibrary.simpleMessage(
      "pick a residential node under \"Routes\", or switch back to smart routing.",
    ),
    "vgGlobalModeSummary": MessageLookupByLibrary.simpleMessage(
      "Global · everything uses the selected route; your IP follows that route",
    ),
    "vgGoSignIn": MessageLookupByLibrary.simpleMessage("Sign in"),
    "vgGoogleSignInFailedNetwork": MessageLookupByLibrary.simpleMessage(
      "Google sign-in failed. Check your connection and try again.",
    ),
    "vgGoogleSignInFailedRetry": MessageLookupByLibrary.simpleMessage(
      "Google sign-in failed, please try again",
    ),
    "vgGotIt": MessageLookupByLibrary.simpleMessage("Got it"),
    "vgHalfYearly": MessageLookupByLibrary.simpleMessage("Every 6 months"),
    "vgImportPlanNodesStart": MessageLookupByLibrary.simpleMessage(
      "Import your plan\'s nodes and get started",
    ),
    "vgInstallPermissionNeeded": MessageLookupByLibrary.simpleMessage(
      "Install permission required",
    ),
    "vgInstallerFileIncomplete": MessageLookupByLibrary.simpleMessage(
      "The installer file is incomplete",
    ),
    "vgInstallerStartedHint": MessageLookupByLibrary.simpleMessage(
      "The installer has started. Follow the prompts to finish — it replaces the old version automatically.",
    ),
    "vgInsufficientBalance": MessageLookupByLibrary.simpleMessage(
      "Insufficient balance",
    ),
    "vgInternational": MessageLookupByLibrary.simpleMessage("International"),
    "vgInvalidAmount": MessageLookupByLibrary.simpleMessage("Invalid amount"),
    "vgInvited": MessageLookupByLibrary.simpleMessage("Invited"),
    "vgIpAddress": MessageLookupByLibrary.simpleMessage("IP address"),
    "vgKeptSystemProxyCarrying": m32,
    "vgLastUpdatedTodayWith": m33,
    "vgLastUpdatedWith": m34,
    "vgLatencyHint": MessageLookupByLibrary.simpleMessage(
      "Domestic sites should connect directly (fast); international ones go through a node. Lower is better.",
    ),
    "vgLatencyTest": MessageLookupByLibrary.simpleMessage("Latency test"),
    "vgLikelyAnotherVpnTookRoute": MessageLookupByLibrary.simpleMessage(
      "another VPN has most likely taken the default route.",
    ),
    "vgListening": MessageLookupByLibrary.simpleMessage("Listening"),
    "vgLiveChat": MessageLookupByLibrary.simpleMessage("Live chat"),
    "vgLiveChatOpenedInBrowser": MessageLookupByLibrary.simpleMessage(
      "Live chat opened in your browser",
    ),
    "vgLiveChatUnavailableUseBrowser": MessageLookupByLibrary.simpleMessage(
      "Live chat is unavailable right now — you can open it in your browser",
    ),
    "vgLoadFailedPullToRetry": MessageLookupByLibrary.simpleMessage(
      "Loading failed, pull down to retry",
    ),
    "vgLoadFailedTapRetry": MessageLookupByLibrary.simpleMessage(
      "Loading failed · tap to retry",
    ),
    "vgLoadFailedWith": m35,
    "vgLoadFailedWithCode": m36,
    "vgLoadingAccount": MessageLookupByLibrary.simpleMessage(
      "Loading account…",
    ),
    "vgLoadingEllipsis": MessageLookupByLibrary.simpleMessage("Loading…"),
    "vgLoadingPlan": MessageLookupByLibrary.simpleMessage("Loading plan…"),
    "vgLoadingSubscription": MessageLookupByLibrary.simpleMessage(
      "Loading subscription…",
    ),
    "vgLocalEnvHint": MessageLookupByLibrary.simpleMessage(
      "Running other proxy apps? This shows which path is actually carrying traffic and what is holding what.",
    ),
    "vgLocalEnvOk": MessageLookupByLibrary.simpleMessage(
      "Local environment is healthy.",
    ),
    "vgLocalEnvOkInControl": m37,
    "vgLocalEnvironment": MessageLookupByLibrary.simpleMessage(
      "Local environment",
    ),
    "vgLocalPortHeldSuggestChange": m38,
    "vgLocalPortNum": m39,
    "vgLogOut": MessageLookupByLibrary.simpleMessage("Log out"),
    "vgMacDnsHintDesc": MessageLookupByLibrary.simpleMessage(
      "Voguesly\'s DNS is added temporarily only while macOS TUN is running, and restored on disconnect or exit; System Proxy mode does not touch DNS",
    ),
    "vgManageBalanceAndPlan": MessageLookupByLibrary.simpleMessage(
      "Manage balance and plans",
    ),
    "vgManageSubscription": MessageLookupByLibrary.simpleMessage(
      "Manage subscription",
    ),
    "vgMe": MessageLookupByLibrary.simpleMessage("Me"),
    "vgMihomoCore": MessageLookupByLibrary.simpleMessage("mihomo core"),
    "vgMonthly": MessageLookupByLibrary.simpleMessage("Monthly"),
    "vgMyOrders": MessageLookupByLibrary.simpleMessage("My orders"),
    "vgMyReferralCode": MessageLookupByLibrary.simpleMessage(
      "My referral code",
    ),
    "vgMySubscription": MessageLookupByLibrary.simpleMessage("My subscription"),
    "vgMyTickets": MessageLookupByLibrary.simpleMessage("My tickets"),
    "vgMyTicketsSubtitle": MessageLookupByLibrary.simpleMessage(
      "Read support replies and follow up",
    ),
    "vgNBillingCycles": m40,
    "vgNDays": m41,
    "vgNMonths": m42,
    "vgNPeople": m43,
    "vgNYears": m44,
    "vgNeedUnknownSourcesPermission": MessageLookupByLibrary.simpleMessage(
      "Installing the update needs the \"install unknown apps\" permission. Grant it in Settings and come back — installation continues automatically.",
    ),
    "vgNetUnstableRetry": MessageLookupByLibrary.simpleMessage(
      "Network is unstable. Check your connection and try again.",
    ),
    "vgNetworkErrorWith": m45,
    "vgNetworkSkippedDirect": MessageLookupByLibrary.simpleMessage(
      "Acceleration skipped on this network · going direct",
    ),
    "vgNetworkUnavailableRetry": MessageLookupByLibrary.simpleMessage(
      "Network unavailable. Check your connection and try again.",
    ),
    "vgNetworkUnstableNoPlanInfo": MessageLookupByLibrary.simpleMessage(
      "Network is unstable; plan details are unavailable right now",
    ),
    "vgNetworkUnstableTapRetry": MessageLookupByLibrary.simpleMessage(
      "Network is unstable — tap to retry",
    ),
    "vgNewPasswordMin8": MessageLookupByLibrary.simpleMessage(
      "New password (at least 8 characters)",
    ),
    "vgNewPasswordTooShort": MessageLookupByLibrary.simpleMessage(
      "New password must be at least 8 characters",
    ),
    "vgNewVersionAvailable": m46,
    "vgNoAccountYet": MessageLookupByLibrary.simpleMessage(
      "Don\'t have an account?",
    ),
    "vgNoAnnouncements": MessageLookupByLibrary.simpleMessage(
      "No announcements",
    ),
    "vgNoExpiry": MessageLookupByLibrary.simpleMessage("No expiry"),
    "vgNoMessages": MessageLookupByLibrary.simpleMessage("No messages"),
    "vgNoOrders": MessageLookupByLibrary.simpleMessage("No orders yet"),
    "vgNoOtherProxyDetected": MessageLookupByLibrary.simpleMessage(
      "No other proxy app detected",
    ),
    "vgNoPathCarryingTraffic": MessageLookupByLibrary.simpleMessage(
      "No path is carrying traffic right now, so you are probably offline. Try reconnecting.",
    ),
    "vgNoPlan": MessageLookupByLibrary.simpleMessage("No plan yet"),
    "vgNoPlansAvailable": MessageLookupByLibrary.simpleMessage(
      "No plans available, or a network issue. Pull down to retry.",
    ),
    "vgNoRouteSelected": MessageLookupByLibrary.simpleMessage(
      "Not selected · pick a route",
    ),
    "vgNoSubscriptionImported": MessageLookupByLibrary.simpleMessage(
      "No subscription imported · open the management page to import",
    ),
    "vgNoTicketsHint": MessageLookupByLibrary.simpleMessage(
      "No tickets yet\\nHaving a problem? Submit it under \"Report an issue / upload logs\"",
    ),
    "vgNoUsageThisMonth": MessageLookupByLibrary.simpleMessage(
      "No usage records this month",
    ),
    "vgNotChecked": MessageLookupByLibrary.simpleMessage("Not checked"),
    "vgNotConnectedTapCircle": MessageLookupByLibrary.simpleMessage(
      "Voguesly is not connected. Tap the big circle on the home screen first, then come back to run the check.",
    ),
    "vgNotEnabled": MessageLookupByLibrary.simpleMessage("Off"),
    "vgNotInControl": MessageLookupByLibrary.simpleMessage("Not in control"),
    "vgNotListening": MessageLookupByLibrary.simpleMessage("Not listening"),
    "vgNotSignedIn": MessageLookupByLibrary.simpleMessage("Not signed in"),
    "vgNotSignedInPleaseSignIn": MessageLookupByLibrary.simpleMessage(
      "Not signed in — please sign in first",
    ),
    "vgOauthSuccessHtmlBody": MessageLookupByLibrary.simpleMessage(
      "<p style=\"opacity:.7;margin:0\">Return to the Voguesly app to continue</p></div>",
    ),
    "vgOauthSuccessHtmlHead": MessageLookupByLibrary.simpleMessage(
      "<div><h2 style=\"margin:0 0 8px;font-weight:600\">Signed in</h2>",
    ),
    "vgOfficialSite": MessageLookupByLibrary.simpleMessage("Website"),
    "vgOneTapTrialInApp": MessageLookupByLibrary.simpleMessage(
      "One-tap trial in app",
    ),
    "vgOneTime": MessageLookupByLibrary.simpleMessage("One-time"),
    "vgOneYear": MessageLookupByLibrary.simpleMessage("1 year"),
    "vgOnlineButChecksAffected": MessageLookupByLibrary.simpleMessage(
      "Browsing works; the check features may be affected by the port being occupied.",
    ),
    "vgOnlinePayment": MessageLookupByLibrary.simpleMessage("Online payment"),
    "vgOnlineViaTunProxyTaken": MessageLookupByLibrary.simpleMessage(
      "Browsing works — Voguesly is on the virtual NIC. The system proxy is held by another app, but that does not affect you.",
    ),
    "vgOpenPayment": MessageLookupByLibrary.simpleMessage("Open payment"),
    "vgOpenSettingsToGrant": MessageLookupByLibrary.simpleMessage(
      "Open Settings to grant",
    ),
    "vgOpenSupportFailedRetry": MessageLookupByLibrary.simpleMessage(
      "Could not open support, please try again later",
    ),
    "vgOpenSupportInBrowser": MessageLookupByLibrary.simpleMessage(
      "Open support in browser",
    ),
    "vgOpenSystemSettings": MessageLookupByLibrary.simpleMessage(
      "Open System Settings",
    ),
    "vgOpeningInstaller": MessageLookupByLibrary.simpleMessage(
      "Opening the installer…",
    ),
    "vgOr": MessageLookupByLibrary.simpleMessage("or"),
    "vgOrderActivating": MessageLookupByLibrary.simpleMessage("Activating"),
    "vgOrderCancelled": MessageLookupByLibrary.simpleMessage("Cancelled"),
    "vgOrderCancelledToast": MessageLookupByLibrary.simpleMessage(
      "Order cancelled",
    ),
    "vgOrderCompleted": MessageLookupByLibrary.simpleMessage("Completed"),
    "vgOrderFailed": MessageLookupByLibrary.simpleMessage("Order failed"),
    "vgOrderFailedRetry": MessageLookupByLibrary.simpleMessage(
      "Could not place the order, please try again later",
    ),
    "vgOrderFailedWith": m47,
    "vgOrderNoWith": m48,
    "vgOrderPendingPayment": MessageLookupByLibrary.simpleMessage(
      "Awaiting payment",
    ),
    "vgOrderRefunded": MessageLookupByLibrary.simpleMessage("Refunded"),
    "vgOriginalsOnly": MessageLookupByLibrary.simpleMessage("Originals only"),
    "vgOtherProxyRunningCloseFirst": m49,
    "vgOtherProxyRunningSkipTun": m50,
    "vgPassword": MessageLookupByLibrary.simpleMessage("Password"),
    "vgPasswordChanged": MessageLookupByLibrary.simpleMessage(
      "Password changed",
    ),
    "vgPasswordsDoNotMatch": MessageLookupByLibrary.simpleMessage(
      "The two new passwords do not match",
    ),
    "vgPayHereOrScanHint": MessageLookupByLibrary.simpleMessage(
      "Tap \"Open payment\" below to pay on this device,\\nor scan with another device. It is credited automatically once done.",
    ),
    "vgPayWithBalance": MessageLookupByLibrary.simpleMessage(
      "Pay with balance",
    ),
    "vgPaymentOpenedInBrowserHint": MessageLookupByLibrary.simpleMessage(
      "The payment page is open in your browser.\\nThis page updates automatically once payment completes.",
    ),
    "vgPaymentStartFailed": MessageLookupByLibrary.simpleMessage(
      "Could not start the payment",
    ),
    "vgPaymentStartFailedWith": m51,
    "vgPaymentSuccessActivated": MessageLookupByLibrary.simpleMessage(
      "Payment complete, your plan is active",
    ),
    "vgPayoutAccount": MessageLookupByLibrary.simpleMessage("Payout account"),
    "vgPkgOpenedQuitting": MessageLookupByLibrary.simpleMessage(
      "The PKG installer is open and Voguesly is quitting safely. Follow the system prompts to authorise; the installer will replace the old version in Applications.",
    ),
    "vgPlacingOrder": MessageLookupByLibrary.simpleMessage("Placing order…"),
    "vgPlan": MessageLookupByLibrary.simpleMessage("Plan"),
    "vgPlanDeviceLimitWith": m52,
    "vgPlatformNoLocalDiag": MessageLookupByLibrary.simpleMessage(
      "Local environment diagnostics is not supported on this platform.",
    ),
    "vgPointsToVogueslyWith": m53,
    "vgPortHeldByOther": m54,
    "vgPortHeldByOther2": MessageLookupByLibrary.simpleMessage(
      "kind of failure, the hardest one to track down. You can pick an unused port under Settings → Network.",
    ),
    "vgPortMaybeTakenAndroid": MessageLookupByLibrary.simpleMessage(
      "The port may be taken by another proxy app. On Android this does not affect browsing (Voguesly uses the VPN tunnel),",
    ),
    "vgPortMaybeTakenAndroid2": MessageLookupByLibrary.simpleMessage(
      "but the unlock and latency checks on this page will not be able to measure anything.",
    ),
    "vgPreparingInstall": MessageLookupByLibrary.simpleMessage(
      "Preparing to install…",
    ),
    "vgPublicTrafficOnOtherTun": m55,
    "vgPublicTrafficOnOurTun": MessageLookupByLibrary.simpleMessage(
      "Public traffic is going through Voguesly\'s virtual NIC. This is the main path and does not rely on the system proxy.",
    ),
    "vgPurchaseSuccessActivated": MessageLookupByLibrary.simpleMessage(
      "Purchase complete, your plan is active",
    ),
    "vgQuarterly": MessageLookupByLibrary.simpleMessage("Quarterly"),
    "vgQuitOtherProxyToTakeOver": MessageLookupByLibrary.simpleMessage(
      "To let Voguesly own the system proxy, quit the other proxy app and reconnect.",
    ),
    "vgRecentLogsHeader": MessageLookupByLibrary.simpleMessage(
      "--- recent logs ---",
    ),
    "vgRecheck": MessageLookupByLibrary.simpleMessage("Check again"),
    "vgReferralCode": MessageLookupByLibrary.simpleMessage("Referral code"),
    "vgReferralCodeDiscount": MessageLookupByLibrary.simpleMessage(
      "Sign up with a referral code for a discount",
    ),
    "vgReferralCodeOptional": MessageLookupByLibrary.simpleMessage(
      "Referral code (optional)",
    ),
    "vgReferralExplain": MessageLookupByLibrary.simpleMessage(
      "When a friend signs up through your link and buys a plan, you earn a commission. Commission can be used towards renewals.",
    ),
    "vgReferralLink": MessageLookupByLibrary.simpleMessage("Referral link"),
    "vgReferralRewards": MessageLookupByLibrary.simpleMessage(
      "Referral rewards",
    ),
    "vgReferralSubtitle": MessageLookupByLibrary.simpleMessage(
      "Invite friends, view commission, withdraw",
    ),
    "vgRefetchPlanAndTrial": MessageLookupByLibrary.simpleMessage(
      "Fetch your plan and free-trial eligibility again",
    ),
    "vgRefresh": MessageLookupByLibrary.simpleMessage("Refresh"),
    "vgRegionBlocked": MessageLookupByLibrary.simpleMessage("Region blocked"),
    "vgRegionNotSupported": MessageLookupByLibrary.simpleMessage(
      "Not available in this region",
    ),
    "vgRegionRestricted": MessageLookupByLibrary.simpleMessage(
      "Region restricted",
    ),
    "vgRemainingData": MessageLookupByLibrary.simpleMessage("Data left"),
    "vgRememberMe": MessageLookupByLibrary.simpleMessage("Remember me"),
    "vgReopenPayment": MessageLookupByLibrary.simpleMessage("Reopen payment"),
    "vgReopenTunAfterPermission": MessageLookupByLibrary.simpleMessage(
      "Once permissions are fixed you can turn Virtual NIC (device-wide) back on from the dashboard.",
    ),
    "vgReplyToSupport": MessageLookupByLibrary.simpleMessage(
      "Reply to support…",
    ),
    "vgReportIssueSubtitle": MessageLookupByLibrary.simpleMessage(
      "Send your logs to support in one tap so they can pinpoint the issue",
    ),
    "vgReportIssueUploadLogs": MessageLookupByLibrary.simpleMessage(
      "Report an issue / upload logs",
    ),
    "vgReset": MessageLookupByLibrary.simpleMessage("Reset"),
    "vgResetFailed": MessageLookupByLibrary.simpleMessage("Reset failed"),
    "vgResetProxyHint": MessageLookupByLibrary.simpleMessage(
      "This only rewrites Voguesly\'s own settings. It will not close or modify your other proxy apps.",
    ),
    "vgResetSubscription": MessageLookupByLibrary.simpleMessage(
      "Reset subscription",
    ),
    "vgResetSubscriptionConfirm": MessageLookupByLibrary.simpleMessage(
      "The old subscription link stops working immediately. Anything already exported to other clients must be imported again. Reset?",
    ),
    "vgResetVogueslySystemProxy": MessageLookupByLibrary.simpleMessage(
      "Reset Voguesly\'s system proxy",
    ),
    "vgResidentialIpProfile": MessageLookupByLibrary.simpleMessage(
      "Voguesly Residential IP",
    ),
    "vgRetry": MessageLookupByLibrary.simpleMessage("Retry"),
    "vgRetryImportSubscription": MessageLookupByLibrary.simpleMessage(
      "Retry subscription import",
    ),
    "vgRouteTableSeesOurTun": MessageLookupByLibrary.simpleMessage(
      "The routing table shows Voguesly\'s virtual NIC. This is the main path and does not rely on the system proxy.",
    ),
    "vgRuleModeSummary": MessageLookupByLibrary.simpleMessage(
      "Smart routing · AI and banking use residential, domestic sites go direct (recommended)",
    ),
    "vgRunningAlongside": MessageLookupByLibrary.simpleMessage(
      "Running alongside",
    ),
    "vgRunningFromDmgHint": MessageLookupByLibrary.simpleMessage(
      "Voguesly is running directly from the DMG disk image. Drag Voguesly into Applications first,",
    ),
    "vgRunningFromDmgHint2": MessageLookupByLibrary.simpleMessage(
      "then open it from Applications — running from the DMG cannot start the TUN background service.",
    ),
    "vgScanToPay": MessageLookupByLibrary.simpleMessage("Scan to pay"),
    "vgScanWithPhoneHint": MessageLookupByLibrary.simpleMessage(
      "Scan with Alipay or WeChat on your phone.\\nThis page updates automatically once payment completes.",
    ),
    "vgSend": MessageLookupByLibrary.simpleMessage("Send"),
    "vgSendFailedRetry": MessageLookupByLibrary.simpleMessage(
      "Sending failed, please try again later",
    ),
    "vgSendFailedRetryComma": MessageLookupByLibrary.simpleMessage(
      "Sending failed, please try again later",
    ),
    "vgSendFailedWith": m56,
    "vgSent": MessageLookupByLibrary.simpleMessage("Sent"),
    "vgSessionExpiredSignInAgain": MessageLookupByLibrary.simpleMessage(
      "Your session expired. Please sign in again.",
    ),
    "vgShadowrocket": MessageLookupByLibrary.simpleMessage("Shadowrocket"),
    "vgSignIn": MessageLookupByLibrary.simpleMessage("Sign in"),
    "vgSignInAccount": MessageLookupByLibrary.simpleMessage("Sign in"),
    "vgSignInBeforeFeedback": MessageLookupByLibrary.simpleMessage(
      "Please sign in before sending feedback",
    ),
    "vgSignInFailed": MessageLookupByLibrary.simpleMessage("Sign-in failed"),
    "vgSignInWithGoogle": MessageLookupByLibrary.simpleMessage(
      "Sign in with Google",
    ),
    "vgSignOut": MessageLookupByLibrary.simpleMessage("Sign out"),
    "vgSignOutAccount": MessageLookupByLibrary.simpleMessage("Sign out"),
    "vgSignOutAccountConfirm": MessageLookupByLibrary.simpleMessage(
      "Sign out of this account? You will need to sign in again.",
    ),
    "vgSignOutConfirm": MessageLookupByLibrary.simpleMessage(
      "Sign out of this account?",
    ),
    "vgSignOutConfirmShort": MessageLookupByLibrary.simpleMessage(
      "Sign out of this account?",
    ),
    "vgSignUp": MessageLookupByLibrary.simpleMessage("Sign up"),
    "vgSignUpAutoConnect": MessageLookupByLibrary.simpleMessage(
      "Sign up and connect automatically",
    ),
    "vgSignUpFailed": MessageLookupByLibrary.simpleMessage("Sign-up failed"),
    "vgSignUpWithGoogle": MessageLookupByLibrary.simpleMessage(
      "Sign up with Google",
    ),
    "vgSignedInLoadingPlan": MessageLookupByLibrary.simpleMessage(
      "Signed in · loading your plan…",
    ),
    "vgSixDigitCode": MessageLookupByLibrary.simpleMessage("6-digit code"),
    "vgSmartRoutingDesc1": MessageLookupByLibrary.simpleMessage(
      "AI, banking and payments automatically use a US residential IP; domestic sites connect directly for speed,",
    ),
    "vgSmartRoutingDesc2": MessageLookupByLibrary.simpleMessage(
      "while streaming and downloads use datacentre nodes to save residential data. IP checks will show a residential IP.",
    ),
    "vgSmartRoutingRecommended": MessageLookupByLibrary.simpleMessage(
      "Smart routing (recommended)",
    ),
    "vgSomethingWentWrongRetry": MessageLookupByLibrary.simpleMessage(
      "Something went wrong, please try again later",
    ),
    "vgSpeedLimitNMbps": m57,
    "vgSplitRouteHint": MessageLookupByLibrary.simpleMessage(
      "International services exit abroad, domestic services stay local — smart routing verified live.",
    ),
    "vgSplitRouteTest": MessageLookupByLibrary.simpleMessage(
      "Split-routing test",
    ),
    "vgStartYourTest": MessageLookupByLibrary.simpleMessage("Start your test"),
    "vgStarterPackSpecs": MessageLookupByLibrary.simpleMessage(
      "3 GB with no time limit — enough to fully test ChatGPT, Claude and similar services",
    ),
    "vgStarting": MessageLookupByLibrary.simpleMessage("Starting"),
    "vgStartingPaymentEllipsis": MessageLookupByLibrary.simpleMessage(
      "Starting payment…",
    ),
    "vgStore": MessageLookupByLibrary.simpleMessage("Store"),
    "vgSubmit": MessageLookupByLibrary.simpleMessage("Submit"),
    "vgSubmitFailedRetry": MessageLookupByLibrary.simpleMessage(
      "Submission failed, please try again later",
    ),
    "vgSubmitFailedWith": m58,
    "vgSubmitToSupport": MessageLookupByLibrary.simpleMessage(
      "Send to support",
    ),
    "vgSubmittedSupportWillFollowUp": MessageLookupByLibrary.simpleMessage(
      "Submitted. Support will follow up shortly.",
    ),
    "vgSubmitting": MessageLookupByLibrary.simpleMessage("Submitting…"),
    "vgSubscribeNow": MessageLookupByLibrary.simpleMessage("Subscribe now"),
    "vgSubscriptionImportFailedRetry": MessageLookupByLibrary.simpleMessage(
      "Subscription import failed, please try again later.",
    ),
    "vgSubscriptionResetFetching": MessageLookupByLibrary.simpleMessage(
      "Subscription reset. Fetching new nodes…",
    ),
    "vgSubscriptionUpdated": MessageLookupByLibrary.simpleMessage(
      "Subscription updated",
    ),
    "vgSupport": MessageLookupByLibrary.simpleMessage("Support"),
    "vgSwitchedToGlobal": MessageLookupByLibrary.simpleMessage(
      "Switched to global acceleration",
    ),
    "vgSystemProxy": MessageLookupByLibrary.simpleMessage("System proxy"),
    "vgSystemProxyCompat": m59,
    "vgSystemProxyCompatDesc": MessageLookupByLibrary.simpleMessage(
      "Only covers apps that support the system proxy; apps like Telegram may still need TUN",
    ),
    "vgSystemProxyOccupied": MessageLookupByLibrary.simpleMessage(
      "System Proxy could not take over traffic — it may be occupied by another proxy app. Quit it and try again.",
    ),
    "vgSystemProxySingleSlot": m60,
    "vgTakenByOtherAppWith": m61,
    "vgTakenByOtherProcessWith": m62,
    "vgTaobao": MessageLookupByLibrary.simpleMessage("Taobao"),
    "vgTapBelowToFetchNodes": MessageLookupByLibrary.simpleMessage(
      "Tap the button below to fetch the latest nodes",
    ),
    "vgTapToActivate": MessageLookupByLibrary.simpleMessage("Tap to activate"),
    "vgTapToConnect": MessageLookupByLibrary.simpleMessage("Tap to connect"),
    "vgTapToDisconnectWith": m63,
    "vgTelegramSupport": MessageLookupByLibrary.simpleMessage(
      "Telegram support",
    ),
    "vgTempEnabledSystemProxy": m64,
    "vgTesting": MessageLookupByLibrary.simpleMessage("Testing…"),
    "vgThreeYearly": MessageLookupByLibrary.simpleMessage("Every 3 years"),
    "vgTicketAwaitingReply": MessageLookupByLibrary.simpleMessage(
      "Awaiting reply",
    ),
    "vgTicketClosed": MessageLookupByLibrary.simpleMessage("Closed"),
    "vgTicketIsClosed": MessageLookupByLibrary.simpleMessage("Ticket closed"),
    "vgTicketNumber": m65,
    "vgTicketSupportReplied": MessageLookupByLibrary.simpleMessage(
      "Support replied",
    ),
    "vgTimeout": MessageLookupByLibrary.simpleMessage("Timeout"),
    "vgTotal": MessageLookupByLibrary.simpleMessage("Total"),
    "vgTotalDownload": MessageLookupByLibrary.simpleMessage("Total download"),
    "vgTotalUpload": MessageLookupByLibrary.simpleMessage("Total upload"),
    "vgTrafficNGb": m66,
    "vgTrafficStillOnTun": MessageLookupByLibrary.simpleMessage(
      "Your traffic is still carried by Voguesly\'s virtual NIC, so browsing is unaffected;",
    ),
    "vgTransfer": MessageLookupByLibrary.simpleMessage("Transfer"),
    "vgTransferAmountYuan": MessageLookupByLibrary.simpleMessage(
      "Transfer amount (CNY)",
    ),
    "vgTransferFailed": MessageLookupByLibrary.simpleMessage("Transfer failed"),
    "vgTransferToBalance": MessageLookupByLibrary.simpleMessage(
      "Transfer to balance",
    ),
    "vgTransferredToBalance": MessageLookupByLibrary.simpleMessage(
      "Transferred to balance",
    ),
    "vgTrialSpecs": MessageLookupByLibrary.simpleMessage(
      "6 hours / 500 MB — good for a quick connectivity check",
    ),
    "vgTryFreeOrBuyStarter": MessageLookupByLibrary.simpleMessage(
      "Try it free, or buy the starter pack for a full test",
    ),
    "vgTunAlsoNotInControlNote": MessageLookupByLibrary.simpleMessage(
      "The virtual NIC is not in control either, so you may genuinely be offline right now.",
    ),
    "vgTunDeviceWide": m67,
    "vgTunDeviceWideDesc": MessageLookupByLibrary.simpleMessage(
      "Takes over traffic for the whole device; other VPNs must be off and system permission granted",
    ),
    "vgTunNotAuthorized": MessageLookupByLibrary.simpleMessage(
      "TUN was not authorised, so device-wide traffic cannot be taken over for now.",
    ),
    "vgTunOffUsingCompatMode": MessageLookupByLibrary.simpleMessage(
      "Virtual NIC is off; you are currently on System Proxy compatibility mode.",
    ),
    "vgTunOnButNoUtun": MessageLookupByLibrary.simpleMessage(
      "Virtual NIC is enabled in settings, but public traffic is not going through utun. Authorisation may be incomplete.",
    ),
    "vgTunOnButNotInRouteTable": MessageLookupByLibrary.simpleMessage(
      "Virtual NIC is enabled in settings but is missing from the routing table. The background service may not be installed.",
    ),
    "vgTunPlusSystemProxy": MessageLookupByLibrary.simpleMessage(
      "TUN + system proxy",
    ),
    "vgTunServiceNeedsReauth": MessageLookupByLibrary.simpleMessage(
      "Voguesly\'s background TUN service needs to be authorised again. Under System Settings → General → Login Items & Extensions,",
    ),
    "vgTunServiceNeedsReauth2": MessageLookupByLibrary.simpleMessage(
      "allow Voguesly\'s background item, then return to Voguesly and tap connect once more.",
    ),
    "vgTunServiceNotEnabled": MessageLookupByLibrary.simpleMessage(
      "Voguesly\'s background TUN service is not enabled. Allow the background item in System Settings and try again.",
    ),
    "vgTunTwiceNoTakeover": MessageLookupByLibrary.simpleMessage(
      "TUN failed to take over system traffic after two attempts.",
    ),
    "vgTunUnaffectedNote": MessageLookupByLibrary.simpleMessage(
      "Your internet access is **unaffected** because Voguesly is on the virtual NIC.",
    ),
    "vgTurnOnVoguesly": MessageLookupByLibrary.simpleMessage(
      "Turn on Voguesly",
    ),
    "vgTwoYearly": MessageLookupByLibrary.simpleMessage("Every 2 years"),
    "vgUnknown": MessageLookupByLibrary.simpleMessage("Unknown"),
    "vgUnlockCheck": MessageLookupByLibrary.simpleMessage("Streaming unlock"),
    "vgUpdateCheckNetworkError": MessageLookupByLibrary.simpleMessage(
      "Network error, cannot check for updates right now. Check your connection and try again.",
    ),
    "vgUpdateFailedRetry": MessageLookupByLibrary.simpleMessage(
      "Update failed, please try again later",
    ),
    "vgUpdateSubscription": MessageLookupByLibrary.simpleMessage(
      "Update subscription",
    ),
    "vgUpdateSubscriptionFailed": MessageLookupByLibrary.simpleMessage(
      "Could not update the subscription, please try again later",
    ),
    "vgUpdating": MessageLookupByLibrary.simpleMessage("Updating…"),
    "vgUserCenter": MessageLookupByLibrary.simpleMessage("Account"),
    "vgUserCenterSubtitle": MessageLookupByLibrary.simpleMessage(
      "Balance, orders, reset subscription, change password",
    ),
    "vgV2RayFamilyClient": MessageLookupByLibrary.simpleMessage(
      "V2Ray-family client",
    ),
    "vgVersionBuildWith": m68,
    "vgVersionLabel": MessageLookupByLibrary.simpleMessage("Version"),
    "vgVersionNumber": m69,
    "vgVersionTapToCheck": m70,
    "vgViewLogs": MessageLookupByLibrary.simpleMessage("View logs"),
    "vgViewLogsSubtitle": MessageLookupByLibrary.simpleMessage(
      "Live connection logs, for troubleshooting",
    ),
    "vgViewOrdersResumePayment": MessageLookupByLibrary.simpleMessage(
      "View orders · resume unfinished payments",
    ),
    "vgVirtualNic": MessageLookupByLibrary.simpleMessage("the virtual NIC"),
    "vgVirtualNicTun": MessageLookupByLibrary.simpleMessage(
      "Virtual NIC (TUN)",
    ),
    "vgVirtualNicVpn": MessageLookupByLibrary.simpleMessage(
      "Virtual NIC (VPN)",
    ),
    "vgVogueslyInControl": MessageLookupByLibrary.simpleMessage(
      "Voguesly in control",
    ),
    "vgVogueslyInControlWith": m71,
    "vgVogueslyListening": MessageLookupByLibrary.simpleMessage(
      "Voguesly is listening",
    ),
    "vgVpnCouldNotConnect": MessageLookupByLibrary.simpleMessage(
      "The VPN could not be established (permission denied or blocked by the system). Please reconnect.",
    ),
    "vgWaitingForPayment": MessageLookupByLibrary.simpleMessage(
      "Waiting for payment",
    ),
    "vgWeChat": MessageLookupByLibrary.simpleMessage("WeChat"),
    "vgWebViewInitFailed": m72,
    "vgWithdraw": MessageLookupByLibrary.simpleMessage("Withdraw"),
    "vgWithdrawFailed": MessageLookupByLibrary.simpleMessage(
      "Withdrawal failed",
    ),
    "vgWithdrawMethod": MessageLookupByLibrary.simpleMessage(
      "Withdrawal method (Alipay / WeChat / USDT)",
    ),
    "vgWithdrawRequest": MessageLookupByLibrary.simpleMessage(
      "Withdrawal request",
    ),
    "vgWithdrawSubmitted": MessageLookupByLibrary.simpleMessage(
      "Withdrawal request submitted. Support will process it shortly.",
    ),
    "vgWrongEmailOrPassword": MessageLookupByLibrary.simpleMessage(
      "Wrong email or password",
    ),
    "vgYearly": MessageLookupByLibrary.simpleMessage("Yearly"),
    "vgYouAlreadyHavePlan": MessageLookupByLibrary.simpleMessage(
      "You already have a plan",
    ),
    "vibrantScheme": MessageLookupByLibrary.simpleMessage("Vibrant"),
    "view": MessageLookupByLibrary.simpleMessage("View"),
    "vogChooseAvatar": MessageLookupByLibrary.simpleMessage("Choose avatar"),
    "vogExpiry": MessageLookupByLibrary.simpleMessage("Expires"),
    "vogMyAccount": MessageLookupByLibrary.simpleMessage("My account"),
    "vogNotLoggedIn": MessageLookupByLibrary.simpleMessage("Not logged in"),
    "vogPermanent": MessageLookupByLibrary.simpleMessage("Permanent"),
    "vogRemainTotal": MessageLookupByLibrary.simpleMessage("Left / total"),
    "vpnConfigChangeDetected": MessageLookupByLibrary.simpleMessage(
      "VPN configuration change detected",
    ),
    "vpnEnableDesc": MessageLookupByLibrary.simpleMessage(
      "Auto routes all system traffic through VpnService",
    ),
    "vpnTip": MessageLookupByLibrary.simpleMessage(
      "Changes take effect after restarting the VPN",
    ),
    "webDAVConfiguration": MessageLookupByLibrary.simpleMessage(
      "WebDAV configuration",
    ),
    "whitelistMode": MessageLookupByLibrary.simpleMessage("Whitelist mode"),
    "yearsAgo": m73,
    "zh_CN": MessageLookupByLibrary.simpleMessage("Simplified Chinese"),
  };
}
