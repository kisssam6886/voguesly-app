// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class AppLocalizations {
  AppLocalizations();

  static AppLocalizations? _current;

  static AppLocalizations get current {
    assert(
      _current != null,
      'No instance of AppLocalizations was loaded. Try to initialize the AppLocalizations delegate before accessing AppLocalizations.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<AppLocalizations> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = AppLocalizations();
      AppLocalizations._current = instance;

      return instance;
    });
  }

  static AppLocalizations of(BuildContext context) {
    final instance = AppLocalizations.maybeOf(context);
    assert(
      instance != null,
      'No instance of AppLocalizations present in the widget tree. Did you add AppLocalizations.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static AppLocalizations? maybeOf(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  /// `Rule`
  String get rule {
    return Intl.message('Rule', name: 'rule', desc: '', args: []);
  }

  /// `Global`
  String get global {
    return Intl.message('Global', name: 'global', desc: '', args: []);
  }

  /// `Direct`
  String get direct {
    return Intl.message('Direct', name: 'direct', desc: '', args: []);
  }

  /// `Dashboard`
  String get dashboard {
    return Intl.message('Dashboard', name: 'dashboard', desc: '', args: []);
  }

  /// `Shop`
  String get shop {
    return Intl.message('Shop', name: 'shop', desc: '', args: []);
  }

  /// `Detection`
  String get detection {
    return Intl.message('Detection', name: 'detection', desc: '', args: []);
  }

  /// `Routes`
  String get proxies {
    return Intl.message('Routes', name: 'proxies', desc: '', args: []);
  }

  /// `Profile`
  String get profile {
    return Intl.message('Profile', name: 'profile', desc: '', args: []);
  }

  /// `My subscription`
  String get profiles {
    return Intl.message(
      'My subscription',
      name: 'profiles',
      desc: '',
      args: [],
    );
  }

  /// `Me`
  String get tools {
    return Intl.message('Me', name: 'tools', desc: '', args: []);
  }

  /// `Logs`
  String get logs {
    return Intl.message('Logs', name: 'logs', desc: '', args: []);
  }

  /// `Log capture records`
  String get logsDesc {
    return Intl.message(
      'Log capture records',
      name: 'logsDesc',
      desc: '',
      args: [],
    );
  }

  /// `Resources`
  String get resources {
    return Intl.message('Resources', name: 'resources', desc: '', args: []);
  }

  /// `External resource related info`
  String get resourcesDesc {
    return Intl.message(
      'External resource related info',
      name: 'resourcesDesc',
      desc: '',
      args: [],
    );
  }

  /// `Traffic usage`
  String get trafficUsage {
    return Intl.message(
      'Traffic usage',
      name: 'trafficUsage',
      desc: '',
      args: [],
    );
  }

  /// `Network speed`
  String get networkSpeed {
    return Intl.message(
      'Network speed',
      name: 'networkSpeed',
      desc: '',
      args: [],
    );
  }

  /// `Outbound mode`
  String get outboundMode {
    return Intl.message(
      'Outbound mode',
      name: 'outboundMode',
      desc: '',
      args: [],
    );
  }

  /// `Network detection`
  String get networkDetection {
    return Intl.message(
      'Network detection',
      name: 'networkDetection',
      desc: '',
      args: [],
    );
  }

  /// `Upload`
  String get upload {
    return Intl.message('Upload', name: 'upload', desc: '', args: []);
  }

  /// `Download`
  String get download {
    return Intl.message('Download', name: 'download', desc: '', args: []);
  }

  /// `No profile, Please add a profile`
  String get nullProfileDesc {
    return Intl.message(
      'No profile, Please add a profile',
      name: 'nullProfileDesc',
      desc: '',
      args: [],
    );
  }

  /// `Settings`
  String get settings {
    return Intl.message('Settings', name: 'settings', desc: '', args: []);
  }

  /// `Language`
  String get language {
    return Intl.message('Language', name: 'language', desc: '', args: []);
  }

  /// `Default`
  String get defaultText {
    return Intl.message('Default', name: 'defaultText', desc: '', args: []);
  }

  /// `More`
  String get more {
    return Intl.message('More', name: 'more', desc: '', args: []);
  }

  /// `Other`
  String get other {
    return Intl.message('Other', name: 'other', desc: '', args: []);
  }

  /// `About`
  String get about {
    return Intl.message('About', name: 'about', desc: '', args: []);
  }

  /// `English`
  String get en {
    return Intl.message('English', name: 'en', desc: '', args: []);
  }

  /// `Japanese`
  String get ja {
    return Intl.message('Japanese', name: 'ja', desc: '', args: []);
  }

  /// `Russian`
  String get ru {
    return Intl.message('Russian', name: 'ru', desc: '', args: []);
  }

  /// `Simplified Chinese`
  String get zh_CN {
    return Intl.message(
      'Simplified Chinese',
      name: 'zh_CN',
      desc: '',
      args: [],
    );
  }

  /// `Theme`
  String get theme {
    return Intl.message('Theme', name: 'theme', desc: '', args: []);
  }

  /// `Set dark mode,adjust the color`
  String get themeDesc {
    return Intl.message(
      'Set dark mode,adjust the color',
      name: 'themeDesc',
      desc: '',
      args: [],
    );
  }

  /// `Override`
  String get override {
    return Intl.message('Override', name: 'override', desc: '', args: []);
  }

  /// `AllowLan`
  String get allowLan {
    return Intl.message('AllowLan', name: 'allowLan', desc: '', args: []);
  }

  /// `Allow access proxy through the LAN`
  String get allowLanDesc {
    return Intl.message(
      'Allow access proxy through the LAN',
      name: 'allowLanDesc',
      desc: '',
      args: [],
    );
  }

  /// `TUN`
  String get tun {
    return Intl.message('TUN', name: 'tun', desc: '', args: []);
  }

  /// `Enable so Telegram, some games and apps work (password required the first time); otherwise only apps like browsers get through`
  String get tunDesc {
    return Intl.message(
      'Enable so Telegram, some games and apps work (password required the first time); otherwise only apps like browsers get through',
      name: 'tunDesc',
      desc: '',
      args: [],
    );
  }

  /// `Minimize on exit`
  String get minimizeOnExit {
    return Intl.message(
      'Minimize on exit',
      name: 'minimizeOnExit',
      desc: '',
      args: [],
    );
  }

  /// `Modify the default system exit event`
  String get minimizeOnExitDesc {
    return Intl.message(
      'Modify the default system exit event',
      name: 'minimizeOnExitDesc',
      desc: '',
      args: [],
    );
  }

  /// `Auto launch`
  String get autoLaunch {
    return Intl.message('Auto launch', name: 'autoLaunch', desc: '', args: []);
  }

  /// `Follow the system self startup`
  String get autoLaunchDesc {
    return Intl.message(
      'Follow the system self startup',
      name: 'autoLaunchDesc',
      desc: '',
      args: [],
    );
  }

  /// `SilentLaunch`
  String get silentLaunch {
    return Intl.message(
      'SilentLaunch',
      name: 'silentLaunch',
      desc: '',
      args: [],
    );
  }

  /// `Start in the background`
  String get silentLaunchDesc {
    return Intl.message(
      'Start in the background',
      name: 'silentLaunchDesc',
      desc: '',
      args: [],
    );
  }

  /// `AutoRun`
  String get autoRun {
    return Intl.message('AutoRun', name: 'autoRun', desc: '', args: []);
  }

  /// `Auto run when the application is opened`
  String get autoRunDesc {
    return Intl.message(
      'Auto run when the application is opened',
      name: 'autoRunDesc',
      desc: '',
      args: [],
    );
  }

  /// `Logcat`
  String get logcat {
    return Intl.message('Logcat', name: 'logcat', desc: '', args: []);
  }

  /// `Disabling will hide the log entry`
  String get logcatDesc {
    return Intl.message(
      'Disabling will hide the log entry',
      name: 'logcatDesc',
      desc: '',
      args: [],
    );
  }

  /// `Auto check updates`
  String get autoCheckUpdate {
    return Intl.message(
      'Auto check updates',
      name: 'autoCheckUpdate',
      desc: '',
      args: [],
    );
  }

  /// `Auto check for updates when the app starts`
  String get autoCheckUpdateDesc {
    return Intl.message(
      'Auto check for updates when the app starts',
      name: 'autoCheckUpdateDesc',
      desc: '',
      args: [],
    );
  }

  /// `AccessControl`
  String get accessControl {
    return Intl.message(
      'AccessControl',
      name: 'accessControl',
      desc: '',
      args: [],
    );
  }

  /// `Configure application access proxy`
  String get accessControlDesc {
    return Intl.message(
      'Configure application access proxy',
      name: 'accessControlDesc',
      desc: '',
      args: [],
    );
  }

  /// `Application`
  String get application {
    return Intl.message('Application', name: 'application', desc: '', args: []);
  }

  /// `Modify application related settings`
  String get applicationDesc {
    return Intl.message(
      'Modify application related settings',
      name: 'applicationDesc',
      desc: '',
      args: [],
    );
  }

  /// `Edit`
  String get edit {
    return Intl.message('Edit', name: 'edit', desc: '', args: []);
  }

  /// `Confirm`
  String get confirm {
    return Intl.message('Confirm', name: 'confirm', desc: '', args: []);
  }

  /// `Update`
  String get update {
    return Intl.message('Update', name: 'update', desc: '', args: []);
  }

  /// `Add`
  String get add {
    return Intl.message('Add', name: 'add', desc: '', args: []);
  }

  /// `Save`
  String get save {
    return Intl.message('Save', name: 'save', desc: '', args: []);
  }

  /// `Delete`
  String get delete {
    return Intl.message('Delete', name: 'delete', desc: '', args: []);
  }

  /// `Seconds`
  String get seconds {
    return Intl.message('Seconds', name: 'seconds', desc: '', args: []);
  }

  /// `QR code`
  String get qrcode {
    return Intl.message('QR code', name: 'qrcode', desc: '', args: []);
  }

  /// `Scan QR code to obtain profile`
  String get qrcodeDesc {
    return Intl.message(
      'Scan QR code to obtain profile',
      name: 'qrcodeDesc',
      desc: '',
      args: [],
    );
  }

  /// `URL`
  String get url {
    return Intl.message('URL', name: 'url', desc: '', args: []);
  }

  /// `Obtain profile through URL`
  String get urlDesc {
    return Intl.message(
      'Obtain profile through URL',
      name: 'urlDesc',
      desc: '',
      args: [],
    );
  }

  /// `File`
  String get file {
    return Intl.message('File', name: 'file', desc: '', args: []);
  }

  /// `Directly upload profile`
  String get fileDesc {
    return Intl.message(
      'Directly upload profile',
      name: 'fileDesc',
      desc: '',
      args: [],
    );
  }

  /// `Name`
  String get name {
    return Intl.message('Name', name: 'name', desc: '', args: []);
  }

  /// `Please input the profile name`
  String get profileNameNullValidationDesc {
    return Intl.message(
      'Please input the profile name',
      name: 'profileNameNullValidationDesc',
      desc: '',
      args: [],
    );
  }

  /// `Please input the profile URL`
  String get profileUrlNullValidationDesc {
    return Intl.message(
      'Please input the profile URL',
      name: 'profileUrlNullValidationDesc',
      desc: '',
      args: [],
    );
  }

  /// `Please input a valid profile URL`
  String get profileUrlInvalidValidationDesc {
    return Intl.message(
      'Please input a valid profile URL',
      name: 'profileUrlInvalidValidationDesc',
      desc: '',
      args: [],
    );
  }

  /// `Auto update`
  String get autoUpdate {
    return Intl.message('Auto update', name: 'autoUpdate', desc: '', args: []);
  }

  /// `Auto update interval (minutes)`
  String get autoUpdateInterval {
    return Intl.message(
      'Auto update interval (minutes)',
      name: 'autoUpdateInterval',
      desc: '',
      args: [],
    );
  }

  /// `Please enter the auto update interval time`
  String get profileAutoUpdateIntervalNullValidationDesc {
    return Intl.message(
      'Please enter the auto update interval time',
      name: 'profileAutoUpdateIntervalNullValidationDesc',
      desc: '',
      args: [],
    );
  }

  /// `Please input a valid interval time format`
  String get profileAutoUpdateIntervalInvalidValidationDesc {
    return Intl.message(
      'Please input a valid interval time format',
      name: 'profileAutoUpdateIntervalInvalidValidationDesc',
      desc: '',
      args: [],
    );
  }

  /// `Theme mode`
  String get themeMode {
    return Intl.message('Theme mode', name: 'themeMode', desc: '', args: []);
  }

  /// `Theme color`
  String get themeColor {
    return Intl.message('Theme color', name: 'themeColor', desc: '', args: []);
  }

  /// `Preview`
  String get preview {
    return Intl.message('Preview', name: 'preview', desc: '', args: []);
  }

  /// `Auto`
  String get auto {
    return Intl.message('Auto', name: 'auto', desc: '', args: []);
  }

  /// `Light`
  String get light {
    return Intl.message('Light', name: 'light', desc: '', args: []);
  }

  /// `Dark`
  String get dark {
    return Intl.message('Dark', name: 'dark', desc: '', args: []);
  }

  /// `Import from URL`
  String get importFromURL {
    return Intl.message(
      'Import from URL',
      name: 'importFromURL',
      desc: '',
      args: [],
    );
  }

  /// `Submit`
  String get submit {
    return Intl.message('Submit', name: 'submit', desc: '', args: []);
  }

  /// `Do you want to pass`
  String get doYouWantToPass {
    return Intl.message(
      'Do you want to pass',
      name: 'doYouWantToPass',
      desc: '',
      args: [],
    );
  }

  /// `Create`
  String get create {
    return Intl.message('Create', name: 'create', desc: '', args: []);
  }

  /// `Please upload a valid QR code`
  String get pleaseUploadValidQrcode {
    return Intl.message(
      'Please upload a valid QR code',
      name: 'pleaseUploadValidQrcode',
      desc: '',
      args: [],
    );
  }

  /// `Blacklist mode`
  String get blacklistMode {
    return Intl.message(
      'Blacklist mode',
      name: 'blacklistMode',
      desc: '',
      args: [],
    );
  }

  /// `Whitelist mode`
  String get whitelistMode {
    return Intl.message(
      'Whitelist mode',
      name: 'whitelistMode',
      desc: '',
      args: [],
    );
  }

  /// `Select all`
  String get selectAll {
    return Intl.message('Select all', name: 'selectAll', desc: '', args: []);
  }

  /// `Cancel select all`
  String get cancelSelectAll {
    return Intl.message(
      'Cancel select all',
      name: 'cancelSelectAll',
      desc: '',
      args: [],
    );
  }

  /// `App access control`
  String get appAccessControl {
    return Intl.message(
      'App access control',
      name: 'appAccessControl',
      desc: '',
      args: [],
    );
  }

  /// `Only allow selected app to enter VPN`
  String get accessControlAllowDesc {
    return Intl.message(
      'Only allow selected app to enter VPN',
      name: 'accessControlAllowDesc',
      desc: '',
      args: [],
    );
  }

  /// `The selected application will be excluded from VPN`
  String get accessControlNotAllowDesc {
    return Intl.message(
      'The selected application will be excluded from VPN',
      name: 'accessControlNotAllowDesc',
      desc: '',
      args: [],
    );
  }

  /// `Selected`
  String get selected {
    return Intl.message('Selected', name: 'selected', desc: '', args: []);
  }

  /// `ProxyPort`
  String get proxyPort {
    return Intl.message('ProxyPort', name: 'proxyPort', desc: '', args: []);
  }

  /// `Port`
  String get port {
    return Intl.message('Port', name: 'port', desc: '', args: []);
  }

  /// `LogLevel`
  String get logLevel {
    return Intl.message('LogLevel', name: 'logLevel', desc: '', args: []);
  }

  /// `Show`
  String get show {
    return Intl.message('Show', name: 'show', desc: '', args: []);
  }

  /// `Exit`
  String get exit {
    return Intl.message('Exit', name: 'exit', desc: '', args: []);
  }

  /// `System proxy`
  String get systemProxy {
    return Intl.message(
      'System proxy',
      name: 'systemProxy',
      desc: '',
      args: [],
    );
  }

  /// `Project`
  String get project {
    return Intl.message('Project', name: 'project', desc: '', args: []);
  }

  /// `Core`
  String get core {
    return Intl.message('Core', name: 'core', desc: '', args: []);
  }

  /// `Tab animation`
  String get tabAnimation {
    return Intl.message(
      'Tab animation',
      name: 'tabAnimation',
      desc: '',
      args: [],
    );
  }

  /// `A multi-platform proxy client based on ClashMeta, simple and easy to use, open-source and ad-free.`
  String get desc {
    return Intl.message(
      'A multi-platform proxy client based on ClashMeta, simple and easy to use, open-source and ad-free.',
      name: 'desc',
      desc: '',
      args: [],
    );
  }

  /// `Starting VPN...`
  String get startVpn {
    return Intl.message(
      'Starting VPN...',
      name: 'startVpn',
      desc: '',
      args: [],
    );
  }

  /// `Stopping VPN...`
  String get stopVpn {
    return Intl.message('Stopping VPN...', name: 'stopVpn', desc: '', args: []);
  }

  /// `Compatibility mode`
  String get compatible {
    return Intl.message(
      'Compatibility mode',
      name: 'compatible',
      desc: '',
      args: [],
    );
  }

  /// `The current proxy group cannot be selected.`
  String get notSelectedTip {
    return Intl.message(
      'The current proxy group cannot be selected.',
      name: 'notSelectedTip',
      desc: '',
      args: [],
    );
  }

  /// `tip`
  String get tip {
    return Intl.message('tip', name: 'tip', desc: '', args: []);
  }

  /// `Account`
  String get account {
    return Intl.message('Account', name: 'account', desc: '', args: []);
  }

  /// `Backup`
  String get backup {
    return Intl.message('Backup', name: 'backup', desc: '', args: []);
  }

  /// `Backup success`
  String get backupSuccess {
    return Intl.message(
      'Backup success',
      name: 'backupSuccess',
      desc: '',
      args: [],
    );
  }

  /// `No info`
  String get noInfo {
    return Intl.message('No info', name: 'noInfo', desc: '', args: []);
  }

  /// `Please bind WebDAV`
  String get pleaseBindWebDAV {
    return Intl.message(
      'Please bind WebDAV',
      name: 'pleaseBindWebDAV',
      desc: '',
      args: [],
    );
  }

  /// `Bind`
  String get bind {
    return Intl.message('Bind', name: 'bind', desc: '', args: []);
  }

  /// `Connectivity：`
  String get connectivity {
    return Intl.message(
      'Connectivity：',
      name: 'connectivity',
      desc: '',
      args: [],
    );
  }

  /// `WebDAV configuration`
  String get webDAVConfiguration {
    return Intl.message(
      'WebDAV configuration',
      name: 'webDAVConfiguration',
      desc: '',
      args: [],
    );
  }

  /// `Address`
  String get address {
    return Intl.message('Address', name: 'address', desc: '', args: []);
  }

  /// `WebDAV server address`
  String get addressHelp {
    return Intl.message(
      'WebDAV server address',
      name: 'addressHelp',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid WebDAV address`
  String get addressTip {
    return Intl.message(
      'Please enter a valid WebDAV address',
      name: 'addressTip',
      desc: '',
      args: [],
    );
  }

  /// `Password`
  String get password {
    return Intl.message('Password', name: 'password', desc: '', args: []);
  }

  /// `Check for updates`
  String get checkUpdate {
    return Intl.message(
      'Check for updates',
      name: 'checkUpdate',
      desc: '',
      args: [],
    );
  }

  /// `Discover the new version`
  String get discoverNewVersion {
    return Intl.message(
      'Discover the new version',
      name: 'discoverNewVersion',
      desc: '',
      args: [],
    );
  }

  /// `The current application is already the latest version`
  String get checkUpdateError {
    return Intl.message(
      'The current application is already the latest version',
      name: 'checkUpdateError',
      desc: '',
      args: [],
    );
  }

  /// `Go to download`
  String get goDownload {
    return Intl.message(
      'Go to download',
      name: 'goDownload',
      desc: '',
      args: [],
    );
  }

  /// `Unknown`
  String get unknown {
    return Intl.message('Unknown', name: 'unknown', desc: '', args: []);
  }

  /// `Country`
  String get country {
    return Intl.message('Country', name: 'country', desc: '', args: []);
  }

  /// `Search`
  String get search {
    return Intl.message('Search', name: 'search', desc: '', args: []);
  }

  /// `Allow applications to bypass VPN`
  String get allowBypass {
    return Intl.message(
      'Allow applications to bypass VPN',
      name: 'allowBypass',
      desc: '',
      args: [],
    );
  }

  /// `Some apps can bypass VPN when turned on`
  String get allowBypassDesc {
    return Intl.message(
      'Some apps can bypass VPN when turned on',
      name: 'allowBypassDesc',
      desc: '',
      args: [],
    );
  }

  /// `ExternalController`
  String get externalController {
    return Intl.message(
      'ExternalController',
      name: 'externalController',
      desc: '',
      args: [],
    );
  }

  /// `Once enabled, the Clash kernel can be controlled on port 9090`
  String get externalControllerDesc {
    return Intl.message(
      'Once enabled, the Clash kernel can be controlled on port 9090',
      name: 'externalControllerDesc',
      desc: '',
      args: [],
    );
  }

  /// `When turned on it will be able to receive IPv6 traffic`
  String get ipv6Desc {
    return Intl.message(
      'When turned on it will be able to receive IPv6 traffic',
      name: 'ipv6Desc',
      desc: '',
      args: [],
    );
  }

  /// `App`
  String get app {
    return Intl.message('App', name: 'app', desc: '', args: []);
  }

  /// `General`
  String get general {
    return Intl.message('General', name: 'general', desc: '', args: []);
  }

  /// `Attach HTTP proxy to VpnService`
  String get systemProxyDesc {
    return Intl.message(
      'Attach HTTP proxy to VpnService',
      name: 'systemProxyDesc',
      desc: '',
      args: [],
    );
  }

  /// `Unified delay`
  String get unifiedDelay {
    return Intl.message(
      'Unified delay',
      name: 'unifiedDelay',
      desc: '',
      args: [],
    );
  }

  /// `Remove extra delays such as handshaking`
  String get unifiedDelayDesc {
    return Intl.message(
      'Remove extra delays such as handshaking',
      name: 'unifiedDelayDesc',
      desc: '',
      args: [],
    );
  }

  /// `TCP concurrent`
  String get tcpConcurrent {
    return Intl.message(
      'TCP concurrent',
      name: 'tcpConcurrent',
      desc: '',
      args: [],
    );
  }

  /// `Enabling it will allow TCP concurrency`
  String get tcpConcurrentDesc {
    return Intl.message(
      'Enabling it will allow TCP concurrency',
      name: 'tcpConcurrentDesc',
      desc: '',
      args: [],
    );
  }

  /// `Geo Low Memory Mode`
  String get geodataLoader {
    return Intl.message(
      'Geo Low Memory Mode',
      name: 'geodataLoader',
      desc: '',
      args: [],
    );
  }

  /// `Enabling will use the Geo low memory loader`
  String get geodataLoaderDesc {
    return Intl.message(
      'Enabling will use the Geo low memory loader',
      name: 'geodataLoaderDesc',
      desc: '',
      args: [],
    );
  }

  /// `Requests`
  String get requests {
    return Intl.message('Requests', name: 'requests', desc: '', args: []);
  }

  /// `View recently request records`
  String get requestsDesc {
    return Intl.message(
      'View recently request records',
      name: 'requestsDesc',
      desc: '',
      args: [],
    );
  }

  /// `Find process`
  String get findProcessMode {
    return Intl.message(
      'Find process',
      name: 'findProcessMode',
      desc: '',
      args: [],
    );
  }

  /// `Init`
  String get init {
    return Intl.message('Init', name: 'init', desc: '', args: []);
  }

  /// `Long term effective`
  String get infiniteTime {
    return Intl.message(
      'Long term effective',
      name: 'infiniteTime',
      desc: '',
      args: [],
    );
  }

  /// `Connections`
  String get connections {
    return Intl.message('Connections', name: 'connections', desc: '', args: []);
  }

  /// `View current connections data`
  String get connectionsDesc {
    return Intl.message(
      'View current connections data',
      name: 'connectionsDesc',
      desc: '',
      args: [],
    );
  }

  /// `Intranet IP`
  String get intranetIP {
    return Intl.message('Intranet IP', name: 'intranetIP', desc: '', args: []);
  }

  /// `View`
  String get view {
    return Intl.message('View', name: 'view', desc: '', args: []);
  }

  /// `Cut`
  String get cut {
    return Intl.message('Cut', name: 'cut', desc: '', args: []);
  }

  /// `Copy`
  String get copy {
    return Intl.message('Copy', name: 'copy', desc: '', args: []);
  }

  /// `Paste`
  String get paste {
    return Intl.message('Paste', name: 'paste', desc: '', args: []);
  }

  /// `Test url`
  String get testUrl {
    return Intl.message('Test url', name: 'testUrl', desc: '', args: []);
  }

  /// `Sync`
  String get sync {
    return Intl.message('Sync', name: 'sync', desc: '', args: []);
  }

  /// `Update`
  String get updateSubscription {
    return Intl.message(
      'Update',
      name: 'updateSubscription',
      desc: '',
      args: [],
    );
  }

  /// `Hidden from recent tasks`
  String get exclude {
    return Intl.message(
      'Hidden from recent tasks',
      name: 'exclude',
      desc: '',
      args: [],
    );
  }

  /// `When the app is in the background, the app is hidden from the recent task`
  String get excludeDesc {
    return Intl.message(
      'When the app is in the background, the app is hidden from the recent task',
      name: 'excludeDesc',
      desc: '',
      args: [],
    );
  }

  /// `Standard`
  String get expand {
    return Intl.message('Standard', name: 'expand', desc: '', args: []);
  }

  /// `Shrink`
  String get shrink {
    return Intl.message('Shrink', name: 'shrink', desc: '', args: []);
  }

  /// `Min`
  String get min {
    return Intl.message('Min', name: 'min', desc: '', args: []);
  }

  /// `Tab`
  String get tab {
    return Intl.message('Tab', name: 'tab', desc: '', args: []);
  }

  /// `List`
  String get list {
    return Intl.message('List', name: 'list', desc: '', args: []);
  }

  /// `Delay`
  String get delay {
    return Intl.message('Delay', name: 'delay', desc: '', args: []);
  }

  /// `Style`
  String get style {
    return Intl.message('Style', name: 'style', desc: '', args: []);
  }

  /// `Size`
  String get size {
    return Intl.message('Size', name: 'size', desc: '', args: []);
  }

  /// `Sort`
  String get sort {
    return Intl.message('Sort', name: 'sort', desc: '', args: []);
  }

  /// `Columns`
  String get columns {
    return Intl.message('Columns', name: 'columns', desc: '', args: []);
  }

  /// `Proxy group`
  String get proxyGroup {
    return Intl.message('Proxy group', name: 'proxyGroup', desc: '', args: []);
  }

  /// `Go`
  String get go {
    return Intl.message('Go', name: 'go', desc: '', args: []);
  }

  /// `External link`
  String get externalLink {
    return Intl.message(
      'External link',
      name: 'externalLink',
      desc: '',
      args: [],
    );
  }

  /// `Other contributors`
  String get otherContributors {
    return Intl.message(
      'Other contributors',
      name: 'otherContributors',
      desc: '',
      args: [],
    );
  }

  /// `Auto close connections`
  String get autoCloseConnections {
    return Intl.message(
      'Auto close connections',
      name: 'autoCloseConnections',
      desc: '',
      args: [],
    );
  }

  /// `Auto close connections after change node`
  String get autoCloseConnectionsDesc {
    return Intl.message(
      'Auto close connections after change node',
      name: 'autoCloseConnectionsDesc',
      desc: '',
      args: [],
    );
  }

  /// `Only statistics proxy`
  String get onlyStatisticsProxy {
    return Intl.message(
      'Only statistics proxy',
      name: 'onlyStatisticsProxy',
      desc: '',
      args: [],
    );
  }

  /// `When turned on, only statistics proxy traffic`
  String get onlyStatisticsProxyDesc {
    return Intl.message(
      'When turned on, only statistics proxy traffic',
      name: 'onlyStatisticsProxyDesc',
      desc: '',
      args: [],
    );
  }

  /// `Pure black mode`
  String get pureBlackMode {
    return Intl.message(
      'Pure black mode',
      name: 'pureBlackMode',
      desc: '',
      args: [],
    );
  }

  /// `Tcp keep alive interval`
  String get keepAliveIntervalDesc {
    return Intl.message(
      'Tcp keep alive interval',
      name: 'keepAliveIntervalDesc',
      desc: '',
      args: [],
    );
  }

  /// ` entries`
  String get entries {
    return Intl.message(' entries', name: 'entries', desc: '', args: []);
  }

  /// `Local`
  String get local {
    return Intl.message('Local', name: 'local', desc: '', args: []);
  }

  /// `Remote`
  String get remote {
    return Intl.message('Remote', name: 'remote', desc: '', args: []);
  }

  /// `Backup local data to WebDAV`
  String get remoteBackupDesc {
    return Intl.message(
      'Backup local data to WebDAV',
      name: 'remoteBackupDesc',
      desc: '',
      args: [],
    );
  }

  /// `Backup local data to local`
  String get localBackupDesc {
    return Intl.message(
      'Backup local data to local',
      name: 'localBackupDesc',
      desc: '',
      args: [],
    );
  }

  /// `Mode`
  String get mode {
    return Intl.message('Mode', name: 'mode', desc: '', args: []);
  }

  /// `Time`
  String get time {
    return Intl.message('Time', name: 'time', desc: '', args: []);
  }

  /// `Source`
  String get source {
    return Intl.message('Source', name: 'source', desc: '', args: []);
  }

  /// `Action`
  String get action {
    return Intl.message('Action', name: 'action', desc: '', args: []);
  }

  /// `Intelligent selection`
  String get intelligentSelected {
    return Intl.message(
      'Intelligent selection',
      name: 'intelligentSelected',
      desc: '',
      args: [],
    );
  }

  /// `Clipboard import`
  String get clipboardImport {
    return Intl.message(
      'Clipboard import',
      name: 'clipboardImport',
      desc: '',
      args: [],
    );
  }

  /// `Export clipboard`
  String get clipboardExport {
    return Intl.message(
      'Export clipboard',
      name: 'clipboardExport',
      desc: '',
      args: [],
    );
  }

  /// `Layout`
  String get layout {
    return Intl.message('Layout', name: 'layout', desc: '', args: []);
  }

  /// `Tight`
  String get tight {
    return Intl.message('Tight', name: 'tight', desc: '', args: []);
  }

  /// `Standard`
  String get standard {
    return Intl.message('Standard', name: 'standard', desc: '', args: []);
  }

  /// `Loose`
  String get loose {
    return Intl.message('Loose', name: 'loose', desc: '', args: []);
  }

  /// `Profiles sort`
  String get profilesSort {
    return Intl.message(
      'Profiles sort',
      name: 'profilesSort',
      desc: '',
      args: [],
    );
  }

  /// `Start`
  String get start {
    return Intl.message('Start', name: 'start', desc: '', args: []);
  }

  /// `Stop`
  String get stop {
    return Intl.message('Stop', name: 'stop', desc: '', args: []);
  }

  /// `Update DNS related settings`
  String get dnsDesc {
    return Intl.message(
      'Update DNS related settings',
      name: 'dnsDesc',
      desc: '',
      args: [],
    );
  }

  /// `Key`
  String get key {
    return Intl.message('Key', name: 'key', desc: '', args: []);
  }

  /// `Value`
  String get value {
    return Intl.message('Value', name: 'value', desc: '', args: []);
  }

  /// `Add Hosts`
  String get hostsDesc {
    return Intl.message('Add Hosts', name: 'hostsDesc', desc: '', args: []);
  }

  /// `Changes take effect after restarting the VPN`
  String get vpnTip {
    return Intl.message(
      'Changes take effect after restarting the VPN',
      name: 'vpnTip',
      desc: '',
      args: [],
    );
  }

  /// `Auto routes all system traffic through VpnService`
  String get vpnEnableDesc {
    return Intl.message(
      'Auto routes all system traffic through VpnService',
      name: 'vpnEnableDesc',
      desc: '',
      args: [],
    );
  }

  /// `Options`
  String get options {
    return Intl.message('Options', name: 'options', desc: '', args: []);
  }

  /// `Loopback unlock tool`
  String get loopback {
    return Intl.message(
      'Loopback unlock tool',
      name: 'loopback',
      desc: '',
      args: [],
    );
  }

  /// `Used for UWP loopback unlocking`
  String get loopbackDesc {
    return Intl.message(
      'Used for UWP loopback unlocking',
      name: 'loopbackDesc',
      desc: '',
      args: [],
    );
  }

  /// `Providers`
  String get providers {
    return Intl.message('Providers', name: 'providers', desc: '', args: []);
  }

  /// `Proxy providers`
  String get proxyProviders {
    return Intl.message(
      'Proxy providers',
      name: 'proxyProviders',
      desc: '',
      args: [],
    );
  }

  /// `Rule providers`
  String get ruleProviders {
    return Intl.message(
      'Rule providers',
      name: 'ruleProviders',
      desc: '',
      args: [],
    );
  }

  /// `Override Dns`
  String get overrideDns {
    return Intl.message(
      'Override Dns',
      name: 'overrideDns',
      desc: '',
      args: [],
    );
  }

  /// `Turning it on will override the DNS options in the profile`
  String get overrideDnsDesc {
    return Intl.message(
      'Turning it on will override the DNS options in the profile',
      name: 'overrideDnsDesc',
      desc: '',
      args: [],
    );
  }

  /// `Status`
  String get status {
    return Intl.message('Status', name: 'status', desc: '', args: []);
  }

  /// `System DNS will be used when turned off`
  String get statusDesc {
    return Intl.message(
      'System DNS will be used when turned off',
      name: 'statusDesc',
      desc: '',
      args: [],
    );
  }

  /// `Prioritize the use of DOH's http/3`
  String get preferH3Desc {
    return Intl.message(
      'Prioritize the use of DOH\'s http/3',
      name: 'preferH3Desc',
      desc: '',
      args: [],
    );
  }

  /// `Respect rules`
  String get respectRules {
    return Intl.message(
      'Respect rules',
      name: 'respectRules',
      desc: '',
      args: [],
    );
  }

  /// `DNS connection following rules, need to configure proxy-server-nameserver`
  String get respectRulesDesc {
    return Intl.message(
      'DNS connection following rules, need to configure proxy-server-nameserver',
      name: 'respectRulesDesc',
      desc: '',
      args: [],
    );
  }

  /// `DNS mode`
  String get dnsMode {
    return Intl.message('DNS mode', name: 'dnsMode', desc: '', args: []);
  }

  /// `Fakeip range`
  String get fakeipRange {
    return Intl.message(
      'Fakeip range',
      name: 'fakeipRange',
      desc: '',
      args: [],
    );
  }

  /// `Fakeip filter`
  String get fakeipFilter {
    return Intl.message(
      'Fakeip filter',
      name: 'fakeipFilter',
      desc: '',
      args: [],
    );
  }

  /// `Default nameserver`
  String get defaultNameserver {
    return Intl.message(
      'Default nameserver',
      name: 'defaultNameserver',
      desc: '',
      args: [],
    );
  }

  /// `For resolving DNS server`
  String get defaultNameserverDesc {
    return Intl.message(
      'For resolving DNS server',
      name: 'defaultNameserverDesc',
      desc: '',
      args: [],
    );
  }

  /// `Nameserver`
  String get nameserver {
    return Intl.message('Nameserver', name: 'nameserver', desc: '', args: []);
  }

  /// `For resolving domain`
  String get nameserverDesc {
    return Intl.message(
      'For resolving domain',
      name: 'nameserverDesc',
      desc: '',
      args: [],
    );
  }

  /// `Use hosts`
  String get useHosts {
    return Intl.message('Use hosts', name: 'useHosts', desc: '', args: []);
  }

  /// `Use system hosts`
  String get useSystemHosts {
    return Intl.message(
      'Use system hosts',
      name: 'useSystemHosts',
      desc: '',
      args: [],
    );
  }

  /// `Nameserver policy`
  String get nameserverPolicy {
    return Intl.message(
      'Nameserver policy',
      name: 'nameserverPolicy',
      desc: '',
      args: [],
    );
  }

  /// `Specify the corresponding nameserver policy`
  String get nameserverPolicyDesc {
    return Intl.message(
      'Specify the corresponding nameserver policy',
      name: 'nameserverPolicyDesc',
      desc: '',
      args: [],
    );
  }

  /// `Proxy nameserver`
  String get proxyNameserver {
    return Intl.message(
      'Proxy nameserver',
      name: 'proxyNameserver',
      desc: '',
      args: [],
    );
  }

  /// `Domain for resolving proxy nodes`
  String get proxyNameserverDesc {
    return Intl.message(
      'Domain for resolving proxy nodes',
      name: 'proxyNameserverDesc',
      desc: '',
      args: [],
    );
  }

  /// `Fallback`
  String get fallback {
    return Intl.message('Fallback', name: 'fallback', desc: '', args: []);
  }

  /// `Generally use offshore DNS`
  String get fallbackDesc {
    return Intl.message(
      'Generally use offshore DNS',
      name: 'fallbackDesc',
      desc: '',
      args: [],
    );
  }

  /// `Fallback filter`
  String get fallbackFilter {
    return Intl.message(
      'Fallback filter',
      name: 'fallbackFilter',
      desc: '',
      args: [],
    );
  }

  /// `Geoip code`
  String get geoipCode {
    return Intl.message('Geoip code', name: 'geoipCode', desc: '', args: []);
  }

  /// `Ipcidr`
  String get ipcidr {
    return Intl.message('Ipcidr', name: 'ipcidr', desc: '', args: []);
  }

  /// `Domain`
  String get domain {
    return Intl.message('Domain', name: 'domain', desc: '', args: []);
  }

  /// `Reset`
  String get reset {
    return Intl.message('Reset', name: 'reset', desc: '', args: []);
  }

  /// `Show/Hide`
  String get action_view {
    return Intl.message('Show/Hide', name: 'action_view', desc: '', args: []);
  }

  /// `Start/Stop`
  String get action_start {
    return Intl.message('Start/Stop', name: 'action_start', desc: '', args: []);
  }

  /// `Switch mode`
  String get action_mode {
    return Intl.message('Switch mode', name: 'action_mode', desc: '', args: []);
  }

  /// `System proxy`
  String get action_proxy {
    return Intl.message(
      'System proxy',
      name: 'action_proxy',
      desc: '',
      args: [],
    );
  }

  /// `TUN`
  String get action_tun {
    return Intl.message('TUN', name: 'action_tun', desc: '', args: []);
  }

  /// `Disclaimer`
  String get disclaimer {
    return Intl.message('Disclaimer', name: 'disclaimer', desc: '', args: []);
  }

  /// `This software is only used for non-commercial purposes such as learning exchanges and scientific research. It is strictly prohibited to use this software for commercial purposes. Any commercial activity, if any, has nothing to do with this software.`
  String get disclaimerDesc {
    return Intl.message(
      'This software is only used for non-commercial purposes such as learning exchanges and scientific research. It is strictly prohibited to use this software for commercial purposes. Any commercial activity, if any, has nothing to do with this software.',
      name: 'disclaimerDesc',
      desc: '',
      args: [],
    );
  }

  /// `Agree`
  String get agree {
    return Intl.message('Agree', name: 'agree', desc: '', args: []);
  }

  /// `Hotkey Management`
  String get hotkeyManagement {
    return Intl.message(
      'Hotkey Management',
      name: 'hotkeyManagement',
      desc: '',
      args: [],
    );
  }

  /// `Use keyboard to control applications`
  String get hotkeyManagementDesc {
    return Intl.message(
      'Use keyboard to control applications',
      name: 'hotkeyManagementDesc',
      desc: '',
      args: [],
    );
  }

  /// `Please press the keyboard.`
  String get pressKeyboard {
    return Intl.message(
      'Please press the keyboard.',
      name: 'pressKeyboard',
      desc: '',
      args: [],
    );
  }

  /// `Please enter the correct hotkey`
  String get inputCorrectHotkey {
    return Intl.message(
      'Please enter the correct hotkey',
      name: 'inputCorrectHotkey',
      desc: '',
      args: [],
    );
  }

  /// `Hotkey conflict`
  String get hotkeyConflict {
    return Intl.message(
      'Hotkey conflict',
      name: 'hotkeyConflict',
      desc: '',
      args: [],
    );
  }

  /// `Remove`
  String get remove {
    return Intl.message('Remove', name: 'remove', desc: '', args: []);
  }

  /// `No HotKey`
  String get noHotKey {
    return Intl.message('No HotKey', name: 'noHotKey', desc: '', args: []);
  }

  /// `No network`
  String get noNetwork {
    return Intl.message('No network', name: 'noNetwork', desc: '', args: []);
  }

  /// `Allow IPv6 inbound`
  String get ipv6InboundDesc {
    return Intl.message(
      'Allow IPv6 inbound',
      name: 'ipv6InboundDesc',
      desc: '',
      args: [],
    );
  }

  /// `Export logs`
  String get exportLogs {
    return Intl.message('Export logs', name: 'exportLogs', desc: '', args: []);
  }

  /// `Export Success`
  String get exportSuccess {
    return Intl.message(
      'Export Success',
      name: 'exportSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Icon style`
  String get iconStyle {
    return Intl.message('Icon style', name: 'iconStyle', desc: '', args: []);
  }

  /// `Icon`
  String get onlyIcon {
    return Intl.message('Icon', name: 'onlyIcon', desc: '', args: []);
  }

  /// `Stack mode`
  String get stackMode {
    return Intl.message('Stack mode', name: 'stackMode', desc: '', args: []);
  }

  /// `Network`
  String get network {
    return Intl.message('Network', name: 'network', desc: '', args: []);
  }

  /// `Modify network-related settings`
  String get networkDesc {
    return Intl.message(
      'Modify network-related settings',
      name: 'networkDesc',
      desc: '',
      args: [],
    );
  }

  /// `Bypass domain`
  String get bypassDomain {
    return Intl.message(
      'Bypass domain',
      name: 'bypassDomain',
      desc: '',
      args: [],
    );
  }

  /// `Only takes effect when the system proxy is enabled`
  String get bypassDomainDesc {
    return Intl.message(
      'Only takes effect when the system proxy is enabled',
      name: 'bypassDomainDesc',
      desc: '',
      args: [],
    );
  }

  /// `Make sure to reset`
  String get resetTip {
    return Intl.message(
      'Make sure to reset',
      name: 'resetTip',
      desc: '',
      args: [],
    );
  }

  /// `Icon`
  String get icon {
    return Intl.message('Icon', name: 'icon', desc: '', args: []);
  }

  /// `No data`
  String get noData {
    return Intl.message('No data', name: 'noData', desc: '', args: []);
  }

  /// `FontFamily`
  String get fontFamily {
    return Intl.message('FontFamily', name: 'fontFamily', desc: '', args: []);
  }

  /// `Toggle`
  String get toggle {
    return Intl.message('Toggle', name: 'toggle', desc: '', args: []);
  }

  /// `System`
  String get system {
    return Intl.message('System', name: 'system', desc: '', args: []);
  }

  /// `Route mode`
  String get routeMode {
    return Intl.message('Route mode', name: 'routeMode', desc: '', args: []);
  }

  /// `Bypass private route address`
  String get routeMode_bypassPrivate {
    return Intl.message(
      'Bypass private route address',
      name: 'routeMode_bypassPrivate',
      desc: '',
      args: [],
    );
  }

  /// `Use config`
  String get routeMode_config {
    return Intl.message(
      'Use config',
      name: 'routeMode_config',
      desc: '',
      args: [],
    );
  }

  /// `Route address`
  String get routeAddress {
    return Intl.message(
      'Route address',
      name: 'routeAddress',
      desc: '',
      args: [],
    );
  }

  /// `Config listen route address`
  String get routeAddressDesc {
    return Intl.message(
      'Config listen route address',
      name: 'routeAddressDesc',
      desc: '',
      args: [],
    );
  }

  /// `Please enter the admin password`
  String get pleaseInputAdminPassword {
    return Intl.message(
      'Please enter the admin password',
      name: 'pleaseInputAdminPassword',
      desc: '',
      args: [],
    );
  }

  /// `Copying environment variables`
  String get copyEnvVar {
    return Intl.message(
      'Copying environment variables',
      name: 'copyEnvVar',
      desc: '',
      args: [],
    );
  }

  /// `Memory info`
  String get memoryInfo {
    return Intl.message('Memory info', name: 'memoryInfo', desc: '', args: []);
  }

  /// `Cancel`
  String get cancel {
    return Intl.message('Cancel', name: 'cancel', desc: '', args: []);
  }

  /// `The file has been modified. Do you want to save the changes?`
  String get fileIsUpdate {
    return Intl.message(
      'The file has been modified. Do you want to save the changes?',
      name: 'fileIsUpdate',
      desc: '',
      args: [],
    );
  }

  /// `The profile has been modified. Do you want to disable auto update?`
  String get profileHasUpdate {
    return Intl.message(
      'The profile has been modified. Do you want to disable auto update?',
      name: 'profileHasUpdate',
      desc: '',
      args: [],
    );
  }

  /// `Do you want to cache the changes?`
  String get hasCacheChange {
    return Intl.message(
      'Do you want to cache the changes?',
      name: 'hasCacheChange',
      desc: '',
      args: [],
    );
  }

  /// `Copy success`
  String get copySuccess {
    return Intl.message(
      'Copy success',
      name: 'copySuccess',
      desc: '',
      args: [],
    );
  }

  /// `Copy link`
  String get copyLink {
    return Intl.message('Copy link', name: 'copyLink', desc: '', args: []);
  }

  /// `Export file`
  String get exportFile {
    return Intl.message('Export file', name: 'exportFile', desc: '', args: []);
  }

  /// `The cache is corrupt. Do you want to clear it?`
  String get cacheCorrupt {
    return Intl.message(
      'The cache is corrupt. Do you want to clear it?',
      name: 'cacheCorrupt',
      desc: '',
      args: [],
    );
  }

  /// `Relying on third-party api is for reference only`
  String get detectionTip {
    return Intl.message(
      'Relying on third-party api is for reference only',
      name: 'detectionTip',
      desc: '',
      args: [],
    );
  }

  /// `Listen`
  String get listen {
    return Intl.message('Listen', name: 'listen', desc: '', args: []);
  }

  /// `undo`
  String get undo {
    return Intl.message('undo', name: 'undo', desc: '', args: []);
  }

  /// `redo`
  String get redo {
    return Intl.message('redo', name: 'redo', desc: '', args: []);
  }

  /// `none`
  String get none {
    return Intl.message('none', name: 'none', desc: '', args: []);
  }

  /// `Basic configuration`
  String get basicConfig {
    return Intl.message(
      'Basic configuration',
      name: 'basicConfig',
      desc: '',
      args: [],
    );
  }

  /// `Modify the basic configuration globally`
  String get basicConfigDesc {
    return Intl.message(
      'Modify the basic configuration globally',
      name: 'basicConfigDesc',
      desc: '',
      args: [],
    );
  }

  /// `Advanced configuration`
  String get advancedConfig {
    return Intl.message(
      'Advanced configuration',
      name: 'advancedConfig',
      desc: '',
      args: [],
    );
  }

  /// `Advanced`
  String get advancedTools {
    return Intl.message('Advanced', name: 'advancedTools', desc: '', args: []);
  }

  /// `Provide diverse configuration options`
  String get advancedConfigDesc {
    return Intl.message(
      'Provide diverse configuration options',
      name: 'advancedConfigDesc',
      desc: '',
      args: [],
    );
  }

  /// `{count} items have been selected`
  String selectedCountTitle(Object count) {
    return Intl.message(
      '$count items have been selected',
      name: 'selectedCountTitle',
      desc: '',
      args: [count],
    );
  }

  /// `Add rule`
  String get addRule {
    return Intl.message('Add rule', name: 'addRule', desc: '', args: []);
  }

  /// `Rule name`
  String get ruleName {
    return Intl.message('Rule name', name: 'ruleName', desc: '', args: []);
  }

  /// `Content`
  String get content {
    return Intl.message('Content', name: 'content', desc: '', args: []);
  }

  /// `Sub rule`
  String get subRule {
    return Intl.message('Sub rule', name: 'subRule', desc: '', args: []);
  }

  /// `Rule target`
  String get ruleTarget {
    return Intl.message('Rule target', name: 'ruleTarget', desc: '', args: []);
  }

  /// `Source IP`
  String get sourceIp {
    return Intl.message('Source IP', name: 'sourceIp', desc: '', args: []);
  }

  /// `No resolve IP`
  String get noResolve {
    return Intl.message('No resolve IP', name: 'noResolve', desc: '', args: []);
  }

  /// `Do you want to save the changes?`
  String get saveChanges {
    return Intl.message(
      'Do you want to save the changes?',
      name: 'saveChanges',
      desc: '',
      args: [],
    );
  }

  /// `There is a certain performance loss after opening`
  String get findProcessModeDesc {
    return Intl.message(
      'There is a certain performance loss after opening',
      name: 'findProcessModeDesc',
      desc: '',
      args: [],
    );
  }

  /// `Effective only in mobile view`
  String get tabAnimationDesc {
    return Intl.message(
      'Effective only in mobile view',
      name: 'tabAnimationDesc',
      desc: '',
      args: [],
    );
  }

  /// `Color schemes`
  String get colorSchemes {
    return Intl.message(
      'Color schemes',
      name: 'colorSchemes',
      desc: '',
      args: [],
    );
  }

  /// `Palette`
  String get palette {
    return Intl.message('Palette', name: 'palette', desc: '', args: []);
  }

  /// `TonalSpot`
  String get tonalSpotScheme {
    return Intl.message(
      'TonalSpot',
      name: 'tonalSpotScheme',
      desc: '',
      args: [],
    );
  }

  /// `Fidelity`
  String get fidelityScheme {
    return Intl.message('Fidelity', name: 'fidelityScheme', desc: '', args: []);
  }

  /// `Monochrome`
  String get monochromeScheme {
    return Intl.message(
      'Monochrome',
      name: 'monochromeScheme',
      desc: '',
      args: [],
    );
  }

  /// `Neutral`
  String get neutralScheme {
    return Intl.message('Neutral', name: 'neutralScheme', desc: '', args: []);
  }

  /// `Vibrant`
  String get vibrantScheme {
    return Intl.message('Vibrant', name: 'vibrantScheme', desc: '', args: []);
  }

  /// `Expressive`
  String get expressiveScheme {
    return Intl.message(
      'Expressive',
      name: 'expressiveScheme',
      desc: '',
      args: [],
    );
  }

  /// `Content`
  String get contentScheme {
    return Intl.message('Content', name: 'contentScheme', desc: '', args: []);
  }

  /// `Rainbow`
  String get rainbowScheme {
    return Intl.message('Rainbow', name: 'rainbowScheme', desc: '', args: []);
  }

  /// `FruitSalad`
  String get fruitSaladScheme {
    return Intl.message(
      'FruitSalad',
      name: 'fruitSaladScheme',
      desc: '',
      args: [],
    );
  }

  /// `Developer mode`
  String get developerMode {
    return Intl.message(
      'Developer mode',
      name: 'developerMode',
      desc: '',
      args: [],
    );
  }

  /// `Developer mode is enabled.`
  String get developerModeEnableTip {
    return Intl.message(
      'Developer mode is enabled.',
      name: 'developerModeEnableTip',
      desc: '',
      args: [],
    );
  }

  /// `Message test`
  String get messageTest {
    return Intl.message(
      'Message test',
      name: 'messageTest',
      desc: '',
      args: [],
    );
  }

  /// `This is a message.`
  String get messageTestTip {
    return Intl.message(
      'This is a message.',
      name: 'messageTestTip',
      desc: '',
      args: [],
    );
  }

  /// `Crash test`
  String get crashTest {
    return Intl.message('Crash test', name: 'crashTest', desc: '', args: []);
  }

  /// `Clear Data`
  String get clearData {
    return Intl.message('Clear Data', name: 'clearData', desc: '', args: []);
  }

  /// `Text Scaling`
  String get textScale {
    return Intl.message('Text Scaling', name: 'textScale', desc: '', args: []);
  }

  /// `Internet`
  String get internet {
    return Intl.message('Internet', name: 'internet', desc: '', args: []);
  }

  /// `System APP`
  String get systemApp {
    return Intl.message('System APP', name: 'systemApp', desc: '', args: []);
  }

  /// `No network APP`
  String get noNetworkApp {
    return Intl.message(
      'No network APP',
      name: 'noNetworkApp',
      desc: '',
      args: [],
    );
  }

  /// `Restore strategy`
  String get restoreStrategy {
    return Intl.message(
      'Restore strategy',
      name: 'restoreStrategy',
      desc: '',
      args: [],
    );
  }

  /// `Override`
  String get restoreStrategy_override {
    return Intl.message(
      'Override',
      name: 'restoreStrategy_override',
      desc: '',
      args: [],
    );
  }

  /// `Compatible`
  String get restoreStrategy_compatible {
    return Intl.message(
      'Compatible',
      name: 'restoreStrategy_compatible',
      desc: '',
      args: [],
    );
  }

  /// `Logs test`
  String get logsTest {
    return Intl.message('Logs test', name: 'logsTest', desc: '', args: []);
  }

  /// `{label} cannot be empty`
  String emptyTip(Object label) {
    return Intl.message(
      '$label cannot be empty',
      name: 'emptyTip',
      desc: '',
      args: [label],
    );
  }

  /// `{label} must be a url`
  String urlTip(Object label) {
    return Intl.message(
      '$label must be a url',
      name: 'urlTip',
      desc: '',
      args: [label],
    );
  }

  /// `{label} must be a number`
  String numberTip(Object label) {
    return Intl.message(
      '$label must be a number',
      name: 'numberTip',
      desc: '',
      args: [label],
    );
  }

  /// `Interval`
  String get interval {
    return Intl.message('Interval', name: 'interval', desc: '', args: []);
  }

  /// `Current {label} already exists`
  String existsTip(Object label) {
    return Intl.message(
      'Current $label already exists',
      name: 'existsTip',
      desc: '',
      args: [label],
    );
  }

  /// `Are you sure you want to delete the current {label}?`
  String deleteTip(Object label) {
    return Intl.message(
      'Are you sure you want to delete the current $label?',
      name: 'deleteTip',
      desc: '',
      args: [label],
    );
  }

  /// `Are you sure you want to delete the selected {label}?`
  String deleteMultipTip(Object label) {
    return Intl.message(
      'Are you sure you want to delete the selected $label?',
      name: 'deleteMultipTip',
      desc: '',
      args: [label],
    );
  }

  /// `No {label} yet`
  String nullTip(Object label) {
    return Intl.message(
      'No $label yet',
      name: 'nullTip',
      desc: '',
      args: [label],
    );
  }

  /// `Script`
  String get script {
    return Intl.message('Script', name: 'script', desc: '', args: []);
  }

  /// `Color`
  String get color {
    return Intl.message('Color', name: 'color', desc: '', args: []);
  }

  /// `Rename`
  String get rename {
    return Intl.message('Rename', name: 'rename', desc: '', args: []);
  }

  /// `Unnamed`
  String get unnamed {
    return Intl.message('Unnamed', name: 'unnamed', desc: '', args: []);
  }

  /// `Please enter a script name`
  String get pleaseEnterScriptName {
    return Intl.message(
      'Please enter a script name',
      name: 'pleaseEnterScriptName',
      desc: '',
      args: [],
    );
  }

  /// `Mixed Port`
  String get mixedPort {
    return Intl.message('Mixed Port', name: 'mixedPort', desc: '', args: []);
  }

  /// `Socks Port`
  String get socksPort {
    return Intl.message('Socks Port', name: 'socksPort', desc: '', args: []);
  }

  /// `Redir Port`
  String get redirPort {
    return Intl.message('Redir Port', name: 'redirPort', desc: '', args: []);
  }

  /// `Tproxy Port`
  String get tproxyPort {
    return Intl.message('Tproxy Port', name: 'tproxyPort', desc: '', args: []);
  }

  /// `{label} must be between 1024 and 49151`
  String portTip(Object label) {
    return Intl.message(
      '$label must be between 1024 and 49151',
      name: 'portTip',
      desc: '',
      args: [label],
    );
  }

  /// `Please enter a different port`
  String get portConflictTip {
    return Intl.message(
      'Please enter a different port',
      name: 'portConflictTip',
      desc: '',
      args: [],
    );
  }

  /// `Import`
  String get import {
    return Intl.message('Import', name: 'import', desc: '', args: []);
  }

  /// `Import from file`
  String get importFile {
    return Intl.message(
      'Import from file',
      name: 'importFile',
      desc: '',
      args: [],
    );
  }

  /// `Import from URL`
  String get importUrl {
    return Intl.message(
      'Import from URL',
      name: 'importUrl',
      desc: '',
      args: [],
    );
  }

  /// `Auto set system DNS`
  String get autoSetSystemDns {
    return Intl.message(
      'Auto set system DNS',
      name: 'autoSetSystemDns',
      desc: '',
      args: [],
    );
  }

  /// `{label} details`
  String details(Object label) {
    return Intl.message(
      '$label details',
      name: 'details',
      desc: '',
      args: [label],
    );
  }

  /// `Creation time`
  String get creationTime {
    return Intl.message(
      'Creation time',
      name: 'creationTime',
      desc: '',
      args: [],
    );
  }

  /// `Process`
  String get process {
    return Intl.message('Process', name: 'process', desc: '', args: []);
  }

  /// `Host`
  String get host {
    return Intl.message('Host', name: 'host', desc: '', args: []);
  }

  /// `Destination`
  String get destination {
    return Intl.message('Destination', name: 'destination', desc: '', args: []);
  }

  /// `Destination GeoIP`
  String get destinationGeoIP {
    return Intl.message(
      'Destination GeoIP',
      name: 'destinationGeoIP',
      desc: '',
      args: [],
    );
  }

  /// `Destination IPASN`
  String get destinationIPASN {
    return Intl.message(
      'Destination IPASN',
      name: 'destinationIPASN',
      desc: '',
      args: [],
    );
  }

  /// `Special proxy`
  String get specialProxy {
    return Intl.message(
      'Special proxy',
      name: 'specialProxy',
      desc: '',
      args: [],
    );
  }

  /// `special rules`
  String get specialRules {
    return Intl.message(
      'special rules',
      name: 'specialRules',
      desc: '',
      args: [],
    );
  }

  /// `Remote destination`
  String get remoteDestination {
    return Intl.message(
      'Remote destination',
      name: 'remoteDestination',
      desc: '',
      args: [],
    );
  }

  /// `Network type`
  String get networkType {
    return Intl.message(
      'Network type',
      name: 'networkType',
      desc: '',
      args: [],
    );
  }

  /// `Proxy chains`
  String get proxyChains {
    return Intl.message(
      'Proxy chains',
      name: 'proxyChains',
      desc: '',
      args: [],
    );
  }

  /// `Log`
  String get log {
    return Intl.message('Log', name: 'log', desc: '', args: []);
  }

  /// `Connection`
  String get connection {
    return Intl.message('Connection', name: 'connection', desc: '', args: []);
  }

  /// `Request`
  String get request {
    return Intl.message('Request', name: 'request', desc: '', args: []);
  }

  /// `Connected`
  String get connected {
    return Intl.message('Connected', name: 'connected', desc: '', args: []);
  }

  /// `Disconnected`
  String get disconnected {
    return Intl.message(
      'Disconnected',
      name: 'disconnected',
      desc: '',
      args: [],
    );
  }

  /// `Connecting...`
  String get connecting {
    return Intl.message(
      'Connecting...',
      name: 'connecting',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to restart the core?`
  String get restartCoreTip {
    return Intl.message(
      'Are you sure you want to restart the core?',
      name: 'restartCoreTip',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to force restart the core?`
  String get forceRestartCoreTip {
    return Intl.message(
      'Are you sure you want to force restart the core?',
      name: 'forceRestartCoreTip',
      desc: '',
      args: [],
    );
  }

  /// `DNS hijacking`
  String get dnsHijacking {
    return Intl.message(
      'DNS hijacking',
      name: 'dnsHijacking',
      desc: '',
      args: [],
    );
  }

  /// `Core status`
  String get coreStatus {
    return Intl.message('Core status', name: 'coreStatus', desc: '', args: []);
  }

  /// `Data Collection Notice`
  String get dataCollectionTip {
    return Intl.message(
      'Data Collection Notice',
      name: 'dataCollectionTip',
      desc: '',
      args: [],
    );
  }

  /// `This app uses Firebase Crashlytics to collect crash information to improve app stability.\nThe collected data includes device information and crash details, but does not contain personal sensitive data.\nYou can disable this feature in settings.`
  String get dataCollectionContent {
    return Intl.message(
      'This app uses Firebase Crashlytics to collect crash information to improve app stability.\nThe collected data includes device information and crash details, but does not contain personal sensitive data.\nYou can disable this feature in settings.',
      name: 'dataCollectionContent',
      desc: '',
      args: [],
    );
  }

  /// `Crash Analysis`
  String get crashlytics {
    return Intl.message(
      'Crash Analysis',
      name: 'crashlytics',
      desc: '',
      args: [],
    );
  }

  /// `When enabled, automatically uploads crash logs without sensitive information when the app crashes`
  String get crashlyticsTip {
    return Intl.message(
      'When enabled, automatically uploads crash logs without sensitive information when the app crashes',
      name: 'crashlyticsTip',
      desc: '',
      args: [],
    );
  }

  /// `Append System DNS`
  String get appendSystemDns {
    return Intl.message(
      'Append System DNS',
      name: 'appendSystemDns',
      desc: '',
      args: [],
    );
  }

  /// `Forcefully append system DNS to the configuration`
  String get appendSystemDnsTip {
    return Intl.message(
      'Forcefully append system DNS to the configuration',
      name: 'appendSystemDnsTip',
      desc: '',
      args: [],
    );
  }

  /// `Edit rule`
  String get editRule {
    return Intl.message('Edit rule', name: 'editRule', desc: '', args: []);
  }

  /// `Override mode`
  String get overrideMode {
    return Intl.message(
      'Override mode',
      name: 'overrideMode',
      desc: '',
      args: [],
    );
  }

  /// `Standard mode, override basic configuration, provide simple rule addition capability`
  String get standardModeDesc {
    return Intl.message(
      'Standard mode, override basic configuration, provide simple rule addition capability',
      name: 'standardModeDesc',
      desc: '',
      args: [],
    );
  }

  /// `Script mode, use external extension scripts, provide one-click override configuration capability`
  String get scriptModeDesc {
    return Intl.message(
      'Script mode, use external extension scripts, provide one-click override configuration capability',
      name: 'scriptModeDesc',
      desc: '',
      args: [],
    );
  }

  /// `Added rules`
  String get addedRules {
    return Intl.message('Added rules', name: 'addedRules', desc: '', args: []);
  }

  /// `Control global added rules`
  String get controlGlobalAddedRules {
    return Intl.message(
      'Control global added rules',
      name: 'controlGlobalAddedRules',
      desc: '',
      args: [],
    );
  }

  /// `Override script`
  String get overrideScript {
    return Intl.message(
      'Override script',
      name: 'overrideScript',
      desc: '',
      args: [],
    );
  }

  /// `Go to configure script`
  String get goToConfigureScript {
    return Intl.message(
      'Go to configure script',
      name: 'goToConfigureScript',
      desc: '',
      args: [],
    );
  }

  /// `Edit global rules`
  String get editGlobalRules {
    return Intl.message(
      'Edit global rules',
      name: 'editGlobalRules',
      desc: '',
      args: [],
    );
  }

  /// `External fetch`
  String get externalFetch {
    return Intl.message(
      'External fetch',
      name: 'externalFetch',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to force crash the core?`
  String get confirmForceCrashCore {
    return Intl.message(
      'Are you sure you want to force crash the core?',
      name: 'confirmForceCrashCore',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to clear all data?`
  String get confirmClearAllData {
    return Intl.message(
      'Are you sure you want to clear all data?',
      name: 'confirmClearAllData',
      desc: '',
      args: [],
    );
  }

  /// `Loading...`
  String get loading {
    return Intl.message('Loading...', name: 'loading', desc: '', args: []);
  }

  /// `Load test`
  String get loadTest {
    return Intl.message('Load test', name: 'loadTest', desc: '', args: []);
  }

  /// `{count, plural, =1{1 year ago} other{{count} years ago}}`
  String yearsAgo(num count) {
    return Intl.plural(
      count,
      one: '1 year ago',
      other: '$count years ago',
      name: 'yearsAgo',
      desc: '',
      args: [count],
    );
  }

  /// `{count, plural, =1{1 month ago} other{{count} months ago}}`
  String monthsAgo(num count) {
    return Intl.plural(
      count,
      one: '1 month ago',
      other: '$count months ago',
      name: 'monthsAgo',
      desc: '',
      args: [count],
    );
  }

  /// `{count, plural, =1{1 day ago} other{{count} days ago}}`
  String daysAgo(num count) {
    return Intl.plural(
      count,
      one: '1 day ago',
      other: '$count days ago',
      name: 'daysAgo',
      desc: '',
      args: [count],
    );
  }

  /// `{count, plural, =1{1 hour ago} other{{count} hours ago}}`
  String hoursAgo(num count) {
    return Intl.plural(
      count,
      one: '1 hour ago',
      other: '$count hours ago',
      name: 'hoursAgo',
      desc: '',
      args: [count],
    );
  }

  /// `{count, plural, =1{1 minute ago} other{{count} minutes ago}}`
  String minutesAgo(num count) {
    return Intl.plural(
      count,
      one: '1 minute ago',
      other: '$count minutes ago',
      name: 'minutesAgo',
      desc: '',
      args: [count],
    );
  }

  /// `Just now`
  String get justNow {
    return Intl.message('Just now', name: 'justNow', desc: '', args: []);
  }

  /// `Don't remind again`
  String get noLongerRemind {
    return Intl.message(
      'Don\'t remind again',
      name: 'noLongerRemind',
      desc: '',
      args: [],
    );
  }

  /// `Access Control Settings`
  String get accessControlSettings {
    return Intl.message(
      'Access Control Settings',
      name: 'accessControlSettings',
      desc: '',
      args: [],
    );
  }

  /// `Turn On`
  String get turnOn {
    return Intl.message('Turn On', name: 'turnOn', desc: '', args: []);
  }

  /// `Turn Off`
  String get turnOff {
    return Intl.message('Turn Off', name: 'turnOff', desc: '', args: []);
  }

  /// `VPN configuration change detected`
  String get vpnConfigChangeDetected {
    return Intl.message(
      'VPN configuration change detected',
      name: 'vpnConfigChangeDetected',
      desc: '',
      args: [],
    );
  }

  /// `Restart`
  String get restart {
    return Intl.message('Restart', name: 'restart', desc: '', args: []);
  }

  /// `Speed statistics`
  String get speedStatistics {
    return Intl.message(
      'Speed statistics',
      name: 'speedStatistics',
      desc: '',
      args: [],
    );
  }

  /// `The current page has changes. Are you sure you want to reset?`
  String get resetPageChangesTip {
    return Intl.message(
      'The current page has changes. Are you sure you want to reset?',
      name: 'resetPageChangesTip',
      desc: '',
      args: [],
    );
  }

  /// `Custom`
  String get overwriteTypeCustom {
    return Intl.message(
      'Custom',
      name: 'overwriteTypeCustom',
      desc: '',
      args: [],
    );
  }

  /// `Custom mode, fully customize proxy groups and rules`
  String get overwriteTypeCustomDesc {
    return Intl.message(
      'Custom mode, fully customize proxy groups and rules',
      name: 'overwriteTypeCustomDesc',
      desc: '',
      args: [],
    );
  }

  /// `Unknown network error`
  String get unknownNetworkError {
    return Intl.message(
      'Unknown network error',
      name: 'unknownNetworkError',
      desc: '',
      args: [],
    );
  }

  /// `Recovery exception`
  String get restoreException {
    return Intl.message(
      'Recovery exception',
      name: 'restoreException',
      desc: '',
      args: [],
    );
  }

  /// `Network exception, please check your connection and try again`
  String get networkException {
    return Intl.message(
      'Network exception, please check your connection and try again',
      name: 'networkException',
      desc: '',
      args: [],
    );
  }

  /// `Invalid backup file`
  String get invalidBackupFile {
    return Intl.message(
      'Invalid backup file',
      name: 'invalidBackupFile',
      desc: '',
      args: [],
    );
  }

  /// `Prune cache`
  String get pruneCache {
    return Intl.message('Prune cache', name: 'pruneCache', desc: '', args: []);
  }

  /// `Backup and Restore`
  String get backupAndRestore {
    return Intl.message(
      'Backup and Restore',
      name: 'backupAndRestore',
      desc: '',
      args: [],
    );
  }

  /// `Sync data via WebDAV or files`
  String get backupAndRestoreDesc {
    return Intl.message(
      'Sync data via WebDAV or files',
      name: 'backupAndRestoreDesc',
      desc: '',
      args: [],
    );
  }

  /// `Restore`
  String get restore {
    return Intl.message('Restore', name: 'restore', desc: '', args: []);
  }

  /// `Restore success`
  String get restoreSuccess {
    return Intl.message(
      'Restore success',
      name: 'restoreSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Restore data via WebDAV`
  String get restoreFromWebDAVDesc {
    return Intl.message(
      'Restore data via WebDAV',
      name: 'restoreFromWebDAVDesc',
      desc: '',
      args: [],
    );
  }

  /// `Restore data via file`
  String get restoreFromFileDesc {
    return Intl.message(
      'Restore data via file',
      name: 'restoreFromFileDesc',
      desc: '',
      args: [],
    );
  }

  /// `Restore configuration files only`
  String get restoreOnlyConfig {
    return Intl.message(
      'Restore configuration files only',
      name: 'restoreOnlyConfig',
      desc: '',
      args: [],
    );
  }

  /// `Restore all data`
  String get restoreAllData {
    return Intl.message(
      'Restore all data',
      name: 'restoreAllData',
      desc: '',
      args: [],
    );
  }

  /// `Add Profile`
  String get addProfile {
    return Intl.message('Add Profile', name: 'addProfile', desc: '', args: []);
  }

  /// `Delay Test`
  String get delayTest {
    return Intl.message('Delay Test', name: 'delayTest', desc: '', args: []);
  }

  /// `Proxy group is empty`
  String get proxyGroupEmpty {
    return Intl.message(
      'Proxy group is empty',
      name: 'proxyGroupEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Proxy group name cannot be empty`
  String get proxyGroupNameEmpty {
    return Intl.message(
      'Proxy group name cannot be empty',
      name: 'proxyGroupNameEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Proxy group name is duplicate`
  String get proxyGroupNameDuplicate {
    return Intl.message(
      'Proxy group name is duplicate',
      name: 'proxyGroupNameDuplicate',
      desc: '',
      args: [],
    );
  }

  /// `Are you sure you want to exit the current window?`
  String get confirmExitWindow {
    return Intl.message(
      'Are you sure you want to exit the current window?',
      name: 'confirmExitWindow',
      desc: '',
      args: [],
    );
  }

  /// `Data changes detected, do you want to save?`
  String get dataChangedSave {
    return Intl.message(
      'Data changes detected, do you want to save?',
      name: 'dataChangedSave',
      desc: '',
      args: [],
    );
  }

  /// `Select proxy providers`
  String get selectProxyProviders {
    return Intl.message(
      'Select proxy providers',
      name: 'selectProxyProviders',
      desc: '',
      args: [],
    );
  }

  /// `Proxy filter`
  String get proxyFilter {
    return Intl.message(
      'Proxy filter',
      name: 'proxyFilter',
      desc: '',
      args: [],
    );
  }

  /// `Optional`
  String get optional {
    return Intl.message('Optional', name: 'optional', desc: '', args: []);
  }

  /// `Max failed times`
  String get maxFailedTimes {
    return Intl.message(
      'Max failed times',
      name: 'maxFailedTimes',
      desc: '',
      args: [],
    );
  }

  /// `Test interval`
  String get testInterval {
    return Intl.message(
      'Test interval',
      name: 'testInterval',
      desc: '',
      args: [],
    );
  }

  /// `Exclude proxy filter`
  String get excludeProxyFilter {
    return Intl.message(
      'Exclude proxy filter',
      name: 'excludeProxyFilter',
      desc: '',
      args: [],
    );
  }

  /// `Exclude type`
  String get excludeType {
    return Intl.message(
      'Exclude type',
      name: 'excludeType',
      desc: '',
      args: [],
    );
  }

  /// `Expected status`
  String get expectedStatus {
    return Intl.message(
      'Expected status',
      name: 'expectedStatus',
      desc: '',
      args: [],
    );
  }

  /// `Select proxies`
  String get selectProxies {
    return Intl.message(
      'Select proxies',
      name: 'selectProxies',
      desc: '',
      args: [],
    );
  }

  /// `Input proxy group name`
  String get inputProxyGroupName {
    return Intl.message(
      'Input proxy group name',
      name: 'inputProxyGroupName',
      desc: '',
      args: [],
    );
  }

  /// `Hide from list`
  String get hideFromList {
    return Intl.message(
      'Hide from list',
      name: 'hideFromList',
      desc: '',
      args: [],
    );
  }

  /// `Test when used`
  String get testWhenUsed {
    return Intl.message(
      'Test when used',
      name: 'testWhenUsed',
      desc: '',
      args: [],
    );
  }

  /// `Disable UDP`
  String get disableUDP {
    return Intl.message('Disable UDP', name: 'disableUDP', desc: '', args: []);
  }

  /// `Are you sure you want to delete the current proxy group?`
  String get confirmDeleteProxyGroup {
    return Intl.message(
      'Are you sure you want to delete the current proxy group?',
      name: 'confirmDeleteProxyGroup',
      desc: '',
      args: [],
    );
  }

  /// `Rule is empty`
  String get ruleEmpty {
    return Intl.message('Rule is empty', name: 'ruleEmpty', desc: '', args: []);
  }

  /// `Input rule content`
  String get inputRuleContent {
    return Intl.message(
      'Input rule content',
      name: 'inputRuleContent',
      desc: '',
      args: [],
    );
  }

  /// `Rule set`
  String get ruleSet {
    return Intl.message('Rule set', name: 'ruleSet', desc: '', args: []);
  }

  /// `Please select rule set`
  String get selectRuleSet {
    return Intl.message(
      'Please select rule set',
      name: 'selectRuleSet',
      desc: '',
      args: [],
    );
  }

  /// `Split strategy`
  String get splitStrategy {
    return Intl.message(
      'Split strategy',
      name: 'splitStrategy',
      desc: '',
      args: [],
    );
  }

  /// `Please select split strategy`
  String get selectSplitStrategy {
    return Intl.message(
      'Please select split strategy',
      name: 'selectSplitStrategy',
      desc: '',
      args: [],
    );
  }

  /// `Please select sub rule`
  String get selectSubRule {
    return Intl.message(
      'Please select sub rule',
      name: 'selectSubRule',
      desc: '',
      args: [],
    );
  }

  /// `No resolve hostname`
  String get noResolveHostname {
    return Intl.message(
      'No resolve hostname',
      name: 'noResolveHostname',
      desc: '',
      args: [],
    );
  }

  /// `Match source IP`
  String get matchSourceIp {
    return Intl.message(
      'Match source IP',
      name: 'matchSourceIp',
      desc: '',
      args: [],
    );
  }

  /// `Basic info`
  String get basicInfo {
    return Intl.message('Basic info', name: 'basicInfo', desc: '', args: []);
  }

  /// `Additional parameters`
  String get additionalParameters {
    return Intl.message(
      'Additional parameters',
      name: 'additionalParameters',
      desc: '',
      args: [],
    );
  }

  /// `Proxy type`
  String get proxyType {
    return Intl.message('Proxy type', name: 'proxyType', desc: '', args: []);
  }

  /// `Basic strategy`
  String get basicStrategy {
    return Intl.message(
      'Basic strategy',
      name: 'basicStrategy',
      desc: '',
      args: [],
    );
  }

  /// `Edit proxy`
  String get editProxy {
    return Intl.message('Edit proxy', name: 'editProxy', desc: '', args: []);
  }

  /// `Include all proxy providers`
  String get includeAllProxyProviders {
    return Intl.message(
      'Include all proxy providers',
      name: 'includeAllProxyProviders',
      desc: '',
      args: [],
    );
  }

  /// `When enabled, it will override the imported proxy providers`
  String get includeAllProxyProvidersTip {
    return Intl.message(
      'When enabled, it will override the imported proxy providers',
      name: 'includeAllProxyProvidersTip',
      desc: '',
      args: [],
    );
  }

  /// `Add proxy providers`
  String get addProxyProviders {
    return Intl.message(
      'Add proxy providers',
      name: 'addProxyProviders',
      desc: '',
      args: [],
    );
  }

  /// `Include all proxies`
  String get includeAllProxies {
    return Intl.message(
      'Include all proxies',
      name: 'includeAllProxies',
      desc: '',
      args: [],
    );
  }

  /// `Import all proxies not containing proxy groups, additional proxy groups can be added below`
  String get includeAllProxiesTip {
    return Intl.message(
      'Import all proxies not containing proxy groups, additional proxy groups can be added below',
      name: 'includeAllProxiesTip',
      desc: '',
      args: [],
    );
  }

  /// `Proxies is empty`
  String get proxiesEmpty {
    return Intl.message(
      'Proxies is empty',
      name: 'proxiesEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Add proxies`
  String get addProxies {
    return Intl.message('Add proxies', name: 'addProxies', desc: '', args: []);
  }

  /// `Add proxy group`
  String get addProxyGroup {
    return Intl.message(
      'Add proxy group',
      name: 'addProxyGroup',
      desc: '',
      args: [],
    );
  }

  /// `Edit proxy group`
  String get editProxyGroup {
    return Intl.message(
      'Edit proxy group',
      name: 'editProxyGroup',
      desc: '',
      args: [],
    );
  }

  /// `Existing data will be overwritten after confirmation`
  String get confirmOverwriteTip {
    return Intl.message(
      'Existing data will be overwritten after confirmation',
      name: 'confirmOverwriteTip',
      desc: '',
      args: [],
    );
  }

  /// `Data detected in configuration`
  String get configDataDetected {
    return Intl.message(
      'Data detected in configuration',
      name: 'configDataDetected',
      desc: '',
      args: [],
    );
  }

  /// `Quick fill`
  String get quickFill {
    return Intl.message('Quick fill', name: 'quickFill', desc: '', args: []);
  }

  /// `Icon URL`
  String get iconUrl {
    return Intl.message('Icon URL', name: 'iconUrl', desc: '', args: []);
  }

  /// `Icon records`
  String get iconRecords {
    return Intl.message(
      'Icon records',
      name: 'iconRecords',
      desc: '',
      args: [],
    );
  }

  /// `No records`
  String get noRecords {
    return Intl.message('No records', name: 'noRecords', desc: '', args: []);
  }

  /// `Custom`
  String get custom {
    return Intl.message('Custom', name: 'custom', desc: '', args: []);
  }

  /// `Match full domain`
  String get ruleActionDomainDesc {
    return Intl.message(
      'Match full domain',
      name: 'ruleActionDomainDesc',
      desc: '',
      args: [],
    );
  }

  /// `Match domain suffix`
  String get ruleActionDomainSuffixDesc {
    return Intl.message(
      'Match domain suffix',
      name: 'ruleActionDomainSuffixDesc',
      desc: '',
      args: [],
    );
  }

  /// `Match domain keyword`
  String get ruleActionDomainKeywordDesc {
    return Intl.message(
      'Match domain keyword',
      name: 'ruleActionDomainKeywordDesc',
      desc: '',
      args: [],
    );
  }

  /// `Wildcard match, only supports * and ? wildcards`
  String get ruleActionDomainRegexDesc {
    return Intl.message(
      'Wildcard match, only supports * and ? wildcards',
      name: 'ruleActionDomainRegexDesc',
      desc: '',
      args: [],
    );
  }

  /// `Match domains within Geosite`
  String get ruleActionGeositeDesc {
    return Intl.message(
      'Match domains within Geosite',
      name: 'ruleActionGeositeDesc',
      desc: '',
      args: [],
    );
  }

  /// `Match IP address range`
  String get ruleActionIpCidrDesc {
    return Intl.message(
      'Match IP address range',
      name: 'ruleActionIpCidrDesc',
      desc: '',
      args: [],
    );
  }

  /// `Match IP address range, IP-CIDR6 is just an alias`
  String get ruleActionIpCidr6Desc {
    return Intl.message(
      'Match IP address range, IP-CIDR6 is just an alias',
      name: 'ruleActionIpCidr6Desc',
      desc: '',
      args: [],
    );
  }

  /// `Match IP suffix range`
  String get ruleActionIpSuffixDesc {
    return Intl.message(
      'Match IP suffix range',
      name: 'ruleActionIpSuffixDesc',
      desc: '',
      args: [],
    );
  }

  /// `Match IP's ASN`
  String get ruleActionIpAsnDesc {
    return Intl.message(
      'Match IP\'s ASN',
      name: 'ruleActionIpAsnDesc',
      desc: '',
      args: [],
    );
  }

  /// `Match IP's country code`
  String get ruleActionGeoipDesc {
    return Intl.message(
      'Match IP\'s country code',
      name: 'ruleActionGeoipDesc',
      desc: '',
      args: [],
    );
  }

  /// `Match source IP's country code`
  String get ruleActionSrcGeoipDesc {
    return Intl.message(
      'Match source IP\'s country code',
      name: 'ruleActionSrcGeoipDesc',
      desc: '',
      args: [],
    );
  }

  /// `Match source IP's ASN`
  String get ruleActionSrcIpAsnDesc {
    return Intl.message(
      'Match source IP\'s ASN',
      name: 'ruleActionSrcIpAsnDesc',
      desc: '',
      args: [],
    );
  }

  /// `Match source IP address range`
  String get ruleActionSrcIpCidrDesc {
    return Intl.message(
      'Match source IP address range',
      name: 'ruleActionSrcIpCidrDesc',
      desc: '',
      args: [],
    );
  }

  /// `Match source IP suffix range`
  String get ruleActionSrcIpSuffixDesc {
    return Intl.message(
      'Match source IP suffix range',
      name: 'ruleActionSrcIpSuffixDesc',
      desc: '',
      args: [],
    );
  }

  /// `Match request target port range`
  String get ruleActionDstPortDesc {
    return Intl.message(
      'Match request target port range',
      name: 'ruleActionDstPortDesc',
      desc: '',
      args: [],
    );
  }

  /// `Match request source port range`
  String get ruleActionSrcPortDesc {
    return Intl.message(
      'Match request source port range',
      name: 'ruleActionSrcPortDesc',
      desc: '',
      args: [],
    );
  }

  /// `Match inbound port`
  String get ruleActionInPortDesc {
    return Intl.message(
      'Match inbound port',
      name: 'ruleActionInPortDesc',
      desc: '',
      args: [],
    );
  }

  /// `Match inbound type`
  String get ruleActionInTypeDesc {
    return Intl.message(
      'Match inbound type',
      name: 'ruleActionInTypeDesc',
      desc: '',
      args: [],
    );
  }

  /// `Match inbound username, supports multiple usernames separated by /`
  String get ruleActionInUserDesc {
    return Intl.message(
      'Match inbound username, supports multiple usernames separated by /',
      name: 'ruleActionInUserDesc',
      desc: '',
      args: [],
    );
  }

  /// `Match inbound name`
  String get ruleActionInNameDesc {
    return Intl.message(
      'Match inbound name',
      name: 'ruleActionInNameDesc',
      desc: '',
      args: [],
    );
  }

  /// `Match using full process path`
  String get ruleActionProcessPathDesc {
    return Intl.message(
      'Match using full process path',
      name: 'ruleActionProcessPathDesc',
      desc: '',
      args: [],
    );
  }

  /// `Match using process path regex`
  String get ruleActionProcessPathRegexDesc {
    return Intl.message(
      'Match using process path regex',
      name: 'ruleActionProcessPathRegexDesc',
      desc: '',
      args: [],
    );
  }

  /// `Match using process name, matches package name on Android`
  String get ruleActionProcessNameDesc {
    return Intl.message(
      'Match using process name, matches package name on Android',
      name: 'ruleActionProcessNameDesc',
      desc: '',
      args: [],
    );
  }

  /// `Match using process name regex, matches package name on Android`
  String get ruleActionProcessNameRegexDesc {
    return Intl.message(
      'Match using process name regex, matches package name on Android',
      name: 'ruleActionProcessNameRegexDesc',
      desc: '',
      args: [],
    );
  }

  /// `Match Linux USER ID`
  String get ruleActionUidDesc {
    return Intl.message(
      'Match Linux USER ID',
      name: 'ruleActionUidDesc',
      desc: '',
      args: [],
    );
  }

  /// `Match TCP or UDP`
  String get ruleActionNetworkDesc {
    return Intl.message(
      'Match TCP or UDP',
      name: 'ruleActionNetworkDesc',
      desc: '',
      args: [],
    );
  }

  /// `Match DSCP mark (tproxy udp inbound only)`
  String get ruleActionDscpDesc {
    return Intl.message(
      'Match DSCP mark (tproxy udp inbound only)',
      name: 'ruleActionDscpDesc',
      desc: '',
      args: [],
    );
  }

  /// `Reference rule set, requires rule-providers configuration`
  String get ruleActionRuleSetDesc {
    return Intl.message(
      'Reference rule set, requires rule-providers configuration',
      name: 'ruleActionRuleSetDesc',
      desc: '',
      args: [],
    );
  }

  /// `Logical rule AND`
  String get ruleActionAndDesc {
    return Intl.message(
      'Logical rule AND',
      name: 'ruleActionAndDesc',
      desc: '',
      args: [],
    );
  }

  /// `Logical rule OR`
  String get ruleActionOrDesc {
    return Intl.message(
      'Logical rule OR',
      name: 'ruleActionOrDesc',
      desc: '',
      args: [],
    );
  }

  /// `Logical rule NOT`
  String get ruleActionNotDesc {
    return Intl.message(
      'Logical rule NOT',
      name: 'ruleActionNotDesc',
      desc: '',
      args: [],
    );
  }

  /// `Match to sub-rule, pay attention to the use of parentheses`
  String get ruleActionSubRuleDesc {
    return Intl.message(
      'Match to sub-rule, pay attention to the use of parentheses',
      name: 'ruleActionSubRuleDesc',
      desc: '',
      args: [],
    );
  }

  /// `Match all requests, no conditions needed`
  String get ruleActionMatchDesc {
    return Intl.message(
      'Match all requests, no conditions needed',
      name: 'ruleActionMatchDesc',
      desc: '',
      args: [],
    );
  }

  /// `Sub rule is empty`
  String get subRuleEmpty {
    return Intl.message(
      'Sub rule is empty',
      name: 'subRuleEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Proxy providers cannot be empty`
  String get proxyProvidersNotEmpty {
    return Intl.message(
      'Proxy providers cannot be empty',
      name: 'proxyProvidersNotEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Content cannot be empty`
  String get contentNotEmpty {
    return Intl.message(
      'Content cannot be empty',
      name: 'contentNotEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Sub rule cannot be empty`
  String get subRuleNotEmpty {
    return Intl.message(
      'Sub rule cannot be empty',
      name: 'subRuleNotEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Split strategy cannot be empty`
  String get splitStrategyNotEmpty {
    return Intl.message(
      'Split strategy cannot be empty',
      name: 'splitStrategyNotEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Proxy providers is empty`
  String get proxyProvidersEmpty {
    return Intl.message(
      'Proxy providers is empty',
      name: 'proxyProvidersEmpty',
      desc: '',
      args: [],
    );
  }

  /// `Timeout`
  String get timeout {
    return Intl.message('Timeout', name: 'timeout', desc: '', args: []);
  }

  /// `{subRule} is an invalid SUB_RULE`
  String invalidSubRule(Object subRule) {
    return Intl.message(
      '$subRule is an invalid SUB_RULE',
      name: 'invalidSubRule',
      desc: '',
      args: [subRule],
    );
  }

  /// `{target} is an invalid policy`
  String invalidPolicy(Object target) {
    return Intl.message(
      '$target is an invalid policy',
      name: 'invalidPolicy',
      desc: '',
      args: [target],
    );
  }

  /// `{providerName} is an invalid proxy provider`
  String invalidProxyProvider(Object providerName) {
    return Intl.message(
      '$providerName is an invalid proxy provider',
      name: 'invalidProxyProvider',
      desc: '',
      args: [providerName],
    );
  }

  /// `{proxyName} is an invalid proxy`
  String invalidProxy(Object proxyName) {
    return Intl.message(
      '$proxyName is an invalid proxy',
      name: 'invalidProxy',
      desc: '',
      args: [proxyName],
    );
  }

  /// `Detected current proxy group is abnormal`
  String get proxyGroupDetectedAbnormal {
    return Intl.message(
      'Detected current proxy group is abnormal',
      name: 'proxyGroupDetectedAbnormal',
      desc: '',
      args: [],
    );
  }

  /// `Detected selected proxy providers are abnormal`
  String get proxyProviderDetectedAbnormal {
    return Intl.message(
      'Detected selected proxy providers are abnormal',
      name: 'proxyProviderDetectedAbnormal',
      desc: '',
      args: [],
    );
  }

  /// `Detected selected proxies are abnormal`
  String get proxyDetectedAbnormal {
    return Intl.message(
      'Detected selected proxies are abnormal',
      name: 'proxyDetectedAbnormal',
      desc: '',
      args: [],
    );
  }

  /// `Create Profile`
  String get createProfile {
    return Intl.message(
      'Create Profile',
      name: 'createProfile',
      desc: '',
      args: [],
    );
  }

  /// `Location Permission Required`
  String get locationPermissionRequired {
    return Intl.message(
      'Location Permission Required',
      name: 'locationPermissionRequired',
      desc: '',
      args: [],
    );
  }

  /// `1. Open System Settings > Privacy & Security\n2. Choose Location Services\n3. Find and check {appName} in the right list\n\nAfter completing the setup, return to the app and use it normally. Thank you for your cooperation.`
  String locationPermissionGuide(Object appName) {
    return Intl.message(
      '1. Open System Settings > Privacy & Security\n2. Choose Location Services\n3. Find and check $appName in the right list\n\nAfter completing the setup, return to the app and use it normally. Thank you for your cooperation.',
      name: 'locationPermissionGuide',
      desc: '',
      args: [appName],
    );
  }

  /// `Prerequisites`
  String get prerequisites {
    return Intl.message(
      'Prerequisites',
      name: 'prerequisites',
      desc: '',
      args: [],
    );
  }

  /// `Ignore Battery Optimization`
  String get ignoreBatteryOptimization {
    return Intl.message(
      'Ignore Battery Optimization',
      name: 'ignoreBatteryOptimization',
      desc: '',
      args: [],
    );
  }

  /// `To ensure background operation, please disable battery optimization for this app. Tap to go to settings.`
  String get batteryOptimizationDesc {
    return Intl.message(
      'To ensure background operation, please disable battery optimization for this app. Tap to go to settings.',
      name: 'batteryOptimizationDesc',
      desc: '',
      args: [],
    );
  }

  /// `Affected by the system, this status may not always be accurate.`
  String get batteryOptimizationStatusTip {
    return Intl.message(
      'Affected by the system, this status may not always be accurate.',
      name: 'batteryOptimizationStatusTip',
      desc: '',
      args: [],
    );
  }

  /// `Location Permission`
  String get locationPermission {
    return Intl.message(
      'Location Permission',
      name: 'locationPermission',
      desc: '',
      args: [],
    );
  }

  /// `According to system requirements, obtaining the Wi-Fi name requires you to grant location permission.`
  String get locationPermissionDesc {
    return Intl.message(
      'According to system requirements, obtaining the Wi-Fi name requires you to grant location permission.',
      name: 'locationPermissionDesc',
      desc: '',
      args: [],
    );
  }

  /// `Exclude SSIDs`
  String get excludeSsids {
    return Intl.message(
      'Exclude SSIDs',
      name: 'excludeSsids',
      desc: '',
      args: [],
    );
  }

  /// `When connected to an excluded SSID Wi-Fi, the app running state will be automatically switched.`
  String get excludeSsidsDesc {
    return Intl.message(
      'When connected to an excluded SSID Wi-Fi, the app running state will be automatically switched.',
      name: 'excludeSsidsDesc',
      desc: '',
      args: [],
    );
  }

  /// `SSIDs is empty`
  String get ssidsEmpty {
    return Intl.message(
      'SSIDs is empty',
      name: 'ssidsEmpty',
      desc: '',
      args: [],
    );
  }

  /// `On Demand`
  String get onDemand {
    return Intl.message('On Demand', name: 'onDemand', desc: '', args: []);
  }

  /// `Configure the program running state for specific scenarios`
  String get onDemandDesc {
    return Intl.message(
      'Configure the program running state for specific scenarios',
      name: 'onDemandDesc',
      desc: '',
      args: [],
    );
  }

  /// `Location permission was denied, so the current Wi-Fi name cannot be obtained. Please open location permission manually in system settings.`
  String get locationPermissionDeniedMessage {
    return Intl.message(
      'Location permission was denied, so the current Wi-Fi name cannot be obtained. Please open location permission manually in system settings.',
      name: 'locationPermissionDeniedMessage',
      desc: '',
      args: [],
    );
  }

  /// `Add SSID`
  String get addSsid {
    return Intl.message('Add SSID', name: 'addSsid', desc: '', args: []);
  }

  /// `Edit SSID`
  String get editSsid {
    return Intl.message('Edit SSID', name: 'editSsid', desc: '', args: []);
  }

  /// `Authorized`
  String get authorized {
    return Intl.message('Authorized', name: 'authorized', desc: '', args: []);
  }

  /// `Tap to authorize`
  String get tapToAuthorize {
    return Intl.message(
      'Tap to authorize',
      name: 'tapToAuthorize',
      desc: '',
      args: [],
    );
  }

  /// `Suspended...`
  String get suspended {
    return Intl.message('Suspended...', name: 'suspended', desc: '', args: []);
  }

  /// `My account`
  String get vogMyAccount {
    return Intl.message('My account', name: 'vogMyAccount', desc: '', args: []);
  }

  /// `Expires`
  String get vogExpiry {
    return Intl.message('Expires', name: 'vogExpiry', desc: '', args: []);
  }

  /// `Permanent`
  String get vogPermanent {
    return Intl.message('Permanent', name: 'vogPermanent', desc: '', args: []);
  }

  /// `Left / total`
  String get vogRemainTotal {
    return Intl.message(
      'Left / total',
      name: 'vogRemainTotal',
      desc: '',
      args: [],
    );
  }

  /// `Not logged in`
  String get vogNotLoggedIn {
    return Intl.message(
      'Not logged in',
      name: 'vogNotLoggedIn',
      desc: '',
      args: [],
    );
  }

  /// `Choose avatar`
  String get vogChooseAvatar {
    return Intl.message(
      'Choose avatar',
      name: 'vogChooseAvatar',
      desc: '',
      args: [],
    );
  }

  /// `Network is unstable. Check your connection and try again.`
  String get vgNetUnstableRetry {
    return Intl.message(
      'Network is unstable. Check your connection and try again.',
      name: 'vgNetUnstableRetry',
      desc: '',
      args: [],
    );
  }

  /// `Connection timed out. Please try again later.`
  String get vgConnectTimeoutRetry {
    return Intl.message(
      'Connection timed out. Please try again later.',
      name: 'vgConnectTimeoutRetry',
      desc: '',
      args: [],
    );
  }

  /// `Could not read the configuration. Update your subscription or contact support.`
  String get vgConfigParseFailed {
    return Intl.message(
      'Could not read the configuration. Update your subscription or contact support.',
      name: 'vgConfigParseFailed',
      desc: '',
      args: [],
    );
  }

  /// `Something went wrong. Please try again later.`
  String get vgActionFailedRetry {
    return Intl.message(
      'Something went wrong. Please try again later.',
      name: 'vgActionFailedRetry',
      desc: '',
      args: [],
    );
  }

  /// `Network error, cannot check for updates right now. Check your connection and try again.`
  String get vgUpdateCheckNetworkError {
    return Intl.message(
      'Network error, cannot check for updates right now. Check your connection and try again.',
      name: 'vgUpdateCheckNetworkError',
      desc: '',
      args: [],
    );
  }

  /// `The VPN could not be established (permission denied or blocked by the system). Please reconnect.`
  String get vgVpnCouldNotConnect {
    return Intl.message(
      'The VPN could not be established (permission denied or blocked by the system). Please reconnect.',
      name: 'vgVpnCouldNotConnect',
      desc: '',
      args: [],
    );
  }

  /// `TUN failed to take over system traffic after two attempts.`
  String get vgTunTwiceNoTakeover {
    return Intl.message(
      'TUN failed to take over system traffic after two attempts.',
      name: 'vgTunTwiceNoTakeover',
      desc: '',
      args: [],
    );
  }

  /// `{p0}; traffic is still carried by System Proxy (compatibility mode).`
  String vgKeptSystemProxyCarrying(Object p0) {
    return Intl.message(
      '$p0; traffic is still carried by System Proxy (compatibility mode).',
      name: 'vgKeptSystemProxyCarrying',
      desc: '',
      args: [p0],
    );
  }

  /// `{p0}; System Proxy (compatibility mode) has been enabled temporarily to keep you online.`
  String vgTempEnabledSystemProxy(Object p0) {
    return Intl.message(
      '$p0; System Proxy (compatibility mode) has been enabled temporarily to keep you online.',
      name: 'vgTempEnabledSystemProxy',
      desc: '',
      args: [p0],
    );
  }

  /// `Note: compatibility mode only covers apps that honour the system proxy; Telegram and similar apps may still not connect;`
  String get vgCompatModeOnlyProxyAware {
    return Intl.message(
      'Note: compatibility mode only covers apps that honour the system proxy; Telegram and similar apps may still not connect;',
      name: 'vgCompatModeOnlyProxyAware',
      desc: '',
      args: [],
    );
  }

  /// `Once permissions are fixed you can turn Virtual NIC (device-wide) back on from the dashboard.`
  String get vgReopenTunAfterPermission {
    return Intl.message(
      'Once permissions are fixed you can turn Virtual NIC (device-wide) back on from the dashboard.',
      name: 'vgReopenTunAfterPermission',
      desc: '',
      args: [],
    );
  }

  /// `System Proxy (compatibility mode) has been taken over by another proxy app, so Voguesly's compatibility mode is not active.`
  String get vgCompatModeTakenOver {
    return Intl.message(
      'System Proxy (compatibility mode) has been taken over by another proxy app, so Voguesly\'s compatibility mode is not active.',
      name: 'vgCompatModeTakenOver',
      desc: '',
      args: [],
    );
  }

  /// `Your traffic is still carried by Voguesly's virtual NIC, so browsing is unaffected;`
  String get vgTrafficStillOnTun {
    return Intl.message(
      'Your traffic is still carried by Voguesly\'s virtual NIC, so browsing is unaffected;',
      name: 'vgTrafficStillOnTun',
      desc: '',
      args: [],
    );
  }

  /// `To let Voguesly own the system proxy, quit the other proxy app and reconnect.`
  String get vgQuitOtherProxyToTakeOver {
    return Intl.message(
      'To let Voguesly own the system proxy, quit the other proxy app and reconnect.',
      name: 'vgQuitOtherProxyToTakeOver',
      desc: '',
      args: [],
    );
  }

  /// `System Proxy could not take over traffic — it may be occupied by another proxy app. Quit it and try again.`
  String get vgSystemProxyOccupied {
    return Intl.message(
      'System Proxy could not take over traffic — it may be occupied by another proxy app. Quit it and try again.',
      name: 'vgSystemProxyOccupied',
      desc: '',
      args: [],
    );
  }

  /// `Another proxy is running ({p0}). Close it before connecting Voguesly.`
  String vgOtherProxyRunningCloseFirst(Object p0) {
    return Intl.message(
      'Another proxy is running ($p0). Close it before connecting Voguesly.',
      name: 'vgOtherProxyRunningCloseFirst',
      desc: '',
      args: [p0],
    );
  }

  /// `Another proxy is running ({p0}). Voguesly's TUN will stay off this time.`
  String vgOtherProxyRunningSkipTun(Object p0) {
    return Intl.message(
      'Another proxy is running ($p0). Voguesly\'s TUN will stay off this time.',
      name: 'vgOtherProxyRunningSkipTun',
      desc: '',
      args: [p0],
    );
  }

  /// `TUN was not authorised, so device-wide traffic cannot be taken over for now.`
  String get vgTunNotAuthorized {
    return Intl.message(
      'TUN was not authorised, so device-wide traffic cannot be taken over for now.',
      name: 'vgTunNotAuthorized',
      desc: '',
      args: [],
    );
  }

  /// `No endpoint is reachable`
  String get vgAllEndpointsUnreachable {
    return Intl.message(
      'No endpoint is reachable',
      name: 'vgAllEndpointsUnreachable',
      desc: '',
      args: [],
    );
  }

  /// `Wrong email or password`
  String get vgWrongEmailOrPassword {
    return Intl.message(
      'Wrong email or password',
      name: 'vgWrongEmailOrPassword',
      desc: '',
      args: [],
    );
  }

  /// `Sign-up failed`
  String get vgSignUpFailed {
    return Intl.message(
      'Sign-up failed',
      name: 'vgSignUpFailed',
      desc: '',
      args: [],
    );
  }

  /// `Empty response, please try again`
  String get vgEmptyResponseRetry {
    return Intl.message(
      'Empty response, please try again',
      name: 'vgEmptyResponseRetry',
      desc: '',
      args: [],
    );
  }

  /// `Network error: {p0}`
  String vgNetworkErrorWith(Object p0) {
    return Intl.message(
      'Network error: $p0',
      name: 'vgNetworkErrorWith',
      desc: '',
      args: [p0],
    );
  }

  /// `One-tap trial in app`
  String get vgOneTapTrialInApp {
    return Intl.message(
      'One-tap trial in app',
      name: 'vgOneTapTrialInApp',
      desc: '',
      args: [],
    );
  }

  /// `Free trial activated`
  String get vgFreeTrialActivated {
    return Intl.message(
      'Free trial activated',
      name: 'vgFreeTrialActivated',
      desc: '',
      args: [],
    );
  }

  /// `Activation failed, please try again later`
  String get vgActivateFailedRetry {
    return Intl.message(
      'Activation failed, please try again later',
      name: 'vgActivateFailedRetry',
      desc: '',
      args: [],
    );
  }

  /// `Activation failed: {p0}`
  String vgActivateFailedWith(Object p0) {
    return Intl.message(
      'Activation failed: $p0',
      name: 'vgActivateFailedWith',
      desc: '',
      args: [p0],
    );
  }

  /// `Could not place the order, please try again later`
  String get vgOrderFailedRetry {
    return Intl.message(
      'Could not place the order, please try again later',
      name: 'vgOrderFailedRetry',
      desc: '',
      args: [],
    );
  }

  /// `Could not place the order: {p0}`
  String vgOrderFailedWith(Object p0) {
    return Intl.message(
      'Could not place the order: $p0',
      name: 'vgOrderFailedWith',
      desc: '',
      args: [p0],
    );
  }

  /// `Could not start the payment`
  String get vgPaymentStartFailed {
    return Intl.message(
      'Could not start the payment',
      name: 'vgPaymentStartFailed',
      desc: '',
      args: [],
    );
  }

  /// `Could not start the payment: {p0}`
  String vgPaymentStartFailedWith(Object p0) {
    return Intl.message(
      'Could not start the payment: $p0',
      name: 'vgPaymentStartFailedWith',
      desc: '',
      args: [p0],
    );
  }

  /// `Subscription reset. Fetching new nodes…`
  String get vgSubscriptionResetFetching {
    return Intl.message(
      'Subscription reset. Fetching new nodes…',
      name: 'vgSubscriptionResetFetching',
      desc: '',
      args: [],
    );
  }

  /// `Reset failed`
  String get vgResetFailed {
    return Intl.message(
      'Reset failed',
      name: 'vgResetFailed',
      desc: '',
      args: [],
    );
  }

  /// `Password changed`
  String get vgPasswordChanged {
    return Intl.message(
      'Password changed',
      name: 'vgPasswordChanged',
      desc: '',
      args: [],
    );
  }

  /// `Change failed (check your current password)`
  String get vgChangeFailedCheckOldPassword {
    return Intl.message(
      'Change failed (check your current password)',
      name: 'vgChangeFailedCheckOldPassword',
      desc: '',
      args: [],
    );
  }

  /// `Transferred to balance`
  String get vgTransferredToBalance {
    return Intl.message(
      'Transferred to balance',
      name: 'vgTransferredToBalance',
      desc: '',
      args: [],
    );
  }

  /// `Transfer failed`
  String get vgTransferFailed {
    return Intl.message(
      'Transfer failed',
      name: 'vgTransferFailed',
      desc: '',
      args: [],
    );
  }

  /// `Withdrawal request submitted. Support will process it shortly.`
  String get vgWithdrawSubmitted {
    return Intl.message(
      'Withdrawal request submitted. Support will process it shortly.',
      name: 'vgWithdrawSubmitted',
      desc: '',
      args: [],
    );
  }

  /// `Withdrawal failed`
  String get vgWithdrawFailed {
    return Intl.message(
      'Withdrawal failed',
      name: 'vgWithdrawFailed',
      desc: '',
      args: [],
    );
  }

  /// `App feedback / logs`
  String get vgAppFeedbackLogs {
    return Intl.message(
      'App feedback / logs',
      name: 'vgAppFeedbackLogs',
      desc: '',
      args: [],
    );
  }

  /// `Submitted. Support will follow up shortly.`
  String get vgSubmittedSupportWillFollowUp {
    return Intl.message(
      'Submitted. Support will follow up shortly.',
      name: 'vgSubmittedSupportWillFollowUp',
      desc: '',
      args: [],
    );
  }

  /// `Submission failed, please try again later`
  String get vgSubmitFailedRetry {
    return Intl.message(
      'Submission failed, please try again later',
      name: 'vgSubmitFailedRetry',
      desc: '',
      args: [],
    );
  }

  /// `Submission failed: {p0}`
  String vgSubmitFailedWith(Object p0) {
    return Intl.message(
      'Submission failed: $p0',
      name: 'vgSubmitFailedWith',
      desc: '',
      args: [p0],
    );
  }

  /// `Sent`
  String get vgSent {
    return Intl.message('Sent', name: 'vgSent', desc: '', args: []);
  }

  /// `Sending failed, please try again later`
  String get vgSendFailedRetryComma {
    return Intl.message(
      'Sending failed, please try again later',
      name: 'vgSendFailedRetryComma',
      desc: '',
      args: [],
    );
  }

  /// `Sending failed: {p0}`
  String vgSendFailedWith(Object p0) {
    return Intl.message(
      'Sending failed: $p0',
      name: 'vgSendFailedWith',
      desc: '',
      args: [p0],
    );
  }

  /// `One-time`
  String get vgOneTime {
    return Intl.message('One-time', name: 'vgOneTime', desc: '', args: []);
  }

  /// `1 year`
  String get vgOneYear {
    return Intl.message('1 year', name: 'vgOneYear', desc: '', args: []);
  }

  /// `{p0} years`
  String vgNYears(Object p0) {
    return Intl.message('$p0 years', name: 'vgNYears', desc: '', args: [p0]);
  }

  /// `{p0} months`
  String vgNMonths(Object p0) {
    return Intl.message('$p0 months', name: 'vgNMonths', desc: '', args: [p0]);
  }

  /// `{p0} days`
  String vgNDays(Object p0) {
    return Intl.message('$p0 days', name: 'vgNDays', desc: '', args: [p0]);
  }

  /// `From {p0}`
  String vgFromPrice(Object p0) {
    return Intl.message('From $p0', name: 'vgFromPrice', desc: '', args: [p0]);
  }

  /// `Monthly`
  String get vgMonthly {
    return Intl.message('Monthly', name: 'vgMonthly', desc: '', args: []);
  }

  /// `Quarterly`
  String get vgQuarterly {
    return Intl.message('Quarterly', name: 'vgQuarterly', desc: '', args: []);
  }

  /// `Every 6 months`
  String get vgHalfYearly {
    return Intl.message(
      'Every 6 months',
      name: 'vgHalfYearly',
      desc: '',
      args: [],
    );
  }

  /// `Yearly`
  String get vgYearly {
    return Intl.message('Yearly', name: 'vgYearly', desc: '', args: []);
  }

  /// `Every 2 years`
  String get vgTwoYearly {
    return Intl.message(
      'Every 2 years',
      name: 'vgTwoYearly',
      desc: '',
      args: [],
    );
  }

  /// `Every 3 years`
  String get vgThreeYearly {
    return Intl.message(
      'Every 3 years',
      name: 'vgThreeYearly',
      desc: '',
      args: [],
    );
  }

  /// `Plan`
  String get vgPlan {
    return Intl.message('Plan', name: 'vgPlan', desc: '', args: []);
  }

  /// `Awaiting payment`
  String get vgOrderPendingPayment {
    return Intl.message(
      'Awaiting payment',
      name: 'vgOrderPendingPayment',
      desc: '',
      args: [],
    );
  }

  /// `Activating`
  String get vgOrderActivating {
    return Intl.message(
      'Activating',
      name: 'vgOrderActivating',
      desc: '',
      args: [],
    );
  }

  /// `Cancelled`
  String get vgOrderCancelled {
    return Intl.message(
      'Cancelled',
      name: 'vgOrderCancelled',
      desc: '',
      args: [],
    );
  }

  /// `Completed`
  String get vgOrderCompleted {
    return Intl.message(
      'Completed',
      name: 'vgOrderCompleted',
      desc: '',
      args: [],
    );
  }

  /// `Refunded`
  String get vgOrderRefunded {
    return Intl.message(
      'Refunded',
      name: 'vgOrderRefunded',
      desc: '',
      args: [],
    );
  }

  /// `Unknown`
  String get vgUnknown {
    return Intl.message('Unknown', name: 'vgUnknown', desc: '', args: []);
  }

  /// `Online payment`
  String get vgOnlinePayment {
    return Intl.message(
      'Online payment',
      name: 'vgOnlinePayment',
      desc: '',
      args: [],
    );
  }

  /// `Download failed, please try again later`
  String get vgDownloadFailedRetry {
    return Intl.message(
      'Download failed, please try again later',
      name: 'vgDownloadFailedRetry',
      desc: '',
      args: [],
    );
  }

  /// `Version: {p0}`
  String vgVersionNumber(Object p0) {
    return Intl.message(
      'Version: $p0',
      name: 'vgVersionNumber',
      desc: '',
      args: [p0],
    );
  }

  /// `Installing the update needs the "install unknown apps" permission. Grant it in Settings and come back — installation continues automatically.`
  String get vgNeedUnknownSourcesPermission {
    return Intl.message(
      'Installing the update needs the "install unknown apps" permission. Grant it in Settings and come back — installation continues automatically.',
      name: 'vgNeedUnknownSourcesPermission',
      desc: '',
      args: [],
    );
  }

  /// `Open Settings to grant`
  String get vgOpenSettingsToGrant {
    return Intl.message(
      'Open Settings to grant',
      name: 'vgOpenSettingsToGrant',
      desc: '',
      args: [],
    );
  }

  /// `Something went wrong, please try again later`
  String get vgSomethingWentWrongRetry {
    return Intl.message(
      'Something went wrong, please try again later',
      name: 'vgSomethingWentWrongRetry',
      desc: '',
      args: [],
    );
  }

  /// `Retry`
  String get vgRetry {
    return Intl.message('Retry', name: 'vgRetry', desc: '', args: []);
  }

  /// `Downloading update`
  String get vgDownloadingUpdate {
    return Intl.message(
      'Downloading update',
      name: 'vgDownloadingUpdate',
      desc: '',
      args: [],
    );
  }

  /// `Install permission required`
  String get vgInstallPermissionNeeded {
    return Intl.message(
      'Install permission required',
      name: 'vgInstallPermissionNeeded',
      desc: '',
      args: [],
    );
  }

  /// `Opening the installer…`
  String get vgOpeningInstaller {
    return Intl.message(
      'Opening the installer…',
      name: 'vgOpeningInstaller',
      desc: '',
      args: [],
    );
  }

  /// `Download failed`
  String get vgDownloadFailed {
    return Intl.message(
      'Download failed',
      name: 'vgDownloadFailed',
      desc: '',
      args: [],
    );
  }

  /// `Your session expired. Please sign in again.`
  String get vgSessionExpiredSignInAgain {
    return Intl.message(
      'Your session expired. Please sign in again.',
      name: 'vgSessionExpiredSignInAgain',
      desc: '',
      args: [],
    );
  }

  /// `Support could not be opened. Please visit the support page manually.`
  String get vgCannotOpenSupportManually {
    return Intl.message(
      'Support could not be opened. Please visit the support page manually.',
      name: 'vgCannotOpenSupportManually',
      desc: '',
      args: [],
    );
  }

  /// `Could not open support, please try again later`
  String get vgOpenSupportFailedRetry {
    return Intl.message(
      'Could not open support, please try again later',
      name: 'vgOpenSupportFailedRetry',
      desc: '',
      args: [],
    );
  }

  /// `Live chat is unavailable right now — you can open it in your browser`
  String get vgLiveChatUnavailableUseBrowser {
    return Intl.message(
      'Live chat is unavailable right now — you can open it in your browser',
      name: 'vgLiveChatUnavailableUseBrowser',
      desc: '',
      args: [],
    );
  }

  /// `Live chat opened in your browser`
  String get vgLiveChatOpenedInBrowser {
    return Intl.message(
      'Live chat opened in your browser',
      name: 'vgLiveChatOpenedInBrowser',
      desc: '',
      args: [],
    );
  }

  /// `Open support in browser`
  String get vgOpenSupportInBrowser {
    return Intl.message(
      'Open support in browser',
      name: 'vgOpenSupportInBrowser',
      desc: '',
      args: [],
    );
  }

  /// `Not available in this region`
  String get vgRegionNotSupported {
    return Intl.message(
      'Not available in this region',
      name: 'vgRegionNotSupported',
      desc: '',
      args: [],
    );
  }

  /// `Region restricted`
  String get vgRegionRestricted {
    return Intl.message(
      'Region restricted',
      name: 'vgRegionRestricted',
      desc: '',
      args: [],
    );
  }

  /// `Check failed`
  String get vgCheckFailed {
    return Intl.message(
      'Check failed',
      name: 'vgCheckFailed',
      desc: '',
      args: [],
    );
  }

  /// `Originals only`
  String get vgOriginalsOnly {
    return Intl.message(
      'Originals only',
      name: 'vgOriginalsOnly',
      desc: '',
      args: [],
    );
  }

  /// `Region blocked`
  String get vgRegionBlocked {
    return Intl.message(
      'Region blocked',
      name: 'vgRegionBlocked',
      desc: '',
      args: [],
    );
  }

  /// `Bilibili (Mainland)`
  String get vgBiliMainland {
    return Intl.message(
      'Bilibili (Mainland)',
      name: 'vgBiliMainland',
      desc: '',
      args: [],
    );
  }

  /// `Bilibili (HK/MO/TW)`
  String get vgBiliHkMoTw {
    return Intl.message(
      'Bilibili (HK/MO/TW)',
      name: 'vgBiliHkMoTw',
      desc: '',
      args: [],
    );
  }

  /// `Bilibili`
  String get vgBilibili {
    return Intl.message('Bilibili', name: 'vgBilibili', desc: '', args: []);
  }

  /// `Baidu`
  String get vgBaidu {
    return Intl.message('Baidu', name: 'vgBaidu', desc: '', args: []);
  }

  /// `Taobao`
  String get vgTaobao {
    return Intl.message('Taobao', name: 'vgTaobao', desc: '', args: []);
  }

  /// `WeChat`
  String get vgWeChat {
    return Intl.message('WeChat', name: 'vgWeChat', desc: '', args: []);
  }

  /// `Douyin`
  String get vgDouyin {
    return Intl.message('Douyin', name: 'vgDouyin', desc: '', args: []);
  }

  /// `Check`
  String get vgCheckItem {
    return Intl.message('Check', name: 'vgCheckItem', desc: '', args: []);
  }

  /// `Check`
  String get vgCheck {
    return Intl.message('Check', name: 'vgCheck', desc: '', args: []);
  }

  /// `Check all`
  String get vgCheckAll {
    return Intl.message('Check all', name: 'vgCheckAll', desc: '', args: []);
  }

  /// `Local environment`
  String get vgLocalEnvironment {
    return Intl.message(
      'Local environment',
      name: 'vgLocalEnvironment',
      desc: '',
      args: [],
    );
  }

  /// `Check again`
  String get vgRecheck {
    return Intl.message('Check again', name: 'vgRecheck', desc: '', args: []);
  }

  /// `Running other proxy apps? This shows which path is actually carrying traffic and what is holding what.`
  String get vgLocalEnvHint {
    return Intl.message(
      'Running other proxy apps? This shows which path is actually carrying traffic and what is holding what.',
      name: 'vgLocalEnvHint',
      desc: '',
      args: [],
    );
  }

  /// `Streaming unlock`
  String get vgUnlockCheck {
    return Intl.message(
      'Streaming unlock',
      name: 'vgUnlockCheck',
      desc: '',
      args: [],
    );
  }

  /// `Latency test`
  String get vgLatencyTest {
    return Intl.message(
      'Latency test',
      name: 'vgLatencyTest',
      desc: '',
      args: [],
    );
  }

  /// `Domestic sites should connect directly (fast); international ones go through a node. Lower is better.`
  String get vgLatencyHint {
    return Intl.message(
      'Domestic sites should connect directly (fast); international ones go through a node. Lower is better.',
      name: 'vgLatencyHint',
      desc: '',
      args: [],
    );
  }

  /// `Domestic`
  String get vgDomestic {
    return Intl.message('Domestic', name: 'vgDomestic', desc: '', args: []);
  }

  /// `International`
  String get vgInternational {
    return Intl.message(
      'International',
      name: 'vgInternational',
      desc: '',
      args: [],
    );
  }

  /// `Split-routing test`
  String get vgSplitRouteTest {
    return Intl.message(
      'Split-routing test',
      name: 'vgSplitRouteTest',
      desc: '',
      args: [],
    );
  }

  /// `International services exit abroad, domestic services stay local — smart routing verified live.`
  String get vgSplitRouteHint {
    return Intl.message(
      'International services exit abroad, domestic services stay local — smart routing verified live.',
      name: 'vgSplitRouteHint',
      desc: '',
      args: [],
    );
  }

  /// `Checking local environment…`
  String get vgCheckingLocalEnv {
    return Intl.message(
      'Checking local environment…',
      name: 'vgCheckingLocalEnv',
      desc: '',
      args: [],
    );
  }

  /// `Not checked`
  String get vgNotChecked {
    return Intl.message(
      'Not checked',
      name: 'vgNotChecked',
      desc: '',
      args: [],
    );
  }

  /// `Reset Voguesly's system proxy`
  String get vgResetVogueslySystemProxy {
    return Intl.message(
      'Reset Voguesly\'s system proxy',
      name: 'vgResetVogueslySystemProxy',
      desc: '',
      args: [],
    );
  }

  /// `This only rewrites Voguesly's own settings. It will not close or modify your other proxy apps.`
  String get vgResetProxyHint {
    return Intl.message(
      'This only rewrites Voguesly\'s own settings. It will not close or modify your other proxy apps.',
      name: 'vgResetProxyHint',
      desc: '',
      args: [],
    );
  }

  /// `Testing…`
  String get vgTesting {
    return Intl.message('Testing…', name: 'vgTesting', desc: '', args: []);
  }

  /// `Timeout`
  String get vgTimeout {
    return Intl.message('Timeout', name: 'vgTimeout', desc: '', args: []);
  }

  /// `Check failed. Connect first, then try again.`
  String get vgCheckFailedConnectFirst {
    return Intl.message(
      'Check failed. Connect first, then try again.',
      name: 'vgCheckFailedConnectFirst',
      desc: '',
      args: [],
    );
  }

  /// `IP address`
  String get vgIpAddress {
    return Intl.message('IP address', name: 'vgIpAddress', desc: '', args: []);
  }

  /// `Country / region`
  String get vgCountryRegion {
    return Intl.message(
      'Country / region',
      name: 'vgCountryRegion',
      desc: '',
      args: [],
    );
  }

  /// `City`
  String get vgCity {
    return Intl.message('City', name: 'vgCity', desc: '', args: []);
  }

  /// `mihomo core`
  String get vgMihomoCore {
    return Intl.message(
      'mihomo core',
      name: 'vgMihomoCore',
      desc: '',
      args: [],
    );
  }

  /// `FlClash (original)`
  String get vgFlClashOriginal {
    return Intl.message(
      'FlClash (original)',
      name: 'vgFlClashOriginal',
      desc: '',
      args: [],
    );
  }

  /// `Shadowrocket`
  String get vgShadowrocket {
    return Intl.message(
      'Shadowrocket',
      name: 'vgShadowrocket',
      desc: '',
      args: [],
    );
  }

  /// `V2Ray-family client`
  String get vgV2RayFamilyClient {
    return Intl.message(
      'V2Ray-family client',
      name: 'vgV2RayFamilyClient',
      desc: '',
      args: [],
    );
  }

  /// `Voguesly is not connected. Tap the big circle on the home screen first, then come back to run the check.`
  String get vgNotConnectedTapCircle {
    return Intl.message(
      'Voguesly is not connected. Tap the big circle on the home screen first, then come back to run the check.',
      name: 'vgNotConnectedTapCircle',
      desc: '',
      args: [],
    );
  }

  /// `Virtual NIC (VPN)`
  String get vgVirtualNicVpn {
    return Intl.message(
      'Virtual NIC (VPN)',
      name: 'vgVirtualNicVpn',
      desc: '',
      args: [],
    );
  }

  /// `Voguesly in control`
  String get vgVogueslyInControl {
    return Intl.message(
      'Voguesly in control',
      name: 'vgVogueslyInControl',
      desc: '',
      args: [],
    );
  }

  /// `Android allows only one VPN at a time. When you start Voguesly the system stops the other VPN`
  String get vgAndroidOneVpnHint {
    return Intl.message(
      'Android allows only one VPN at a time. When you start Voguesly the system stops the other VPN',
      name: 'vgAndroidOneVpnHint',
      desc: '',
      args: [],
    );
  }

  /// `and asks you to confirm — so there is never a silent conflict where both think they are running.`
  String get vgAndroidOneVpnHint2 {
    return Intl.message(
      'and asks you to confirm — so there is never a silent conflict where both think they are running.',
      name: 'vgAndroidOneVpnHint2',
      desc: '',
      args: [],
    );
  }

  /// `Local port {p0}`
  String vgLocalPortNum(Object p0) {
    return Intl.message(
      'Local port $p0',
      name: 'vgLocalPortNum',
      desc: '',
      args: [p0],
    );
  }

  /// `Listening`
  String get vgListening {
    return Intl.message('Listening', name: 'vgListening', desc: '', args: []);
  }

  /// `Not listening`
  String get vgNotListening {
    return Intl.message(
      'Not listening',
      name: 'vgNotListening',
      desc: '',
      args: [],
    );
  }

  /// `The port may be taken by another proxy app. On Android this does not affect browsing (Voguesly uses the VPN tunnel),`
  String get vgPortMaybeTakenAndroid {
    return Intl.message(
      'The port may be taken by another proxy app. On Android this does not affect browsing (Voguesly uses the VPN tunnel),',
      name: 'vgPortMaybeTakenAndroid',
      desc: '',
      args: [],
    );
  }

  /// `but the unlock and latency checks on this page will not be able to measure anything.`
  String get vgPortMaybeTakenAndroid2 {
    return Intl.message(
      'but the unlock and latency checks on this page will not be able to measure anything.',
      name: 'vgPortMaybeTakenAndroid2',
      desc: '',
      args: [],
    );
  }

  /// `Local environment is healthy.`
  String get vgLocalEnvOk {
    return Intl.message(
      'Local environment is healthy.',
      name: 'vgLocalEnvOk',
      desc: '',
      args: [],
    );
  }

  /// `Browsing works; the check features may be affected by the port being occupied.`
  String get vgOnlineButChecksAffected {
    return Intl.message(
      'Browsing works; the check features may be affected by the port being occupied.',
      name: 'vgOnlineButChecksAffected',
      desc: '',
      args: [],
    );
  }

  /// `Local environment diagnostics is not supported on this platform.`
  String get vgPlatformNoLocalDiag {
    return Intl.message(
      'Local environment diagnostics is not supported on this platform.',
      name: 'vgPlatformNoLocalDiag',
      desc: '',
      args: [],
    );
  }

  /// `Virtual NIC (TUN)`
  String get vgVirtualNicTun {
    return Intl.message(
      'Virtual NIC (TUN)',
      name: 'vgVirtualNicTun',
      desc: '',
      args: [],
    );
  }

  /// `Voguesly in control · {p0}`
  String vgVogueslyInControlWith(Object p0) {
    return Intl.message(
      'Voguesly in control · $p0',
      name: 'vgVogueslyInControlWith',
      desc: '',
      args: [p0],
    );
  }

  /// `Not in control`
  String get vgNotInControl {
    return Intl.message(
      'Not in control',
      name: 'vgNotInControl',
      desc: '',
      args: [],
    );
  }

  /// `Off`
  String get vgNotEnabled {
    return Intl.message('Off', name: 'vgNotEnabled', desc: '', args: []);
  }

  /// `Public traffic is going through Voguesly's virtual NIC. This is the main path and does not rely on the system proxy.`
  String get vgPublicTrafficOnOurTun {
    return Intl.message(
      'Public traffic is going through Voguesly\'s virtual NIC. This is the main path and does not rely on the system proxy.',
      name: 'vgPublicTrafficOnOurTun',
      desc: '',
      args: [],
    );
  }

  /// `Public traffic is going through {p0}, which is not Voguesly's virtual NIC — `
  String vgPublicTrafficOnOtherTun(Object p0) {
    return Intl.message(
      'Public traffic is going through $p0, which is not Voguesly\'s virtual NIC — ',
      name: 'vgPublicTrafficOnOtherTun',
      desc: '',
      args: [p0],
    );
  }

  /// `another VPN has most likely taken the default route.`
  String get vgLikelyAnotherVpnTookRoute {
    return Intl.message(
      'another VPN has most likely taken the default route.',
      name: 'vgLikelyAnotherVpnTookRoute',
      desc: '',
      args: [],
    );
  }

  /// `Virtual NIC is enabled in settings, but public traffic is not going through utun. Authorisation may be incomplete.`
  String get vgTunOnButNoUtun {
    return Intl.message(
      'Virtual NIC is enabled in settings, but public traffic is not going through utun. Authorisation may be incomplete.',
      name: 'vgTunOnButNoUtun',
      desc: '',
      args: [],
    );
  }

  /// `Virtual NIC is off; you are currently on System Proxy compatibility mode.`
  String get vgTunOffUsingCompatMode {
    return Intl.message(
      'Virtual NIC is off; you are currently on System Proxy compatibility mode.',
      name: 'vgTunOffUsingCompatMode',
      desc: '',
      args: [],
    );
  }

  /// `The routing table shows Voguesly's virtual NIC. This is the main path and does not rely on the system proxy.`
  String get vgRouteTableSeesOurTun {
    return Intl.message(
      'The routing table shows Voguesly\'s virtual NIC. This is the main path and does not rely on the system proxy.',
      name: 'vgRouteTableSeesOurTun',
      desc: '',
      args: [],
    );
  }

  /// `Virtual NIC is enabled in settings but is missing from the routing table. The background service may not be installed.`
  String get vgTunOnButNotInRouteTable {
    return Intl.message(
      'Virtual NIC is enabled in settings but is missing from the routing table. The background service may not be installed.',
      name: 'vgTunOnButNotInRouteTable',
      desc: '',
      args: [],
    );
  }

  /// `System proxy`
  String get vgSystemProxy {
    return Intl.message(
      'System proxy',
      name: 'vgSystemProxy',
      desc: '',
      args: [],
    );
  }

  /// `Points to Voguesly · {p0}`
  String vgPointsToVogueslyWith(Object p0) {
    return Intl.message(
      'Points to Voguesly · $p0',
      name: 'vgPointsToVogueslyWith',
      desc: '',
      args: [p0],
    );
  }

  /// `Taken by another app · {p0}`
  String vgTakenByOtherAppWith(Object p0) {
    return Intl.message(
      'Taken by another app · $p0',
      name: 'vgTakenByOtherAppWith',
      desc: '',
      args: [p0],
    );
  }

  /// `A machine has only one system proxy setting and the last writer wins — right now it points to {p0}, not Voguesly's {p1}.`
  String vgSystemProxySingleSlot(Object p0, Object p1) {
    return Intl.message(
      'A machine has only one system proxy setting and the last writer wins — right now it points to $p0, not Voguesly\'s $p1.',
      name: 'vgSystemProxySingleSlot',
      desc: '',
      args: [p0, p1],
    );
  }

  /// `Voguesly is listening`
  String get vgVogueslyListening {
    return Intl.message(
      'Voguesly is listening',
      name: 'vgVogueslyListening',
      desc: '',
      args: [],
    );
  }

  /// `Occupied by another process · {p0}`
  String vgTakenByOtherProcessWith(Object p0) {
    return Intl.message(
      'Occupied by another process · $p0',
      name: 'vgTakenByOtherProcessWith',
      desc: '',
      args: [p0],
    );
  }

  /// `The Voguesly core failed to bind its port.`
  String get vgCoreFailedToBindPort {
    return Intl.message(
      'The Voguesly core failed to bind its port.',
      name: 'vgCoreFailedToBindPort',
      desc: '',
      args: [],
    );
  }

  /// `{p0} is holding {p1}, so the Voguesly core cannot bind — this is exactly the "shows connected but no internet"`
  String vgPortHeldByOther(Object p0, Object p1) {
    return Intl.message(
      '$p0 is holding $p1, so the Voguesly core cannot bind — this is exactly the "shows connected but no internet"',
      name: 'vgPortHeldByOther',
      desc: '',
      args: [p0, p1],
    );
  }

  /// `kind of failure, the hardest one to track down. You can pick an unused port under Settings → Network.`
  String get vgPortHeldByOther2 {
    return Intl.message(
      'kind of failure, the hardest one to track down. You can pick an unused port under Settings → Network.',
      name: 'vgPortHeldByOther2',
      desc: '',
      args: [],
    );
  }

  /// `Running alongside`
  String get vgRunningAlongside {
    return Intl.message(
      'Running alongside',
      name: 'vgRunningAlongside',
      desc: '',
      args: [],
    );
  }

  /// `No other proxy app detected`
  String get vgNoOtherProxyDetected {
    return Intl.message(
      'No other proxy app detected',
      name: 'vgNoOtherProxyDetected',
      desc: '',
      args: [],
    );
  }

  /// `Voguesly will not touch them (some may be your corporate network tunnel). As long as the three items above are fine, coexisting is not a problem.`
  String get vgCoexistFine {
    return Intl.message(
      'Voguesly will not touch them (some may be your corporate network tunnel). As long as the three items above are fine, coexisting is not a problem.',
      name: 'vgCoexistFine',
      desc: '',
      args: [],
    );
  }

  /// `The local port is held by {p0}, so the Voguesly core may fail to bind — consider switching to another port.`
  String vgLocalPortHeldSuggestChange(Object p0) {
    return Intl.message(
      'The local port is held by $p0, so the Voguesly core may fail to bind — consider switching to another port.',
      name: 'vgLocalPortHeldSuggestChange',
      desc: '',
      args: [p0],
    );
  }

  /// `No path is carrying traffic right now, so you are probably offline. Try reconnecting.`
  String get vgNoPathCarryingTraffic {
    return Intl.message(
      'No path is carrying traffic right now, so you are probably offline. Try reconnecting.',
      name: 'vgNoPathCarryingTraffic',
      desc: '',
      args: [],
    );
  }

  /// `Browsing works — Voguesly is on the virtual NIC. The system proxy is held by another app, but that does not affect you.`
  String get vgOnlineViaTunProxyTaken {
    return Intl.message(
      'Browsing works — Voguesly is on the virtual NIC. The system proxy is held by another app, but that does not affect you.',
      name: 'vgOnlineViaTunProxyTaken',
      desc: '',
      args: [],
    );
  }

  /// `Local environment is healthy; Voguesly is in control via {p0}.`
  String vgLocalEnvOkInControl(Object p0) {
    return Intl.message(
      'Local environment is healthy; Voguesly is in control via $p0.',
      name: 'vgLocalEnvOkInControl',
      desc: '',
      args: [p0],
    );
  }

  /// `Not signed in`
  String get vgNotSignedIn {
    return Intl.message(
      'Not signed in',
      name: 'vgNotSignedIn',
      desc: '',
      args: [],
    );
  }

  /// `Loading failed, pull down to retry`
  String get vgLoadFailedPullToRetry {
    return Intl.message(
      'Loading failed, pull down to retry',
      name: 'vgLoadFailedPullToRetry',
      desc: '',
      args: [],
    );
  }

  /// `{p0} copied`
  String vgCopiedSuffix(Object p0) {
    return Intl.message(
      '$p0 copied',
      name: 'vgCopiedSuffix',
      desc: '',
      args: [p0],
    );
  }

  /// `Transfer to balance`
  String get vgTransferToBalance {
    return Intl.message(
      'Transfer to balance',
      name: 'vgTransferToBalance',
      desc: '',
      args: [],
    );
  }

  /// `Available commission: {p0}`
  String vgAvailableCommissionWith(Object p0) {
    return Intl.message(
      'Available commission: $p0',
      name: 'vgAvailableCommissionWith',
      desc: '',
      args: [p0],
    );
  }

  /// `Transfer amount (CNY)`
  String get vgTransferAmountYuan {
    return Intl.message(
      'Transfer amount (CNY)',
      name: 'vgTransferAmountYuan',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get vgCancel {
    return Intl.message('Cancel', name: 'vgCancel', desc: '', args: []);
  }

  /// `Transfer`
  String get vgTransfer {
    return Intl.message('Transfer', name: 'vgTransfer', desc: '', args: []);
  }

  /// `Invalid amount`
  String get vgInvalidAmount {
    return Intl.message(
      'Invalid amount',
      name: 'vgInvalidAmount',
      desc: '',
      args: [],
    );
  }

  /// `Alipay`
  String get vgAlipay {
    return Intl.message('Alipay', name: 'vgAlipay', desc: '', args: []);
  }

  /// `Withdrawal request`
  String get vgWithdrawRequest {
    return Intl.message(
      'Withdrawal request',
      name: 'vgWithdrawRequest',
      desc: '',
      args: [],
    );
  }

  /// `Withdrawal method (Alipay / WeChat / USDT)`
  String get vgWithdrawMethod {
    return Intl.message(
      'Withdrawal method (Alipay / WeChat / USDT)',
      name: 'vgWithdrawMethod',
      desc: '',
      args: [],
    );
  }

  /// `Payout account`
  String get vgPayoutAccount {
    return Intl.message(
      'Payout account',
      name: 'vgPayoutAccount',
      desc: '',
      args: [],
    );
  }

  /// `Submit`
  String get vgSubmit {
    return Intl.message('Submit', name: 'vgSubmit', desc: '', args: []);
  }

  /// `Please enter your payout account`
  String get vgEnterPayoutAccount {
    return Intl.message(
      'Please enter your payout account',
      name: 'vgEnterPayoutAccount',
      desc: '',
      args: [],
    );
  }

  /// `Referral rewards`
  String get vgReferralRewards {
    return Intl.message(
      'Referral rewards',
      name: 'vgReferralRewards',
      desc: '',
      args: [],
    );
  }

  /// `Refresh`
  String get vgRefresh {
    return Intl.message('Refresh', name: 'vgRefresh', desc: '', args: []);
  }

  /// `Available commission`
  String get vgAvailableCommission {
    return Intl.message(
      'Available commission',
      name: 'vgAvailableCommission',
      desc: '',
      args: [],
    );
  }

  /// `Invited`
  String get vgInvited {
    return Intl.message('Invited', name: 'vgInvited', desc: '', args: []);
  }

  /// `{p0} people`
  String vgNPeople(Object p0) {
    return Intl.message('$p0 people', name: 'vgNPeople', desc: '', args: [p0]);
  }

  /// `Withdraw`
  String get vgWithdraw {
    return Intl.message('Withdraw', name: 'vgWithdraw', desc: '', args: []);
  }

  /// `My referral code`
  String get vgMyReferralCode {
    return Intl.message(
      'My referral code',
      name: 'vgMyReferralCode',
      desc: '',
      args: [],
    );
  }

  /// `Referral code`
  String get vgReferralCode {
    return Intl.message(
      'Referral code',
      name: 'vgReferralCode',
      desc: '',
      args: [],
    );
  }

  /// `Copy`
  String get vgCopy {
    return Intl.message('Copy', name: 'vgCopy', desc: '', args: []);
  }

  /// `Referral link`
  String get vgReferralLink {
    return Intl.message(
      'Referral link',
      name: 'vgReferralLink',
      desc: '',
      args: [],
    );
  }

  /// `Copy referral link`
  String get vgCopyReferralLink {
    return Intl.message(
      'Copy referral link',
      name: 'vgCopyReferralLink',
      desc: '',
      args: [],
    );
  }

  /// `When a friend signs up through your link and buys a plan, you earn a commission. Commission can be used towards renewals.`
  String get vgReferralExplain {
    return Intl.message(
      'When a friend signs up through your link and buys a plan, you earn a commission. Commission can be used towards renewals.',
      name: 'vgReferralExplain',
      desc: '',
      args: [],
    );
  }

  /// `<div><h2 style="margin:0 0 8px;font-weight:600">Signed in</h2>`
  String get vgOauthSuccessHtmlHead {
    return Intl.message(
      '<div><h2 style="margin:0 0 8px;font-weight:600">Signed in</h2>',
      name: 'vgOauthSuccessHtmlHead',
      desc: '',
      args: [],
    );
  }

  /// `<p style="opacity:.7;margin:0">Return to the Voguesly app to continue</p></div>`
  String get vgOauthSuccessHtmlBody {
    return Intl.message(
      '<p style="opacity:.7;margin:0">Return to the Voguesly app to continue</p></div>',
      name: 'vgOauthSuccessHtmlBody',
      desc: '',
      args: [],
    );
  }

  /// `Please enter a valid email first`
  String get vgEnterValidEmailFirst {
    return Intl.message(
      'Please enter a valid email first',
      name: 'vgEnterValidEmailFirst',
      desc: '',
      args: [],
    );
  }

  /// `Verification code sent`
  String get vgCodeSent {
    return Intl.message(
      'Verification code sent',
      name: 'vgCodeSent',
      desc: '',
      args: [],
    );
  }

  /// `Sending failed, please try again later`
  String get vgSendFailedRetry {
    return Intl.message(
      'Sending failed, please try again later',
      name: 'vgSendFailedRetry',
      desc: '',
      args: [],
    );
  }

  /// `Network unavailable. Check your connection and try again.`
  String get vgNetworkUnavailableRetry {
    return Intl.message(
      'Network unavailable. Check your connection and try again.',
      name: 'vgNetworkUnavailableRetry',
      desc: '',
      args: [],
    );
  }

  /// `Sign-in failed`
  String get vgSignInFailed {
    return Intl.message(
      'Sign-in failed',
      name: 'vgSignInFailed',
      desc: '',
      args: [],
    );
  }

  /// `Google sign-in failed, please try again`
  String get vgGoogleSignInFailedRetry {
    return Intl.message(
      'Google sign-in failed, please try again',
      name: 'vgGoogleSignInFailedRetry',
      desc: '',
      args: [],
    );
  }

  /// `Google sign-in failed. Check your connection and try again.`
  String get vgGoogleSignInFailedNetwork {
    return Intl.message(
      'Google sign-in failed. Check your connection and try again.',
      name: 'vgGoogleSignInFailedNetwork',
      desc: '',
      args: [],
    );
  }

  /// `Cannot open the browser`
  String get vgCannotOpenBrowser {
    return Intl.message(
      'Cannot open the browser',
      name: 'vgCannotOpenBrowser',
      desc: '',
      args: [],
    );
  }

  /// `Create account`
  String get vgCreateAccount {
    return Intl.message(
      'Create account',
      name: 'vgCreateAccount',
      desc: '',
      args: [],
    );
  }

  /// `Sign in`
  String get vgSignInAccount {
    return Intl.message('Sign in', name: 'vgSignInAccount', desc: '', args: []);
  }

  /// `Sign up and connect automatically`
  String get vgSignUpAutoConnect {
    return Intl.message(
      'Sign up and connect automatically',
      name: 'vgSignUpAutoConnect',
      desc: '',
      args: [],
    );
  }

  /// `Enter your credentials to continue`
  String get vgEnterCredentials {
    return Intl.message(
      'Enter your credentials to continue',
      name: 'vgEnterCredentials',
      desc: '',
      args: [],
    );
  }

  /// `Email`
  String get vgEmail {
    return Intl.message('Email', name: 'vgEmail', desc: '', args: []);
  }

  /// `Please enter a valid email`
  String get vgEnterValidEmail {
    return Intl.message(
      'Please enter a valid email',
      name: 'vgEnterValidEmail',
      desc: '',
      args: [],
    );
  }

  /// `Email verification code`
  String get vgEmailCode {
    return Intl.message(
      'Email verification code',
      name: 'vgEmailCode',
      desc: '',
      args: [],
    );
  }

  /// `6-digit code`
  String get vgSixDigitCode {
    return Intl.message(
      '6-digit code',
      name: 'vgSixDigitCode',
      desc: '',
      args: [],
    );
  }

  /// `Please enter the verification code`
  String get vgEnterCode {
    return Intl.message(
      'Please enter the verification code',
      name: 'vgEnterCode',
      desc: '',
      args: [],
    );
  }

  /// `Send`
  String get vgSend {
    return Intl.message('Send', name: 'vgSend', desc: '', args: []);
  }

  /// `Password`
  String get vgPassword {
    return Intl.message('Password', name: 'vgPassword', desc: '', args: []);
  }

  /// `Please enter your password`
  String get vgEnterPassword {
    return Intl.message(
      'Please enter your password',
      name: 'vgEnterPassword',
      desc: '',
      args: [],
    );
  }

  /// `Referral code (optional)`
  String get vgReferralCodeOptional {
    return Intl.message(
      'Referral code (optional)',
      name: 'vgReferralCodeOptional',
      desc: '',
      args: [],
    );
  }

  /// `Sign up with a referral code for a discount`
  String get vgReferralCodeDiscount {
    return Intl.message(
      'Sign up with a referral code for a discount',
      name: 'vgReferralCodeDiscount',
      desc: '',
      args: [],
    );
  }

  /// `Remember me`
  String get vgRememberMe {
    return Intl.message(
      'Remember me',
      name: 'vgRememberMe',
      desc: '',
      args: [],
    );
  }

  /// `Forgot password?`
  String get vgForgotPassword {
    return Intl.message(
      'Forgot password?',
      name: 'vgForgotPassword',
      desc: '',
      args: [],
    );
  }

  /// `Sign up`
  String get vgSignUp {
    return Intl.message('Sign up', name: 'vgSignUp', desc: '', args: []);
  }

  /// `Sign in`
  String get vgSignIn {
    return Intl.message('Sign in', name: 'vgSignIn', desc: '', args: []);
  }

  /// `or`
  String get vgOr {
    return Intl.message('or', name: 'vgOr', desc: '', args: []);
  }

  /// `Sign up with Google`
  String get vgSignUpWithGoogle {
    return Intl.message(
      'Sign up with Google',
      name: 'vgSignUpWithGoogle',
      desc: '',
      args: [],
    );
  }

  /// `Sign in with Google`
  String get vgSignInWithGoogle {
    return Intl.message(
      'Sign in with Google',
      name: 'vgSignInWithGoogle',
      desc: '',
      args: [],
    );
  }

  /// `Already have an account?`
  String get vgAlreadyHaveAccount {
    return Intl.message(
      'Already have an account?',
      name: 'vgAlreadyHaveAccount',
      desc: '',
      args: [],
    );
  }

  /// `Don't have an account?`
  String get vgNoAccountYet {
    return Intl.message(
      'Don\'t have an account?',
      name: 'vgNoAccountYet',
      desc: '',
      args: [],
    );
  }

  /// `Sign in`
  String get vgGoSignIn {
    return Intl.message('Sign in', name: 'vgGoSignIn', desc: '', args: []);
  }

  /// `The installer file is incomplete`
  String get vgInstallerFileIncomplete {
    return Intl.message(
      'The installer file is incomplete',
      name: 'vgInstallerFileIncomplete',
      desc: '',
      args: [],
    );
  }

  /// `Download failed, please try again later`
  String get vgDownloadFailedRetryFull {
    return Intl.message(
      'Download failed, please try again later',
      name: 'vgDownloadFailedRetryFull',
      desc: '',
      args: [],
    );
  }

  /// `The PKG installer is open and Voguesly is quitting safely. Follow the system prompts to authorise; the installer will replace the old version in Applications.`
  String get vgPkgOpenedQuitting {
    return Intl.message(
      'The PKG installer is open and Voguesly is quitting safely. Follow the system prompts to authorise; the installer will replace the old version in Applications.',
      name: 'vgPkgOpenedQuitting',
      desc: '',
      args: [],
    );
  }

  /// `The DMG is open and Voguesly is quitting safely. Drag the new version into Applications to replace the old one.`
  String get vgDmgOpenedQuitting {
    return Intl.message(
      'The DMG is open and Voguesly is quitting safely. Drag the new version into Applications to replace the old one.',
      name: 'vgDmgOpenedQuitting',
      desc: '',
      args: [],
    );
  }

  /// `Preparing to install…`
  String get vgPreparingInstall {
    return Intl.message(
      'Preparing to install…',
      name: 'vgPreparingInstall',
      desc: '',
      args: [],
    );
  }

  /// `Announcements`
  String get vgAnnouncements {
    return Intl.message(
      'Announcements',
      name: 'vgAnnouncements',
      desc: '',
      args: [],
    );
  }

  /// `No announcements`
  String get vgNoAnnouncements {
    return Intl.message(
      'No announcements',
      name: 'vgNoAnnouncements',
      desc: '',
      args: [],
    );
  }

  /// `Collapse`
  String get vgCollapse {
    return Intl.message('Collapse', name: 'vgCollapse', desc: '', args: []);
  }

  /// `Read more`
  String get vgExpandFullText {
    return Intl.message(
      'Read more',
      name: 'vgExpandFullText',
      desc: '',
      args: [],
    );
  }

  /// `Start your test`
  String get vgStartYourTest {
    return Intl.message(
      'Start your test',
      name: 'vgStartYourTest',
      desc: '',
      args: [],
    );
  }

  /// `Already have`
  String get vgAlreadyHave {
    return Intl.message(
      'Already have',
      name: 'vgAlreadyHave',
      desc: '',
      args: [],
    );
  }

  /// `✅ Activated — tap the centre circle to connect`
  String get vgActivatedTapCircle {
    return Intl.message(
      '✅ Activated — tap the centre circle to connect',
      name: 'vgActivatedTapCircle',
      desc: '',
      args: [],
    );
  }

  /// `Activated, but the subscription import failed (possibly a brief network drop). Tap "Retry import" below.`
  String get vgActivatedImportFailed {
    return Intl.message(
      'Activated, but the subscription import failed (possibly a brief network drop). Tap "Retry import" below.',
      name: 'vgActivatedImportFailed',
      desc: '',
      args: [],
    );
  }

  /// `Subscription import failed, please try again later.`
  String get vgSubscriptionImportFailedRetry {
    return Intl.message(
      'Subscription import failed, please try again later.',
      name: 'vgSubscriptionImportFailedRetry',
      desc: '',
      args: [],
    );
  }

  /// `Free trial activated — import nodes to connect`
  String get vgFreeTrialImportToConnect {
    return Intl.message(
      'Free trial activated — import nodes to connect',
      name: 'vgFreeTrialImportToConnect',
      desc: '',
      args: [],
    );
  }

  /// `Network is unstable; plan details are unavailable right now`
  String get vgNetworkUnstableNoPlanInfo {
    return Intl.message(
      'Network is unstable; plan details are unavailable right now',
      name: 'vgNetworkUnstableNoPlanInfo',
      desc: '',
      args: [],
    );
  }

  /// `You already have a plan`
  String get vgYouAlreadyHavePlan {
    return Intl.message(
      'You already have a plan',
      name: 'vgYouAlreadyHavePlan',
      desc: '',
      args: [],
    );
  }

  /// `Try it free, or buy the starter pack for a full test`
  String get vgTryFreeOrBuyStarter {
    return Intl.message(
      'Try it free, or buy the starter pack for a full test',
      name: 'vgTryFreeOrBuyStarter',
      desc: '',
      args: [],
    );
  }

  /// `Buy the starter pack for a full test`
  String get vgBuyStarterForFullTest {
    return Intl.message(
      'Buy the starter pack for a full test',
      name: 'vgBuyStarterForFullTest',
      desc: '',
      args: [],
    );
  }

  /// `Retry subscription import`
  String get vgRetryImportSubscription {
    return Intl.message(
      'Retry subscription import',
      name: 'vgRetryImportSubscription',
      desc: '',
      args: [],
    );
  }

  /// `Network is unstable — tap to retry`
  String get vgNetworkUnstableTapRetry {
    return Intl.message(
      'Network is unstable — tap to retry',
      name: 'vgNetworkUnstableTapRetry',
      desc: '',
      args: [],
    );
  }

  /// `Fetch your plan and free-trial eligibility again`
  String get vgRefetchPlanAndTrial {
    return Intl.message(
      'Fetch your plan and free-trial eligibility again',
      name: 'vgRefetchPlanAndTrial',
      desc: '',
      args: [],
    );
  }

  /// `Subscribe now`
  String get vgSubscribeNow {
    return Intl.message(
      'Subscribe now',
      name: 'vgSubscribeNow',
      desc: '',
      args: [],
    );
  }

  /// `Import your plan's nodes and get started`
  String get vgImportPlanNodesStart {
    return Intl.message(
      'Import your plan\'s nodes and get started',
      name: 'vgImportPlanNodesStart',
      desc: '',
      args: [],
    );
  }

  /// `Activate the free trial now`
  String get vgActivateFreeTrialNow {
    return Intl.message(
      'Activate the free trial now',
      name: 'vgActivateFreeTrialNow',
      desc: '',
      args: [],
    );
  }

  /// `6 hours / 500 MB — good for a quick connectivity check`
  String get vgTrialSpecs {
    return Intl.message(
      '6 hours / 500 MB — good for a quick connectivity check',
      name: 'vgTrialSpecs',
      desc: '',
      args: [],
    );
  }

  /// `Already claimed? Buy the ¥3.9 starter pack · 3 GB, no time limit`
  String get vgAlreadyClaimedBuyStarter {
    return Intl.message(
      'Already claimed? Buy the ¥3.9 starter pack · 3 GB, no time limit',
      name: 'vgAlreadyClaimedBuyStarter',
      desc: '',
      args: [],
    );
  }

  /// `Buy the ¥3.9 starter pack`
  String get vgBuyStarterPack {
    return Intl.message(
      'Buy the ¥3.9 starter pack',
      name: 'vgBuyStarterPack',
      desc: '',
      args: [],
    );
  }

  /// `3 GB with no time limit — enough to fully test ChatGPT, Claude and similar services`
  String get vgStarterPackSpecs {
    return Intl.message(
      '3 GB with no time limit — enough to fully test ChatGPT, Claude and similar services',
      name: 'vgStarterPackSpecs',
      desc: '',
      args: [],
    );
  }

  /// `Already bought? Refresh subscription`
  String get vgAlreadyBoughtRefresh {
    return Intl.message(
      'Already bought? Refresh subscription',
      name: 'vgAlreadyBoughtRefresh',
      desc: '',
      args: [],
    );
  }

  /// `Activating...`
  String get vgActivatingEllipsis {
    return Intl.message(
      'Activating...',
      name: 'vgActivatingEllipsis',
      desc: '',
      args: [],
    );
  }

  /// `Encrypted`
  String get vgEncrypted {
    return Intl.message('Encrypted', name: 'vgEncrypted', desc: '', args: []);
  }

  /// `Credit card`
  String get vgCreditCard {
    return Intl.message(
      'Credit card',
      name: 'vgCreditCard',
      desc: '',
      args: [],
    );
  }

  /// `Choose a payment method`
  String get vgChoosePaymentMethod {
    return Intl.message(
      'Choose a payment method',
      name: 'vgChoosePaymentMethod',
      desc: '',
      args: [],
    );
  }

  /// `Current balance: {p0}`
  String vgCurrentBalanceWith(Object p0) {
    return Intl.message(
      'Current balance: $p0',
      name: 'vgCurrentBalanceWith',
      desc: '',
      args: [p0],
    );
  }

  /// `Pay with balance`
  String get vgPayWithBalance {
    return Intl.message(
      'Pay with balance',
      name: 'vgPayWithBalance',
      desc: '',
      args: [],
    );
  }

  /// `Insufficient balance`
  String get vgInsufficientBalance {
    return Intl.message(
      'Insufficient balance',
      name: 'vgInsufficientBalance',
      desc: '',
      args: [],
    );
  }

  /// `Balance`
  String get vgBalance {
    return Intl.message('Balance', name: 'vgBalance', desc: '', args: []);
  }

  /// `Charging…`
  String get vgChargingEllipsis {
    return Intl.message(
      'Charging…',
      name: 'vgChargingEllipsis',
      desc: '',
      args: [],
    );
  }

  /// `Starting payment…`
  String get vgStartingPaymentEllipsis {
    return Intl.message(
      'Starting payment…',
      name: 'vgStartingPaymentEllipsis',
      desc: '',
      args: [],
    );
  }

  /// `Purchase complete, your plan is active`
  String get vgPurchaseSuccessActivated {
    return Intl.message(
      'Purchase complete, your plan is active',
      name: 'vgPurchaseSuccessActivated',
      desc: '',
      args: [],
    );
  }

  /// `Payment complete, your plan is active`
  String get vgPaymentSuccessActivated {
    return Intl.message(
      'Payment complete, your plan is active',
      name: 'vgPaymentSuccessActivated',
      desc: '',
      args: [],
    );
  }

  /// `Scan to pay`
  String get vgScanToPay {
    return Intl.message('Scan to pay', name: 'vgScanToPay', desc: '', args: []);
  }

  /// `Waiting for payment`
  String get vgWaitingForPayment {
    return Intl.message(
      'Waiting for payment',
      name: 'vgWaitingForPayment',
      desc: '',
      args: [],
    );
  }

  /// `Tap "Open payment" below to pay on this device,\nor scan with another device. It is credited automatically once done.`
  String get vgPayHereOrScanHint {
    return Intl.message(
      'Tap "Open payment" below to pay on this device,\\nor scan with another device. It is credited automatically once done.',
      name: 'vgPayHereOrScanHint',
      desc: '',
      args: [],
    );
  }

  /// `Scan with Alipay or WeChat on your phone.\nThis page updates automatically once payment completes.`
  String get vgScanWithPhoneHint {
    return Intl.message(
      'Scan with Alipay or WeChat on your phone.\\nThis page updates automatically once payment completes.',
      name: 'vgScanWithPhoneHint',
      desc: '',
      args: [],
    );
  }

  /// `The payment page is open in your browser.\nThis page updates automatically once payment completes.`
  String get vgPaymentOpenedInBrowserHint {
    return Intl.message(
      'The payment page is open in your browser.\\nThis page updates automatically once payment completes.',
      name: 'vgPaymentOpenedInBrowserHint',
      desc: '',
      args: [],
    );
  }

  /// `Open payment`
  String get vgOpenPayment {
    return Intl.message(
      'Open payment',
      name: 'vgOpenPayment',
      desc: '',
      args: [],
    );
  }

  /// `Reopen payment`
  String get vgReopenPayment {
    return Intl.message(
      'Reopen payment',
      name: 'vgReopenPayment',
      desc: '',
      args: [],
    );
  }

  /// `I'm done / close`
  String get vgDoneOrClose {
    return Intl.message(
      'I\'m done / close',
      name: 'vgDoneOrClose',
      desc: '',
      args: [],
    );
  }

  /// `Not signed in — please sign in first`
  String get vgNotSignedInPleaseSignIn {
    return Intl.message(
      'Not signed in — please sign in first',
      name: 'vgNotSignedInPleaseSignIn',
      desc: '',
      args: [],
    );
  }

  /// `No plans available, or a network issue. Pull down to retry.`
  String get vgNoPlansAvailable {
    return Intl.message(
      'No plans available, or a network issue. Pull down to retry.',
      name: 'vgNoPlansAvailable',
      desc: '',
      args: [],
    );
  }

  /// `Loading failed: {p0}`
  String vgLoadFailedWith(Object p0) {
    return Intl.message(
      'Loading failed: $p0',
      name: 'vgLoadFailedWith',
      desc: '',
      args: [p0],
    );
  }

  /// `Store`
  String get vgStore {
    return Intl.message('Store', name: 'vgStore', desc: '', args: []);
  }

  /// `Account balance`
  String get vgAccountBalance {
    return Intl.message(
      'Account balance',
      name: 'vgAccountBalance',
      desc: '',
      args: [],
    );
  }

  /// `Manage balance and plans`
  String get vgManageBalanceAndPlan {
    return Intl.message(
      'Manage balance and plans',
      name: 'vgManageBalanceAndPlan',
      desc: '',
      args: [],
    );
  }

  /// `My orders`
  String get vgMyOrders {
    return Intl.message('My orders', name: 'vgMyOrders', desc: '', args: []);
  }

  /// `View orders · resume unfinished payments`
  String get vgViewOrdersResumePayment {
    return Intl.message(
      'View orders · resume unfinished payments',
      name: 'vgViewOrdersResumePayment',
      desc: '',
      args: [],
    );
  }

  /// `{p0} billing cycles available`
  String vgNBillingCycles(Object p0) {
    return Intl.message(
      '$p0 billing cycles available',
      name: 'vgNBillingCycles',
      desc: '',
      args: [p0],
    );
  }

  /// `Data {p0} GB`
  String vgTrafficNGb(Object p0) {
    return Intl.message(
      'Data $p0 GB',
      name: 'vgTrafficNGb',
      desc: '',
      args: [p0],
    );
  }

  /// `Speed limit {p0} Mbps`
  String vgSpeedLimitNMbps(Object p0) {
    return Intl.message(
      'Speed limit $p0 Mbps',
      name: 'vgSpeedLimitNMbps',
      desc: '',
      args: [p0],
    );
  }

  /// `Duration {p0}`
  String vgDurationWith(Object p0) {
    return Intl.message(
      'Duration $p0',
      name: 'vgDurationWith',
      desc: '',
      args: [p0],
    );
  }

  /// `Buy now`
  String get vgBuyNow {
    return Intl.message('Buy now', name: 'vgBuyNow', desc: '', args: []);
  }

  /// `Choose a billing cycle`
  String get vgChooseBillingCycle {
    return Intl.message(
      'Choose a billing cycle',
      name: 'vgChooseBillingCycle',
      desc: '',
      args: [],
    );
  }

  /// `Buy now {p0}`
  String vgBuyNowWith(Object p0) {
    return Intl.message(
      'Buy now $p0',
      name: 'vgBuyNowWith',
      desc: '',
      args: [p0],
    );
  }

  /// `Placing order…`
  String get vgPlacingOrder {
    return Intl.message(
      'Placing order…',
      name: 'vgPlacingOrder',
      desc: '',
      args: [],
    );
  }

  /// `Order failed`
  String get vgOrderFailed {
    return Intl.message(
      'Order failed',
      name: 'vgOrderFailed',
      desc: '',
      args: [],
    );
  }

  /// `Data usage`
  String get vgDataUsage {
    return Intl.message('Data usage', name: 'vgDataUsage', desc: '', args: []);
  }

  /// `Total upload`
  String get vgTotalUpload {
    return Intl.message(
      'Total upload',
      name: 'vgTotalUpload',
      desc: '',
      args: [],
    );
  }

  /// `Total download`
  String get vgTotalDownload {
    return Intl.message(
      'Total download',
      name: 'vgTotalDownload',
      desc: '',
      args: [],
    );
  }

  /// `Total`
  String get vgTotal {
    return Intl.message('Total', name: 'vgTotal', desc: '', args: []);
  }

  /// `Daily usage this month`
  String get vgDailyUsageThisMonth {
    return Intl.message(
      'Daily usage this month',
      name: 'vgDailyUsageThisMonth',
      desc: '',
      args: [],
    );
  }

  /// `No usage records this month`
  String get vgNoUsageThisMonth {
    return Intl.message(
      'No usage records this month',
      name: 'vgNoUsageThisMonth',
      desc: '',
      args: [],
    );
  }

  /// `Voguesly Residential IP`
  String get vgResidentialIpProfile {
    return Intl.message(
      'Voguesly Residential IP',
      name: 'vgResidentialIpProfile',
      desc: '',
      args: [],
    );
  }

  /// `My tickets`
  String get vgMyTickets {
    return Intl.message('My tickets', name: 'vgMyTickets', desc: '', args: []);
  }

  /// `No tickets yet\nHaving a problem? Submit it under "Report an issue / upload logs"`
  String get vgNoTicketsHint {
    return Intl.message(
      'No tickets yet\\nHaving a problem? Submit it under "Report an issue / upload logs"',
      name: 'vgNoTicketsHint',
      desc: '',
      args: [],
    );
  }

  /// `Ticket #{p0}`
  String vgTicketNumber(Object p0) {
    return Intl.message(
      'Ticket #$p0',
      name: 'vgTicketNumber',
      desc: '',
      args: [p0],
    );
  }

  /// `Closed`
  String get vgTicketClosed {
    return Intl.message('Closed', name: 'vgTicketClosed', desc: '', args: []);
  }

  /// `Awaiting reply`
  String get vgTicketAwaitingReply {
    return Intl.message(
      'Awaiting reply',
      name: 'vgTicketAwaitingReply',
      desc: '',
      args: [],
    );
  }

  /// `Support replied`
  String get vgTicketSupportReplied {
    return Intl.message(
      'Support replied',
      name: 'vgTicketSupportReplied',
      desc: '',
      args: [],
    );
  }

  /// `Close ticket`
  String get vgCloseTicket {
    return Intl.message(
      'Close ticket',
      name: 'vgCloseTicket',
      desc: '',
      args: [],
    );
  }

  /// `Once closed you cannot reply again. Is the issue resolved?`
  String get vgCloseTicketConfirm {
    return Intl.message(
      'Once closed you cannot reply again. Is the issue resolved?',
      name: 'vgCloseTicketConfirm',
      desc: '',
      args: [],
    );
  }

  /// `Could not close, please try again later`
  String get vgCloseFailedRetry {
    return Intl.message(
      'Could not close, please try again later',
      name: 'vgCloseFailedRetry',
      desc: '',
      args: [],
    );
  }

  /// `No messages`
  String get vgNoMessages {
    return Intl.message(
      'No messages',
      name: 'vgNoMessages',
      desc: '',
      args: [],
    );
  }

  /// `Ticket closed`
  String get vgTicketIsClosed {
    return Intl.message(
      'Ticket closed',
      name: 'vgTicketIsClosed',
      desc: '',
      args: [],
    );
  }

  /// `Reply to support…`
  String get vgReplyToSupport {
    return Intl.message(
      'Reply to support…',
      name: 'vgReplyToSupport',
      desc: '',
      args: [],
    );
  }

  /// `No expiry`
  String get vgNoExpiry {
    return Intl.message('No expiry', name: 'vgNoExpiry', desc: '', args: []);
  }

  /// `Reset subscription`
  String get vgResetSubscription {
    return Intl.message(
      'Reset subscription',
      name: 'vgResetSubscription',
      desc: '',
      args: [],
    );
  }

  /// `The old subscription link stops working immediately. Anything already exported to other clients must be imported again. Reset?`
  String get vgResetSubscriptionConfirm {
    return Intl.message(
      'The old subscription link stops working immediately. Anything already exported to other clients must be imported again. Reset?',
      name: 'vgResetSubscriptionConfirm',
      desc: '',
      args: [],
    );
  }

  /// `Reset`
  String get vgReset {
    return Intl.message('Reset', name: 'vgReset', desc: '', args: []);
  }

  /// `Change password`
  String get vgChangePassword {
    return Intl.message(
      'Change password',
      name: 'vgChangePassword',
      desc: '',
      args: [],
    );
  }

  /// `Current password`
  String get vgCurrentPassword {
    return Intl.message(
      'Current password',
      name: 'vgCurrentPassword',
      desc: '',
      args: [],
    );
  }

  /// `New password (at least 8 characters)`
  String get vgNewPasswordMin8 {
    return Intl.message(
      'New password (at least 8 characters)',
      name: 'vgNewPasswordMin8',
      desc: '',
      args: [],
    );
  }

  /// `Confirm new password`
  String get vgConfirmNewPassword {
    return Intl.message(
      'Confirm new password',
      name: 'vgConfirmNewPassword',
      desc: '',
      args: [],
    );
  }

  /// `Confirm change`
  String get vgConfirmChange {
    return Intl.message(
      'Confirm change',
      name: 'vgConfirmChange',
      desc: '',
      args: [],
    );
  }

  /// `New password must be at least 8 characters`
  String get vgNewPasswordTooShort {
    return Intl.message(
      'New password must be at least 8 characters',
      name: 'vgNewPasswordTooShort',
      desc: '',
      args: [],
    );
  }

  /// `The two new passwords do not match`
  String get vgPasswordsDoNotMatch {
    return Intl.message(
      'The two new passwords do not match',
      name: 'vgPasswordsDoNotMatch',
      desc: '',
      args: [],
    );
  }

  /// `Sign out`
  String get vgSignOut {
    return Intl.message('Sign out', name: 'vgSignOut', desc: '', args: []);
  }

  /// `Sign out of this account?`
  String get vgSignOutConfirm {
    return Intl.message(
      'Sign out of this account?',
      name: 'vgSignOutConfirm',
      desc: '',
      args: [],
    );
  }

  /// `Exit`
  String get vgExit {
    return Intl.message('Exit', name: 'vgExit', desc: '', args: []);
  }

  /// `Account`
  String get vgUserCenter {
    return Intl.message('Account', name: 'vgUserCenter', desc: '', args: []);
  }

  /// `No plan yet`
  String get vgNoPlan {
    return Intl.message('No plan yet', name: 'vgNoPlan', desc: '', args: []);
  }

  /// `Current plan: {p0}`
  String vgCurrentPlanWith(Object p0) {
    return Intl.message(
      'Current plan: $p0',
      name: 'vgCurrentPlanWith',
      desc: '',
      args: [p0],
    );
  }

  /// `Data left`
  String get vgRemainingData {
    return Intl.message(
      'Data left',
      name: 'vgRemainingData',
      desc: '',
      args: [],
    );
  }

  /// `Expires`
  String get vgExpiryDate {
    return Intl.message('Expires', name: 'vgExpiryDate', desc: '', args: []);
  }

  /// `Buy / renew a plan`
  String get vgBuyOrRenewPlan {
    return Intl.message(
      'Buy / renew a plan',
      name: 'vgBuyOrRenewPlan',
      desc: '',
      args: [],
    );
  }

  /// `Cancel order`
  String get vgCancelOrder {
    return Intl.message(
      'Cancel order',
      name: 'vgCancelOrder',
      desc: '',
      args: [],
    );
  }

  /// `Cancel the order "{p0}"?`
  String vgCancelOrderConfirm(Object p0) {
    return Intl.message(
      'Cancel the order "$p0"?',
      name: 'vgCancelOrderConfirm',
      desc: '',
      args: [p0],
    );
  }

  /// `Back`
  String get vgBack {
    return Intl.message('Back', name: 'vgBack', desc: '', args: []);
  }

  /// `Order cancelled`
  String get vgOrderCancelledToast {
    return Intl.message(
      'Order cancelled',
      name: 'vgOrderCancelledToast',
      desc: '',
      args: [],
    );
  }

  /// `Could not cancel, please try again later`
  String get vgCancelFailedRetry {
    return Intl.message(
      'Could not cancel, please try again later',
      name: 'vgCancelFailedRetry',
      desc: '',
      args: [],
    );
  }

  /// `No orders yet`
  String get vgNoOrders {
    return Intl.message(
      'No orders yet',
      name: 'vgNoOrders',
      desc: '',
      args: [],
    );
  }

  /// `Order no.: {p0}`
  String vgOrderNoWith(Object p0) {
    return Intl.message(
      'Order no.: $p0',
      name: 'vgOrderNoWith',
      desc: '',
      args: [p0],
    );
  }

  /// `Continue payment`
  String get vgContinuePayment {
    return Intl.message(
      'Continue payment',
      name: 'vgContinuePayment',
      desc: '',
      args: [],
    );
  }

  /// `Loading failed: {p0} (code {p1})`
  String vgLoadFailedWithCode(Object p0, Object p1) {
    return Intl.message(
      'Loading failed: $p0 (code $p1)',
      name: 'vgLoadFailedWithCode',
      desc: '',
      args: [p0, p1],
    );
  }

  /// `WebView failed to initialise: {p0}`
  String vgWebViewInitFailed(Object p0) {
    return Intl.message(
      'WebView failed to initialise: $p0',
      name: 'vgWebViewInitFailed',
      desc: '',
      args: [p0],
    );
  }

  /// `The installer has started. Follow the prompts to finish — it replaces the old version automatically.`
  String get vgInstallerStartedHint {
    return Intl.message(
      'The installer has started. Follow the prompts to finish — it replaces the old version automatically.',
      name: 'vgInstallerStartedHint',
      desc: '',
      args: [],
    );
  }

  /// `Subscription updated`
  String get vgSubscriptionUpdated {
    return Intl.message(
      'Subscription updated',
      name: 'vgSubscriptionUpdated',
      desc: '',
      args: [],
    );
  }

  /// `Update failed, please try again later`
  String get vgUpdateFailedRetry {
    return Intl.message(
      'Update failed, please try again later',
      name: 'vgUpdateFailedRetry',
      desc: '',
      args: [],
    );
  }

  /// `Sign out of this account?`
  String get vgSignOutConfirmShort {
    return Intl.message(
      'Sign out of this account?',
      name: 'vgSignOutConfirmShort',
      desc: '',
      args: [],
    );
  }

  /// `Update subscription`
  String get vgUpdateSubscription {
    return Intl.message(
      'Update subscription',
      name: 'vgUpdateSubscription',
      desc: '',
      args: [],
    );
  }

  /// `Live chat`
  String get vgLiveChat {
    return Intl.message('Live chat', name: 'vgLiveChat', desc: '', args: []);
  }

  /// `Version {p0} available`
  String vgNewVersionAvailable(Object p0) {
    return Intl.message(
      'Version $p0 available',
      name: 'vgNewVersionAvailable',
      desc: '',
      args: [p0],
    );
  }

  /// `Check for updates`
  String get vgCheckForUpdate {
    return Intl.message(
      'Check for updates',
      name: 'vgCheckForUpdate',
      desc: '',
      args: [],
    );
  }

  /// `Log out`
  String get vgLogOut {
    return Intl.message('Log out', name: 'vgLogOut', desc: '', args: []);
  }

  /// `Voguesly is running directly from the DMG disk image. Drag Voguesly into Applications first,`
  String get vgRunningFromDmgHint {
    return Intl.message(
      'Voguesly is running directly from the DMG disk image. Drag Voguesly into Applications first,',
      name: 'vgRunningFromDmgHint',
      desc: '',
      args: [],
    );
  }

  /// `then open it from Applications — running from the DMG cannot start the TUN background service.`
  String get vgRunningFromDmgHint2 {
    return Intl.message(
      'then open it from Applications — running from the DMG cannot start the TUN background service.',
      name: 'vgRunningFromDmgHint2',
      desc: '',
      args: [],
    );
  }

  /// `Got it`
  String get vgGotIt {
    return Intl.message('Got it', name: 'vgGotIt', desc: '', args: []);
  }

  /// `Allow Voguesly's background item under System Settings → General → Login Items & Extensions,`
  String get vgAllowLoginItemHint {
    return Intl.message(
      'Allow Voguesly\'s background item under System Settings → General → Login Items & Extensions,',
      name: 'vgAllowLoginItemHint',
      desc: '',
      args: [],
    );
  }

  /// `then come back to Voguesly and tap TUN once more — no password needed afterwards.`
  String get vgAllowLoginItemHint2 {
    return Intl.message(
      'then come back to Voguesly and tap TUN once more — no password needed afterwards.',
      name: 'vgAllowLoginItemHint2',
      desc: '',
      args: [],
    );
  }

  /// `Open System Settings`
  String get vgOpenSystemSettings {
    return Intl.message(
      'Open System Settings',
      name: 'vgOpenSystemSettings',
      desc: '',
      args: [],
    );
  }

  /// `Voguesly's background TUN service is not enabled. Allow the background item in System Settings and try again.`
  String get vgTunServiceNotEnabled {
    return Intl.message(
      'Voguesly\'s background TUN service is not enabled. Allow the background item in System Settings and try again.',
      name: 'vgTunServiceNotEnabled',
      desc: '',
      args: [],
    );
  }

  /// `Voguesly's background TUN service needs to be authorised again. Under System Settings → General → Login Items & Extensions,`
  String get vgTunServiceNeedsReauth {
    return Intl.message(
      'Voguesly\'s background TUN service needs to be authorised again. Under System Settings → General → Login Items & Extensions,',
      name: 'vgTunServiceNeedsReauth',
      desc: '',
      args: [],
    );
  }

  /// `allow Voguesly's background item, then return to Voguesly and tap connect once more.`
  String get vgTunServiceNeedsReauth2 {
    return Intl.message(
      'allow Voguesly\'s background item, then return to Voguesly and tap connect once more.',
      name: 'vgTunServiceNeedsReauth2',
      desc: '',
      args: [],
    );
  }

  /// `Telegram support`
  String get vgTelegramSupport {
    return Intl.message(
      'Telegram support',
      name: 'vgTelegramSupport',
      desc: '',
      args: [],
    );
  }

  /// `Website`
  String get vgOfficialSite {
    return Intl.message('Website', name: 'vgOfficialSite', desc: '', args: []);
  }

  /// `Voguesly · US residential IP proxy\nStable access to ChatGPT, Claude, OKX and other global services`
  String get vgAboutTagline {
    return Intl.message(
      'Voguesly · US residential IP proxy\\nStable access to ChatGPT, Claude, OKX and other global services',
      name: 'vgAboutTagline',
      desc: '',
      args: [],
    );
  }

  /// `Version`
  String get vgVersionLabel {
    return Intl.message('Version', name: 'vgVersionLabel', desc: '', args: []);
  }

  /// `v{p0} · tap to check for updates`
  String vgVersionTapToCheck(Object p0) {
    return Intl.message(
      'v$p0 · tap to check for updates',
      name: 'vgVersionTapToCheck',
      desc: '',
      args: [p0],
    );
  }

  /// `Buy / renew`
  String get vgBuyOrRenew {
    return Intl.message(
      'Buy / renew',
      name: 'vgBuyOrRenew',
      desc: '',
      args: [],
    );
  }

  /// `Contact support`
  String get vgContactSupport {
    return Intl.message(
      'Contact support',
      name: 'vgContactSupport',
      desc: '',
      args: [],
    );
  }

  /// `Global · everything uses the selected route; your IP follows that route`
  String get vgGlobalModeSummary {
    return Intl.message(
      'Global · everything uses the selected route; your IP follows that route',
      name: 'vgGlobalModeSummary',
      desc: '',
      args: [],
    );
  }

  /// `⚠️ Direct · not accelerated, traffic does not use any node (not private)`
  String get vgDirectModeSummary {
    return Intl.message(
      '⚠️ Direct · not accelerated, traffic does not use any node (not private)',
      name: 'vgDirectModeSummary',
      desc: '',
      args: [],
    );
  }

  /// `Smart routing · AI and banking use residential, domestic sites go direct (recommended)`
  String get vgRuleModeSummary {
    return Intl.message(
      'Smart routing · AI and banking use residential, domestic sites go direct (recommended)',
      name: 'vgRuleModeSummary',
      desc: '',
      args: [],
    );
  }

  /// `Acceleration mode`
  String get vgAccelerationMode {
    return Intl.message(
      'Acceleration mode',
      name: 'vgAccelerationMode',
      desc: '',
      args: [],
    );
  }

  /// `Smart routing (recommended)`
  String get vgSmartRoutingRecommended {
    return Intl.message(
      'Smart routing (recommended)',
      name: 'vgSmartRoutingRecommended',
      desc: '',
      args: [],
    );
  }

  /// `AI, banking and payments automatically use a US residential IP; domestic sites connect directly for speed,`
  String get vgSmartRoutingDesc1 {
    return Intl.message(
      'AI, banking and payments automatically use a US residential IP; domestic sites connect directly for speed,',
      name: 'vgSmartRoutingDesc1',
      desc: '',
      args: [],
    );
  }

  /// `while streaming and downloads use datacentre nodes to save residential data. IP checks will show a residential IP.`
  String get vgSmartRoutingDesc2 {
    return Intl.message(
      'while streaming and downloads use datacentre nodes to save residential data. IP checks will show a residential IP.',
      name: 'vgSmartRoutingDesc2',
      desc: '',
      args: [],
    );
  }

  /// `Global acceleration`
  String get vgGlobalAcceleration {
    return Intl.message(
      'Global acceleration',
      name: 'vgGlobalAcceleration',
      desc: '',
      args: [],
    );
  }

  /// `All traffic uses the single route you picked; nothing is split automatically.`
  String get vgGlobalAccelDesc1 {
    return Intl.message(
      'All traffic uses the single route you picked; nothing is split automatically.',
      name: 'vgGlobalAccelDesc1',
      desc: '',
      args: [],
    );
  }

  /// `If you pick a datacentre route, IP checks will show a datacentre IP;`
  String get vgGlobalAccelDesc2 {
    return Intl.message(
      'If you pick a datacentre route, IP checks will show a datacentre IP;',
      name: 'vgGlobalAccelDesc2',
      desc: '',
      args: [],
    );
  }

  /// `for a residential IP, pick a residential node under "Routes", or use smart routing.`
  String get vgGlobalAccelDesc3 {
    return Intl.message(
      'for a residential IP, pick a residential node under "Routes", or use smart routing.',
      name: 'vgGlobalAccelDesc3',
      desc: '',
      args: [],
    );
  }

  /// `Report an issue / upload logs`
  String get vgReportIssueUploadLogs {
    return Intl.message(
      'Report an issue / upload logs',
      name: 'vgReportIssueUploadLogs',
      desc: '',
      args: [],
    );
  }

  /// `Balance, orders, reset subscription, change password`
  String get vgUserCenterSubtitle {
    return Intl.message(
      'Balance, orders, reset subscription, change password',
      name: 'vgUserCenterSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Invite friends, view commission, withdraw`
  String get vgReferralSubtitle {
    return Intl.message(
      'Invite friends, view commission, withdraw',
      name: 'vgReferralSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Latest announcements and maintenance notices`
  String get vgAnnouncementsSubtitle {
    return Intl.message(
      'Latest announcements and maintenance notices',
      name: 'vgAnnouncementsSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Day-by-day data usage`
  String get vgDataUsageSubtitle {
    return Intl.message(
      'Day-by-day data usage',
      name: 'vgDataUsageSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Send your logs to support in one tap so they can pinpoint the issue`
  String get vgReportIssueSubtitle {
    return Intl.message(
      'Send your logs to support in one tap so they can pinpoint the issue',
      name: 'vgReportIssueSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Read support replies and follow up`
  String get vgMyTicketsSubtitle {
    return Intl.message(
      'Read support replies and follow up',
      name: 'vgMyTicketsSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `View logs`
  String get vgViewLogs {
    return Intl.message('View logs', name: 'vgViewLogs', desc: '', args: []);
  }

  /// `Live connection logs, for troubleshooting`
  String get vgViewLogsSubtitle {
    return Intl.message(
      'Live connection logs, for troubleshooting',
      name: 'vgViewLogsSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Version: {p0}+{p1}`
  String vgVersionBuildWith(Object p0, Object p1) {
    return Intl.message(
      'Version: $p0+$p1',
      name: 'vgVersionBuildWith',
      desc: '',
      args: [p0, p1],
    );
  }

  /// `Device: {p0} {p1} · Android {p2}`
  String vgDeviceInfoWith(Object p0, Object p1, Object p2) {
    return Intl.message(
      'Device: $p0 $p1 · Android $p2',
      name: 'vgDeviceInfoWith',
      desc: '',
      args: [p0, p1, p2],
    );
  }

  /// `--- recent logs ---`
  String get vgRecentLogsHeader {
    return Intl.message(
      '--- recent logs ---',
      name: 'vgRecentLogsHeader',
      desc: '',
      args: [],
    );
  }

  /// `Please sign in before sending feedback`
  String get vgSignInBeforeFeedback {
    return Intl.message(
      'Please sign in before sending feedback',
      name: 'vgSignInBeforeFeedback',
      desc: '',
      args: [],
    );
  }

  /// `{p0}\n\n=== Diagnostics (attached automatically) ===\n{p1}`
  String vgFeedbackBodyWith(Object p0, Object p1) {
    return Intl.message(
      '$p0\\n\\n=== Diagnostics (attached automatically) ===\\n$p1',
      name: 'vgFeedbackBodyWith',
      desc: '',
      args: [p0, p1],
    );
  }

  /// `Describe the problem you ran into. We attach your device info and recent logs automatically to help pinpoint it.`
  String get vgFeedbackHint {
    return Intl.message(
      'Describe the problem you ran into. We attach your device info and recent logs automatically to help pinpoint it.',
      name: 'vgFeedbackHint',
      desc: '',
      args: [],
    );
  }

  /// `For example: pages won't load after connecting / a node won't connect…`
  String get vgFeedbackPlaceholder {
    return Intl.message(
      'For example: pages won\'t load after connecting / a node won\'t connect…',
      name: 'vgFeedbackPlaceholder',
      desc: '',
      args: [],
    );
  }

  /// `Submitting…`
  String get vgSubmitting {
    return Intl.message(
      'Submitting…',
      name: 'vgSubmitting',
      desc: '',
      args: [],
    );
  }

  /// `Send to support`
  String get vgSubmitToSupport {
    return Intl.message(
      'Send to support',
      name: 'vgSubmitToSupport',
      desc: '',
      args: [],
    );
  }

  /// `Signed in · loading your plan…`
  String get vgSignedInLoadingPlan {
    return Intl.message(
      'Signed in · loading your plan…',
      name: 'vgSignedInLoadingPlan',
      desc: '',
      args: [],
    );
  }

  /// `Your plan allows {p0} simultaneous devices;`
  String vgPlanDeviceLimitWith(Object p0) {
    return Intl.message(
      'Your plan allows $p0 simultaneous devices;',
      name: 'vgPlanDeviceLimitWith',
      desc: '',
      args: [p0],
    );
  }

  /// `if you see a connection-limit message, fully quit the other clients and reconnect`
  String get vgDeviceLimitHint {
    return Intl.message(
      'if you see a connection-limit message, fully quit the other clients and reconnect',
      name: 'vgDeviceLimitHint',
      desc: '',
      args: [],
    );
  }

  /// `Tap the button below to fetch the latest nodes`
  String get vgTapBelowToFetchNodes {
    return Intl.message(
      'Tap the button below to fetch the latest nodes',
      name: 'vgTapBelowToFetchNodes',
      desc: '',
      args: [],
    );
  }

  /// `Last updated · today {p0}`
  String vgLastUpdatedTodayWith(Object p0) {
    return Intl.message(
      'Last updated · today $p0',
      name: 'vgLastUpdatedTodayWith',
      desc: '',
      args: [p0],
    );
  }

  /// `Last updated · {p0} {p1}`
  String vgLastUpdatedWith(Object p0, Object p1) {
    return Intl.message(
      'Last updated · $p0 $p1',
      name: 'vgLastUpdatedWith',
      desc: '',
      args: [p0, p1],
    );
  }

  /// `My subscription`
  String get vgMySubscription {
    return Intl.message(
      'My subscription',
      name: 'vgMySubscription',
      desc: '',
      args: [],
    );
  }

  /// `No subscription imported · open the management page to import`
  String get vgNoSubscriptionImported {
    return Intl.message(
      'No subscription imported · open the management page to import',
      name: 'vgNoSubscriptionImported',
      desc: '',
      args: [],
    );
  }

  /// `Updating…`
  String get vgUpdating {
    return Intl.message('Updating…', name: 'vgUpdating', desc: '', args: []);
  }

  /// `Manage subscription`
  String get vgManageSubscription {
    return Intl.message(
      'Manage subscription',
      name: 'vgManageSubscription',
      desc: '',
      args: [],
    );
  }

  /// `{p0} (device-wide)`
  String vgTunDeviceWide(Object p0) {
    return Intl.message(
      '$p0 (device-wide)',
      name: 'vgTunDeviceWide',
      desc: '',
      args: [p0],
    );
  }

  /// `Takes over traffic for the whole device; other VPNs must be off and system permission granted`
  String get vgTunDeviceWideDesc {
    return Intl.message(
      'Takes over traffic for the whole device; other VPNs must be off and system permission granted',
      name: 'vgTunDeviceWideDesc',
      desc: '',
      args: [],
    );
  }

  /// `{p0} (compatibility)`
  String vgSystemProxyCompat(Object p0) {
    return Intl.message(
      '$p0 (compatibility)',
      name: 'vgSystemProxyCompat',
      desc: '',
      args: [p0],
    );
  }

  /// `Only covers apps that support the system proxy; apps like Telegram may still need TUN`
  String get vgSystemProxyCompatDesc {
    return Intl.message(
      'Only covers apps that support the system proxy; apps like Telegram may still need TUN',
      name: 'vgSystemProxyCompatDesc',
      desc: '',
      args: [],
    );
  }

  /// `Voguesly's DNS is added temporarily only while macOS TUN is running, and restored on disconnect or exit; System Proxy mode does not touch DNS`
  String get vgMacDnsHintDesc {
    return Intl.message(
      'Voguesly\'s DNS is added temporarily only while macOS TUN is running, and restored on disconnect or exit; System Proxy mode does not touch DNS',
      name: 'vgMacDnsHintDesc',
      desc: '',
      args: [],
    );
  }

  /// `Connection timed out. Check your network, or pick another route under "Current route".`
  String get vgConnectTimeoutTryAnotherRoute {
    return Intl.message(
      'Connection timed out. Check your network, or pick another route under "Current route".',
      name: 'vgConnectTimeoutTryAnotherRoute',
      desc: '',
      args: [],
    );
  }

  /// `Loading subscription…`
  String get vgLoadingSubscription {
    return Intl.message(
      'Loading subscription…',
      name: 'vgLoadingSubscription',
      desc: '',
      args: [],
    );
  }

  /// `Loading failed · tap to retry`
  String get vgLoadFailedTapRetry {
    return Intl.message(
      'Loading failed · tap to retry',
      name: 'vgLoadFailedTapRetry',
      desc: '',
      args: [],
    );
  }

  /// `Tap to activate`
  String get vgTapToActivate {
    return Intl.message(
      'Tap to activate',
      name: 'vgTapToActivate',
      desc: '',
      args: [],
    );
  }

  /// `Acceleration skipped`
  String get vgAccelerationSkipped {
    return Intl.message(
      'Acceleration skipped',
      name: 'vgAccelerationSkipped',
      desc: '',
      args: [],
    );
  }

  /// `Connected`
  String get vgConnected {
    return Intl.message('Connected', name: 'vgConnected', desc: '', args: []);
  }

  /// `Starting`
  String get vgStarting {
    return Intl.message('Starting', name: 'vgStarting', desc: '', args: []);
  }

  /// `Turn on Voguesly`
  String get vgTurnOnVoguesly {
    return Intl.message(
      'Turn on Voguesly',
      name: 'vgTurnOnVoguesly',
      desc: '',
      args: [],
    );
  }

  /// `TUN + system proxy`
  String get vgTunPlusSystemProxy {
    return Intl.message(
      'TUN + system proxy',
      name: 'vgTunPlusSystemProxy',
      desc: '',
      args: [],
    );
  }

  /// `Acceleration skipped on this network · going direct`
  String get vgNetworkSkippedDirect {
    return Intl.message(
      'Acceleration skipped on this network · going direct',
      name: 'vgNetworkSkippedDirect',
      desc: '',
      args: [],
    );
  }

  /// `Tap to disconnect  ·  {p0}`
  String vgTapToDisconnectWith(Object p0) {
    return Intl.message(
      'Tap to disconnect  ·  $p0',
      name: 'vgTapToDisconnectWith',
      desc: '',
      args: [p0],
    );
  }

  /// `Selecting automatically…`
  String get vgAutoSelecting {
    return Intl.message(
      'Selecting automatically…',
      name: 'vgAutoSelecting',
      desc: '',
      args: [],
    );
  }

  /// `Not selected · pick a route`
  String get vgNoRouteSelected {
    return Intl.message(
      'Not selected · pick a route',
      name: 'vgNoRouteSelected',
      desc: '',
      args: [],
    );
  }

  /// `Current route`
  String get vgCurrentRoute {
    return Intl.message(
      'Current route',
      name: 'vgCurrentRoute',
      desc: '',
      args: [],
    );
  }

  /// `Switched to global acceleration`
  String get vgSwitchedToGlobal {
    return Intl.message(
      'Switched to global acceleration',
      name: 'vgSwitchedToGlobal',
      desc: '',
      args: [],
    );
  }

  /// `In global mode all traffic uses the single route you picked under "Routes", instead of splitting by AI / banking /`
  String get vgGlobalModeDialog1 {
    return Intl.message(
      'In global mode all traffic uses the single route you picked under "Routes", instead of splitting by AI / banking /',
      name: 'vgGlobalModeDialog1',
      desc: '',
      args: [],
    );
  }

  /// `domestic sites automatically.\n\n`
  String get vgGlobalModeDialog2 {
    return Intl.message(
      'domestic sites automatically.\\n\\n',
      name: 'vgGlobalModeDialog2',
      desc: '',
      args: [],
    );
  }

  /// `If you picked a datacentre route, IP-check sites will show a datacentre IP. For a US residential IP,`
  String get vgGlobalModeDialog3 {
    return Intl.message(
      'If you picked a datacentre route, IP-check sites will show a datacentre IP. For a US residential IP,',
      name: 'vgGlobalModeDialog3',
      desc: '',
      args: [],
    );
  }

  /// `pick a residential node under "Routes", or switch back to smart routing.`
  String get vgGlobalModeDialog4 {
    return Intl.message(
      'pick a residential node under "Routes", or switch back to smart routing.',
      name: 'vgGlobalModeDialog4',
      desc: '',
      args: [],
    );
  }

  /// `Tap to connect`
  String get vgTapToConnect {
    return Intl.message(
      'Tap to connect',
      name: 'vgTapToConnect',
      desc: '',
      args: [],
    );
  }

  /// `Current plan: {p0} · `
  String vgCurrentPlanPrefixWith(Object p0) {
    return Intl.message(
      'Current plan: $p0 · ',
      name: 'vgCurrentPlanPrefixWith',
      desc: '',
      args: [p0],
    );
  }

  /// `Loading account…`
  String get vgLoadingAccount {
    return Intl.message(
      'Loading account…',
      name: 'vgLoadingAccount',
      desc: '',
      args: [],
    );
  }

  /// `{p0} expired`
  String vgExpiredSuffix(Object p0) {
    return Intl.message(
      '$p0 expired',
      name: 'vgExpiredSuffix',
      desc: '',
      args: [p0],
    );
  }

  /// `Expired · please renew`
  String get vgExpiredRenew {
    return Intl.message(
      'Expired · please renew',
      name: 'vgExpiredRenew',
      desc: '',
      args: [],
    );
  }

  /// `Data used up · please renew`
  String get vgDataExhaustedRenew {
    return Intl.message(
      'Data used up · please renew',
      name: 'vgDataExhaustedRenew',
      desc: '',
      args: [],
    );
  }

  /// `Buy / renew`
  String get vgBuyRenewShort {
    return Intl.message(
      'Buy / renew',
      name: 'vgBuyRenewShort',
      desc: '',
      args: [],
    );
  }

  /// `Loading plan…`
  String get vgLoadingPlan {
    return Intl.message(
      'Loading plan…',
      name: 'vgLoadingPlan',
      desc: '',
      args: [],
    );
  }

  /// `Sign out`
  String get vgSignOutAccount {
    return Intl.message(
      'Sign out',
      name: 'vgSignOutAccount',
      desc: '',
      args: [],
    );
  }

  /// `Sign out of this account? You will need to sign in again.`
  String get vgSignOutAccountConfirm {
    return Intl.message(
      'Sign out of this account? You will need to sign in again.',
      name: 'vgSignOutAccountConfirm',
      desc: '',
      args: [],
    );
  }

  /// `Could not update the subscription, please try again later`
  String get vgUpdateSubscriptionFailed {
    return Intl.message(
      'Could not update the subscription, please try again later',
      name: 'vgUpdateSubscriptionFailed',
      desc: '',
      args: [],
    );
  }

  /// `Your internet access is **unaffected** because Voguesly is on the virtual NIC.`
  String get vgTunUnaffectedNote {
    return Intl.message(
      'Your internet access is **unaffected** because Voguesly is on the virtual NIC.',
      name: 'vgTunUnaffectedNote',
      desc: '',
      args: [],
    );
  }

  /// `The virtual NIC is not in control either, so you may genuinely be offline right now.`
  String get vgTunAlsoNotInControlNote {
    return Intl.message(
      'The virtual NIC is not in control either, so you may genuinely be offline right now.',
      name: 'vgTunAlsoNotInControlNote',
      desc: '',
      args: [],
    );
  }

  /// `the virtual NIC`
  String get vgVirtualNic {
    return Intl.message(
      'the virtual NIC',
      name: 'vgVirtualNic',
      desc: '',
      args: [],
    );
  }

  /// `Me`
  String get vgMe {
    return Intl.message('Me', name: 'vgMe', desc: '', args: []);
  }

  /// `Support`
  String get vgSupport {
    return Intl.message('Support', name: 'vgSupport', desc: '', args: []);
  }

  /// `Loading…`
  String get vgLoadingEllipsis {
    return Intl.message(
      'Loading…',
      name: 'vgLoadingEllipsis',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ja'),
      Locale.fromSubtags(languageCode: 'ru'),
      Locale.fromSubtags(languageCode: 'zh', countryCode: 'CN'),
      Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<AppLocalizations> load(Locale locale) => AppLocalizations.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
