# 🏨 booking_app — Flutter + Riverpod
 
<div align="center">
  <img width="250" src="https://github.com/user-attachments/assets/c57cbc56-b4d0-4173-9245-d580a37a1e3b" />
  <img width="250" src="https://github.com/user-attachments/assets/414f17ea-ebf5-43c9-b812-c7d5fafdea0f" />

 <img width="250"  src="https://github.com/user-attachments/assets/b9760a0e-41fa-44a4-8d8b-6f9608dcdd7a" />



</div>

**دليل تشغيل واستخدام Riverpod في مشروع Flutter** — جاهز للبداية بسرعة، منظم، وقابل للتوسع. (وإذا علقت، لا تقلق… حتى المحترفون ينسون `flutter pub get` أحيانًا 😉)

---

## 👀 نظرة عامة

يوفّر هذا المستودع هيكل مشروع Flutter يستخدم **Riverpod** لإدارة الحالة، مع أمثلة عملية لأنواع الـ Providers (State/Provider/Future/Stream/Notifier)، بالإضافة إلى أفضل الممارسات، والاختبارات، والتنظيم المعماري.

---

## ✅ المتطلبات

* **Flutter** 3.19+ (أو أحدث)
* **Dart** 3+
* **Android Studio** أو **VS Code** مع إضافات Flutter/Dart

> تأكد من تثبيت Flutter:

```bash
flutter --version
```

---

## 🚀 البدء السريع

1. أنشئ مشروع Flutter جديد (اختياري):

```bash
flutter create riverpod_starter
cd riverpod_starter
```

2. أضف Riverpod:

```bash
flutter pub add flutter_riverpod
```

3. لفّ تطبيقك بـ `ProviderScope` في `main.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Riverpod Starter',
      theme: ThemeData(useMaterial3: true),
      home: const HomePage(),
    );
  }
}
```

---

## 🧩 الأمثلة الأساسية (ملف واحد لكل نوع)

### 1) `Provider` — قيمة ثابتة/محسوبة

```dart
final appNameProvider = Provider<String>((ref) => 'Riverpod Starter');

class AppNameText extends ConsumerWidget {
  const AppNameText({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final name = ref.watch(appNameProvider);
    return Text(name);
  }
}
```

### 2) `StateProvider` — حالة بسيطة

```dart
final counterProvider = StateProvider<int>((ref) => 0);

class CounterButtons extends ConsumerWidget {
  const CounterButtons({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(counterProvider);
    return Column(
      children: [
        Text('العداد: $count'),
        FilledButton(
          onPressed: () => ref.read(counterProvider.notifier).state++,
          child: const Text('زيادة'),
        ),
      ],
    );
  }
}
```

### 3) `FutureProvider` — بيانات غير متزامنة

```dart
final userNameProvider = FutureProvider<String>((ref) async {
  await Future.delayed(const Duration(milliseconds: 600));
  return 'أحمد';
});

class AsyncUserName extends ConsumerWidget {
  const AsyncUserName({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncValue = ref.watch(userNameProvider);
    return asyncValue.when(
      data: (name) => Text('مرحبًا $name'),
      loading: () => const CircularProgressIndicator(),
      error: (e, _) => Text('خطأ: $e'),
    );
  }
}
```

### 4) `StreamProvider` — تدفق حي

```dart
final tickerProvider = StreamProvider<int>((ref) async* {
  var i = 0;
  while (true) {
    await Future.delayed(const Duration(seconds: 1));
    yield i++;
  }
});

class LiveTicker extends ConsumerWidget {
  const LiveTicker({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncValue = ref.watch(tickerProvider);
    return asyncValue.when(
      data: (i) => Text('الوقت: $i'),
      loading: () => const CircularProgressIndicator(),
      error: (e, _) => Text('خطأ: $e'),
    );
  }
}
```

### 5) `NotifierProvider` — منطق منظم

```dart
class CounterNotifier extends Notifier<int> {
  @override
  int build() => 0;
  void increment() => state++;
}

final counterNotifierProvider =
    NotifierProvider<CounterNotifier, int>(CounterNotifier.new);

class CounterView extends ConsumerWidget {
  const CounterView({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final count = ref.watch(counterNotifierProvider);
    return Row(
      children: [
        Text('$count'),
        IconButton(
          onPressed: () => ref.read(counterNotifierProvider.notifier).increment(),
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }
}
```

> 💡 استخدم `*.autoDispose` عندما تريد حذف الحالة تلقائيًا عند مغادرة الشاشة لتوفير الذاكرة.

---

## 🗂️ هيكلة المجلدات المقترحة

```
lib/
  app/
    app.dart              # MaterialApp, الثيم، الراوتينغ
    providers.dart        # مزودات عامة للتطبيق
  features/
    counter/
      data/
      domain/
      presentation/
        counter_page.dart
        widgets/
  core/
    network/
    utils/
    widgets/
```

* **feature-first**: كل ميزة في مجلد مستقل (data/domain/presentation)
* **decoupling**: اجعل الـ providers قريبة من استخدامها لكن ضع العامة في `app/providers.dart`

---

## 🧪 الاختبارات (Unit/Widget)

### مثال Unit Test لمزوّد حالة بسيطة

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final counterProvider = StateProvider<int>((ref) => 0);

void main() {
  test('counter starts at 0 and increments', () {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    expect(container.read(counterProvider), 0);
    container.read(counterProvider.notifier).state++;
    expect(container.read(counterProvider), 1);
  });
}
```

### مثال Widget Test مع ProviderScope

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('renders text from Provider', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: MaterialApp(
      home: Scaffold(body: Text('Hello')),
    )));

    expect(find.text('Hello'), findsOneWidget);
  });
}
```

---

## 🧭 أفضل الممارسات

* اجعل **المنطق** داخل Notifiers/Repositories وليس في Widgets.
* استخدم `ref.watch` في الـ UI و`ref.read` عند تنفيذ الأوامر (events).
* لا تسرب `BuildContext` داخل الـ providers.
* نظّم async state باستخدام `AsyncValue` و`when`.
* استخدم `autoDispose` للحالات المؤقتة.
* عبّر بالأصناف (domain models) بدل الخرائط العشوائية.

---

## 🆘 استكشاف الأخطاء

* **Widget خارج ProviderScope؟** ستظهر أخطاء قراءة المزوّد → لف التطبيق بـ `ProviderScope`.
* **عدم إعادة البناء؟** تأكد أنك تستخدم `ref.watch` بدل `read` داخل `build`.
* **أداء ضعيف؟** جزّئ الـ Widgets واستفد من `select()` لقراءة جزء من الحالة.

---

## 🛠️ سكربتات مفيدة

```bash
flutter pub get
flutter analyze
flutter test
flutter run -d chrome    # للويب
flutter run -d emulator  # للمحاكي
```

---

## 🔗 مصادر موثوقة

* Riverpod Docs: [https://riverpod.dev/docs/introduction](https://riverpod.dev/docs/introduction)
* Flutter State Management Intro: [https://docs.flutter.dev/development/data-and-backend/state-mgmt/intro](https://docs.flutter.dev/development/data-and-backend/state-mgmt/intro)
* Code With Andrea (Riverpod guide): [https://codewithandrea.com/articles/flutter-state-management-riverpod/](https://codewithandrea.com/articles/flutter-state-management-riverpod/)
* YouTube — Flutter Explained (Riverpod): [https://www.youtube.com/watch?v=COYFmbwTgJk](https://www.youtube.com/watch?v=COYFmbwTgJk)

> ملاحظة: المصادر أعلاه هي نقاط بداية موثوقة وذائعة الصيت في مجتمع Flutter.

---

## ❓أسئلة شائعة

**لماذا Riverpod بدل Provider؟**
أكثر أمانًا، لا يعتمد على `BuildContext`، أسهل للاختبار، أداء أفضل.

**هل أحتاج Freezed/JsonSerializable؟**
موصى به لنماذج البيانات الكبيرة لتقليل الأخطاء وتحسين الصيانة.

**هل يعمل مع GoRouter/Router 2.0؟**
نعم — استخدم providers لتخزين حالة المصادقة/المستخدم وقرائتها داخل الحارس (redirect).

---

## 🧾 رخصة

MIT — استخدمه كما تشاء، واذكر المصدر إذا أحببت.

---

> إذا أردت، يمكننا توليد **هيكل مشروع كامل** مع الملفات جاهزة للنسخ/اللصق (أو سكربت `mason`/`very_good_cli`).
