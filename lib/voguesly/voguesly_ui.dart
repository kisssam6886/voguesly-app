import 'dart:io';

import 'package:flutter/material.dart';

import 'voguesly_overlay.dart';

/// 统一原生页 AppBar。
/// ⚠️ macOS 隐藏标题栏:红黄绿灯(关闭/最小化/全屏)占左上角 ~78px,push 页覆盖全窗
/// 会令返回键同红黄绿灯重叠(Sam 投诉)。故 macOS 上把返回键推到红黄绿灯右边。
PreferredSizeWidget vogAppBar(
  BuildContext context, {
  required String title,
  List<Widget>? actions,
  PreferredSizeWidget? bottom,
}) {
  final isMac = Platform.isMacOS;
  // ⚠️ leadingWidth 必须 = 左内距 + 返回键宽(48),否则返回键被裁 → 箭头同点击热区错位(Sam 投诉)。
  const pad = 70.0; // 让开红黄绿灯(约 74px)
  return AppBar(
    leadingWidth: isMac ? pad + 48 : null,
    leading: Padding(
      padding: EdgeInsets.only(left: isMac ? pad : 4),
      // 返回:有得 pop(子页)就 pop;否则(半框页根)关闭 overlay 返回内容。
      child: BackButton(
        onPressed: () {
          final nav = Navigator.of(context);
          if (nav.canPop()) {
            nav.maybePop();
          } else {
            ContentOverlayScope.of(context)?.close();
          }
        },
      ),
    ),
    titleSpacing: 0,
    title: Text(title),
    actions: actions,
    bottom: bottom,
  );
}
