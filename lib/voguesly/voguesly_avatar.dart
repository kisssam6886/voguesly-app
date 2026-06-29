import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 可选现代渐变头像(bundle 喺 assets/images/avatar/，唔靠网络)。
const List<String> vogueslyAvatars = [
  'a1', 'a2', 'a3', 'a4', 'a5', 'a6', 'a7', 'a8',
];

const String _kAvatarKey = 'voguesly_avatar';

String vogueslyAvatarAsset(String id) => 'assets/images/avatar/$id.svg';

/// 当前选中头像(默认 a1)，持久化喺 SharedPreferences。
class VogueslyAvatarNotifier extends Notifier<String> {
  @override
  String build() {
    _load();
    return vogueslyAvatars.first;
  }

  Future<void> _load() async {
    final p = await SharedPreferences.getInstance();
    final v = p.getString(_kAvatarKey);
    if (v != null && vogueslyAvatars.contains(v)) {
      state = v;
    }
  }

  Future<void> select(String id) async {
    if (!vogueslyAvatars.contains(id)) return;
    state = id;
    final p = await SharedPreferences.getInstance();
    await p.setString(_kAvatarKey, id);
  }
}

final vogueslyAvatarProvider =
    NotifierProvider<VogueslyAvatarNotifier, String>(
  VogueslyAvatarNotifier.new,
);
