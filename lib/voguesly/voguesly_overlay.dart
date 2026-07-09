import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 内容区 overlay(半框):购买套餐 / 邀请返利 / 用户中心 / 在线客服 都只覆盖**右边内容区**,
/// 左侧栏保留可点(Sam 要求)。由 app_manager 喺内容 Expanded 内 Positioned.fill 渲染。
enum ContentOverlay { none, shop, invite, userCenter, cs, notice, stat }

class ContentOverlayNotifier extends Notifier<ContentOverlay> {
  @override
  ContentOverlay build() => ContentOverlay.none;
  void set(ContentOverlay v) => state = v;
  void close() => state = ContentOverlay.none;
}

final contentOverlayProvider =
    NotifierProvider<ContentOverlayNotifier, ContentOverlay>(
        ContentOverlayNotifier.new);

/// 令半框页嘅返回键(vogAppBar)喺无得再 pop 时关闭整个 overlay。
class ContentOverlayScope extends InheritedWidget {
  final VoidCallback close;
  const ContentOverlayScope({
    required this.close,
    required super.child,
    super.key,
  });

  static ContentOverlayScope? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<ContentOverlayScope>();

  @override
  bool updateShouldNotify(ContentOverlayScope oldWidget) => false;
}
