import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// 易联 · 内嵌网页页(商城/邀请返利/在线客服等,面板页嵌 app 内,非外部浏览器)。
class VogueslyWebView extends StatefulWidget {
  final String url;
  final String title;
  const VogueslyWebView({super.key, required this.url, required this.title});

  static void open(BuildContext context, String url, String title) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => VogueslyWebView(url: url, title: title),
      ),
    );
  }

  @override
  State<VogueslyWebView> createState() => _VogueslyWebViewState();
}

class _VogueslyWebViewState extends State<VogueslyWebView> {
  WebViewController? _controller;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    try {
      _controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..setUserAgent(
          'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) '
          'AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.0 Safari/605.1.15',
        )
        ..setNavigationDelegate(
          NavigationDelegate(
            onPageStarted: (_) {
              if (mounted) setState(() => _loading = true);
            },
            onPageFinished: (_) {
              if (mounted) setState(() => _loading = false);
            },
            onWebResourceError: (e) {
              if (mounted) {
                setState(() {
                  _loading = false;
                  if (e.isForMainFrame ?? true) {
                    _error = '加载失败:${e.description}(code ${e.errorCode})';
                  }
                });
              }
            },
          ),
        )
        ..loadRequest(Uri.parse(widget.url));
    } catch (e) {
      _error = 'WebView 初始化失败:$e';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            tooltip: '刷新',
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() => _error = null);
              _controller?.reload();
            },
          ),
        ],
      ),
      body: _error != null
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline, size: 40),
                    const SizedBox(height: 12),
                    Text(_error!, textAlign: TextAlign.center),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: () {
                        setState(() {
                          _error = null;
                          _loading = true;
                        });
                        _controller?.loadRequest(Uri.parse(widget.url));
                      },
                      child: const Text('重试'),
                    ),
                  ],
                ),
              ),
            )
          : Stack(
              children: [
                if (_controller != null)
                  WebViewWidget(controller: _controller!),
                if (_loading)
                  const Align(
                    alignment: Alignment.topCenter,
                    child: LinearProgressIndicator(minHeight: 3),
                  ),
              ],
            ),
    );
  }
}
