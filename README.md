# wechat

Wechat Plugin for Flutter app.

## Getting Started

```yaml
dependencies:
  wechat: ^0.0.2
```

```dart
import 'package:wechat/wechat.dart';

...
  void _share (arguments) async {
    try {
      var result = await Wechat.share(arguments);
      _result = result.toString() ?? 'null result';
    } catch (e) {
      _result = e.toString();
    }
  }
...
```
