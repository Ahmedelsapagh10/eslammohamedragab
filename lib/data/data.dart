import 'item_model.dart';

List<ItemModel> courses = [
  ItemModel(
      name: 'C Plus Plus Course ',
      url: '',
      courseLink:
          'https://www.youtube.com/playlist?list=PLMsKeImcVjbv0cBh1XhBNyB0gJDrGXn3N',
      image: 'assets/images/cpp.webp',
      description: '''
نظرة عامة على الكورس
المدرب: Ahmed Elsapagh (المحتوى باللغة العربية).

التركيز: إتقان أساسيات البرمجة باستخدام C++. الكورس مصمم للمبتدئين تمامًا لبناء عقلية منطقية قوية.

الهدف: تعليمك كيف "تفكر كمبرمج" من خلال حل المشكلات باستخدام C++، وهذا ينعكس مباشرة على قوة المنطق عند كتابة Dart.

المحاور الأساسية والمحتوى
1. المقدمة والإعداد
بيئة العمل: تثبيت الـ Compiler (MinGW) و IDE (Visual Studio Code أو أي محرر مشابه).

الخطوات الأولى: فهم طريقة عمل C++، ودالة main()، وكتابة أول برنامج "Hello World".

Syntax: الفاصلة المنقوطة ;، التعليقات، وهيكلة الكود.

2. المتغيرات وأنواع البيانات
التخزين: تخزين البيانات باستخدام int و float و double و char و string.

الإدخال/الإخراج: شرح عميق لـ cin (إدخال) و cout (إخراج)، وهي مشابهة لفكرة stdin و print في Dart لكن بشكل أكثر manual.

العمليات: العمليات الحسابية (+, -, *, /) والمعاملات المنطقية.

3. التحكم في التدفق (قلب المنطق)
هذا الجزء هو الأهم في تطويرك كمبرمج:

الجمل الشرطية: if و else if و else و switch.

الحلقات: for و while و do-while.

لماذا هذا مهم: نفس المنطق الذي تتعلمه هنا للتعامل مع الشروط المعقدة هو نفسه الذي تستخدمه في Cubit emit states أو منطق عرض UI في Flutter (مثل: "If state is Loading, show Spinner").

4. Arrays و Functions
Arrays: تخزين قائمة بيانات (الجد الأكبر لـ Dart List).

Functions: إنشاء كتل كود قابلة لإعادة الاستخدام، وتمرير parameters، وتحديد return type.

لماذا يناسب مسارك (Flutter/Dart Developer)
رغم أنك تستخدم Dart، تعلم C++ مفيد جدًا من أجل:

Memory Management: فهم كيفية تخزين البيانات داخل RAM، وهذا يجعلك أكثر وعيًا بالأداء في تطبيقات Flutter.

Strict Typing: C++ صارمة جدًا في الأنواع. إتقانها يجعل Dart أسهل ويساعدك تقلل runtime errors في Dio models.

Algorithm Thinking: كورسات C++ تركز بقوة على problem-solving (algorithms)، وهذا سيجعل business logic داخل Cubits أدق وأكثر كفاءة.
'''),

  ItemModel(
    name: 'Flutter And Dart Course',
    url: '',
    courseLink:
        'https://www.youtube.com/playlist?list=PLMsKeImcVjbugZWl3SbV_HPbUyMqlzWgG',
    image: 'assets/images/flutter.webp',
    description: '''
نظرة عامة على الكورس
المدرب: Ahmed Elsapagh (المحتوى باللغة العربية)

التركيز: مسار شامل يغطي أساسيات Dart، ومبادئ OOP، وتطوير واجهات Flutter.

الفئة المستهدفة: من Beginner إلى Intermediate ممن يريدون فهمًا قويًا لطريقة عمل Flutter من الداخل.

المحاور الأساسية والمحتوى
1. برمجة Dart و OOP (الأساس)
قبل الدخول في Flutter، الكورس يبني قاعدة قوية في Dart، وهذا مهم جدًا لعملك مع state management متقدم مثل Cubit.

Dart Basics: المتغيرات، أنواع البيانات، Control Flow (Loops, If/Else)، و Functions.

Object-Oriented Programming (OOP): جزء أساسي في الكورس، ويغطي:

Classes & Objects: كيف تمثل مفاهيم العالم الحقيقي داخل الكود.

Inheritance & Polymorphism: إعادة استخدام الكود وتوسيع الوظائف.

Abstraction & Encapsulation: كتابة كود نظيف، آمن، ومقسم بشكل Modular.

لماذا هذا مهم لك: مهارات OOP القوية أساسية عند تنظيم Cubit states وبناء Data/Domain layers نظيفة في Dio API calls.

2. Flutter Fundamentals (بناء الواجهة)
الكورس ينتقل إلى مفهوم "Everything is a Widget".

Core Widgets: شروحات تفصيلية لـ Text و Container و Row و Column و Stack.

Scrollable Views: شرح عميق لـ ListView و GridView للتعامل مع قوائم البيانات.

Layout & Design: فهم Padding و Margin ومبادئ responsive design.

Assets: إدارة الصور والخطوط.

3. State Management & Interactivity
Stateful vs Stateless: فهم دورة حياة الـ widget (initState, setState, dispose).

User Input: التعامل مع forms و text fields و buttons.

ملاحظة: رغم أن الأساسيات تغطي setState، فهم هذه الـ lifecycles هو prerequisite لإتقان Bloc/Cubit الذي تستخدمه حاليًا.

4. مشاريع عملية ومواضيع متقدمة
الـ playlist تحتوي على تطبيقات عملية لترسيخ الفهم:

Building Apps: أمثلة مثل Calculator App و To-Do List أو تطبيقات utility مشابهة للتدريب على المنطق.

Networking (API): الأجزاء المتقدمة (غالبًا بعد الفيديو 50+) تغطي HTTP requests و JSON parsing والاتصال بالإنترنت، كتمهيد قوي لاستخدام Dio.

لماذا هذا مناسب لمسارك
بما أنك تعمل بالفعل بـ Flutter و Cubit و Dio، فهذا الكورس ممتاز كمرجع من أجل:

Refining OOP knowledge: تحسين تصميم Cubits و Repositories بشكل معماري صحيح.

Mastering UI constraints: مساعدتك على تصميم شاشات معقدة بدون layout errors.

Language nuances: تعميق فهمك لخصائص Dart (مثل spread operator ... المذكور في الفيديوهات) لكتابة كود أكثر اختصارًا ووضوحًا.
''',
  ),
  //! Flutter Instructor at Faculty of Sciences Sfax
  ItemModel(
      name: 'Flutter Instructor at Faculty of Sciences Sfax',
      url: '',
      courseLink:
          'https://www.youtube.com/watch?v=Eq6X_nNUbDo&list=PLMsKeImcVjbs-fUIGzaHus1y__uT-1HQw',
      image: 'assets/images/instructor.webp',
      description: '''
الكورس: GDSC Dart & Flutter Bootcamp (جلسات مباشرة)
إجمالي المحاضرات: 8
نمط الجلسات: محاضرات عميقة بأسلوب جامعي (Theory + Memory Management + Live Coding)

الجلسة 1: الأساس (تمت تغطيته)
التركيز: كيف تعمل الذاكرة (RAM)، المتغيرات، أنواع البيانات (int, String, bool, dynamic)، ودالة main().

الجلسة 2: Control Flow وبناء المنطق
"عقل" الكود: الانتقال من تخزين البيانات إلى اتخاذ القرارات.

Conditionals: شرح عميق لـ if و else if و switch مع أمثلة واقعية (مثل أنظمة الدرجات أو منطق التسعير).

Loops: for و while و do-while. فهم كيفية تكرار المهام بكفاءة بدون استهلاك زائد للذاكرة.

Logic Training: حل مسائل algorithmic بسيطة للتدرب على "thinking like a machine".

الجلسة 3: Functions وإعادة الاستخدام
Functions: كتابة كتل كود نظيفة وقابلة لإعادة الاستخدام حتى لا تكرر نفس الكود (DRY Principle).

Parameters: Positional vs Named parameters (مهم جدًا لاحقًا في Flutter widgets).

Return Types: فهم ما الذي تعيده الدالة (ومتى تستخدم void).

Arrow Functions: كتابة syntax مختصر باستخدام =>.

الجلسة 4: مقدمة في OOP (Object-Oriented Programming)
هذا أكثر جزء مهم لك كمطور يستخدم Cubit و Dio.

Classes & Objects: الانتقال من المتغيرات إلى "Blueprints". كيف تمثل User أو Product أو Order داخل الكود.

Constructors: تهيئة objects بشكل صحيح.

Encapsulation: حماية البيانات (private variables مثل _variable) حتى لا يتم تعديلها من الخارج، وهذا مهم جدًا لبناء Repositories آمنة.

الجلسة 5: OOP المتقدم (Inheritance)
Inheritance (extends): إنشاء parent class (مثل Vehicle) و child classes (Car, Bike) لمشاركة المنطق.

Super Keyword: الوصول لخصائص الـ parent.

Overriding: تغيير سلوك الـ child class (مثل toString() أو methods مخصصة).

الجلسة 6: Polymorphism و Abstraction
Polymorphism: التعامل مع objects مختلفة على أنها نفس النوع (مثل List<Vehicle> تحتوي cars و bikes).

Abstract Classes: إنشاء "Contracts" للكود.

لماذا هذا مهم: هذا نفس الأسلوب المستخدم عند بناء Interfaces لـ API repositories (مثل AuthRepository interface وتنفيذها بـ AuthRepositoryImpl).

Interfaces (implements): إجبار الكلاسات على اتباع قواعد محددة.

الجلسة 7: Collections و Null Safety
Collections:

Lists: Arrays وكيفية التعامل معها (add, remove, filter).

Maps: أزواج Key-Value (الأساس في JSON و API handling).

Loops with Collections: مثل forEach و map و where (فلترة القوائم).

Null Safety: شرح ?, !, late. وفهم "The Billion Dollar Mistake" وكيف Dart تتجنب null errors.

الجلسة 8: الانتقال إلى Flutter
The Shift: الانتقال من شاشة console السوداء إلى شاشة الموبايل.

Flutter Architecture: كيف Flutter تستخدم Dart لرسم الـ pixels.

Widget Tree: فهم أن "Everything is a Widget."

First App: إعداد بنية المشروع (lib, main.dart, pubspec.yaml) وتشغيل تطبيق "Hello World" بسيط.'''),
  ItemModel(
      name: 'General Tech Tips & Tools',
      url: '',
      courseLink:
          'https://www.youtube.com/playlist?list=PLMsKeImcVjbsLIaAdilXD1JWVgNtdtOEJ',
      image: 'assets/images/general.webp',
      description: '''
Playlist: نصائح وأدوات تقنية عامة
1. نقل الملفات (Phone <-> PC)
الأداة المستخدمة: SHAREit

ما الذي ستتعلمه: نقل الصور والفيديوهات والمستندات لاسلكيًا بين الهاتف والكمبيوتر بدون كابل. الشرط الأساسي أن الجهازين يكونان على نفس شبكة Wi-Fi.

2. عرض شاشة الهاتف على الكمبيوتر (Phone -> PC)
الأداة المستخدمة: Vysor

ما الذي ستتعلمه: عرض والتحكم في شاشة Android مباشرة من الكمبيوتر.

الإعداد الأساسي:

تفعيل Developer Options في الهاتف.

تشغيل USB Debugging.

التوصيل عبر USB واستخدام برنامج Vysor لعرض شاشة الهاتف على المونيتور (مفيد جدًا للعروض التقديمية أو تسجيل التطبيقات).

الخلاصة السريعة: مجموعة قصيرة من "Tools & Tips" مناسبة للمطورين أو المستخدمين بشكل عام لإدارة الهاتف من سطح المكتب بكفاءة.
'''),
];

List<ItemModel> packages = [
  ItemModel(
    name: 'waapi_flutter',
    url: 'https://pub.dev/packages/waapi_flutter',
    docsLink: 'https://waapi.octopusteam.net/docs',
    image: 'assets/images/waapi.webp',
    highlights: [
      'Send OTP codes for verification',
      'Send WhatsApp notifications and templates',
      'Media support: image, video, document with caption',
      'Strongly typed models and centralized exception handling',
    ],
    description: '''
`waapi_flutter` هو WhatsApp Business Messaging SDK مبني خصيصًا لـ Flutter، ويعتمد على Waapi Gateway لإرسال الرسائل بشكل بسيط وموثوق داخل تطبيقاتك.

المميزات الأساسية:
- إرسال OTP codes للمصادقة والتحقق.
- إرسال notifications مباشرة لمستخدمي WhatsApp.
- إرسال media (صور، فيديو، مستندات) مع caption.
- دعم template messages المعتمدة من WhatsApp Business.
- Location sharing و Contact Cards (vCard).
- دعم Voice Notes و Stickers.
- Device management (QR code generation + connection status).
- Error handling موحّد عبر `WaapiException`.
- Type-safe models & responses لتجربة تطوير أكثر أمانًا.

باختصار: SDK عملي وسريع الدمج لأي منتج Flutter يحتاج قناة WhatsApp Business قوية في الإنتاج.
''',
  ),
];

final List<ItemModel> _allProjectsArchive = [
  //! OCTOPUS WEBSITE
  //!
  //! Shopia
  ItemModel(
    name: 'Shopia',
    url:
        'https://play.google.com/store/apps/details?id=net.octopusteam.shopiaexpress',
    image: 'assets/images/shopia.webp',
    description: '''
هو تطبيق تسوق إلكتروني حديث يتيح تجربة شراء سهلة وسريعة لمجموعة واسعة من المنتجات مثل الملابس، الأحذية، الإكسسوارات، المنتجات الرياضية، ومنتجات الأطفال. يوفر التطبيق واجهة استخدام بسيطة ومنظمة تساعد المستخدمين على تصفح المنتجات والعروض بسهولة والعثور على ما يحتاجون إليه في ثوانٍ.

يتميز Shopia بعرض منتجات متنوع مع صور عالية الجودة وتفاصيل واضحة عن كل منتج مثل السعر، المقاسات، الألوان، والمواصفات الكاملة. كما يقدم خصومات وعروضًا مميزة تصل إلى نسب كبيرة، مما يساعد المستخدمين على الحصول على أفضل المنتجات بأفضل الأسعار.

يدعم التطبيق إضافة المنتجات إلى السلة بسهولة، وإدارة المفضلة، واستكشاف المنتجات الأكثر شيوعًا، مع إمكانية البحث السريع والتنقل بين الأقسام المختلفة مثل الرجال، النساء، الأطفال، والجمال.

أهم ما يميز Shopia:
- تصميم واجهة مستخدم بسيط ومنظم.
- نظام عرض منتجات ببيانات مفصلة وصور متعددة.
- دعم عمليات السحب والإفلات والإضافة السريعة للسلة.
- إدارة المفضلة بسرعة وسلاسة.
- أقسام متعددة للمنتجات لتسهيل الوصول.
- عروض وخصومات مستمرة.

Back-end التطبيق كان مبني على Shopify، وواجهنا تحديات تطوير response قوية باستخدام GraphQL. تم التعامل مع الـ APIs عبر ردود GraphQL مرتبة وتخصيصها بشكل دقيق لتتناسب مع تجربة المستخدم السلسة داخل التطبيق.
''',
    googlePlay:
        'https://play.google.com/store/apps/details?id=net.octopusteam.shopiaexpress',
    appleStore: 'https://apps.apple.com/us/app/shopia/id6760429708',
  ),

  ItemModel(
    name: 'Sella - صِلة',
    url: 'https://play.google.com/store/apps/details?id=net.elsapagh.sella',
    image: 'assets/images/sella.webp',
    description: '''
تطبيق "صِلة" هو رفيقك الرقمي المتكامل لتعزيز روحانياتك. يجمع التطبيق بين دقة مواقيت الصلاة والتقويم الهجري، مع تجربة مميزة لقراءة واستماع القرآن الكريم. يضم قسماً شاملاً للأذكار اليومية وسبحة إلكترونية تفاعلية ذكية، مع ميزة تتبع "وردك اليومي" لتحفيزك على الاستمرارية في العبادة. استكشف معاني أسماء الله الحسنى بتصميم جذاب وسهل المشاركة. يتميز صلة بواجهات عصرية مريحة للعين وتجربة مستخدم سلسة، مما يجعله الجسر الأمثل الذي يصلك بعباداتك اليومية بكل يسر وإتقان.
''',
    googlePlay:
        'https://play.google.com/store/apps/details?id=net.elsapagh.sella',
    appleStore:
        'https://apps.apple.com/us/app/%D8%B5%D9%84%D8%A9-sella/id6758775818',
  ),

  ItemModel(
    name: 'Waslny',
    url: 'https://play.google.com/store/apps/details?id=com.asom.waslny',
    image: 'assets/images/waslny2.webp',
    description: '''
Waslny - بناء مجتمع أذكى وأكثر ترابطًا في جاردينيا سيتي
تم تصميم Waslny ليكون خطوة حقيقية لتحسين الحياة اليومية داخل الكمباوند.
رؤيتنا هي إنشاء مجتمع ذكي ومنظم وتعاوني، بحيث يتمكن السكان من الوصول إلى خدمات النقل بسهولة وأمان وكفاءة.
تربط المنصة بين السكان والسائقين في نظام موحد قائم على الثقة والشفافية والراحة، داخل بيئة آمنة تدعم أسلوب حياة عصري.
ماذا يقدم Waslny؟
طلبات رحلات داخل الكمباوند بشكل منظم وموثوق.
حجز سريع بضغطة واحدة.
تتبع الرحلة لحظيًا.
نظام تقييم شفاف لزيادة الثقة.
تسعير واضح وثابت.
تجربة سلسة مخصصة للمجتمعات السكنية.
للسكان:
تنقل داخل الكمباوند بسهولة وأمان.
للسائقين:
فرص عمل مستقرة باشتراك شهري عادل، بدون عمولات، وأولوية للسائقين الملتزمين.
رؤيتنا:
إنشاء منصة مجتمعية متكاملة ترفع جودة الحياة، مبنية على التعاون والخصوصية وتجربة سكن ذكية حديثة.
متاح حاليًا في جاردينيا سيتي - القاهرة
مع خطط توسع مستقبلية لمجتمعات مشابهة.
''',
    googlePlay: 'https://play.google.com/store/apps/details?id=com.asom.waslny',
  ),
  ItemModel(
    name: 'Baraddy',
    url:
        'https://play.google.com/store/apps/details?id=net.octopusteam.baraddy',
    image: 'assets/images/baraddy.webp',
    description: '''
Baraddy.com هو تطبيق ذكي مصمم لتبسيط لوجستيات النقل البري بين المصدّرين المصريين وسائقي الشاحنات المبردة أو الجافة، من خلال ربط مباشر وسلس.

نهدف إلى توفير طريقة سريعة وآمنة وموثوقة لحجز شاحنات التصدير بضغطة واحدة، مع دعم كامل للتتبع والتقييم المتبادل.

المميزات:
- تسجيل مجاني للمصدّرين والسائقين
- إنشاء طلب شحنة بسهولة مع بيانات الاستلام والتسليم
- عروض لحظية من سائقين مؤهلين وقريبين
- تتبع مباشر للشاحنة عبر GPS
- نظام تقييم متبادل لبناء الثقة
- دعم عملاء مخصص متاح دائمًا

مثالي لـ:
- مصدّري الخضروات والفاكهة والأغذية المجمدة والمنسوجات
- سائقي الشاحنات المبردة والجافة الباحثين عن فرص عمل مباشرة

الخصوصية والأمان:
- التحقق من الهوية لكل مستخدم
- التقييمات بعد تسليم الشحنة فقط
- معايير قوية لحماية البيانات والتشفير

الإطلاق في مصر مع خطط توسع إلى السعودية والسودان وليبيا.

الموقع الرسمي: www.baraddy.com
''',
    googlePlay:
        'https://play.google.com/store/apps/details?id=net.octopusteam.baraddy',
  ),

  //!
  //! Elmazoon
  ItemModel(
      name: 'منصة المأذون في الفيزياء',
      url:
          'https://play.google.com/store/apps/details?id=com.topbusiness.new_mazoon',
      image: 'assets/images/elmazon.webp',
      description:
          'Elmazoon هي منصة تعليمية متخصصة في تدريس الفيزياء بقيادة الأستاذ أحمد المأذون. تعمل كمساحة تعليمية رقمية يستطيع من خلالها الطلاب الاشتراك في الدروس، وأداء الاختبارات، وتحسين فهمهم لمفاهيم الفيزياء. تم تصميم التطبيق ليجعل تعلم الفيزياء أسهل وأكثر إتاحة للطلاب في مصر.',
      googlePlay:
          'https://play.google.com/store/apps/details?id=com.topbusiness.new_mazoon',
      appleStore:
          'https://apps.apple.com/in/app/%D9%85%D9%86%D8%B5%D8%A9-%D8%A7%D9%84%D9%85%D8%A3%D8%B0%D9%88%D9%86-%D9%81%D9%8A-%D8%A7%D9%84%D9%81%D9%8A%D8%B2%D9%8A%D8%A7%D8%A1/id6753646548'),
//! EUA
  ItemModel(
      name: 'RDAPP Client',
      url: 'https://play.google.com/store/apps/details?id=com.rdapp.EUA',
      image: 'assets/images/eua.webp',
      description:
          'RDAPP منصة قوية وسهلة الاستخدام مصممة لمساعدة العملاء على إدارة مشاريعهم بسلاسة من البداية حتى النهاية. بواجهة واضحة ومزايا شاملة، يتيح التطبيق للمستخدمين متابعة مراحل المشروع، وإدارة زيارات التفتيش، ومعالجة الملاحظات، والتواصل مع دعم العملاء في مكان واحد.',
      googlePlay: 'https://play.google.com/store/apps/details?id=com.rdapp.EUA',
      appleStore: 'https://apps.apple.com/us/app/rdapp-client/id6743003162'),
//! Inspection
  ItemModel(
      name: 'RDAPP (Inspectors Platform)',
      url: 'https://play.google.com/store/apps/details?id=com.rdapp.inspection',
      image: 'assets/images/inspection.webp',
      description:
          'CPV Arabia جهة رائدة متخصصة في خدمات التفتيش الفني، وإدارة المخاطر، والتفتيش المستقل للتصميم. يقوم فريقنا المتخصص بإجراء فحوصات دقيقة لتقييم الالتزام، واكتشاف العيوب، وضمان التوافق مع اللوائح والمواصفات.\nيُمكّن التطبيق المهندسين من رفع التقارير الفنية Online وOffline، كما يتيح لملاك العقارات متابعة حالة الالتزام لحظيًا باستخدام EUA.',
      googlePlay:
          'https://play.google.com/store/apps/details?id=com.rdapp.inspection',
      appleStore: 'https://apps.apple.com/us/app/rdapp-client/id6743003162'),
//! malakia
//! malakia

  //!Cheebo:
  ItemModel(
      name: 'Cheebo',
      url: 'https://play.google.com/store/apps/details?id=com.neuralbey.cheebo',
      image: 'assets/images/cheebo.webp',
      description:
          'Cheebo منظومة متكاملة لرعاية الحيوانات الأليفة، مصممة لمساعدة المالكين على إدارة صحة ورفاهية حيواناتهم. يوفر التطبيق إدارة لملفات الحيوانات، ومتتبعًا صحيًا للتطعيمات والنظام الغذائي، وشبكة اجتماعية للتواصل مع ملاك آخرين. كما يتضمن ميزة المفقودات، وخريطة للأماكن المناسبة للحيوانات الأليفة، وإمكانية الوصول إلى نصائح الخبراء من الأطباء البيطريين والمدربين.',
      googlePlay:
          'https://play.google.com/store/apps/details?id=com.neuralbey.cheebo',
      appleStore:
          'https://apps.apple.com/us/app/cheebo-%D8%B4%D9%8A%D8%A8%D9%88/id6480533430'),
  //!At3aby:
  ItemModel(
      name: 'At3aby',
      url:
          'https://play.google.com/store/apps/details?id=com.topbusiness.ataaby',
      image: 'assets/images/at3aby.webp',
      description:
          'At3aby (أتعابي) تطبيق قانوني مبتكر يربط العملاء بالمحامين المحترفين بسهولة وكفاءة. يمكن للعميل إرسال قضيته مباشرة عبر التطبيق مع كل التفاصيل المطلوبة، ثم يبدأ المحامون في تقديم عروضهم للتعامل مع القضية. بعد ذلك يستطيع العميل مقارنة العروض حسب السعر والخبرة والتقييمات لاختيار الأنسب.\nبعد اختيار المحامي، يمكن إدارة كامل الإجراءات القانونية من داخل التطبيق بطريقة آمنة ومنظمة. كما يوفّر At3aby متجرًا قانونيًا متخصصًا يقدم خدمات وأدوات متعددة مثل النماذج القانونية الجاهزة، والاستشارات السريعة، والكتب القانونية وغيرها، ليكون منصة شاملة لكل الاحتياجات القانونية.',
      googlePlay:
          'https://play.google.com/store/apps/details?id=com.topbusiness.ataaby',
      appleStore: 'https://apps.apple.com/us/app/ataaby/id6744648039'),
  ItemModel(
      name: 'Mawhebtac',
      url:
          'https://play.google.com/store/apps/details?id=com.topbusiness.mawhebtak',
      image: 'assets/images/mawhebtac.webp',
      description:
          "Mawhebtac منصة ذكية وشاملة مصممة لمساعدة أصحاب المواهب على عرض مهاراتهم، والتواصل مع الجمهور المناسب، والوصول إلى فرص عمل حقيقية في المجالات الإبداعية والفنية.\nسواء كنت مغنيًا، ممثلًا، موسيقيًا، رسامًا، مصممًا، شاعرًا، راقصًا، أو أي موهبة إبداعية أخرى، يمنحك Mawhebtac مساحة شخصية للتعبير عن شغفك، وبناء ملف رقمي احترافي، والتواصل مع المنتجين والمخرجين وصناع المحتوى والشركات الباحثة عن المواهب الحقيقية.\nمن خلال ملفك الشخصي يمكنك:\nرفع الفيديوهات والصور ونماذج أعمالك.\nكتابة نبذة تعريفية تبرز خبراتك وشغفك.\nمشاركة معلومات التواصل والسيرة الإبداعية.\nيسهّل Mawhebtac اكتشاف المواهب كما يساعد جهات التوظيف على الوصول للشخص الأنسب بسرعة، ويجسر الفجوة بين الموهبة الخام والفرص الفعلية.\nأهداف التطبيق:\nتمكين أصحاب المواهب من بناء مسار مهني احترافي.\nتوفير مساحة رقمية للنمو والظهور.\nبناء قاعدة بيانات موثوقة وقابلة للبحث عن المواهب.\nالمميزات الرئيسية:\nملف احترافي لعرض الموهبة والـ portfolio.\nإشعارات بعروض العمل والـ auditions والفرص الجديدة.\nاستكشاف مواهب أخرى والتفاعل معها على المنصة.\nنظام تقييم وFeedback لتعزيز المصداقية والانتشار.\nدعم مجتمعي وتحديثات مستمرة للميزات.\nالفئة المستهدفة:\nالأفراد أصحاب المواهب الفنية والإبداعية.\nالشركات والوكالات الباحثة عن توظيف المواهب.\nصنّاع المحتوى والمخرجون والمنتجون وفرق الـ casting.\nسواء كنت في بداية الطريق أو لديك خبرة، يساعدك Mawhebtac على الانتقال من موهبة غير مرئية إلى فنان معترف به.\nابدأ رحلتك اليوم ودع العالم يكتشف موهبتك مع Mawhebtac.",
      googlePlay:
          'https://play.google.com/store/apps/details?id=com.topbusiness.mawhebtak',
      appleStore: 'https://apps.apple.com/us/app/mawhebtac/id6748575013'),
  //!Dwam School App:
  ItemModel(
    name: 'Dwam School',
    url: 'https://play.google.com/store/apps/details?id=com.dwam.school',
    image: 'assets/images/dwam_school.webp',
    appleStore: 'https://apps.apple.com/us/app/dwam-school/id6745431688',
    huaweiStore: 'https://appgallery.huawei.com/app/C114109937',
    description: '''
تطبيق DWAM School
DWAM School هو تطبيق تعليمي مبتكر يهدف إلى تسهيل إدارة العملية التعليمية داخل المدارس، من خلال أدوات ذكية وفعالة لإدارة الحضور والانصراف، ومتابعة سلوك الطلاب، وتقديم خدمات تساعد على تعزيز التواصل بين المدرسة والطلاب وأولياء الأمور. وبفضل تصميمه البسيط والواضح، يُعد التطبيق أداة شاملة لتنظيم البيئة المدرسية وتطويرها.

المميزات الرئيسية لتطبيق DWAM School:
متابعة الحضور والانصراف:

يتيح التطبيق للمعلمين وإدارة المدرسة تسجيل حضور وانصراف الطلاب إلكترونيًا بدقة وسهولة.

يتم تحديث البيانات بشكل فوري، مما يسمح للمدرسة وأولياء الأمور بمتابعة حالة الطالب لحظيًا.

تقييم سلوك الطلاب:

يوفر التطبيق نظامًا متكاملًا لتقييم سلوك الطالب وفق معايير محددة، مثل الالتزام بقوانين المدرسة، والتعاون مع الزملاء، والتفاعل داخل الفصل.

يمكن للمعلمين تسجيل الملاحظات السلوكية وإرسالها لأولياء الأمور لتعزيز التواصل والعمل المشترك على تحسين سلوك الطالب.

تقديم طلبات الإجازة:

يتيح التطبيق للطلاب أو أولياء الأمور تقديم طلبات إجازة إلكترونية... (النص الأصلي يبدو مقطوعًا هنا).
''',
    googlePlay: 'https://play.google.com/store/apps/details?id=com.dwam.school',
  ),
  ItemModel(
    name: 'Dwam lite',
    url: 'https://play.google.com/store/apps/details?id=com.app.dwam_hr',
    image: 'assets/images/dwam_lite.webp',
    appleStore: 'https://apps.apple.com/us/app/dwam-lite/id6742085336',
    huaweiStore: 'https://appgallery.huawei.com/app/C113543423',
    description: '''
تطبيق Dwam Lite
Dwam Lite هو تطبيق متكامل لإدارة الموظفين داخل الشركات، يتيح متابعة دقيقة للحضور والانصراف والغياب. ويوفر ميزات متقدمة مثل تسجيل أوقات الاستراحات وجدولة ساعات العمل بشكل سلس. يهدف التطبيق إلى رفع كفاءة إدارة الموارد البشرية وتقليل الأخطاء في تسجيل بيانات الموظفين.''',
    googlePlay: 'https://play.google.com/store/apps/details?id=com.app.dwam_hr',
  ), //!

  ItemModel(
      name: 'Top Hr',
      url:
          'https://play.google.com/store/apps/details?id=com.topbusiness.topbusinesshr',
      image: 'assets/images/tophr.webp',
      description:
          'TopBusiness HR تطبيق متقدم مصمم لتسهيل إدارة الموظفين، بما يشمل متابعة الحضور والانصراف، وإدارة الرواتب، والخصومات، والحوافز. يساعد الشركات على مراقبة الالتزام وضمان سلاسة إجراءات الرواتب. من خلال TopBusiness HR يمكن تتبع ساعات العمل بسهولة، وأتمتة حساب الرواتب، وتطبيق خصومات التأخير أو الغياب، وتوزيع الحوافز حسب الأداء. كما يقدم رؤية شاملة لنشاط الموظفين، مما يرفع كفاءة عمليات HR مع الحفاظ على الالتزام بلوائح العمل.',
      googlePlay:
          'https://play.google.com/store/apps/details?id=com.topbusiness.topbusinesshr',
      appleStore:
          'https://apps.apple.com/us/app/topbusiness-hr/id6738186675'), //!

  ItemModel(
      name: 'Teach Me Course',
      url: 'https://github.com/Ahmedelsapagh10/LMS',
      image: 'assets/images/tm.webp',
      description: 'Teach Me Course: منصة تعليمية ونظام LMS لإدارة التعلم.'),

  //!Deals:
  ItemModel(
    name: 'Deals (for odoo sales man)',
    url: 'https://play.google.com/store/apps/details?id=net.topbusiness.deals',
    image: 'assets/images/deals.webp',
    description:
        'Deals تطبيق متخصص لمندوبي المبيعات ومتكامل بالكامل مع نظام Odoo. يتيح مزامنة مباشرة لبيانات المبيعات والعملاء، وإدارة سهلة لعمليات البيع، ومتابعة أداء الفريق في الوقت الحقيقي. يدعم التطبيق وضع Offline ويوفر تنبيهات فورية، مما يساعد فرق المبيعات على زيادة الإنتاجية.',
    googlePlay:
        'https://play.google.com/store/apps/details?id=net.topbusiness.deals',
    appleStore: 'https://apps.apple.com/us/app/deals-topbusiness/id6737592676',
  ),
  //!Well 7:
  ItemModel(
      name: 'Well Seven',
      url:
          'https://play.google.com/store/apps/details?id=com.topbusiness.well_seven_new&hl=en_GB',
      image: 'assets/images/wellseven.webp',
      description:
          'Well Seven منصة مبتكرة لبيع وشراء المنتجات المنزلية، بما في ذلك الأغذية الطازجة مثل الخضروات والفواكه واللحوم. توفر توصيلًا منزليًا سريعًا وآمنًا، وواجهة سهلة الاستخدام، ونظام تقييم لضمان جودة المنتجات. كما يمكن للمستخدمين عرض منتجاتهم الخاصة للبيع على المنصة.',
      googlePlay:
          'https://play.google.com/store/apps/details?id=com.topbusiness.well_seven_new&hl=en_GB',
      appleStore: 'https://apps.apple.com/ng/app/well-seven/id6737221339'),
  ItemModel(
      name: 'Well Seven Provider',
      url:
          'https://play.google.com/store/apps/details?id=com.topbusiness.well_seven_provider_new',
      image: 'assets/images/wellseven.webp',
      description:
          'Well Seven Provider منصة مخصصة للمورّدين لإدارة منتجاتهم والتحكم فيها بسهولة. بواجهة مرنة ومنظمة، يستطيع المورد إضافة منتجات جديدة بسرعة، وتحديث المنتجات الحالية، ومتابعة المخزون، وتتبع أداء المبيعات من مكان واحد. يوفر التطبيق أدوات للتسعير وإدارة المخزون وتفاصيل المنتجات لضمان تجربة سلسة للمورد والمشتري. ويعد الشريك المثالي لتطبيق Well Seven من خلال تكامل سلس وتحكم كامل في منتجاتك داخل السوق.',
      googlePlay:
          'https://play.google.com/store/apps/details?id=com.topbusiness.well_seven_provider_new',
      appleStore:
          'https://apps.apple.com/ng/app/seven-well-provider/id6744165283'),
  ItemModel(
      name: 'Well Seven Delivery',
      url:
          'https://play.google.com/store/apps/details?id=com.topbusiness.wellsevendelivery_new',
      image: 'assets/images/wellseven.webp',
      description: '''
تطبيق Well Seven Delivery
Well Seven Delivery هو تطبيق مبتكر يهدف إلى تسهيل توصيل المنتجات بسرعة وأمان لمستخدمي منصة Well Seven. يتيح التطبيق لمقدمي خدمات التوصيل إدارة الطلبات وتوزيعها بكفاءة، بما يضمن تقديم خدمة عالية الجودة للعملاء.

المميزات الرئيسية في Well Seven Delivery:
إدارة فعالة للطلبات: يمكن للسائقين والمندوبين متابعة الطلبات الواردة بسهولة من تحديد الوجهة حتى تسليم المنتج للعميل النهائي.

تتبع الطلبات: يوفر التطبيق تتبعًا لحظيًا لحالة الطلبات، مع تحديد المواقع الجغرافية عبر الخرائط لضمان وصول سريع ودقيق.

إشعارات فورية: يحصل مقدمو خدمات التوصيل على تنبيهات فورية لأي تغييرات أو تحديثات مهمة في الطلبات، مما يساعد على سرعة الاستجابة.

إدارة الوقت: يوفر التطبيق أدوات فعالة لتنظيم الوقت وتخطيط أفضل مسارات التوصيل، مما يقلل وقت الانتظار ويرفع كفاءة العمل.

واجهة سهلة الاستخدام: تصميم بسيط يسهّل إدارة الطلبات وإضافة أو تعديل تفاصيل التوصيل دون الحاجة لخبرة تقنية متقدمة.

التواصل مع العملاء: يتيح التطبيق للمندوبين التواصل المباشر مع العملاء عبر المحادثة أو المكالمات لضمان تسليم ناجح وخدمة ممتازة.

الإحصائيات والتقارير: يوفر التطبيق تقارير تفصيلية عن أداء التوصيل، مثل الزمن المستغرق في كل عملية تسليم، بما يساعد على تحسين مستوى الخدمة وتحقيق أعلى كفاءة.

Well Seven Delivery هو الحل المثالي لمقدمي خدمات التوصيل الذين يسعون لرفع سرعة وكفاءة عملياتهم، مع ضمان تجربة تسوق مريحة وآمنة للعملاء.
''',
      googlePlay:
          'https://play.google.com/store/apps/details?id=com.topbusiness.wellsevendelivery_new',
      appleStore:
          'https://apps.apple.com/ng/app/well-seven-delivery/id6737466548'),
  //!Medo sedo:
  ItemModel(
      name: 'Medo Sedo',
      url:
          'https://play.google.com/store/apps/details?id=com.topbusiness.medosedo_ecom',
      image: 'assets/images/medo.webp',
      description:
          'Medo Sedo تطبيق e-commerce مصمم لعرض وشراء مجموعة متنوعة من المنتجات. يوفر واجهة سهلة الاستخدام لتصفح العناصر وإتمام عمليات شراء آمنة، بهدف تقديم تجربة تسوق سلسة للمستخدمين.',
      googlePlay:
          'https://play.google.com/store/apps/details?id=com.topbusiness.medosedo_ecom',
      appleStore:
          'https://apps.apple.com/us/app/medo-sedo-%D9%85%D9%8A%D8%AF%D9%88-%D8%B3%D9%8A%D8%AF%D9%88/id6449517311'),
  ItemModel(
      name: 'Salony',
      url: 'https://apps.apple.com/us/app/salony/id6480115778',
      image: 'assets/images/salony.webp',
      description:
          'Salony وجهتك المتكاملة لتصفح المنتجات وحجز الخدمات بسهولة. اكتشف مجموعة واسعة من الخيارات، من أساسيات الجمال إلى خدمات العناية والـ wellness، وكل ذلك في مكان واحد. تنقل بين الأقسام بسهولة، واستكشف الخيارات، واحجز المواعيد بدون تعقيد. استمتع بالراحة والجودة مع Salony.',
      appleStore: 'https://apps.apple.com/us/app/salony/id6480115778'),
  ItemModel(
      name: 'Salony Partner',
      url: 'https://apps.apple.com/us/app/salony-partner/id6480368878',
      image: 'assets/images/salony-partner.webp',
      description:
          'طوّر أعمالك مع تطبيق Salony Partner المصمم لمقدمي الخدمات لإدارة المنتجات والخدمات بكفاءة. تابع المخزون والمواعيد وتفضيلات العملاء بسهولة، وابقَ منظمًا وسريع الاستجابة لضمان تقديم خدمة سلسة ورضا أعلى للعملاء. ارتقِ بإدارة عملياتك مع Salony Partner.',
      appleStore: 'https://apps.apple.com/us/app/salony-partner/id6480368878'),

  ItemModel(
      name: 'Wallpaper Hub ',
      url: 'https://github.com/Ahmedelsapagh10/wallpaper-hub',
      image: 'assets/images/wallper.webp',
      description:
          'Wallpaper Hub تطبيق لتصفح الصور؛ يمكنك البحث باسم الصورة أو بأي كلمة وسيعرض لك التطبيق مجموعة صور مرتبطة بنتيجة البحث.'),
  /*ItemModel(
      name: 'e-commerce App ',
      url: 'https://github.com/Ahmedelsapagh10/e-commerce',
      image: 'assets/images/e-commerce.webp',
      description:
          'E-Commerce App هو تطبيق لتصفح المنتجات مثل الإلكترونيات والملابس.'),*/
  /*ItemModel(
      name: 'chat App ',
      url: 'https://github.com/Ahmedelsapagh10/chat-app',
      image: 'assets/images/chat.webp',
      description: 'تطبيق محادثة فورية مبني باستخدام Flutter.'),*/
  /*ItemModel(
      name: 'News App',
      url: 'https://github.com/Ahmedelsapagh10/news-app',
      image: 'assets/images/news.webp',
      description:
          'كل الأخبار التي تحتاج معرفتها عن الرياضة والأعمال والتكنولوجيا والعلوم.'),
  ItemModel(
      name: 'Calculator App',
      url: '',
      youtubeLink: 'https://www.youtube.com/watch?v=ODoquUbOXxw',
      image: 'assets/images/calculator.webp',
      description: 'تطبيق آلة حاسبة مبني باستخدام Flutter.'),

  ItemModel(
      name: 'Drawing App',
      url: 'https://github.com/Ahmedelsapagh10/drawing-app',
      image: 'assets/images/drawing.webp',
      description: 'تطبيق رسم بسيط.'),
  ItemModel(
      name: 'Drap_Drop game',
      url: 'https://github.com/Ahmedelsapagh10/drag_drop_game',
      image: 'assets/images/game1.webp',
      description: 'لعبة Drag and Drop مبنية باستخدام Flutter.'),
  ItemModel(
      name: 'Tic Tac game',
      url: 'https://github.com/Ahmedelsapagh10/tictak_game',
      image: 'assets/images/game2.webp',
      description: 'لعبة Tic Tac Toe مبنية باستخدام Flutter.'),*/
  /*  ItemModel(
      name: 'BMI App',
      url: 'https://github.com/Ahmedelsapagh10/BMI-Calculator',
      image: 'assets/images/bmi.webp',
      description: 'تطبيق BMI Calculator.'),
 
   ItemModel(
      name: 'Weather App',
      url: 'https://github.com/Ahmedelsapagh10/weather-App',
      image: 'assets/images/weather.webp',
      description: 'تطبيق طقس يوفر توقعات لحظية.'),
  ItemModel(
      name: 'Beaking Bad App',
      url: 'https://github.com/Ahmedelsapagh10/breaking-Bad',
      image: 'assets/images/breaking.webp',
      description:
          'تطبيق يقدم معلومات عن شخصيات Breaking Bad.'),
  ItemModel(
      name: 'Note App',
      url: 'https://github.com/Ahmedelsapagh10/note-app',
      image: 'assets/images/note.webp',
      description: 'تطبيق لتدوين الملاحظات.'),
  ItemModel(
      name: 'To Do App',
      url: 'https://github.com/Ahmedelsapagh10/To-Do-',
      image: 'assets/images/todo.webp',
      description: 'تطبيق To-Do مع تركيز على تصميم UI جيد.'),
  ItemModel(
      name: 'To Do App',
      url: 'https://github.com/Ahmedelsapagh10/todo',
      image: 'assets/images/todo2.webp',
      description: 'تطبيق To-Do بسيط.'),
  ItemModel(
      name: 'AR Pharmacy RESTFULL API',
      url: 'https://github.com/Ahmedelsapagh10/AR-Pharmacy-Project',
      image: 'assets/images/api1.webp',
      description: 'مشروع تخرج AR Pharmacy.'),
  ItemModel(
      name: 'Shopping RESTFULL API',
      url: 'https://github.com/Ahmedelsapagh10/shoppingAPI',
      image: 'assets/images/api2.webp',
      description: 'عمليات CRUD للمستخدمين والمنتجات.'),
 
  ItemModel(
      name: 'Another Projects',
      url: 'https://github.com/Ahmedelsapagh10?tab=repositories',
      image: 'assets/images/gitfub.webp'),  */
];

List<ItemModel> projects = _allProjectsArchive
    .where((item) => item.name.startsWith('Well Seven'))
    .toList(growable: false);
