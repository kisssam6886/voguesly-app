import 'package:fl_clash/l10n/l10n.dart';

// ⚠️ 必须係 getter,唔可以係 top-level final:
// final 只会喺第一次读取时初始化一次,用户之后切语言,
// 所有唔经 context 攞文案嘅地方(通知、托盘、SnackBar、诊断页)会永远停喺旧语言。
AppLocalizations get currentAppLocalizations => AppLocalizations.current;
