// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a ru locale. All the
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
  String get localeName => 'ru';

  static String m0(count) =>
      "${Intl.plural(count, one: '${count} день назад', few: '${count} дня назад', many: '${count} дней назад', other: '${count} дня назад')}";

  static String m1(label) =>
      "Вы уверены, что хотите удалить выбранные ${label}?";

  static String m2(label) => "Вы уверены, что хотите удалить текущий ${label}?";

  static String m3(label) => "Детали {}";

  static String m4(label) => "${label} не может быть пустым";

  static String m5(label) => "Текущий ${label} уже существует";

  static String m6(count) =>
      "${Intl.plural(count, one: '${count} час назад', few: '${count} часа назад', many: '${count} часов назад', other: '${count} часа назад')}";

  static String m7(target) => "${target} является недопустимой политикой";

  static String m8(proxyName) => "${proxyName} является недопустимым прокси";

  static String m9(providerName) =>
      "${providerName} является недопустимым провайдером прокси";

  static String m10(subRule) => "${subRule} является недопустимым подправилом";

  static String m11(appName) =>
      "1. Open System Settings > Privacy & Security\n2. Choose Location Services\n3. Find and check ${appName} in the right list\n\nAfter completing the setup, return to the app and use it normally. Thank you for your cooperation.";

  static String m12(count) =>
      "${Intl.plural(count, one: '${count} минута назад', few: '${count} минуты назад', many: '${count} минут назад', other: '${count} минуты назад')}";

  static String m13(count) =>
      "${Intl.plural(count, one: '${count} месяц назад', few: '${count} месяца назад', many: '${count} месяцев назад', other: '${count} месяца назад')}";

  static String m14(label) => "${label} пока отсутствуют";

  static String m15(label) => "${label} должно быть числом";

  static String m16(label) => "${label} должен быть числом от 1024 до 49151";

  static String m17(count) => "Выбрано ${count} элементов";

  static String m18(label) => "${label} должен быть URL";

  static String m19(p0) => "Не удалось активировать: ${p0}";

  static String m20(p0) => "Доступная комиссия: ${p0}";

  static String m21(p0) => "Купить ${p0}";

  static String m22(p0) => "Отменить заказ «${p0}»?";

  static String m23(p0) => "${p0} скопировано";

  static String m24(p0) => "Текущий баланс: ${p0}";

  static String m25(p0) => "Текущий тариф: ${p0} · ";

  static String m26(p0) => "Текущий тариф: ${p0}";

  static String m27(p0, p1, p2) => "Устройство: ${p0} ${p1} · Android ${p2}";

  static String m28(p0) => "Срок ${p0}";

  static String m29(p0) => "${p0} истёк";

  static String m30(p0, p1) =>
      "${p0}\\n\\n=== Диагностика (прикреплено автоматически) ===\\n${p1}";

  static String m31(p0) => "от ${p0}";

  static String m32(p0) =>
      "${p0}; трафик по-прежнему идёт через системный прокси (режим совместимости).";

  static String m33(p0) => "Обновлено · сегодня ${p0}";

  static String m34(p0, p1) => "Обновлено · ${p0} ${p1}";

  static String m35(p0) => "Не удалось загрузить: ${p0}";

  static String m36(p0, p1) => "Не удалось загрузить: ${p0} (code ${p1})";

  static String m37(p0) =>
      "Локальное окружение в порядке; Voguesly управляет через ${p0}.";

  static String m38(p0) =>
      "Локальный порт занят ${p0}, ядро Voguesly может не привязаться — рекомендуем сменить порт.";

  static String m39(p0) => "Локальный порт ${p0}";

  static String m40(p0) => "Доступно циклов оплаты: ${p0}";

  static String m41(p0) => "${p0} дн.";

  static String m42(p0) => "${p0} мес.";

  static String m43(p0) => "${p0} чел.";

  static String m44(p0) => "${p0} г.";

  static String m45(p0) => "Ошибка сети: ${p0}";

  static String m46(p0) => "Доступна версия ${p0}";

  static String m47(p0) => "Не удалось оформить заказ: ${p0}";

  static String m48(p0) => "Номер заказа: ${p0}";

  static String m49(p0) =>
      "Запущен другой прокси (${p0}). Закройте его перед подключением Voguesly.";

  static String m50(p0) =>
      "Запущен другой прокси (${p0}). TUN Voguesly в этот раз не включается.";

  static String m51(p0) => "Не удалось начать оплату: ${p0}";

  static String m52(p0) => "Ваш тариф допускает одновременно устройств: ${p0};";

  static String m53(p0) => "Указывает на Voguesly · ${p0}";

  static String m54(p0, p1) =>
      "${p0} занимает ${p1}, поэтому ядро Voguesly не может привязаться — это и есть тот самый случай «показывает подключено, но интернета нет»,";

  static String m55(p0) =>
      "Внешний трафик идёт через ${p0}, а не через виртуальный адаптер Voguesly — ";

  static String m56(p0) => "Не удалось отправить: ${p0}";

  static String m57(p0) => "Ограничение скорости ${p0} Мбит/с";

  static String m58(p0) => "Не удалось отправить: ${p0}";

  static String m59(p0) => "${p0} (совместимость)";

  static String m60(p0, p1) =>
      "На компьютере только одна настройка системного прокси, и побеждает тот, кто записал последним — сейчас она указывает на ${p0}, а не на ${p1} от Voguesly.";

  static String m61(p0) => "Перехвачено другим приложением · ${p0}";

  static String m62(p0) => "Занято другим процессом · ${p0}";

  static String m63(p0) => "Нажмите, чтобы отключиться  ·  ${p0}";

  static String m64(p0) =>
      "${p0}; временно включён системный прокси (режим совместимости), чтобы сохранить доступ в интернет.";

  static String m65(p0) => "Обращение №${p0}";

  static String m66(p0) => "Трафик ${p0} ГБ";

  static String m67(p0) => "${p0} (весь трафик)";

  static String m68(p0, p1) => "Версия: ${p0}+${p1}";

  static String m69(p0) => "Версия: ${p0}";

  static String m70(p0) => "v${p0} · нажмите, чтобы проверить обновления";

  static String m71(p0) => "Управляет Voguesly · ${p0}";

  static String m72(p0) => "Не удалось инициализировать WebView: ${p0}";

  static String m73(count) =>
      "${Intl.plural(count, one: '${count} год назад', few: '${count} года назад', many: '${count} лет назад', other: '${count} года назад')}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "about": MessageLookupByLibrary.simpleMessage("О программе"),
    "accessControl": MessageLookupByLibrary.simpleMessage("Контроль доступа"),
    "accessControlAllowDesc": MessageLookupByLibrary.simpleMessage(
      "Разрешить только выбранным приложениям доступ к VPN",
    ),
    "accessControlDesc": MessageLookupByLibrary.simpleMessage(
      "Настройка доступа приложений к прокси",
    ),
    "accessControlNotAllowDesc": MessageLookupByLibrary.simpleMessage(
      "Выбранные приложения будут исключены из VPN",
    ),
    "accessControlSettings": MessageLookupByLibrary.simpleMessage(
      "Настройки контроля доступа",
    ),
    "account": MessageLookupByLibrary.simpleMessage("Аккаунт"),
    "action": MessageLookupByLibrary.simpleMessage("Действие"),
    "action_mode": MessageLookupByLibrary.simpleMessage("Переключить режим"),
    "action_proxy": MessageLookupByLibrary.simpleMessage("Системный прокси"),
    "action_start": MessageLookupByLibrary.simpleMessage("Старт/Стоп"),
    "action_tun": MessageLookupByLibrary.simpleMessage("TUN"),
    "action_view": MessageLookupByLibrary.simpleMessage("Показать/Скрыть"),
    "add": MessageLookupByLibrary.simpleMessage("Добавить"),
    "addProfile": MessageLookupByLibrary.simpleMessage("Добавить профиль"),
    "addProxies": MessageLookupByLibrary.simpleMessage("Добавить прокси"),
    "addProxyGroup": MessageLookupByLibrary.simpleMessage(
      "Добавить группу прокси",
    ),
    "addProxyProviders": MessageLookupByLibrary.simpleMessage(
      "Добавить провайдеров прокси",
    ),
    "addRule": MessageLookupByLibrary.simpleMessage("Добавить правило"),
    "addSsid": MessageLookupByLibrary.simpleMessage("Добавить SSID"),
    "addedRules": MessageLookupByLibrary.simpleMessage("Добавленные правила"),
    "additionalParameters": MessageLookupByLibrary.simpleMessage(
      "Дополнительные параметры",
    ),
    "address": MessageLookupByLibrary.simpleMessage("Адрес"),
    "addressHelp": MessageLookupByLibrary.simpleMessage("Адрес сервера WebDAV"),
    "addressTip": MessageLookupByLibrary.simpleMessage(
      "Пожалуйста, введите действительный адрес WebDAV",
    ),
    "advancedConfig": MessageLookupByLibrary.simpleMessage(
      "Расширенная конфигурация",
    ),
    "advancedConfigDesc": MessageLookupByLibrary.simpleMessage(
      "Предоставляет разнообразные варианты конфигурации",
    ),
    "advancedTools": MessageLookupByLibrary.simpleMessage(
      "Дополнительные инструменты",
    ),
    "agree": MessageLookupByLibrary.simpleMessage("Согласен"),
    "allowBypass": MessageLookupByLibrary.simpleMessage(
      "Разрешить приложениям обходить VPN",
    ),
    "allowBypassDesc": MessageLookupByLibrary.simpleMessage(
      "Некоторые приложения могут обходить VPN при включении",
    ),
    "allowLan": MessageLookupByLibrary.simpleMessage("Разрешить LAN"),
    "allowLanDesc": MessageLookupByLibrary.simpleMessage(
      "Разрешить доступ к прокси через локальную сеть",
    ),
    "app": MessageLookupByLibrary.simpleMessage("Приложение"),
    "appAccessControl": MessageLookupByLibrary.simpleMessage(
      "Контроль доступа приложений",
    ),
    "appendSystemDns": MessageLookupByLibrary.simpleMessage(
      "Добавить системный DNS",
    ),
    "appendSystemDnsTip": MessageLookupByLibrary.simpleMessage(
      "Принудительно добавить системный DNS к конфигурации",
    ),
    "application": MessageLookupByLibrary.simpleMessage("Приложение"),
    "applicationDesc": MessageLookupByLibrary.simpleMessage(
      "Изменение настроек, связанных с приложением",
    ),
    "authorized": MessageLookupByLibrary.simpleMessage("Разрешено"),
    "auto": MessageLookupByLibrary.simpleMessage("Авто"),
    "autoCheckUpdate": MessageLookupByLibrary.simpleMessage(
      "Автопроверка обновлений",
    ),
    "autoCheckUpdateDesc": MessageLookupByLibrary.simpleMessage(
      "Автоматически проверять обновления при запуске приложения",
    ),
    "autoCloseConnections": MessageLookupByLibrary.simpleMessage(
      "Автоматическое закрытие соединений",
    ),
    "autoCloseConnectionsDesc": MessageLookupByLibrary.simpleMessage(
      "Автоматически закрывать соединения после смены узла",
    ),
    "autoLaunch": MessageLookupByLibrary.simpleMessage("Автозапуск"),
    "autoLaunchDesc": MessageLookupByLibrary.simpleMessage(
      "Следовать автозапуску системы",
    ),
    "autoRun": MessageLookupByLibrary.simpleMessage("Автозапуск"),
    "autoRunDesc": MessageLookupByLibrary.simpleMessage(
      "Автоматический запуск при открытии приложения",
    ),
    "autoSetSystemDns": MessageLookupByLibrary.simpleMessage(
      "Автоматическая настройка системного DNS",
    ),
    "autoUpdate": MessageLookupByLibrary.simpleMessage("Автообновление"),
    "autoUpdateInterval": MessageLookupByLibrary.simpleMessage(
      "Интервал автообновления (минуты)",
    ),
    "backup": MessageLookupByLibrary.simpleMessage("Резервное копирование"),
    "backupAndRestore": MessageLookupByLibrary.simpleMessage(
      "Резервное копирование и восстановление",
    ),
    "backupAndRestoreDesc": MessageLookupByLibrary.simpleMessage(
      "Синхронизация данных через WebDAV или файлы",
    ),
    "backupSuccess": MessageLookupByLibrary.simpleMessage(
      "Резервное копирование успешно",
    ),
    "basicConfig": MessageLookupByLibrary.simpleMessage("Базовая конфигурация"),
    "basicConfigDesc": MessageLookupByLibrary.simpleMessage(
      "Глобальное изменение базовых настроек",
    ),
    "basicInfo": MessageLookupByLibrary.simpleMessage("Основная информация"),
    "basicStrategy": MessageLookupByLibrary.simpleMessage("Базовая стратегия"),
    "batteryOptimizationDesc": MessageLookupByLibrary.simpleMessage(
      "To ensure background operation, please disable battery optimization for this app. Tap to go to settings.",
    ),
    "batteryOptimizationStatusTip": MessageLookupByLibrary.simpleMessage(
      "Из-за особенностей системы этот статус не всегда может быть точным.",
    ),
    "bind": MessageLookupByLibrary.simpleMessage("Привязать"),
    "blacklistMode": MessageLookupByLibrary.simpleMessage(
      "Режим черного списка",
    ),
    "bypassDomain": MessageLookupByLibrary.simpleMessage("Обход домена"),
    "bypassDomainDesc": MessageLookupByLibrary.simpleMessage(
      "Действует только при включенном системном прокси",
    ),
    "cacheCorrupt": MessageLookupByLibrary.simpleMessage(
      "Кэш поврежден. Хотите очистить его?",
    ),
    "cancel": MessageLookupByLibrary.simpleMessage("Отмена"),
    "cancelSelectAll": MessageLookupByLibrary.simpleMessage(
      "Отменить выбор всего",
    ),
    "checkUpdate": MessageLookupByLibrary.simpleMessage("Проверить обновления"),
    "checkUpdateError": MessageLookupByLibrary.simpleMessage(
      "Текущее приложение уже является последней версией",
    ),
    "clearData": MessageLookupByLibrary.simpleMessage("Очистить данные"),
    "clipboardExport": MessageLookupByLibrary.simpleMessage(
      "Экспорт в буфер обмена",
    ),
    "clipboardImport": MessageLookupByLibrary.simpleMessage(
      "Импорт из буфера обмена",
    ),
    "color": MessageLookupByLibrary.simpleMessage("Цвет"),
    "colorSchemes": MessageLookupByLibrary.simpleMessage("Цветовые схемы"),
    "columns": MessageLookupByLibrary.simpleMessage("Столбцы"),
    "compatible": MessageLookupByLibrary.simpleMessage("Режим совместимости"),
    "configDataDetected": MessageLookupByLibrary.simpleMessage(
      "Данные обнаружены в конфигурации",
    ),
    "confirm": MessageLookupByLibrary.simpleMessage("Подтвердить"),
    "confirmClearAllData": MessageLookupByLibrary.simpleMessage(
      "Вы уверены, что хотите очистить все данные?",
    ),
    "confirmDeleteProxyGroup": MessageLookupByLibrary.simpleMessage(
      "Вы уверены, что хотите удалить текущую группу прокси?",
    ),
    "confirmExitWindow": MessageLookupByLibrary.simpleMessage(
      "Вы уверены, что хотите выйти из текущего окна?",
    ),
    "confirmForceCrashCore": MessageLookupByLibrary.simpleMessage(
      "Вы уверены, что хотите принудительно аварийно завершить работу ядра?",
    ),
    "confirmOverwriteTip": MessageLookupByLibrary.simpleMessage(
      "Существующие данные будут перезаписаны после подтверждения",
    ),
    "connected": MessageLookupByLibrary.simpleMessage("Подключено"),
    "connecting": MessageLookupByLibrary.simpleMessage("Подключение..."),
    "connection": MessageLookupByLibrary.simpleMessage("Соединение"),
    "connections": MessageLookupByLibrary.simpleMessage("Соединения"),
    "connectionsDesc": MessageLookupByLibrary.simpleMessage(
      "Просмотр текущих данных о соединениях",
    ),
    "connectivity": MessageLookupByLibrary.simpleMessage("Связь："),
    "content": MessageLookupByLibrary.simpleMessage("Содержание"),
    "contentNotEmpty": MessageLookupByLibrary.simpleMessage(
      "Содержимое не может быть пустым",
    ),
    "contentScheme": MessageLookupByLibrary.simpleMessage("Контентная тема"),
    "controlGlobalAddedRules": MessageLookupByLibrary.simpleMessage(
      "Управление глобальными добавленными правилами",
    ),
    "copy": MessageLookupByLibrary.simpleMessage("Копировать"),
    "copyEnvVar": MessageLookupByLibrary.simpleMessage(
      "Копирование переменных окружения",
    ),
    "copyLink": MessageLookupByLibrary.simpleMessage("Копировать ссылку"),
    "copySuccess": MessageLookupByLibrary.simpleMessage("Копирование успешно"),
    "core": MessageLookupByLibrary.simpleMessage("Ядро"),
    "coreStatus": MessageLookupByLibrary.simpleMessage("Основной статус"),
    "country": MessageLookupByLibrary.simpleMessage("Страна"),
    "crashTest": MessageLookupByLibrary.simpleMessage("Тест на сбои"),
    "crashlytics": MessageLookupByLibrary.simpleMessage("Анализ сбоев"),
    "crashlyticsTip": MessageLookupByLibrary.simpleMessage(
      "При включении автоматически загружает журналы сбоев без конфиденциальной информации, когда приложение выходит из строя",
    ),
    "create": MessageLookupByLibrary.simpleMessage("Создать"),
    "createProfile": MessageLookupByLibrary.simpleMessage("Create Profile"),
    "creationTime": MessageLookupByLibrary.simpleMessage("Время создания"),
    "custom": MessageLookupByLibrary.simpleMessage("Пользовательский"),
    "cut": MessageLookupByLibrary.simpleMessage("Вырезать"),
    "dark": MessageLookupByLibrary.simpleMessage("Темный"),
    "dashboard": MessageLookupByLibrary.simpleMessage("Панель управления"),
    "dataChangedSave": MessageLookupByLibrary.simpleMessage(
      "Обнаружены изменения данных, хотите сохранить?",
    ),
    "dataCollectionContent": MessageLookupByLibrary.simpleMessage(
      "Это приложение использует Firebase Crashlytics для сбора информации о сбоях nhằm улучшения стабильности приложения.\nСобираемые данные включают информацию об устройстве и подробности о сбоях, но не содержат персональных конфиденциальных данных.\nВы можете отключить эту функцию в настройках.",
    ),
    "dataCollectionTip": MessageLookupByLibrary.simpleMessage(
      "Уведомление о сборе данных",
    ),
    "daysAgo": m0,
    "defaultNameserver": MessageLookupByLibrary.simpleMessage(
      "Сервер имен по умолчанию",
    ),
    "defaultNameserverDesc": MessageLookupByLibrary.simpleMessage(
      "Для разрешения DNS-сервера",
    ),
    "defaultText": MessageLookupByLibrary.simpleMessage("По умолчанию"),
    "delay": MessageLookupByLibrary.simpleMessage("Задержка"),
    "delayTest": MessageLookupByLibrary.simpleMessage("Тест задержки"),
    "delete": MessageLookupByLibrary.simpleMessage("Удалить"),
    "deleteMultipTip": m1,
    "deleteTip": m2,
    "desc": MessageLookupByLibrary.simpleMessage(
      "Многоплатформенный прокси-клиент на основе ClashMeta, простой и удобный в использовании, с открытым исходным кодом и без рекламы.",
    ),
    "destination": MessageLookupByLibrary.simpleMessage("Назначение"),
    "destinationGeoIP": MessageLookupByLibrary.simpleMessage(
      "Геолокация назначения",
    ),
    "destinationIPASN": MessageLookupByLibrary.simpleMessage("ASN назначения"),
    "details": m3,
    "detection": MessageLookupByLibrary.simpleMessage("Проверка"),
    "detectionTip": MessageLookupByLibrary.simpleMessage(
      "Опирается на сторонний API, только для справки",
    ),
    "developerMode": MessageLookupByLibrary.simpleMessage("Режим разработчика"),
    "developerModeEnableTip": MessageLookupByLibrary.simpleMessage(
      "Режим разработчика активирован.",
    ),
    "direct": MessageLookupByLibrary.simpleMessage("Прямой"),
    "disableUDP": MessageLookupByLibrary.simpleMessage("Отключить UDP"),
    "disclaimer": MessageLookupByLibrary.simpleMessage(
      "Отказ от ответственности",
    ),
    "disclaimerDesc": MessageLookupByLibrary.simpleMessage(
      "Это программное обеспечение используется только в некоммерческих целях, таких как учебные обмены и научные исследования. Запрещено использовать это программное обеспечение в коммерческих целях. Любая коммерческая деятельность, если таковая имеется, не имеет отношения к этому программному обеспечению.",
    ),
    "disconnected": MessageLookupByLibrary.simpleMessage("Отключено"),
    "discoverNewVersion": MessageLookupByLibrary.simpleMessage(
      "Обнаружена новая версия",
    ),
    "dnsDesc": MessageLookupByLibrary.simpleMessage(
      "Обновление настроек, связанных с DNS",
    ),
    "dnsHijacking": MessageLookupByLibrary.simpleMessage("DNS-перехват"),
    "dnsMode": MessageLookupByLibrary.simpleMessage("Режим DNS"),
    "doYouWantToPass": MessageLookupByLibrary.simpleMessage(
      "Вы хотите пропустить",
    ),
    "domain": MessageLookupByLibrary.simpleMessage("Домен"),
    "download": MessageLookupByLibrary.simpleMessage("Скачивание"),
    "edit": MessageLookupByLibrary.simpleMessage("Редактировать"),
    "editGlobalRules": MessageLookupByLibrary.simpleMessage(
      "Редактировать глобальные правила",
    ),
    "editProxy": MessageLookupByLibrary.simpleMessage("Редактировать прокси"),
    "editProxyGroup": MessageLookupByLibrary.simpleMessage(
      "Редактировать группу прокси",
    ),
    "editRule": MessageLookupByLibrary.simpleMessage("Редактировать правило"),
    "editSsid": MessageLookupByLibrary.simpleMessage("Изменить SSID"),
    "emptyTip": m4,
    "en": MessageLookupByLibrary.simpleMessage("Английский"),
    "entries": MessageLookupByLibrary.simpleMessage(" записей"),
    "exclude": MessageLookupByLibrary.simpleMessage(
      "Скрыть из последних задач",
    ),
    "excludeDesc": MessageLookupByLibrary.simpleMessage(
      "Когда приложение находится в фоновом режиме, оно скрыто из последних задач",
    ),
    "excludeProxyFilter": MessageLookupByLibrary.simpleMessage(
      "Исключить фильтр прокси",
    ),
    "excludeSsids": MessageLookupByLibrary.simpleMessage("Exclude SSIDs"),
    "excludeSsidsDesc": MessageLookupByLibrary.simpleMessage(
      "When connected to an excluded SSID Wi-Fi, the app running state will be automatically switched.",
    ),
    "excludeType": MessageLookupByLibrary.simpleMessage("Тип исключения"),
    "existsTip": m5,
    "exit": MessageLookupByLibrary.simpleMessage("Выход"),
    "expand": MessageLookupByLibrary.simpleMessage("Стандартный"),
    "expectedStatus": MessageLookupByLibrary.simpleMessage("Ожидаемый статус"),
    "exportFile": MessageLookupByLibrary.simpleMessage("Экспорт файла"),
    "exportLogs": MessageLookupByLibrary.simpleMessage("Экспорт логов"),
    "exportSuccess": MessageLookupByLibrary.simpleMessage("Экспорт успешен"),
    "expressiveScheme": MessageLookupByLibrary.simpleMessage("Экспрессивные"),
    "externalController": MessageLookupByLibrary.simpleMessage(
      "Внешний контроллер",
    ),
    "externalControllerDesc": MessageLookupByLibrary.simpleMessage(
      "При включении ядро Clash можно контролировать на порту 9090",
    ),
    "externalFetch": MessageLookupByLibrary.simpleMessage("Внешнее получение"),
    "externalLink": MessageLookupByLibrary.simpleMessage("Внешняя ссылка"),
    "fakeipFilter": MessageLookupByLibrary.simpleMessage("Фильтр Fakeip"),
    "fakeipRange": MessageLookupByLibrary.simpleMessage("Диапазон Fakeip"),
    "fallback": MessageLookupByLibrary.simpleMessage("Резервный"),
    "fallbackDesc": MessageLookupByLibrary.simpleMessage(
      "Обычно используется оффшорный DNS",
    ),
    "fallbackFilter": MessageLookupByLibrary.simpleMessage(
      "Фильтр резервного DNS",
    ),
    "fidelityScheme": MessageLookupByLibrary.simpleMessage("Точная передача"),
    "file": MessageLookupByLibrary.simpleMessage("Файл"),
    "fileDesc": MessageLookupByLibrary.simpleMessage("Прямая загрузка профиля"),
    "fileIsUpdate": MessageLookupByLibrary.simpleMessage(
      "Файл был изменен. Хотите сохранить изменения?",
    ),
    "findProcessMode": MessageLookupByLibrary.simpleMessage(
      "Режим поиска процесса",
    ),
    "findProcessModeDesc": MessageLookupByLibrary.simpleMessage(
      "При включении возможны небольшие потери производительности",
    ),
    "fontFamily": MessageLookupByLibrary.simpleMessage("Семейство шрифтов"),
    "forceRestartCoreTip": MessageLookupByLibrary.simpleMessage(
      "Вы уверены, что хотите принудительно перезапустить ядро?",
    ),
    "fruitSaladScheme": MessageLookupByLibrary.simpleMessage("Фруктовый микс"),
    "general": MessageLookupByLibrary.simpleMessage("Общие"),
    "geodataLoader": MessageLookupByLibrary.simpleMessage(
      "Режим низкого потребления памяти для геоданных",
    ),
    "geodataLoaderDesc": MessageLookupByLibrary.simpleMessage(
      "Включение будет использовать загрузчик геоданных с низким потреблением памяти",
    ),
    "geoipCode": MessageLookupByLibrary.simpleMessage("Код Geoip"),
    "global": MessageLookupByLibrary.simpleMessage("Глобальный"),
    "go": MessageLookupByLibrary.simpleMessage("Перейти"),
    "goDownload": MessageLookupByLibrary.simpleMessage("Перейти к загрузке"),
    "goToConfigureScript": MessageLookupByLibrary.simpleMessage(
      "Перейти к настройке скрипта",
    ),
    "hasCacheChange": MessageLookupByLibrary.simpleMessage(
      "Хотите сохранить изменения в кэше?",
    ),
    "hideFromList": MessageLookupByLibrary.simpleMessage("Скрыть из списка"),
    "host": MessageLookupByLibrary.simpleMessage("Хост"),
    "hostsDesc": MessageLookupByLibrary.simpleMessage("Добавить Hosts"),
    "hotkeyConflict": MessageLookupByLibrary.simpleMessage(
      "Конфликт горячих клавиш",
    ),
    "hotkeyManagement": MessageLookupByLibrary.simpleMessage(
      "Управление горячими клавишами",
    ),
    "hotkeyManagementDesc": MessageLookupByLibrary.simpleMessage(
      "Использование клавиатуры для управления приложением",
    ),
    "hoursAgo": m6,
    "icon": MessageLookupByLibrary.simpleMessage("Иконка"),
    "iconRecords": MessageLookupByLibrary.simpleMessage("История иконок"),
    "iconStyle": MessageLookupByLibrary.simpleMessage("Стиль иконки"),
    "iconUrl": MessageLookupByLibrary.simpleMessage("URL иконки"),
    "ignoreBatteryOptimization": MessageLookupByLibrary.simpleMessage(
      "Ignore Battery Optimization",
    ),
    "import": MessageLookupByLibrary.simpleMessage("Импорт"),
    "importFile": MessageLookupByLibrary.simpleMessage("Импорт из файла"),
    "importFromURL": MessageLookupByLibrary.simpleMessage("Импорт из URL"),
    "importUrl": MessageLookupByLibrary.simpleMessage("Импорт по URL"),
    "includeAllProxies": MessageLookupByLibrary.simpleMessage(
      "Включить все прокси",
    ),
    "includeAllProxiesTip": MessageLookupByLibrary.simpleMessage(
      "Импорт всех прокси, не содержащих группы прокси, дополнительные группы прокси можно добавить ниже",
    ),
    "includeAllProxyProviders": MessageLookupByLibrary.simpleMessage(
      "Включить всех провайдеров прокси",
    ),
    "includeAllProxyProvidersTip": MessageLookupByLibrary.simpleMessage(
      "При включении это переопределит импортированных провайдеров прокси",
    ),
    "infiniteTime": MessageLookupByLibrary.simpleMessage(
      "Долгосрочное действие",
    ),
    "init": MessageLookupByLibrary.simpleMessage("Инициализация"),
    "inputCorrectHotkey": MessageLookupByLibrary.simpleMessage(
      "Пожалуйста, введите правильную горячую клавишу",
    ),
    "inputProxyGroupName": MessageLookupByLibrary.simpleMessage(
      "Введите имя группы прокси",
    ),
    "inputRuleContent": MessageLookupByLibrary.simpleMessage(
      "Введите содержимое правила",
    ),
    "intelligentSelected": MessageLookupByLibrary.simpleMessage(
      "Интеллектуальный выбор",
    ),
    "internet": MessageLookupByLibrary.simpleMessage("Интернет"),
    "interval": MessageLookupByLibrary.simpleMessage("Интервал"),
    "intranetIP": MessageLookupByLibrary.simpleMessage("Внутренний IP"),
    "invalidBackupFile": MessageLookupByLibrary.simpleMessage(
      "Неверный файл резервной копии",
    ),
    "invalidPolicy": m7,
    "invalidProxy": m8,
    "invalidProxyProvider": m9,
    "invalidSubRule": m10,
    "ipcidr": MessageLookupByLibrary.simpleMessage("IPCIDR"),
    "ipv6Desc": MessageLookupByLibrary.simpleMessage(
      "При включении будет возможно получать IPv6 трафик",
    ),
    "ipv6InboundDesc": MessageLookupByLibrary.simpleMessage(
      "Разрешить входящий IPv6",
    ),
    "ja": MessageLookupByLibrary.simpleMessage("Японский"),
    "justNow": MessageLookupByLibrary.simpleMessage("Только что"),
    "keepAliveIntervalDesc": MessageLookupByLibrary.simpleMessage(
      "Интервал поддержания TCP-соединения",
    ),
    "key": MessageLookupByLibrary.simpleMessage("Ключ"),
    "language": MessageLookupByLibrary.simpleMessage("Язык"),
    "layout": MessageLookupByLibrary.simpleMessage("Макет"),
    "light": MessageLookupByLibrary.simpleMessage("Светлый"),
    "list": MessageLookupByLibrary.simpleMessage("Список"),
    "listen": MessageLookupByLibrary.simpleMessage("Слушать"),
    "loadTest": MessageLookupByLibrary.simpleMessage("Тест загрузки"),
    "loading": MessageLookupByLibrary.simpleMessage("Загрузка..."),
    "local": MessageLookupByLibrary.simpleMessage("Локальный"),
    "localBackupDesc": MessageLookupByLibrary.simpleMessage(
      "Резервное копирование локальных данных на локальный диск",
    ),
    "locationPermission": MessageLookupByLibrary.simpleMessage(
      "Location Permission",
    ),
    "locationPermissionDeniedMessage": MessageLookupByLibrary.simpleMessage(
      "Разрешение на геолокацию отклонено, поэтому невозможно получить имя текущей Wi-Fi сети. Включите разрешение на геолокацию вручную в системных настройках.",
    ),
    "locationPermissionDesc": MessageLookupByLibrary.simpleMessage(
      "According to system requirements, obtaining the Wi-Fi name requires you to grant location permission.",
    ),
    "locationPermissionGuide": m11,
    "locationPermissionRequired": MessageLookupByLibrary.simpleMessage(
      "Location Permission Required",
    ),
    "log": MessageLookupByLibrary.simpleMessage("Журнал"),
    "logLevel": MessageLookupByLibrary.simpleMessage("Уровень логов"),
    "logcat": MessageLookupByLibrary.simpleMessage("Logcat"),
    "logcatDesc": MessageLookupByLibrary.simpleMessage(
      "Отключение скроет запись логов",
    ),
    "logs": MessageLookupByLibrary.simpleMessage("Логи"),
    "logsDesc": MessageLookupByLibrary.simpleMessage("Записи захвата логов"),
    "logsTest": MessageLookupByLibrary.simpleMessage("Тест журналов"),
    "loopback": MessageLookupByLibrary.simpleMessage(
      "Инструмент разблокировки Loopback",
    ),
    "loopbackDesc": MessageLookupByLibrary.simpleMessage(
      "Используется для разблокировки Loopback UWP",
    ),
    "loose": MessageLookupByLibrary.simpleMessage("Свободный"),
    "matchSourceIp": MessageLookupByLibrary.simpleMessage(
      "Сопоставить исходный IP",
    ),
    "maxFailedTimes": MessageLookupByLibrary.simpleMessage(
      "Макс. количество неудач",
    ),
    "memoryInfo": MessageLookupByLibrary.simpleMessage("Информация о памяти"),
    "messageTest": MessageLookupByLibrary.simpleMessage(
      "Тестирование сообщения",
    ),
    "messageTestTip": MessageLookupByLibrary.simpleMessage("Это сообщение."),
    "min": MessageLookupByLibrary.simpleMessage("Мин"),
    "minimizeOnExit": MessageLookupByLibrary.simpleMessage(
      "Свернуть при выходе",
    ),
    "minimizeOnExitDesc": MessageLookupByLibrary.simpleMessage(
      "Изменить стандартное событие выхода из системы",
    ),
    "minutesAgo": m12,
    "mixedPort": MessageLookupByLibrary.simpleMessage("Смешанный порт"),
    "mode": MessageLookupByLibrary.simpleMessage("Режим"),
    "monochromeScheme": MessageLookupByLibrary.simpleMessage("Монохром"),
    "monthsAgo": m13,
    "more": MessageLookupByLibrary.simpleMessage("Еще"),
    "name": MessageLookupByLibrary.simpleMessage("Имя"),
    "nameserver": MessageLookupByLibrary.simpleMessage("Сервер имен"),
    "nameserverDesc": MessageLookupByLibrary.simpleMessage(
      "Для разрешения домена",
    ),
    "nameserverPolicy": MessageLookupByLibrary.simpleMessage(
      "Политика сервера имен",
    ),
    "nameserverPolicyDesc": MessageLookupByLibrary.simpleMessage(
      "Указать соответствующую политику сервера имен",
    ),
    "network": MessageLookupByLibrary.simpleMessage("Сеть"),
    "networkDesc": MessageLookupByLibrary.simpleMessage(
      "Изменение настроек, связанных с сетью",
    ),
    "networkDetection": MessageLookupByLibrary.simpleMessage(
      "Обнаружение сети",
    ),
    "networkException": MessageLookupByLibrary.simpleMessage(
      "Ошибка сети, проверьте соединение и попробуйте еще раз",
    ),
    "networkSpeed": MessageLookupByLibrary.simpleMessage("Скорость сети"),
    "networkType": MessageLookupByLibrary.simpleMessage("Тип сети"),
    "neutralScheme": MessageLookupByLibrary.simpleMessage("Нейтральные"),
    "noData": MessageLookupByLibrary.simpleMessage("Нет данных"),
    "noHotKey": MessageLookupByLibrary.simpleMessage("Нет горячей клавиши"),
    "noInfo": MessageLookupByLibrary.simpleMessage("Нет информации"),
    "noLongerRemind": MessageLookupByLibrary.simpleMessage(
      "Больше не напоминать",
    ),
    "noNetwork": MessageLookupByLibrary.simpleMessage("Нет сети"),
    "noNetworkApp": MessageLookupByLibrary.simpleMessage("Приложение без сети"),
    "noRecords": MessageLookupByLibrary.simpleMessage("Нет записей"),
    "noResolve": MessageLookupByLibrary.simpleMessage("Не разрешать IP"),
    "noResolveHostname": MessageLookupByLibrary.simpleMessage(
      "Не разрешать имя хоста",
    ),
    "none": MessageLookupByLibrary.simpleMessage("Нет"),
    "notSelectedTip": MessageLookupByLibrary.simpleMessage(
      "Текущая группа прокси не может быть выбрана.",
    ),
    "nullProfileDesc": MessageLookupByLibrary.simpleMessage(
      "Нет профиля, пожалуйста, добавьте профиль",
    ),
    "nullTip": m14,
    "numberTip": m15,
    "onDemand": MessageLookupByLibrary.simpleMessage("On Demand"),
    "onDemandDesc": MessageLookupByLibrary.simpleMessage(
      "Configure the program running state for specific scenarios",
    ),
    "onlyIcon": MessageLookupByLibrary.simpleMessage("Только иконка"),
    "onlyStatisticsProxy": MessageLookupByLibrary.simpleMessage(
      "Только статистика прокси",
    ),
    "onlyStatisticsProxyDesc": MessageLookupByLibrary.simpleMessage(
      "При включении будет учитываться только трафик прокси",
    ),
    "optional": MessageLookupByLibrary.simpleMessage("Необязательно"),
    "options": MessageLookupByLibrary.simpleMessage("Опции"),
    "other": MessageLookupByLibrary.simpleMessage("Другое"),
    "otherContributors": MessageLookupByLibrary.simpleMessage(
      "Другие участники",
    ),
    "outboundMode": MessageLookupByLibrary.simpleMessage(
      "Режим исходящего трафика",
    ),
    "override": MessageLookupByLibrary.simpleMessage("Переопределить"),
    "overrideDns": MessageLookupByLibrary.simpleMessage("Переопределить DNS"),
    "overrideDnsDesc": MessageLookupByLibrary.simpleMessage(
      "Включение переопределит настройки DNS в профиле",
    ),
    "overrideMode": MessageLookupByLibrary.simpleMessage(
      "Режим переопределения",
    ),
    "overrideScript": MessageLookupByLibrary.simpleMessage(
      "Скрипт переопределения",
    ),
    "overwriteTypeCustom": MessageLookupByLibrary.simpleMessage(
      "Пользовательский",
    ),
    "overwriteTypeCustomDesc": MessageLookupByLibrary.simpleMessage(
      "Пользовательский режим, полная настройка групп прокси и правил",
    ),
    "palette": MessageLookupByLibrary.simpleMessage("Палитра"),
    "password": MessageLookupByLibrary.simpleMessage("Пароль"),
    "paste": MessageLookupByLibrary.simpleMessage("Вставить"),
    "pleaseBindWebDAV": MessageLookupByLibrary.simpleMessage(
      "Пожалуйста, привяжите WebDAV",
    ),
    "pleaseEnterScriptName": MessageLookupByLibrary.simpleMessage(
      "Пожалуйста, введите название скрипта",
    ),
    "pleaseInputAdminPassword": MessageLookupByLibrary.simpleMessage(
      "Пожалуйста, введите пароль администратора",
    ),
    "pleaseUploadValidQrcode": MessageLookupByLibrary.simpleMessage(
      "Пожалуйста, загрузите действительный QR-код",
    ),
    "port": MessageLookupByLibrary.simpleMessage("Порт"),
    "portConflictTip": MessageLookupByLibrary.simpleMessage(
      "Введите другой порт",
    ),
    "portTip": m16,
    "preferH3Desc": MessageLookupByLibrary.simpleMessage(
      "Приоритетное использование HTTP/3 для DOH",
    ),
    "prerequisites": MessageLookupByLibrary.simpleMessage("Prerequisites"),
    "pressKeyboard": MessageLookupByLibrary.simpleMessage(
      "Пожалуйста, нажмите клавишу.",
    ),
    "preview": MessageLookupByLibrary.simpleMessage("Предпросмотр"),
    "process": MessageLookupByLibrary.simpleMessage("процесс"),
    "profile": MessageLookupByLibrary.simpleMessage("Профиль"),
    "profileAutoUpdateIntervalInvalidValidationDesc":
        MessageLookupByLibrary.simpleMessage(
          "Пожалуйста, введите действительный формат интервала времени",
        ),
    "profileAutoUpdateIntervalNullValidationDesc":
        MessageLookupByLibrary.simpleMessage(
          "Пожалуйста, введите интервал времени для автообновления",
        ),
    "profileHasUpdate": MessageLookupByLibrary.simpleMessage(
      "Профиль был изменен. Хотите отключить автообновление?",
    ),
    "profileNameNullValidationDesc": MessageLookupByLibrary.simpleMessage(
      "Пожалуйста, введите имя профиля",
    ),
    "profileUrlInvalidValidationDesc": MessageLookupByLibrary.simpleMessage(
      "Пожалуйста, введите действительный URL профиля",
    ),
    "profileUrlNullValidationDesc": MessageLookupByLibrary.simpleMessage(
      "Пожалуйста, введите URL профиля",
    ),
    "profiles": MessageLookupByLibrary.simpleMessage("Профили"),
    "profilesSort": MessageLookupByLibrary.simpleMessage("Сортировка профилей"),
    "project": MessageLookupByLibrary.simpleMessage("Проект"),
    "providers": MessageLookupByLibrary.simpleMessage("Провайдеры"),
    "proxies": MessageLookupByLibrary.simpleMessage("Прокси"),
    "proxiesEmpty": MessageLookupByLibrary.simpleMessage("Список прокси пуст"),
    "proxyChains": MessageLookupByLibrary.simpleMessage("Цепочки прокси"),
    "proxyDetectedAbnormal": MessageLookupByLibrary.simpleMessage(
      "Обнаружена аномалия выбранных прокси",
    ),
    "proxyFilter": MessageLookupByLibrary.simpleMessage("Фильтр прокси"),
    "proxyGroup": MessageLookupByLibrary.simpleMessage("Группа прокси"),
    "proxyGroupDetectedAbnormal": MessageLookupByLibrary.simpleMessage(
      "Обнаружена аномалия текущей группы прокси",
    ),
    "proxyGroupEmpty": MessageLookupByLibrary.simpleMessage(
      "Группа прокси пуста",
    ),
    "proxyGroupNameDuplicate": MessageLookupByLibrary.simpleMessage(
      "Имя группы прокси дублируется",
    ),
    "proxyGroupNameEmpty": MessageLookupByLibrary.simpleMessage(
      "Имя группы прокси не может быть пустым",
    ),
    "proxyNameserver": MessageLookupByLibrary.simpleMessage(
      "Прокси-сервер имен",
    ),
    "proxyNameserverDesc": MessageLookupByLibrary.simpleMessage(
      "Домен для разрешения прокси-узлов",
    ),
    "proxyPort": MessageLookupByLibrary.simpleMessage("Порт прокси"),
    "proxyProviderDetectedAbnormal": MessageLookupByLibrary.simpleMessage(
      "Обнаружена аномалия выбранных провайдеров прокси",
    ),
    "proxyProviders": MessageLookupByLibrary.simpleMessage("Провайдеры прокси"),
    "proxyProvidersEmpty": MessageLookupByLibrary.simpleMessage(
      "Провайдеры прокси пусты",
    ),
    "proxyProvidersNotEmpty": MessageLookupByLibrary.simpleMessage(
      "Провайдеры прокси не могут быть пустыми",
    ),
    "proxyType": MessageLookupByLibrary.simpleMessage("Тип прокси"),
    "pruneCache": MessageLookupByLibrary.simpleMessage("Очистить кэш"),
    "pureBlackMode": MessageLookupByLibrary.simpleMessage("Чисто черный режим"),
    "qrcode": MessageLookupByLibrary.simpleMessage("QR-код"),
    "qrcodeDesc": MessageLookupByLibrary.simpleMessage(
      "Сканируйте QR-код для получения профиля",
    ),
    "quickFill": MessageLookupByLibrary.simpleMessage("Быстрое заполнение"),
    "rainbowScheme": MessageLookupByLibrary.simpleMessage("Радужные"),
    "redirPort": MessageLookupByLibrary.simpleMessage("Redir-порт"),
    "redo": MessageLookupByLibrary.simpleMessage("Повторить"),
    "remote": MessageLookupByLibrary.simpleMessage("Удаленный"),
    "remoteBackupDesc": MessageLookupByLibrary.simpleMessage(
      "Резервное копирование локальных данных на WebDAV",
    ),
    "remoteDestination": MessageLookupByLibrary.simpleMessage(
      "Удалённое назначение",
    ),
    "remove": MessageLookupByLibrary.simpleMessage("Удалить"),
    "rename": MessageLookupByLibrary.simpleMessage("Переименовать"),
    "request": MessageLookupByLibrary.simpleMessage("Запрос"),
    "requests": MessageLookupByLibrary.simpleMessage("Запросы"),
    "requestsDesc": MessageLookupByLibrary.simpleMessage(
      "Просмотр последних записей запросов",
    ),
    "reset": MessageLookupByLibrary.simpleMessage("Сброс"),
    "resetPageChangesTip": MessageLookupByLibrary.simpleMessage(
      "На текущей странице есть изменения. Вы уверены, что хотите сбросить?",
    ),
    "resetTip": MessageLookupByLibrary.simpleMessage(
      "Убедитесь, что хотите сбросить",
    ),
    "resources": MessageLookupByLibrary.simpleMessage("Ресурсы"),
    "resourcesDesc": MessageLookupByLibrary.simpleMessage(
      "Информация, связанная с внешними ресурсами",
    ),
    "respectRules": MessageLookupByLibrary.simpleMessage("Соблюдение правил"),
    "respectRulesDesc": MessageLookupByLibrary.simpleMessage(
      "DNS-соединение следует правилам, необходимо настроить proxy-server-nameserver",
    ),
    "restart": MessageLookupByLibrary.simpleMessage("Перезапустить"),
    "restartCoreTip": MessageLookupByLibrary.simpleMessage(
      "Вы уверены, что хотите перезапустить ядро?",
    ),
    "restore": MessageLookupByLibrary.simpleMessage("Восстановить"),
    "restoreAllData": MessageLookupByLibrary.simpleMessage(
      "Восстановить все данные",
    ),
    "restoreException": MessageLookupByLibrary.simpleMessage(
      "Ошибка восстановления",
    ),
    "restoreFromFileDesc": MessageLookupByLibrary.simpleMessage(
      "Восстановить данные из файла",
    ),
    "restoreFromWebDAVDesc": MessageLookupByLibrary.simpleMessage(
      "Восстановить данные через WebDAV",
    ),
    "restoreOnlyConfig": MessageLookupByLibrary.simpleMessage(
      "Восстановить только файлы конфигурации",
    ),
    "restoreStrategy": MessageLookupByLibrary.simpleMessage(
      "Стратегия восстановления",
    ),
    "restoreStrategy_compatible": MessageLookupByLibrary.simpleMessage(
      "Совместимый",
    ),
    "restoreStrategy_override": MessageLookupByLibrary.simpleMessage(
      "Перезаписать",
    ),
    "restoreSuccess": MessageLookupByLibrary.simpleMessage(
      "Восстановление успешно",
    ),
    "routeAddress": MessageLookupByLibrary.simpleMessage("Адрес маршрутизации"),
    "routeAddressDesc": MessageLookupByLibrary.simpleMessage(
      "Настройка адреса прослушивания маршрутизации",
    ),
    "routeMode": MessageLookupByLibrary.simpleMessage("Режим маршрутизации"),
    "routeMode_bypassPrivate": MessageLookupByLibrary.simpleMessage(
      "Обход частных адресов маршрутизации",
    ),
    "routeMode_config": MessageLookupByLibrary.simpleMessage(
      "Использовать конфигурацию",
    ),
    "ru": MessageLookupByLibrary.simpleMessage("Русский"),
    "rule": MessageLookupByLibrary.simpleMessage("Правило"),
    "ruleActionAndDesc": MessageLookupByLibrary.simpleMessage(
      "Логическое правило AND",
    ),
    "ruleActionDomainDesc": MessageLookupByLibrary.simpleMessage(
      "Сопоставить полный домен",
    ),
    "ruleActionDomainKeywordDesc": MessageLookupByLibrary.simpleMessage(
      "Сопоставить ключевое слово домена",
    ),
    "ruleActionDomainRegexDesc": MessageLookupByLibrary.simpleMessage(
      "Сопоставление по маске, поддерживает только * и ?",
    ),
    "ruleActionDomainSuffixDesc": MessageLookupByLibrary.simpleMessage(
      "Сопоставить суффикс домена",
    ),
    "ruleActionDscpDesc": MessageLookupByLibrary.simpleMessage(
      "Сопоставить метку DSCP (только для tproxy udp inbound)",
    ),
    "ruleActionDstPortDesc": MessageLookupByLibrary.simpleMessage(
      "Сопоставить диапазон портов назначения запроса",
    ),
    "ruleActionGeoipDesc": MessageLookupByLibrary.simpleMessage(
      "Сопоставить код страны IP-адреса",
    ),
    "ruleActionGeositeDesc": MessageLookupByLibrary.simpleMessage(
      "Сопоставить домены внутри Geosite",
    ),
    "ruleActionInNameDesc": MessageLookupByLibrary.simpleMessage(
      "Сопоставить входящее имя",
    ),
    "ruleActionInPortDesc": MessageLookupByLibrary.simpleMessage(
      "Сопоставить входящий порт",
    ),
    "ruleActionInTypeDesc": MessageLookupByLibrary.simpleMessage(
      "Сопоставить входящий тип",
    ),
    "ruleActionInUserDesc": MessageLookupByLibrary.simpleMessage(
      "Сопоставить входящее имя пользователя, поддерживает несколько имен через /",
    ),
    "ruleActionIpAsnDesc": MessageLookupByLibrary.simpleMessage(
      "Сопоставить ASN IP-адреса",
    ),
    "ruleActionIpCidr6Desc": MessageLookupByLibrary.simpleMessage(
      "Сопоставить диапазон IP-адресов (IP-CIDR6 — это просто псевдоним)",
    ),
    "ruleActionIpCidrDesc": MessageLookupByLibrary.simpleMessage(
      "Сопоставить диапазон IP-адресов",
    ),
    "ruleActionIpSuffixDesc": MessageLookupByLibrary.simpleMessage(
      "Сопоставить диапазон суффиксов IP",
    ),
    "ruleActionMatchDesc": MessageLookupByLibrary.simpleMessage(
      "Сопоставить все запросы, условия не требуются",
    ),
    "ruleActionNetworkDesc": MessageLookupByLibrary.simpleMessage(
      "Сопоставить TCP или UDP",
    ),
    "ruleActionNotDesc": MessageLookupByLibrary.simpleMessage(
      "Логическое правило NOT",
    ),
    "ruleActionOrDesc": MessageLookupByLibrary.simpleMessage(
      "Логическое правило OR",
    ),
    "ruleActionProcessNameDesc": MessageLookupByLibrary.simpleMessage(
      "Сопоставить по имени процесса, на Android соответствует имени пакета",
    ),
    "ruleActionProcessNameRegexDesc": MessageLookupByLibrary.simpleMessage(
      "Сопоставить по регулярному выражению имени процесса, на Android соответствует имени пакета",
    ),
    "ruleActionProcessPathDesc": MessageLookupByLibrary.simpleMessage(
      "Сопоставить по полному пути процесса",
    ),
    "ruleActionProcessPathRegexDesc": MessageLookupByLibrary.simpleMessage(
      "Сопоставить по регулярному выражению пути процесса",
    ),
    "ruleActionRuleSetDesc": MessageLookupByLibrary.simpleMessage(
      "Ссылка на набор правил, требуется настройка rule-providers",
    ),
    "ruleActionSrcGeoipDesc": MessageLookupByLibrary.simpleMessage(
      "Сопоставить код страны исходного IP",
    ),
    "ruleActionSrcIpAsnDesc": MessageLookupByLibrary.simpleMessage(
      "Сопоставить ASN исходного IP",
    ),
    "ruleActionSrcIpCidrDesc": MessageLookupByLibrary.simpleMessage(
      "Сопоставить диапазон исходных IP-адресов",
    ),
    "ruleActionSrcIpSuffixDesc": MessageLookupByLibrary.simpleMessage(
      "Сопоставить диапазон исходных суффиксов IP",
    ),
    "ruleActionSrcPortDesc": MessageLookupByLibrary.simpleMessage(
      "Сопоставить диапазон портов источника запроса",
    ),
    "ruleActionSubRuleDesc": MessageLookupByLibrary.simpleMessage(
      "Сопоставить с подправилом, обратите внимание на использование скобок",
    ),
    "ruleActionUidDesc": MessageLookupByLibrary.simpleMessage(
      "Сопоставить Linux USER ID",
    ),
    "ruleEmpty": MessageLookupByLibrary.simpleMessage("Правило пусто"),
    "ruleName": MessageLookupByLibrary.simpleMessage("Название правила"),
    "ruleProviders": MessageLookupByLibrary.simpleMessage("Провайдеры правил"),
    "ruleSet": MessageLookupByLibrary.simpleMessage("Набор правил"),
    "ruleTarget": MessageLookupByLibrary.simpleMessage("Цель правила"),
    "save": MessageLookupByLibrary.simpleMessage("Сохранить"),
    "saveChanges": MessageLookupByLibrary.simpleMessage("Сохранить изменения?"),
    "script": MessageLookupByLibrary.simpleMessage("Скрипт"),
    "scriptModeDesc": MessageLookupByLibrary.simpleMessage(
      "Режим скрипта, использование внешних расширяющих скриптов, предоставление возможности переопределения конфигурации одним кликом",
    ),
    "search": MessageLookupByLibrary.simpleMessage("Поиск"),
    "seconds": MessageLookupByLibrary.simpleMessage("Секунд"),
    "selectAll": MessageLookupByLibrary.simpleMessage("Выбрать все"),
    "selectProxies": MessageLookupByLibrary.simpleMessage("Выбрать прокси"),
    "selectProxyProviders": MessageLookupByLibrary.simpleMessage(
      "Выбрать провайдеров прокси",
    ),
    "selectRuleSet": MessageLookupByLibrary.simpleMessage(
      "Пожалуйста, выберите набор правил",
    ),
    "selectSplitStrategy": MessageLookupByLibrary.simpleMessage(
      "Пожалуйста, выберите стратегию разделения",
    ),
    "selectSubRule": MessageLookupByLibrary.simpleMessage(
      "Пожалуйста, выберите подправило",
    ),
    "selected": MessageLookupByLibrary.simpleMessage("Выбрано"),
    "selectedCountTitle": m17,
    "settings": MessageLookupByLibrary.simpleMessage("Настройки"),
    "shop": MessageLookupByLibrary.simpleMessage("Магазин"),
    "show": MessageLookupByLibrary.simpleMessage("Показать"),
    "shrink": MessageLookupByLibrary.simpleMessage("Сжать"),
    "silentLaunch": MessageLookupByLibrary.simpleMessage("Тихий запуск"),
    "silentLaunchDesc": MessageLookupByLibrary.simpleMessage(
      "Запуск в фоновом режиме",
    ),
    "size": MessageLookupByLibrary.simpleMessage("Размер"),
    "socksPort": MessageLookupByLibrary.simpleMessage("Socks-порт"),
    "sort": MessageLookupByLibrary.simpleMessage("Сортировка"),
    "source": MessageLookupByLibrary.simpleMessage("Источник"),
    "sourceIp": MessageLookupByLibrary.simpleMessage("Исходный IP"),
    "specialProxy": MessageLookupByLibrary.simpleMessage("Специальный прокси"),
    "specialRules": MessageLookupByLibrary.simpleMessage("Специальные правила"),
    "speedStatistics": MessageLookupByLibrary.simpleMessage(
      "Статистика скорости",
    ),
    "splitStrategy": MessageLookupByLibrary.simpleMessage(
      "Стратегия разделения",
    ),
    "splitStrategyNotEmpty": MessageLookupByLibrary.simpleMessage(
      "Стратегия разделения не может быть пустой",
    ),
    "ssidsEmpty": MessageLookupByLibrary.simpleMessage("SSIDs is empty"),
    "stackMode": MessageLookupByLibrary.simpleMessage("Режим стека"),
    "standard": MessageLookupByLibrary.simpleMessage("Стандартный"),
    "standardModeDesc": MessageLookupByLibrary.simpleMessage(
      "Стандартный режим, переопределение базовой конфигурации, предоставление возможности простого добавления правил",
    ),
    "start": MessageLookupByLibrary.simpleMessage("Старт"),
    "startVpn": MessageLookupByLibrary.simpleMessage("Запуск VPN..."),
    "status": MessageLookupByLibrary.simpleMessage("Статус"),
    "statusDesc": MessageLookupByLibrary.simpleMessage(
      "Системный DNS будет использоваться при выключении",
    ),
    "stop": MessageLookupByLibrary.simpleMessage("Стоп"),
    "stopVpn": MessageLookupByLibrary.simpleMessage("Остановка VPN..."),
    "style": MessageLookupByLibrary.simpleMessage("Стиль"),
    "subRule": MessageLookupByLibrary.simpleMessage("Подправило"),
    "subRuleEmpty": MessageLookupByLibrary.simpleMessage("Подправило пусто"),
    "subRuleNotEmpty": MessageLookupByLibrary.simpleMessage(
      "Подправило не может быть пустым",
    ),
    "submit": MessageLookupByLibrary.simpleMessage("Отправить"),
    "suspended": MessageLookupByLibrary.simpleMessage("Приостановлено..."),
    "sync": MessageLookupByLibrary.simpleMessage("Синхронизация"),
    "system": MessageLookupByLibrary.simpleMessage("Система"),
    "systemApp": MessageLookupByLibrary.simpleMessage("Системное приложение"),
    "systemProxy": MessageLookupByLibrary.simpleMessage("Системный прокси"),
    "systemProxyDesc": MessageLookupByLibrary.simpleMessage(
      "Прикрепить HTTP-прокси к VpnService",
    ),
    "tab": MessageLookupByLibrary.simpleMessage("Вкладка"),
    "tabAnimation": MessageLookupByLibrary.simpleMessage("Анимация вкладок"),
    "tabAnimationDesc": MessageLookupByLibrary.simpleMessage(
      "Действительно только в мобильном виде",
    ),
    "tapToAuthorize": MessageLookupByLibrary.simpleMessage(
      "Нажмите, чтобы разрешить",
    ),
    "tcpConcurrent": MessageLookupByLibrary.simpleMessage("TCP параллелизм"),
    "tcpConcurrentDesc": MessageLookupByLibrary.simpleMessage(
      "Включение позволит использовать параллелизм TCP",
    ),
    "testInterval": MessageLookupByLibrary.simpleMessage(
      "Интервал тестирования",
    ),
    "testUrl": MessageLookupByLibrary.simpleMessage("Тест URL"),
    "testWhenUsed": MessageLookupByLibrary.simpleMessage(
      "Тестировать при использовании",
    ),
    "textScale": MessageLookupByLibrary.simpleMessage("Масштабирование текста"),
    "theme": MessageLookupByLibrary.simpleMessage("Тема"),
    "themeColor": MessageLookupByLibrary.simpleMessage("Цвет темы"),
    "themeDesc": MessageLookupByLibrary.simpleMessage(
      "Установить темный режим, настроить цвет",
    ),
    "themeMode": MessageLookupByLibrary.simpleMessage("Режим темы"),
    "tight": MessageLookupByLibrary.simpleMessage("Плотный"),
    "time": MessageLookupByLibrary.simpleMessage("Время"),
    "timeout": MessageLookupByLibrary.simpleMessage("Таймаут"),
    "tip": MessageLookupByLibrary.simpleMessage("подсказка"),
    "toggle": MessageLookupByLibrary.simpleMessage("Переключить"),
    "tonalSpotScheme": MessageLookupByLibrary.simpleMessage("Тональный акцент"),
    "tools": MessageLookupByLibrary.simpleMessage("Инструменты"),
    "tproxyPort": MessageLookupByLibrary.simpleMessage("Tproxy-порт"),
    "trafficUsage": MessageLookupByLibrary.simpleMessage(
      "Использование трафика",
    ),
    "tun": MessageLookupByLibrary.simpleMessage("TUN"),
    "tunDesc": MessageLookupByLibrary.simpleMessage(
      "Включите, чтобы работали Telegram, некоторые игры и приложения (при первом запуске нужен пароль); иначе доступ только у браузеров и подобных приложений",
    ),
    "turnOff": MessageLookupByLibrary.simpleMessage("Выключить"),
    "turnOn": MessageLookupByLibrary.simpleMessage("Включить"),
    "undo": MessageLookupByLibrary.simpleMessage("Отменить"),
    "unifiedDelay": MessageLookupByLibrary.simpleMessage(
      "Унифицированная задержка",
    ),
    "unifiedDelayDesc": MessageLookupByLibrary.simpleMessage(
      "Убрать дополнительные задержки, такие как рукопожатие",
    ),
    "unknown": MessageLookupByLibrary.simpleMessage("Неизвестно"),
    "unknownNetworkError": MessageLookupByLibrary.simpleMessage(
      "Неизвестная сетевая ошибка",
    ),
    "unnamed": MessageLookupByLibrary.simpleMessage("Без имени"),
    "update": MessageLookupByLibrary.simpleMessage("Обновить"),
    "updateSubscription": MessageLookupByLibrary.simpleMessage(
      "Обновить подписку",
    ),
    "upload": MessageLookupByLibrary.simpleMessage("Загрузка"),
    "url": MessageLookupByLibrary.simpleMessage("URL"),
    "urlDesc": MessageLookupByLibrary.simpleMessage(
      "Получить профиль через URL",
    ),
    "urlTip": m18,
    "useHosts": MessageLookupByLibrary.simpleMessage("Использовать hosts"),
    "useSystemHosts": MessageLookupByLibrary.simpleMessage(
      "Использовать системные hosts",
    ),
    "value": MessageLookupByLibrary.simpleMessage("Значение"),
    "vgAboutTagline": MessageLookupByLibrary.simpleMessage(
      "Voguesly · прокси с резидентными IP в США\\nСтабильный доступ к ChatGPT, Claude, OKX и другим глобальным сервисам",
    ),
    "vgAccelerationMode": MessageLookupByLibrary.simpleMessage(
      "Режим ускорения",
    ),
    "vgAccelerationSkipped": MessageLookupByLibrary.simpleMessage(
      "Ускорение пропущено",
    ),
    "vgAccountBalance": MessageLookupByLibrary.simpleMessage("Баланс аккаунта"),
    "vgActionFailedRetry": MessageLookupByLibrary.simpleMessage(
      "Не удалось выполнить действие. Повторите попытку позже.",
    ),
    "vgActivateFailedRetry": MessageLookupByLibrary.simpleMessage(
      "Не удалось активировать, повторите попытку позже",
    ),
    "vgActivateFailedWith": m19,
    "vgActivateFreeTrialNow": MessageLookupByLibrary.simpleMessage(
      "Активировать бесплатный пробный доступ",
    ),
    "vgActivatedImportFailed": MessageLookupByLibrary.simpleMessage(
      "Активировано, но импорт подписки не удался (возможно, кратковременный обрыв сети). Нажмите «Повторить импорт» ниже.",
    ),
    "vgActivatedTapCircle": MessageLookupByLibrary.simpleMessage(
      "✅ Активировано — нажмите центральный круг для подключения",
    ),
    "vgActivatingEllipsis": MessageLookupByLibrary.simpleMessage(
      "Активация...",
    ),
    "vgAlipay": MessageLookupByLibrary.simpleMessage("Alipay"),
    "vgAllEndpointsUnreachable": MessageLookupByLibrary.simpleMessage(
      "Ни одна точка входа недоступна",
    ),
    "vgAllowLoginItemHint": MessageLookupByLibrary.simpleMessage(
      "Разрешите фоновый элемент Voguesly в «Системные настройки → Основные → Объекты входа и расширения»,",
    ),
    "vgAllowLoginItemHint2": MessageLookupByLibrary.simpleMessage(
      "затем вернитесь в Voguesly и снова нажмите TUN — далее пароль не потребуется.",
    ),
    "vgAlreadyBoughtRefresh": MessageLookupByLibrary.simpleMessage(
      "Уже купили? Обновить подписку",
    ),
    "vgAlreadyClaimedBuyStarter": MessageLookupByLibrary.simpleMessage(
      "Уже получали? Купите стартовый пакет за ¥3.9 · 3 ГБ без ограничения по времени",
    ),
    "vgAlreadyHave": MessageLookupByLibrary.simpleMessage("Уже есть"),
    "vgAlreadyHaveAccount": MessageLookupByLibrary.simpleMessage(
      "Уже есть аккаунт?",
    ),
    "vgAndroidOneVpnHint": MessageLookupByLibrary.simpleMessage(
      "Android допускает только один VPN одновременно. При запуске Voguesly система останавливает другой VPN",
    ),
    "vgAndroidOneVpnHint2": MessageLookupByLibrary.simpleMessage(
      "и запрашивает подтверждение — поэтому скрытого конфликта, когда оба считают себя активными, не бывает.",
    ),
    "vgAnnouncements": MessageLookupByLibrary.simpleMessage("Объявления"),
    "vgAnnouncementsSubtitle": MessageLookupByLibrary.simpleMessage(
      "Последние объявления и уведомления об обслуживании",
    ),
    "vgAppFeedbackLogs": MessageLookupByLibrary.simpleMessage(
      "Отзыв о приложении / журналы",
    ),
    "vgAutoSelecting": MessageLookupByLibrary.simpleMessage("Автовыбор…"),
    "vgAvailableCommission": MessageLookupByLibrary.simpleMessage(
      "Доступная комиссия",
    ),
    "vgAvailableCommissionWith": m20,
    "vgBack": MessageLookupByLibrary.simpleMessage("Назад"),
    "vgBaidu": MessageLookupByLibrary.simpleMessage("Baidu"),
    "vgBalance": MessageLookupByLibrary.simpleMessage("Баланс"),
    "vgBiliHkMoTw": MessageLookupByLibrary.simpleMessage(
      "Bilibili (Гонконг/Макао/Тайвань)",
    ),
    "vgBiliMainland": MessageLookupByLibrary.simpleMessage(
      "Bilibili (материковый Китай)",
    ),
    "vgBilibili": MessageLookupByLibrary.simpleMessage("Bilibili"),
    "vgBuyNow": MessageLookupByLibrary.simpleMessage("Купить"),
    "vgBuyNowWith": m21,
    "vgBuyOrRenew": MessageLookupByLibrary.simpleMessage("Купить / продлить"),
    "vgBuyOrRenewPlan": MessageLookupByLibrary.simpleMessage(
      "Купить / продлить тариф",
    ),
    "vgBuyRenewShort": MessageLookupByLibrary.simpleMessage(
      "Купить / продлить",
    ),
    "vgBuyStarterForFullTest": MessageLookupByLibrary.simpleMessage(
      "Купить стартовый пакет для полного теста",
    ),
    "vgBuyStarterPack": MessageLookupByLibrary.simpleMessage(
      "Купить стартовый пакет за ¥3.9",
    ),
    "vgCancel": MessageLookupByLibrary.simpleMessage("Отмена"),
    "vgCancelFailedRetry": MessageLookupByLibrary.simpleMessage(
      "Не удалось отменить, повторите попытку позже",
    ),
    "vgCancelOrder": MessageLookupByLibrary.simpleMessage("Отменить заказ"),
    "vgCancelOrderConfirm": m22,
    "vgCannotOpenBrowser": MessageLookupByLibrary.simpleMessage(
      "Не удалось открыть браузер",
    ),
    "vgCannotOpenSupportManually": MessageLookupByLibrary.simpleMessage(
      "Не удалось открыть поддержку. Откройте страницу поддержки вручную.",
    ),
    "vgChangeFailedCheckOldPassword": MessageLookupByLibrary.simpleMessage(
      "Не удалось изменить (проверьте текущий пароль)",
    ),
    "vgChangePassword": MessageLookupByLibrary.simpleMessage("Сменить пароль"),
    "vgChargingEllipsis": MessageLookupByLibrary.simpleMessage(
      "Списание средств…",
    ),
    "vgCheck": MessageLookupByLibrary.simpleMessage("Проверка"),
    "vgCheckAll": MessageLookupByLibrary.simpleMessage("Проверить всё"),
    "vgCheckFailed": MessageLookupByLibrary.simpleMessage(
      "Проверка не удалась",
    ),
    "vgCheckFailedConnectFirst": MessageLookupByLibrary.simpleMessage(
      "Проверка не удалась. Сначала подключитесь, затем повторите.",
    ),
    "vgCheckForUpdate": MessageLookupByLibrary.simpleMessage(
      "Проверить обновления",
    ),
    "vgCheckItem": MessageLookupByLibrary.simpleMessage("Проверка"),
    "vgCheckingLocalEnv": MessageLookupByLibrary.simpleMessage(
      "Проверка локального окружения…",
    ),
    "vgChooseBillingCycle": MessageLookupByLibrary.simpleMessage(
      "Выберите цикл оплаты",
    ),
    "vgChoosePaymentMethod": MessageLookupByLibrary.simpleMessage(
      "Выберите способ оплаты",
    ),
    "vgCity": MessageLookupByLibrary.simpleMessage("Город"),
    "vgCloseFailedRetry": MessageLookupByLibrary.simpleMessage(
      "Не удалось закрыть, повторите попытку позже",
    ),
    "vgCloseTicket": MessageLookupByLibrary.simpleMessage("Закрыть обращение"),
    "vgCloseTicketConfirm": MessageLookupByLibrary.simpleMessage(
      "После закрытия ответить будет нельзя. Вопрос решён?",
    ),
    "vgCodeSent": MessageLookupByLibrary.simpleMessage(
      "Код подтверждения отправлен",
    ),
    "vgCoexistFine": MessageLookupByLibrary.simpleMessage(
      "Voguesly их не трогает (некоторые могут быть корпоративными туннелями). Пока три пункта выше в порядке, сосуществование не проблема.",
    ),
    "vgCollapse": MessageLookupByLibrary.simpleMessage("Свернуть"),
    "vgCompatModeOnlyProxyAware": MessageLookupByLibrary.simpleMessage(
      "Внимание: режим совместимости охватывает только приложения, использующие системный прокси; Telegram и подобные могут не работать;",
    ),
    "vgCompatModeTakenOver": MessageLookupByLibrary.simpleMessage(
      "Системный прокси (режим совместимости) перехвачен другой программой, поэтому режим совместимости Voguesly сейчас не действует.",
    ),
    "vgConfigParseFailed": MessageLookupByLibrary.simpleMessage(
      "Не удалось разобрать конфигурацию. Обновите подписку или обратитесь в поддержку.",
    ),
    "vgConfirmChange": MessageLookupByLibrary.simpleMessage(
      "Подтвердить изменение",
    ),
    "vgConfirmNewPassword": MessageLookupByLibrary.simpleMessage(
      "Подтвердите новый пароль",
    ),
    "vgConnectTimeoutRetry": MessageLookupByLibrary.simpleMessage(
      "Тайм-аут подключения. Повторите попытку позже.",
    ),
    "vgConnectTimeoutTryAnotherRoute": MessageLookupByLibrary.simpleMessage(
      "Тайм-аут подключения. Проверьте сеть или выберите другой маршрут в разделе «Текущий маршрут».",
    ),
    "vgConnected": MessageLookupByLibrary.simpleMessage("Подключено"),
    "vgContactSupport": MessageLookupByLibrary.simpleMessage(
      "Связаться с поддержкой",
    ),
    "vgContinuePayment": MessageLookupByLibrary.simpleMessage(
      "Продолжить оплату",
    ),
    "vgCopiedSuffix": m23,
    "vgCopy": MessageLookupByLibrary.simpleMessage("Копировать"),
    "vgCopyReferralLink": MessageLookupByLibrary.simpleMessage(
      "Копировать реферальную ссылку",
    ),
    "vgCoreFailedToBindPort": MessageLookupByLibrary.simpleMessage(
      "Ядро Voguesly не смогло занять порт.",
    ),
    "vgCountryRegion": MessageLookupByLibrary.simpleMessage("Страна / регион"),
    "vgCreateAccount": MessageLookupByLibrary.simpleMessage("Создать аккаунт"),
    "vgCreditCard": MessageLookupByLibrary.simpleMessage("Банковская карта"),
    "vgCurrentBalanceWith": m24,
    "vgCurrentPassword": MessageLookupByLibrary.simpleMessage("Текущий пароль"),
    "vgCurrentPlanPrefixWith": m25,
    "vgCurrentPlanWith": m26,
    "vgCurrentRoute": MessageLookupByLibrary.simpleMessage("Текущий маршрут"),
    "vgDailyUsageThisMonth": MessageLookupByLibrary.simpleMessage(
      "Дневное использование за месяц",
    ),
    "vgDataExhaustedRenew": MessageLookupByLibrary.simpleMessage(
      "Трафик исчерпан · продлите тариф",
    ),
    "vgDataUsage": MessageLookupByLibrary.simpleMessage(
      "Использование трафика",
    ),
    "vgDataUsageSubtitle": MessageLookupByLibrary.simpleMessage(
      "Ежедневная статистика трафика",
    ),
    "vgDeviceInfoWith": m27,
    "vgDeviceLimitHint": MessageLookupByLibrary.simpleMessage(
      "если появляется сообщение о превышении лимита, полностью закройте другие клиенты и подключитесь снова",
    ),
    "vgDirectModeSummary": MessageLookupByLibrary.simpleMessage(
      "⚠️ Прямое подключение · без ускорения, трафик не идёт через узел (небезопасно)",
    ),
    "vgDmgOpenedQuitting": MessageLookupByLibrary.simpleMessage(
      "DMG открыт, Voguesly безопасно завершает работу. Перетащите новую версию в Applications, заменив старую.",
    ),
    "vgDomestic": MessageLookupByLibrary.simpleMessage("Внутри страны"),
    "vgDoneOrClose": MessageLookupByLibrary.simpleMessage("Готово / закрыть"),
    "vgDouyin": MessageLookupByLibrary.simpleMessage("Douyin"),
    "vgDownloadFailed": MessageLookupByLibrary.simpleMessage("Ошибка загрузки"),
    "vgDownloadFailedRetry": MessageLookupByLibrary.simpleMessage(
      "Не удалось загрузить, повторите попытку позже",
    ),
    "vgDownloadFailedRetryFull": MessageLookupByLibrary.simpleMessage(
      "Не удалось загрузить, повторите попытку позже",
    ),
    "vgDownloadingUpdate": MessageLookupByLibrary.simpleMessage(
      "Загрузка обновления",
    ),
    "vgDurationWith": m28,
    "vgEmail": MessageLookupByLibrary.simpleMessage("Эл. почта"),
    "vgEmailCode": MessageLookupByLibrary.simpleMessage("Код из письма"),
    "vgEmptyResponseRetry": MessageLookupByLibrary.simpleMessage(
      "Пустой ответ, повторите попытку",
    ),
    "vgEncrypted": MessageLookupByLibrary.simpleMessage("Шифрование"),
    "vgEnterCode": MessageLookupByLibrary.simpleMessage(
      "Введите код подтверждения",
    ),
    "vgEnterCredentials": MessageLookupByLibrary.simpleMessage(
      "Введите свои данные, чтобы продолжить",
    ),
    "vgEnterPassword": MessageLookupByLibrary.simpleMessage("Введите пароль"),
    "vgEnterPayoutAccount": MessageLookupByLibrary.simpleMessage(
      "Укажите счёт для выплаты",
    ),
    "vgEnterValidEmail": MessageLookupByLibrary.simpleMessage(
      "Введите корректный адрес эл. почты",
    ),
    "vgEnterValidEmailFirst": MessageLookupByLibrary.simpleMessage(
      "Сначала введите корректный адрес эл. почты",
    ),
    "vgExit": MessageLookupByLibrary.simpleMessage("Выход"),
    "vgExpandFullText": MessageLookupByLibrary.simpleMessage(
      "Читать полностью",
    ),
    "vgExpiredRenew": MessageLookupByLibrary.simpleMessage(
      "Истёк · продлите тариф",
    ),
    "vgExpiredSuffix": m29,
    "vgExpiryDate": MessageLookupByLibrary.simpleMessage("Дата окончания"),
    "vgFeedbackBodyWith": m30,
    "vgFeedbackHint": MessageLookupByLibrary.simpleMessage(
      "Опишите возникшую проблему. Мы автоматически приложим сведения об устройстве и последние журналы.",
    ),
    "vgFeedbackPlaceholder": MessageLookupByLibrary.simpleMessage(
      "Например: после подключения не открываются страницы / узел не подключается…",
    ),
    "vgFlClashOriginal": MessageLookupByLibrary.simpleMessage(
      "FlClash (оригинал)",
    ),
    "vgForgotPassword": MessageLookupByLibrary.simpleMessage("Забыли пароль?"),
    "vgFreeTrialActivated": MessageLookupByLibrary.simpleMessage(
      "Бесплатный пробный доступ активирован",
    ),
    "vgFreeTrialImportToConnect": MessageLookupByLibrary.simpleMessage(
      "Бесплатный пробный доступ активирован — импортируйте узлы для подключения",
    ),
    "vgFromPrice": m31,
    "vgGlobalAccelDesc1": MessageLookupByLibrary.simpleMessage(
      "Весь трафик идёт по одному выбранному маршруту, без автоматического разделения.",
    ),
    "vgGlobalAccelDesc2": MessageLookupByLibrary.simpleMessage(
      "Если выбрать маршрут дата-центра, проверка IP покажет адрес дата-центра;",
    ),
    "vgGlobalAccelDesc3": MessageLookupByLibrary.simpleMessage(
      "Для резидентного IP выберите резидентный узел в разделе «Маршруты» или используйте умную маршрутизацию.",
    ),
    "vgGlobalAcceleration": MessageLookupByLibrary.simpleMessage(
      "Глобальное ускорение",
    ),
    "vgGlobalModeDialog1": MessageLookupByLibrary.simpleMessage(
      "В глобальном режиме весь трафик идёт по одному маршруту, выбранному в разделе «Маршруты», без разделения по ИИ / банкам /",
    ),
    "vgGlobalModeDialog2": MessageLookupByLibrary.simpleMessage(
      "локальным сайтам.\\n\\n",
    ),
    "vgGlobalModeDialog3": MessageLookupByLibrary.simpleMessage(
      "Если выбран маршрут дата-центра, сайты проверки IP покажут адрес дата-центра. Для резидентного IP США",
    ),
    "vgGlobalModeDialog4": MessageLookupByLibrary.simpleMessage(
      "выберите резидентный узел в разделе «Маршруты» или вернитесь к умной маршрутизации.",
    ),
    "vgGlobalModeSummary": MessageLookupByLibrary.simpleMessage(
      "Глобальный · весь трафик идёт по выбранному маршруту, IP соответствует ему",
    ),
    "vgGoSignIn": MessageLookupByLibrary.simpleMessage("Войти"),
    "vgGoogleSignInFailedNetwork": MessageLookupByLibrary.simpleMessage(
      "Не удалось войти через Google. Проверьте подключение и повторите попытку.",
    ),
    "vgGoogleSignInFailedRetry": MessageLookupByLibrary.simpleMessage(
      "Не удалось войти через Google, повторите попытку",
    ),
    "vgGotIt": MessageLookupByLibrary.simpleMessage("Понятно"),
    "vgHalfYearly": MessageLookupByLibrary.simpleMessage("Раз в полгода"),
    "vgImportPlanNodesStart": MessageLookupByLibrary.simpleMessage(
      "Импортируйте узлы вашего тарифа и начните",
    ),
    "vgInstallPermissionNeeded": MessageLookupByLibrary.simpleMessage(
      "Требуется разрешение на установку",
    ),
    "vgInstallerFileIncomplete": MessageLookupByLibrary.simpleMessage(
      "Файл установщика повреждён",
    ),
    "vgInstallerStartedHint": MessageLookupByLibrary.simpleMessage(
      "Установщик запущен. Следуйте подсказкам — старая версия будет заменена автоматически.",
    ),
    "vgInsufficientBalance": MessageLookupByLibrary.simpleMessage(
      "Недостаточно средств",
    ),
    "vgInternational": MessageLookupByLibrary.simpleMessage("Международные"),
    "vgInvalidAmount": MessageLookupByLibrary.simpleMessage("Неверная сумма"),
    "vgInvited": MessageLookupByLibrary.simpleMessage("Приглашено"),
    "vgIpAddress": MessageLookupByLibrary.simpleMessage("IP-адрес"),
    "vgKeptSystemProxyCarrying": m32,
    "vgLastUpdatedTodayWith": m33,
    "vgLastUpdatedWith": m34,
    "vgLatencyHint": MessageLookupByLibrary.simpleMessage(
      "Внутренние сайты должны идти напрямую (быстро), международные — через узел. Чем ниже, тем лучше.",
    ),
    "vgLatencyTest": MessageLookupByLibrary.simpleMessage("Тест задержки"),
    "vgLikelyAnotherVpnTookRoute": MessageLookupByLibrary.simpleMessage(
      "скорее всего, другой VPN перехватил маршрут по умолчанию.",
    ),
    "vgListening": MessageLookupByLibrary.simpleMessage("Слушает"),
    "vgLiveChat": MessageLookupByLibrary.simpleMessage("Онлайн-чат"),
    "vgLiveChatOpenedInBrowser": MessageLookupByLibrary.simpleMessage(
      "Онлайн-чат открыт в браузере",
    ),
    "vgLiveChatUnavailableUseBrowser": MessageLookupByLibrary.simpleMessage(
      "Онлайн-чат сейчас недоступен — можно открыть его в браузере",
    ),
    "vgLoadFailedPullToRetry": MessageLookupByLibrary.simpleMessage(
      "Не удалось загрузить, потяните вниз для повтора",
    ),
    "vgLoadFailedTapRetry": MessageLookupByLibrary.simpleMessage(
      "Не удалось загрузить · нажмите для повтора",
    ),
    "vgLoadFailedWith": m35,
    "vgLoadFailedWithCode": m36,
    "vgLoadingAccount": MessageLookupByLibrary.simpleMessage(
      "Загрузка аккаунта…",
    ),
    "vgLoadingEllipsis": MessageLookupByLibrary.simpleMessage("Загрузка…"),
    "vgLoadingPlan": MessageLookupByLibrary.simpleMessage("Загрузка тарифа…"),
    "vgLoadingSubscription": MessageLookupByLibrary.simpleMessage(
      "Загрузка подписки…",
    ),
    "vgLocalEnvHint": MessageLookupByLibrary.simpleMessage(
      "Используете другие прокси-приложения? Здесь видно, какой маршрут реально несёт трафик и что чем занято.",
    ),
    "vgLocalEnvOk": MessageLookupByLibrary.simpleMessage(
      "Локальное окружение в порядке.",
    ),
    "vgLocalEnvOkInControl": m37,
    "vgLocalEnvironment": MessageLookupByLibrary.simpleMessage(
      "Локальное окружение",
    ),
    "vgLocalPortHeldSuggestChange": m38,
    "vgLocalPortNum": m39,
    "vgLogOut": MessageLookupByLibrary.simpleMessage("Выйти"),
    "vgMacDnsHintDesc": MessageLookupByLibrary.simpleMessage(
      "DNS Voguesly добавляется временно только при работе TUN на macOS и восстанавливается при отключении или выходе; режим системного прокси DNS не меняет",
    ),
    "vgManageBalanceAndPlan": MessageLookupByLibrary.simpleMessage(
      "Управление балансом и тарифами",
    ),
    "vgManageSubscription": MessageLookupByLibrary.simpleMessage(
      "Управление подпиской",
    ),
    "vgMe": MessageLookupByLibrary.simpleMessage("Я"),
    "vgMihomoCore": MessageLookupByLibrary.simpleMessage("Ядро mihomo"),
    "vgMonthly": MessageLookupByLibrary.simpleMessage("Ежемесячно"),
    "vgMyOrders": MessageLookupByLibrary.simpleMessage("Мои заказы"),
    "vgMyReferralCode": MessageLookupByLibrary.simpleMessage(
      "Мой реферальный код",
    ),
    "vgMySubscription": MessageLookupByLibrary.simpleMessage("Моя подписка"),
    "vgMyTickets": MessageLookupByLibrary.simpleMessage("Мои обращения"),
    "vgMyTicketsSubtitle": MessageLookupByLibrary.simpleMessage(
      "Читайте ответы поддержки и продолжайте диалог",
    ),
    "vgNBillingCycles": m40,
    "vgNDays": m41,
    "vgNMonths": m42,
    "vgNPeople": m43,
    "vgNYears": m44,
    "vgNeedUnknownSourcesPermission": MessageLookupByLibrary.simpleMessage(
      "Для установки обновления нужно разрешение «установка неизвестных приложений». Выдайте его в настройках и вернитесь — установка продолжится автоматически.",
    ),
    "vgNetUnstableRetry": MessageLookupByLibrary.simpleMessage(
      "Сеть нестабильна. Проверьте подключение и повторите попытку.",
    ),
    "vgNetworkErrorWith": m45,
    "vgNetworkSkippedDirect": MessageLookupByLibrary.simpleMessage(
      "На этой сети ускорение пропущено · прямое подключение",
    ),
    "vgNetworkUnavailableRetry": MessageLookupByLibrary.simpleMessage(
      "Сеть недоступна. Проверьте подключение и повторите попытку.",
    ),
    "vgNetworkUnstableNoPlanInfo": MessageLookupByLibrary.simpleMessage(
      "Сеть нестабильна, сведения о тарифе временно недоступны",
    ),
    "vgNetworkUnstableTapRetry": MessageLookupByLibrary.simpleMessage(
      "Сеть нестабильна — нажмите для повтора",
    ),
    "vgNewPasswordMin8": MessageLookupByLibrary.simpleMessage(
      "Новый пароль (не менее 8 символов)",
    ),
    "vgNewPasswordTooShort": MessageLookupByLibrary.simpleMessage(
      "Новый пароль должен содержать не менее 8 символов",
    ),
    "vgNewVersionAvailable": m46,
    "vgNoAccountYet": MessageLookupByLibrary.simpleMessage("Ещё нет аккаунта?"),
    "vgNoAnnouncements": MessageLookupByLibrary.simpleMessage("Объявлений нет"),
    "vgNoExpiry": MessageLookupByLibrary.simpleMessage("Бессрочно"),
    "vgNoMessages": MessageLookupByLibrary.simpleMessage("Сообщений нет"),
    "vgNoOrders": MessageLookupByLibrary.simpleMessage("Заказов пока нет"),
    "vgNoOtherProxyDetected": MessageLookupByLibrary.simpleMessage(
      "Другие прокси-приложения не обнаружены",
    ),
    "vgNoPathCarryingTraffic": MessageLookupByLibrary.simpleMessage(
      "Сейчас ни один маршрут не несёт трафик, скорее всего интернета нет. Попробуйте переподключиться.",
    ),
    "vgNoPlan": MessageLookupByLibrary.simpleMessage("Тарифа пока нет"),
    "vgNoPlansAvailable": MessageLookupByLibrary.simpleMessage(
      "Нет доступных тарифов или проблема с сетью. Потяните вниз для повтора.",
    ),
    "vgNoRouteSelected": MessageLookupByLibrary.simpleMessage(
      "Не выбрано · выберите маршрут",
    ),
    "vgNoSubscriptionImported": MessageLookupByLibrary.simpleMessage(
      "Подписка не импортирована · откройте страницу управления для импорта",
    ),
    "vgNoTicketsHint": MessageLookupByLibrary.simpleMessage(
      "Обращений пока нет\\nЕсли возникла проблема, отправьте её через «Сообщить о проблеме / отправить журналы»",
    ),
    "vgNoUsageThisMonth": MessageLookupByLibrary.simpleMessage(
      "Нет записей об использовании в этом месяце",
    ),
    "vgNotChecked": MessageLookupByLibrary.simpleMessage("Не проверено"),
    "vgNotConnectedTapCircle": MessageLookupByLibrary.simpleMessage(
      "Voguesly не подключён. Сначала нажмите большой круг на главном экране, затем вернитесь к проверке.",
    ),
    "vgNotEnabled": MessageLookupByLibrary.simpleMessage("Выключено"),
    "vgNotInControl": MessageLookupByLibrary.simpleMessage("Не управляет"),
    "vgNotListening": MessageLookupByLibrary.simpleMessage("Не слушает"),
    "vgNotSignedIn": MessageLookupByLibrary.simpleMessage("Вы не вошли"),
    "vgNotSignedInPleaseSignIn": MessageLookupByLibrary.simpleMessage(
      "Вы не вошли — сначала выполните вход",
    ),
    "vgOauthSuccessHtmlBody": MessageLookupByLibrary.simpleMessage(
      "<p style=\"opacity:.7;margin:0\">Вернитесь в приложение Voguesly, чтобы продолжить</p></div>",
    ),
    "vgOauthSuccessHtmlHead": MessageLookupByLibrary.simpleMessage(
      "<div><h2 style=\"margin:0 0 8px;font-weight:600\">Вход выполнен</h2>",
    ),
    "vgOfficialSite": MessageLookupByLibrary.simpleMessage("Сайт"),
    "vgOneTapTrialInApp": MessageLookupByLibrary.simpleMessage(
      "Пробный доступ в одно касание",
    ),
    "vgOneTime": MessageLookupByLibrary.simpleMessage("Разовый"),
    "vgOneYear": MessageLookupByLibrary.simpleMessage("1 год"),
    "vgOnlineButChecksAffected": MessageLookupByLibrary.simpleMessage(
      "Интернет работает; функции проверки могут быть затронуты занятым портом.",
    ),
    "vgOnlinePayment": MessageLookupByLibrary.simpleMessage("Онлайн-оплата"),
    "vgOnlineViaTunProxyTaken": MessageLookupByLibrary.simpleMessage(
      "Интернет работает — Voguesly использует виртуальный адаптер. Системный прокси занят другим приложением, но на вас это не влияет.",
    ),
    "vgOpenPayment": MessageLookupByLibrary.simpleMessage("Открыть оплату"),
    "vgOpenSettingsToGrant": MessageLookupByLibrary.simpleMessage(
      "Открыть настройки и выдать",
    ),
    "vgOpenSupportFailedRetry": MessageLookupByLibrary.simpleMessage(
      "Не удалось открыть поддержку, повторите попытку позже",
    ),
    "vgOpenSupportInBrowser": MessageLookupByLibrary.simpleMessage(
      "Открыть поддержку в браузере",
    ),
    "vgOpenSystemSettings": MessageLookupByLibrary.simpleMessage(
      "Открыть системные настройки",
    ),
    "vgOpeningInstaller": MessageLookupByLibrary.simpleMessage(
      "Запуск установщика…",
    ),
    "vgOr": MessageLookupByLibrary.simpleMessage("или"),
    "vgOrderActivating": MessageLookupByLibrary.simpleMessage("Активируется"),
    "vgOrderCancelled": MessageLookupByLibrary.simpleMessage("Отменён"),
    "vgOrderCancelledToast": MessageLookupByLibrary.simpleMessage(
      "Заказ отменён",
    ),
    "vgOrderCompleted": MessageLookupByLibrary.simpleMessage("Завершён"),
    "vgOrderFailed": MessageLookupByLibrary.simpleMessage(
      "Не удалось оформить заказ",
    ),
    "vgOrderFailedRetry": MessageLookupByLibrary.simpleMessage(
      "Не удалось оформить заказ, повторите попытку позже",
    ),
    "vgOrderFailedWith": m47,
    "vgOrderNoWith": m48,
    "vgOrderPendingPayment": MessageLookupByLibrary.simpleMessage(
      "Ожидает оплаты",
    ),
    "vgOrderRefunded": MessageLookupByLibrary.simpleMessage("Возвращён"),
    "vgOriginalsOnly": MessageLookupByLibrary.simpleMessage("Только оригиналы"),
    "vgOtherProxyRunningCloseFirst": m49,
    "vgOtherProxyRunningSkipTun": m50,
    "vgPassword": MessageLookupByLibrary.simpleMessage("Пароль"),
    "vgPasswordChanged": MessageLookupByLibrary.simpleMessage("Пароль изменён"),
    "vgPasswordsDoNotMatch": MessageLookupByLibrary.simpleMessage(
      "Новые пароли не совпадают",
    ),
    "vgPayHereOrScanHint": MessageLookupByLibrary.simpleMessage(
      "Нажмите «Открыть оплату» ниже, чтобы оплатить на этом устройстве,\\nили отсканируйте с другого. Зачисление произойдёт автоматически.",
    ),
    "vgPayWithBalance": MessageLookupByLibrary.simpleMessage(
      "Оплатить с баланса",
    ),
    "vgPaymentOpenedInBrowserHint": MessageLookupByLibrary.simpleMessage(
      "Страница оплаты открыта в браузере.\\nСтраница обновится автоматически после оплаты.",
    ),
    "vgPaymentStartFailed": MessageLookupByLibrary.simpleMessage(
      "Не удалось начать оплату",
    ),
    "vgPaymentStartFailedWith": m51,
    "vgPaymentSuccessActivated": MessageLookupByLibrary.simpleMessage(
      "Оплата прошла, тариф активирован",
    ),
    "vgPayoutAccount": MessageLookupByLibrary.simpleMessage("Счёт для выплаты"),
    "vgPkgOpenedQuitting": MessageLookupByLibrary.simpleMessage(
      "Установщик PKG открыт, Voguesly безопасно завершает работу. Подтвердите запросы системы; установщик заменит старую версию в Applications.",
    ),
    "vgPlacingOrder": MessageLookupByLibrary.simpleMessage("Оформляем заказ…"),
    "vgPlan": MessageLookupByLibrary.simpleMessage("Тариф"),
    "vgPlanDeviceLimitWith": m52,
    "vgPlatformNoLocalDiag": MessageLookupByLibrary.simpleMessage(
      "Диагностика локального окружения не поддерживается на этой платформе.",
    ),
    "vgPointsToVogueslyWith": m53,
    "vgPortHeldByOther": m54,
    "vgPortHeldByOther2": MessageLookupByLibrary.simpleMessage(
      "который сложнее всего диагностировать. Выберите свободный порт в «Настройки → Сеть».",
    ),
    "vgPortMaybeTakenAndroid": MessageLookupByLibrary.simpleMessage(
      "Порт может быть занят другим прокси-приложением. На Android это не влияет на доступ в интернет (Voguesly использует VPN-туннель),",
    ),
    "vgPortMaybeTakenAndroid2": MessageLookupByLibrary.simpleMessage(
      "но проверки разблокировки и задержки на этой странице ничего не смогут измерить.",
    ),
    "vgPreparingInstall": MessageLookupByLibrary.simpleMessage(
      "Подготовка к установке…",
    ),
    "vgPublicTrafficOnOtherTun": m55,
    "vgPublicTrafficOnOurTun": MessageLookupByLibrary.simpleMessage(
      "Внешний трафик идёт через виртуальный адаптер Voguesly. Это основной путь, системный прокси не задействован.",
    ),
    "vgPurchaseSuccessActivated": MessageLookupByLibrary.simpleMessage(
      "Покупка завершена, тариф активирован",
    ),
    "vgQuarterly": MessageLookupByLibrary.simpleMessage("Ежеквартально"),
    "vgQuitOtherProxyToTakeOver": MessageLookupByLibrary.simpleMessage(
      "Чтобы системным прокси управлял Voguesly, закройте другую программу-прокси и подключитесь заново.",
    ),
    "vgRecentLogsHeader": MessageLookupByLibrary.simpleMessage(
      "--- последние журналы ---",
    ),
    "vgRecheck": MessageLookupByLibrary.simpleMessage("Проверить снова"),
    "vgReferralCode": MessageLookupByLibrary.simpleMessage("Реферальный код"),
    "vgReferralCodeDiscount": MessageLookupByLibrary.simpleMessage(
      "Регистрация с реферальным кодом даёт скидку",
    ),
    "vgReferralCodeOptional": MessageLookupByLibrary.simpleMessage(
      "Реферальный код (необязательно)",
    ),
    "vgReferralExplain": MessageLookupByLibrary.simpleMessage(
      "Когда друг регистрируется по вашей ссылке и покупает тариф, вы получаете комиссию. Её можно потратить на продление.",
    ),
    "vgReferralLink": MessageLookupByLibrary.simpleMessage(
      "Реферальная ссылка",
    ),
    "vgReferralRewards": MessageLookupByLibrary.simpleMessage(
      "Реферальные вознаграждения",
    ),
    "vgReferralSubtitle": MessageLookupByLibrary.simpleMessage(
      "Приглашайте друзей, смотрите комиссию, выводите средства",
    ),
    "vgRefetchPlanAndTrial": MessageLookupByLibrary.simpleMessage(
      "Повторно получить тариф и право на пробный доступ",
    ),
    "vgRefresh": MessageLookupByLibrary.simpleMessage("Обновить"),
    "vgRegionBlocked": MessageLookupByLibrary.simpleMessage(
      "Регион заблокирован",
    ),
    "vgRegionNotSupported": MessageLookupByLibrary.simpleMessage(
      "Недоступно в этом регионе",
    ),
    "vgRegionRestricted": MessageLookupByLibrary.simpleMessage(
      "Региональные ограничения",
    ),
    "vgRemainingData": MessageLookupByLibrary.simpleMessage("Осталось трафика"),
    "vgRememberMe": MessageLookupByLibrary.simpleMessage("Запомнить меня"),
    "vgReopenPayment": MessageLookupByLibrary.simpleMessage(
      "Открыть оплату заново",
    ),
    "vgReopenTunAfterPermission": MessageLookupByLibrary.simpleMessage(
      "После исправления разрешений включите «Виртуальный адаптер (весь трафик)» на панели заново.",
    ),
    "vgReplyToSupport": MessageLookupByLibrary.simpleMessage(
      "Ответить поддержке…",
    ),
    "vgReportIssueSubtitle": MessageLookupByLibrary.simpleMessage(
      "Отправьте журналы в поддержку одним нажатием, чтобы быстрее найти причину",
    ),
    "vgReportIssueUploadLogs": MessageLookupByLibrary.simpleMessage(
      "Сообщить о проблеме / отправить журналы",
    ),
    "vgReset": MessageLookupByLibrary.simpleMessage("Сбросить"),
    "vgResetFailed": MessageLookupByLibrary.simpleMessage(
      "Не удалось сбросить",
    ),
    "vgResetProxyHint": MessageLookupByLibrary.simpleMessage(
      "Это перезапишет только собственные настройки Voguesly. Другие прокси-приложения не будут закрыты или изменены.",
    ),
    "vgResetSubscription": MessageLookupByLibrary.simpleMessage(
      "Сбросить подписку",
    ),
    "vgResetSubscriptionConfirm": MessageLookupByLibrary.simpleMessage(
      "Старая ссылка подписки перестанет работать сразу. Всё, что уже экспортировано в другие клиенты, придётся импортировать заново. Сбросить?",
    ),
    "vgResetVogueslySystemProxy": MessageLookupByLibrary.simpleMessage(
      "Сбросить системный прокси Voguesly",
    ),
    "vgResidentialIpProfile": MessageLookupByLibrary.simpleMessage(
      "Voguesly Residential IP",
    ),
    "vgRetry": MessageLookupByLibrary.simpleMessage("Повторить"),
    "vgRetryImportSubscription": MessageLookupByLibrary.simpleMessage(
      "Повторить импорт подписки",
    ),
    "vgRouteTableSeesOurTun": MessageLookupByLibrary.simpleMessage(
      "В таблице маршрутизации виден виртуальный адаптер Voguesly. Это основной путь, системный прокси не задействован.",
    ),
    "vgRuleModeSummary": MessageLookupByLibrary.simpleMessage(
      "Умная маршрутизация · ИИ и банки через резидентные IP, локальные сайты напрямую (рекомендуется)",
    ),
    "vgRunningAlongside": MessageLookupByLibrary.simpleMessage(
      "Работают одновременно",
    ),
    "vgRunningFromDmgHint": MessageLookupByLibrary.simpleMessage(
      "Voguesly запущен прямо из образа DMG. Сначала перетащите Voguesly в Applications,",
    ),
    "vgRunningFromDmgHint2": MessageLookupByLibrary.simpleMessage(
      "затем откройте его оттуда — при запуске из DMG фоновая служба TUN не работает.",
    ),
    "vgScanToPay": MessageLookupByLibrary.simpleMessage("Оплата по QR-коду"),
    "vgScanWithPhoneHint": MessageLookupByLibrary.simpleMessage(
      "Отсканируйте код в Alipay или WeChat на телефоне.\\nСтраница обновится автоматически после оплаты.",
    ),
    "vgSend": MessageLookupByLibrary.simpleMessage("Отправить"),
    "vgSendFailedRetry": MessageLookupByLibrary.simpleMessage(
      "Не удалось отправить, повторите попытку позже",
    ),
    "vgSendFailedRetryComma": MessageLookupByLibrary.simpleMessage(
      "Не удалось отправить, повторите попытку позже",
    ),
    "vgSendFailedWith": m56,
    "vgSent": MessageLookupByLibrary.simpleMessage("Отправлено"),
    "vgSessionExpiredSignInAgain": MessageLookupByLibrary.simpleMessage(
      "Сессия истекла. Войдите снова.",
    ),
    "vgShadowrocket": MessageLookupByLibrary.simpleMessage("Shadowrocket"),
    "vgSignIn": MessageLookupByLibrary.simpleMessage("Войти"),
    "vgSignInAccount": MessageLookupByLibrary.simpleMessage("Вход в аккаунт"),
    "vgSignInBeforeFeedback": MessageLookupByLibrary.simpleMessage(
      "Войдите, прежде чем отправлять отзыв",
    ),
    "vgSignInFailed": MessageLookupByLibrary.simpleMessage("Не удалось войти"),
    "vgSignInWithGoogle": MessageLookupByLibrary.simpleMessage(
      "Войти через Google",
    ),
    "vgSignOut": MessageLookupByLibrary.simpleMessage("Выйти"),
    "vgSignOutAccount": MessageLookupByLibrary.simpleMessage(
      "Выйти из аккаунта",
    ),
    "vgSignOutAccountConfirm": MessageLookupByLibrary.simpleMessage(
      "Выйти из этого аккаунта? Потребуется войти заново.",
    ),
    "vgSignOutConfirm": MessageLookupByLibrary.simpleMessage(
      "Выйти из этого аккаунта?",
    ),
    "vgSignOutConfirmShort": MessageLookupByLibrary.simpleMessage(
      "Выйти из этого аккаунта?",
    ),
    "vgSignUp": MessageLookupByLibrary.simpleMessage("Регистрация"),
    "vgSignUpAutoConnect": MessageLookupByLibrary.simpleMessage(
      "Зарегистрируйтесь — подключение произойдёт автоматически",
    ),
    "vgSignUpFailed": MessageLookupByLibrary.simpleMessage(
      "Не удалось зарегистрироваться",
    ),
    "vgSignUpWithGoogle": MessageLookupByLibrary.simpleMessage(
      "Зарегистрироваться через Google",
    ),
    "vgSignedInLoadingPlan": MessageLookupByLibrary.simpleMessage(
      "Вы вошли · загружаем тариф…",
    ),
    "vgSixDigitCode": MessageLookupByLibrary.simpleMessage("6-значный код"),
    "vgSmartRoutingDesc1": MessageLookupByLibrary.simpleMessage(
      "ИИ, банки и платежи автоматически используют резидентный IP США; локальные сайты идут напрямую для скорости,",
    ),
    "vgSmartRoutingDesc2": MessageLookupByLibrary.simpleMessage(
      "а стриминг и загрузки идут через дата-центры, экономя резидентный трафик. Проверка IP покажет резидентный адрес.",
    ),
    "vgSmartRoutingRecommended": MessageLookupByLibrary.simpleMessage(
      "Умная маршрутизация (рекомендуется)",
    ),
    "vgSomethingWentWrongRetry": MessageLookupByLibrary.simpleMessage(
      "Произошла ошибка, повторите попытку позже",
    ),
    "vgSpeedLimitNMbps": m57,
    "vgSplitRouteHint": MessageLookupByLibrary.simpleMessage(
      "Международные сервисы выходят за рубеж, локальные остаются внутри — умная маршрутизация проверяется в реальном времени.",
    ),
    "vgSplitRouteTest": MessageLookupByLibrary.simpleMessage(
      "Тест разделения маршрутов",
    ),
    "vgStartYourTest": MessageLookupByLibrary.simpleMessage("Начните тест"),
    "vgStarterPackSpecs": MessageLookupByLibrary.simpleMessage(
      "3 ГБ без ограничения по времени — достаточно для полной проверки ChatGPT, Claude и подобных сервисов",
    ),
    "vgStarting": MessageLookupByLibrary.simpleMessage("Запуск"),
    "vgStartingPaymentEllipsis": MessageLookupByLibrary.simpleMessage(
      "Начинаем оплату…",
    ),
    "vgStore": MessageLookupByLibrary.simpleMessage("Магазин"),
    "vgSubmit": MessageLookupByLibrary.simpleMessage("Отправить"),
    "vgSubmitFailedRetry": MessageLookupByLibrary.simpleMessage(
      "Не удалось отправить, повторите попытку позже",
    ),
    "vgSubmitFailedWith": m58,
    "vgSubmitToSupport": MessageLookupByLibrary.simpleMessage(
      "Отправить в поддержку",
    ),
    "vgSubmittedSupportWillFollowUp": MessageLookupByLibrary.simpleMessage(
      "Отправлено. Поддержка свяжется с вами в ближайшее время.",
    ),
    "vgSubmitting": MessageLookupByLibrary.simpleMessage("Отправка…"),
    "vgSubscribeNow": MessageLookupByLibrary.simpleMessage(
      "Подписаться сейчас",
    ),
    "vgSubscriptionImportFailedRetry": MessageLookupByLibrary.simpleMessage(
      "Импорт подписки не удался, повторите попытку позже.",
    ),
    "vgSubscriptionResetFetching": MessageLookupByLibrary.simpleMessage(
      "Подписка сброшена. Загружаем новые узлы…",
    ),
    "vgSubscriptionUpdated": MessageLookupByLibrary.simpleMessage(
      "Подписка обновлена",
    ),
    "vgSupport": MessageLookupByLibrary.simpleMessage("Поддержка"),
    "vgSwitchedToGlobal": MessageLookupByLibrary.simpleMessage(
      "Переключено на глобальное ускорение",
    ),
    "vgSystemProxy": MessageLookupByLibrary.simpleMessage("Системный прокси"),
    "vgSystemProxyCompat": m59,
    "vgSystemProxyCompatDesc": MessageLookupByLibrary.simpleMessage(
      "Охватывает только приложения с поддержкой системного прокси; Telegram и подобным может понадобиться TUN",
    ),
    "vgSystemProxyOccupied": MessageLookupByLibrary.simpleMessage(
      "Системный прокси не смог перехватить трафик — возможно, он занят другой программой. Закройте её и повторите попытку.",
    ),
    "vgSystemProxySingleSlot": m60,
    "vgTakenByOtherAppWith": m61,
    "vgTakenByOtherProcessWith": m62,
    "vgTaobao": MessageLookupByLibrary.simpleMessage("Taobao"),
    "vgTapBelowToFetchNodes": MessageLookupByLibrary.simpleMessage(
      "Нажмите кнопку ниже, чтобы получить актуальные узлы",
    ),
    "vgTapToActivate": MessageLookupByLibrary.simpleMessage(
      "Нажмите, чтобы активировать",
    ),
    "vgTapToConnect": MessageLookupByLibrary.simpleMessage(
      "Нажмите для подключения",
    ),
    "vgTapToDisconnectWith": m63,
    "vgTelegramSupport": MessageLookupByLibrary.simpleMessage(
      "Поддержка в Telegram",
    ),
    "vgTempEnabledSystemProxy": m64,
    "vgTesting": MessageLookupByLibrary.simpleMessage("Тестирование…"),
    "vgThreeYearly": MessageLookupByLibrary.simpleMessage("Раз в 3 года"),
    "vgTicketAwaitingReply": MessageLookupByLibrary.simpleMessage(
      "Ожидает ответа",
    ),
    "vgTicketClosed": MessageLookupByLibrary.simpleMessage("Закрыто"),
    "vgTicketIsClosed": MessageLookupByLibrary.simpleMessage(
      "Обращение закрыто",
    ),
    "vgTicketNumber": m65,
    "vgTicketSupportReplied": MessageLookupByLibrary.simpleMessage(
      "Поддержка ответила",
    ),
    "vgTimeout": MessageLookupByLibrary.simpleMessage("Тайм-аут"),
    "vgTotal": MessageLookupByLibrary.simpleMessage("Итого"),
    "vgTotalDownload": MessageLookupByLibrary.simpleMessage("Всего получено"),
    "vgTotalUpload": MessageLookupByLibrary.simpleMessage("Всего отправлено"),
    "vgTrafficNGb": m66,
    "vgTrafficStillOnTun": MessageLookupByLibrary.simpleMessage(
      "Трафик по-прежнему идёт через виртуальный адаптер Voguesly, доступ в интернет не нарушен;",
    ),
    "vgTransfer": MessageLookupByLibrary.simpleMessage("Перевести"),
    "vgTransferAmountYuan": MessageLookupByLibrary.simpleMessage(
      "Сумма перевода (CNY)",
    ),
    "vgTransferFailed": MessageLookupByLibrary.simpleMessage(
      "Не удалось перевести",
    ),
    "vgTransferToBalance": MessageLookupByLibrary.simpleMessage(
      "Перевести на баланс",
    ),
    "vgTransferredToBalance": MessageLookupByLibrary.simpleMessage(
      "Переведено на баланс",
    ),
    "vgTrialSpecs": MessageLookupByLibrary.simpleMessage(
      "6 часов / 500 МБ — для быстрой проверки подключения",
    ),
    "vgTryFreeOrBuyStarter": MessageLookupByLibrary.simpleMessage(
      "Попробуйте бесплатно или купите стартовый пакет для полного теста",
    ),
    "vgTunAlsoNotInControlNote": MessageLookupByLibrary.simpleMessage(
      "Виртуальный адаптер тоже не управляет трафиком, поэтому интернета сейчас может действительно не быть.",
    ),
    "vgTunDeviceWide": m67,
    "vgTunDeviceWideDesc": MessageLookupByLibrary.simpleMessage(
      "Перехватывает трафик всего устройства; другие VPN должны быть выключены, требуется разрешение системы",
    ),
    "vgTunNotAuthorized": MessageLookupByLibrary.simpleMessage(
      "TUN не авторизован, перехват трафика всего устройства пока невозможен.",
    ),
    "vgTunOffUsingCompatMode": MessageLookupByLibrary.simpleMessage(
      "Виртуальный адаптер выключен; сейчас используется режим совместимости системного прокси.",
    ),
    "vgTunOnButNoUtun": MessageLookupByLibrary.simpleMessage(
      "В настройках виртуальный адаптер включён, но внешний трафик не идёт через utun. Возможно, авторизация не завершена.",
    ),
    "vgTunOnButNotInRouteTable": MessageLookupByLibrary.simpleMessage(
      "В настройках виртуальный адаптер включён, но его нет в таблице маршрутизации. Возможно, фоновая служба не установлена.",
    ),
    "vgTunPlusSystemProxy": MessageLookupByLibrary.simpleMessage(
      "TUN + системный прокси",
    ),
    "vgTunServiceNeedsReauth": MessageLookupByLibrary.simpleMessage(
      "Фоновой службе TUN Voguesly требуется повторная авторизация. В «Системные настройки → Основные → Объекты входа и расширения»",
    ),
    "vgTunServiceNeedsReauth2": MessageLookupByLibrary.simpleMessage(
      "разрешите фоновый элемент Voguesly, затем вернитесь и снова нажмите «Подключить».",
    ),
    "vgTunServiceNotEnabled": MessageLookupByLibrary.simpleMessage(
      "Фоновая служба TUN для Voguesly не включена. Разрешите фоновый элемент в системных настройках и повторите попытку.",
    ),
    "vgTunTwiceNoTakeover": MessageLookupByLibrary.simpleMessage(
      "TUN дважды запускался, но не перехватил системный трафик.",
    ),
    "vgTunUnaffectedNote": MessageLookupByLibrary.simpleMessage(
      "Доступ в интернет **не нарушен**, так как Voguesly использует виртуальный адаптер.",
    ),
    "vgTurnOnVoguesly": MessageLookupByLibrary.simpleMessage(
      "Включить Voguesly",
    ),
    "vgTwoYearly": MessageLookupByLibrary.simpleMessage("Раз в 2 года"),
    "vgUnknown": MessageLookupByLibrary.simpleMessage("Неизвестно"),
    "vgUnlockCheck": MessageLookupByLibrary.simpleMessage(
      "Проверка разблокировки",
    ),
    "vgUpdateCheckNetworkError": MessageLookupByLibrary.simpleMessage(
      "Ошибка сети: не удалось проверить обновления. Проверьте подключение и повторите попытку.",
    ),
    "vgUpdateFailedRetry": MessageLookupByLibrary.simpleMessage(
      "Не удалось обновить, повторите попытку позже",
    ),
    "vgUpdateSubscription": MessageLookupByLibrary.simpleMessage(
      "Обновить подписку",
    ),
    "vgUpdateSubscriptionFailed": MessageLookupByLibrary.simpleMessage(
      "Не удалось обновить подписку, повторите попытку позже",
    ),
    "vgUpdating": MessageLookupByLibrary.simpleMessage("Обновление…"),
    "vgUserCenter": MessageLookupByLibrary.simpleMessage("Личный кабинет"),
    "vgUserCenterSubtitle": MessageLookupByLibrary.simpleMessage(
      "Баланс, заказы, сброс подписки, смена пароля",
    ),
    "vgV2RayFamilyClient": MessageLookupByLibrary.simpleMessage(
      "Клиент семейства V2Ray",
    ),
    "vgVersionBuildWith": m68,
    "vgVersionLabel": MessageLookupByLibrary.simpleMessage("Версия"),
    "vgVersionNumber": m69,
    "vgVersionTapToCheck": m70,
    "vgViewLogs": MessageLookupByLibrary.simpleMessage("Просмотр журналов"),
    "vgViewLogsSubtitle": MessageLookupByLibrary.simpleMessage(
      "Журналы подключения в реальном времени, для диагностики",
    ),
    "vgViewOrdersResumePayment": MessageLookupByLibrary.simpleMessage(
      "Просмотр заказов · продолжить незавершённую оплату",
    ),
    "vgVirtualNic": MessageLookupByLibrary.simpleMessage("виртуальный адаптер"),
    "vgVirtualNicTun": MessageLookupByLibrary.simpleMessage(
      "Виртуальный адаптер (TUN)",
    ),
    "vgVirtualNicVpn": MessageLookupByLibrary.simpleMessage(
      "Виртуальный адаптер (VPN)",
    ),
    "vgVogueslyInControl": MessageLookupByLibrary.simpleMessage(
      "Управляет Voguesly",
    ),
    "vgVogueslyInControlWith": m71,
    "vgVogueslyListening": MessageLookupByLibrary.simpleMessage(
      "Voguesly слушает",
    ),
    "vgVpnCouldNotConnect": MessageLookupByLibrary.simpleMessage(
      "Не удалось установить VPN (доступ запрещён или ограничение системы). Подключитесь заново.",
    ),
    "vgWaitingForPayment": MessageLookupByLibrary.simpleMessage(
      "Ожидание оплаты",
    ),
    "vgWeChat": MessageLookupByLibrary.simpleMessage("WeChat"),
    "vgWebViewInitFailed": m72,
    "vgWithdraw": MessageLookupByLibrary.simpleMessage("Вывести"),
    "vgWithdrawFailed": MessageLookupByLibrary.simpleMessage(
      "Не удалось вывести средства",
    ),
    "vgWithdrawMethod": MessageLookupByLibrary.simpleMessage(
      "Способ вывода (Alipay / WeChat / USDT)",
    ),
    "vgWithdrawRequest": MessageLookupByLibrary.simpleMessage(
      "Заявка на вывод",
    ),
    "vgWithdrawSubmitted": MessageLookupByLibrary.simpleMessage(
      "Заявка на вывод отправлена. Поддержка обработает её в ближайшее время.",
    ),
    "vgWrongEmailOrPassword": MessageLookupByLibrary.simpleMessage(
      "Неверный адрес эл. почты или пароль",
    ),
    "vgYearly": MessageLookupByLibrary.simpleMessage("Ежегодно"),
    "vgYouAlreadyHavePlan": MessageLookupByLibrary.simpleMessage(
      "У вас уже есть тариф",
    ),
    "vibrantScheme": MessageLookupByLibrary.simpleMessage("Яркие"),
    "view": MessageLookupByLibrary.simpleMessage("Просмотр"),
    "vogChooseAvatar": MessageLookupByLibrary.simpleMessage("Choose avatar"),
    "vogExpiry": MessageLookupByLibrary.simpleMessage("Expires"),
    "vogMyAccount": MessageLookupByLibrary.simpleMessage("My account"),
    "vogNotLoggedIn": MessageLookupByLibrary.simpleMessage("Not logged in"),
    "vogPermanent": MessageLookupByLibrary.simpleMessage("Permanent"),
    "vogRemainTotal": MessageLookupByLibrary.simpleMessage("Left / total"),
    "vpnConfigChangeDetected": MessageLookupByLibrary.simpleMessage(
      "Обнаружено изменение конфигурации VPN",
    ),
    "vpnEnableDesc": MessageLookupByLibrary.simpleMessage(
      "Автоматически направляет весь системный трафик через VpnService",
    ),
    "vpnTip": MessageLookupByLibrary.simpleMessage(
      "Изменения вступят в силу после перезапуска VPN",
    ),
    "webDAVConfiguration": MessageLookupByLibrary.simpleMessage(
      "Конфигурация WebDAV",
    ),
    "whitelistMode": MessageLookupByLibrary.simpleMessage(
      "Режим белого списка",
    ),
    "yearsAgo": m73,
    "zh_CN": MessageLookupByLibrary.simpleMessage("Упрощенный китайский"),
  };
}
