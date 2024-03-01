import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    searchIcon = Icon(Icons.search,
        color: Colors.grey);
    if (editingController.text.isEmpty) {
      setState(() {
        searchIcon = isFocus.hasFocus ||
            editingController.text.isNotEmpty
            ? null
            : Icon(Icons.search,
            color:  Colors.grey);
      });
    }

    isFocus.addListener(() {
      closeIcon =
      isFocus.hasFocus && editingController.text.isNotEmpty
          ? IconButton(
          splashColor: Colors.transparent,
          hoverColor: Colors.transparent,
          icon: Icon(Icons.close,
              size: 24,
              color: Colors.grey),
          onPressed: () {
            editingController.text = '';
            isFocus.unfocus();
            filterSearchResults('');

              ///Remove the overlay on pressing close button
              _overlayEntry.opaque = false;
              _removeOverlayEntries();

          })
          : null;

      if (editingController.text.isEmpty) {
        setState(() {
          searchIcon = isFocus.hasFocus ||
              editingController.text.isNotEmpty
              ? null
              : Icon(Icons.search,
              color: Colors.grey);
        });
      }
      hint = isFocus.hasFocus ? '' : 'Search';
    });

    super.initState();
  }


  late List sampleList;
  String hint = 'Search';
  late OverlayEntry _overlayEntry;
  final FocusNode _rawKeyFocusNode = FocusNode();
  final FocusNode isFocus = FocusNode();
  Widget? searchIcon;
  int? _selectionIndex;
  /// Represents the close icon instance
  Widget? closeIcon;
  List<dynamic>? controlList;
  late List<SubItem> searchResults;
  TextEditingController editingController = TextEditingController();
  void _performKeyBoardEvent(RawKeyEvent event) {
    /// We need RawKeyEventDataWeb, RawKeyEventDataWindows,
    /// RawKeyEventDataMacOs. So dynamic type used
    final dynamic rawKeyEventData = event.data;
    if (event is RawKeyDownEvent) {
      if (searchResults.isNotEmpty &&
          rawKeyEventData.logicalKey == LogicalKeyboardKey.arrowDown) {
        ///Arrow down key action
        _selectionIndex = _selectionIndex == null
            ? 0
            : (_selectionIndex! >= searchResults.length - 1)
            ? searchResults.length - 1
            : _selectionIndex! + 1;
       // final List<int> indexes = _getVisibleIndexes();

      } else if (searchResults.isNotEmpty &&
          rawKeyEventData.logicalKey == LogicalKeyboardKey.arrowUp) {
        ///Arrow up key action
        _selectionIndex = _selectionIndex == null
            ? 0
            : _selectionIndex == 0
            ? 0
            : _selectionIndex! - 1;
      //  final List<int> indexes = _getVisibleIndexes();

      } else if (rawKeyEventData.logicalKey == LogicalKeyboardKey.escape) {
        ///Escape key action
        _selectionIndex = null;
        editingController.text = '';
        isFocus.unfocus();
        _overlayEntry.maintainState = false;
        _overlayEntry.opaque = false;
        _removeOverlayEntries();
      }
    }
  }
  void filterSearchResults(String query) {
    _removeOverlayEntries();
    final List<Control> dummySearchControl = <Control>[];

    final List<SubItem> dummySearchSamplesList = <SubItem>[];


    if (query.isNotEmpty) {
      final List<Control> dummyControlData = <Control>[];
      for (int i = 0; i < dummySearchControl.length; i++) {
        final Control item = dummySearchControl[i];
        if (item.title!.toLowerCase().contains(query.toLowerCase())) {
          dummyControlData.add(item);
        }
      }
      final List<SubItem> dummySampleData = <SubItem>[];
      for (int i = 0; i < dummySearchSamplesList.length; i++) {
        final SubItem item = dummySearchSamplesList[i];
        if ((item.control!.title! + ' - ' + item.title!)
            .toLowerCase()
            .contains(query.toLowerCase())) {
          dummySampleData.add(item);
        }
      }

      controlList!.clear();
      sampleList.clear();
      sampleList.addAll(dummySampleData);
      searchResults.clear();
      searchResults.addAll(dummySampleData);

        //ignore: invalid_use_of_protected_member
      //  notifyListeners();

    } else {
      searchResults.clear();
   //   controlList.addAll(duplicateControlItems);
      sampleList.clear();
    }
  }

  Future<void> _navigateToSample(int index) async {
    _overlayEntry.maintainState = false;
    editingController.text = '';
    isFocus.unfocus();
    _overlayEntry.opaque = false;
    _removeOverlayEntries();
    _selectionIndex = null;
    final dynamic renderSample = searchResults[index].key;
    if (renderSample != null) {

      //  onTapExpandSample(context, searchResults[index]);

    }
  }

  void _removeOverlayEntries() {
    if (overlayEntries != null && overlayEntries.isNotEmpty) {
      for (final OverlayEntry overlayEntry in overlayEntries) {
        if (overlayEntry != null) {
          overlayEntry.remove();
        }
      }
    }
    overlayEntries.clear();
  }
  late List<OverlayEntry> overlayEntries;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RawKeyboardListener(
        focusNode: _rawKeyFocusNode,
        onKey: (RawKeyEvent event) => _performKeyBoardEvent(event),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 35,
              // width: double.infinity,
              decoration: BoxDecoration(
                color:Colors.blue[100]!.withOpacity(0.2),
                borderRadius: const BorderRadius.all(Radius.circular(5.0)),
              ),
              child: Padding(
                padding: EdgeInsets.only(left: (isFocus.hasFocus || searchIcon == null) ? 10 : 0),
                child: Center(
                  child: TextField(
                    onSubmitted: (String value) {
                      if (_selectionIndex != null) {
                        _navigateToSample(_selectionIndex!);
                      }
                    },
                    mouseCursor: MaterialStateMouseCursor.clickable,
                    cursorColor:  Colors.grey,
                    focusNode: isFocus,
                    onChanged: (String value) {
                      closeIcon = isFocus.hasFocus && (editingController.text.isNotEmpty)
                          ? IconButton(
                          splashColor: Colors.transparent,
                          hoverColor: Colors.transparent,
                          icon: Icon(Icons.close,
                              size:  24,
                              color: Colors.grey),
                          onPressed: () {
                            editingController.text = '';
                            isFocus.unfocus();
                            filterSearchResults('');
                         /*   if (isMobileResolution) {
                              sampleList.clear();
                              setState(() {
                                closeIcon = null;
                              });
                            } else {*/
                              _overlayEntry.opaque = false;
                              _removeOverlayEntries();

                          })
                          : null;
                      setState(() {
                        /// searched results changed
                      });
                      filterSearchResults(value);
                    },
                    onEditingComplete: () {
                      isFocus.unfocus();
                    },
                    style: TextStyle(
                      fontFamily: 'Roboto-Regular',
                      color:  Colors.grey,
                      fontSize: 13,
                    ),
                    controller: editingController,
                    textAlignVertical: TextAlignVertical.center,
                    decoration: InputDecoration(
                      labelStyle: TextStyle(
                        fontFamily: 'Roboto-Regular',
                        color: Colors.grey,
                        fontSize: 13,
                      ),
                      hintText: hint,
                      hintStyle: TextStyle(
                        fontSize: 13,
                        fontFamily: 'Roboto-Regular',
                        color: Colors.grey,
                      ),
                      contentPadding: EdgeInsets.zero,
                      isDense: true,
                      border: InputBorder.none,
                      suffixIcon: closeIcon,
                      prefixIcon: searchIcon,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class Control {
  /// Contructor holds the tile, description, status etc., of the [Control]
  Control(
      this.title,
      this.description,
      this.image,
      this.status,
      this.displayType,
      this.subItems,
      this.controlId,
      this.isBeta,
      this.platformsToHide);

  /// Getting the control details from the json file
  factory Control.fromJson(Map<String, dynamic> json) {
    return Control(
        json['title'],
        json['description'],
        json['image'],
        json['status'],
        json['displayType'],
        json['subItems'],
        json['controlId'],
        json['isBeta'],
        json['platformsToHide']);
  }

  /// Contains title of the control, display in the home page
  final String? title;

  /// Contains description of the control, display in the home page
  final String? description;

  /// Contains image relates to the control, display in the home page
  final String? image;

  /// Conatins status of the control New/Updated/Beta
  final String? status;

  /// Display the controls based on this order.
  final int? controlId;

  /// Need to mention this when samples directly given without any sub category
  /// Mention as card/fullView, by default it will taken as "fullView".
  final String? displayType;

  /// Contains the subItem list which comes under sample type
  List<SubItem>? sampleList;

  /// Contains the subItem list which comes under [child] type
  List<SubItem>? childList;

  /// Contains the sample details collection
  List<dynamic>? subItems;

  /// To specify the control is beta or not in `https://pub.dev/publishers/syncfusion.com/packages`
  final bool? isBeta;

  /// To specify the control not to show on the web/android/iOS/windows/linux/macOS
  /// platforms in list format.
  ///
  /// Eg: In json file we can specify like below,
  ///
  /// "platformsToHide": ["linux", "android"] => the current control should not show on the linux and android platforms
  final List<dynamic>? platformsToHide;
}

/// Contains the detail of sample in different hierarchy levels
/// parent, child, sample types
class SubItem {
  /// It holds the type, title, key, description etc., of the sample
  SubItem(
      [this.type,
        this.displayType,
        this.title,
        this.key,
        this.codeLink,
        this.description,
        this.status,
        this.subItems,
        this.sourceLink,
        this.sourceText,
        this.needsPropertyPanel,
        this.platformsToHide]);

  /// Getting the SubItem details from the json file
  factory SubItem.fromJson(Map<String, dynamic> json) {
    return SubItem(
        json['type'],
        json['displayType'],
        json['title'],
        json['key'],
        json['codeLink'],
        json['description'],
        json['status'],
        json['subItems'],
        json['sourceLink'],
        json['sourceText'],
        json['needsPropertyPanel'],
        json['platformsToHide']);
  }

  /// Type given as parent/child/sample.
  /// if "parent" is given then primary tab and secondary tab both come.
  /// for "parent", "child" type must be give to subItems(next hierarchy).
  /// if "child" is given only primary tab will come.
  /// if "sample" is given no tab will come.
  /// by default it taken as "sample".
  /// Note: In all cases displayType is given as "fullView",
  /// additionally sample's tab will come.
  final String? type;

  /// Mention the samples layout.
  /// displayType given as card/fullView.
  /// by default it taken as "fullView".
  /// Note: Need to mention this when on display type is child.
  final String? displayType;

  /// Need to mention in all type.
  final String? title;

  /// Below values need to give when type is "sample".
  final String? key;

  /// Contains Github sample link
  final String? codeLink;

  /// Contains the description of the sample
  /// to be displayed in the sample backpanel
  final String? description;

  /// Status of the sample, displays above the sample
  final String? status;

  /// SourceLink which will launch a url of the sample's source
  /// on tapping source text present under the sample.
  final String? sourceLink;

  /// Short form of the source link which will displays under the sample.
  final String? sourceText;

  /// No need to give when type is "sample".
  List<dynamic>? subItems;

  /// If current sample has property panel mention true.
  final bool? needsPropertyPanel;

  /// Contains appropriate category name
  String? categoryName;

  ///Holds the URL text
  String? breadCrumbText;

  ///Current parent subItem index
  int? parentIndex;

  ///Current child subItem index
  int? childIndex;

  ///Current child subItem index
  int? sampleIndex;

  /// Holds appropriate control
  Control? control;

  /// To specify the sample not to show on the web/android/iOS/windows/linux/macOS
  /// platforms in list format.
  ///
  /// Eg: In json file we can specify like below,
  ///
  /// "platformsToHide": ["linux", "android"] => the specific sample should not show on the linux and android platforms
  final List<dynamic>? platformsToHide;
}
