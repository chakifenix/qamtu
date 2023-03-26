import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:qamtu/colors.dart';
import 'package:qamtu/logic/cubit/internet_cubit.dart';
import 'package:qamtu/presentation/screens/announcements_screen.dart';
import 'package:qamtu/presentation/screens/home_screen.dart';
import 'package:qamtu/presentation/screens/profile_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../services/firebase_service.dart';

class TabviewScreen extends StatefulWidget {
  TabviewScreen({Key? key}) : super(key: key);

  @override
  State<TabviewScreen> createState() => _TabviewScreenState();
}

class _TabviewScreenState extends State<TabviewScreen> {
  String _currentPage = 'home';
  List<String> pageKeys = ['home', 'announcements', 'profile'];
  bool internetConnected = false;
  bool isLoading = true;

  final Map<String, GlobalKey<NavigatorState>> _navigatorKeys = {
    'home': GlobalKey<NavigatorState>(),
    'announcements': GlobalKey<NavigatorState>(),
    'profile': GlobalKey<NavigatorState>(),
  };

  int _currentIndex = 0;
  List<int> loadedPages = [0];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkInternet().then((value) => {
      if(value) {
        setState(() {
          internetConnected = true;
    })
      }
    }).whenComplete(() {
      setState(() {
        isLoading = false;
      });
    });
  }

  void _selectTab(String tabItem, int index) {
    if (!loadedPages.contains(index)) {
      setState(() {
        loadedPages.add(index);
      });
    }

    if (tabItem == _currentPage) {
      if (_navigatorKeys[tabItem] != null) {
        if (_navigatorKeys[tabItem]!.currentState != null) {
          _navigatorKeys[tabItem]!
              .currentState!
              .popUntil((route) => route.isFirst);
        }
      }
    } else {
      setState(() {
        _currentPage = pageKeys[index];
        _currentIndex = index;
      });
    }
  }

  Future<bool> checkInternet() async {
    bool hasConnection = await InternetConnectionChecker().hasConnection;

    return hasConnection;
  }

  @override
  Widget build(BuildContext context) {
    final translations = AppLocalizations.of(context)!;

    return WillPopScope(
      onWillPop: () async {
        final isFirstRouteInCurrentTab =
        !await _navigatorKeys[_currentPage]!
            .currentState!
            .maybePop();
        if (isFirstRouteInCurrentTab) {
          if (_currentPage != 'home') {
            _selectTab('home', 0);
            return false;
          }
        }
        // let system handle back button if we're on the first route
        return isFirstRouteInCurrentTab;
      },
      child: isLoading ? const Scaffold(
        body: Center(
          child: CircularProgressIndicator.adaptive(),
        ),
      ) : internetConnected ? Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: [
            _buildOffstageNavigator('home'),
            loadedPages.contains(1)
                ? _buildOffstageNavigator('announcements')
                : Container(),
            loadedPages.contains(2)
                ? _buildOffstageNavigator('profile')
                : Container(),
          ],
        ),
        bottomNavigationBar: SizedBox(
          child: BottomNavigationBar(
            onTap: (int index) {
              _selectTab(pageKeys[index], index);
            },
            type: BottomNavigationBarType.fixed,
            backgroundColor: customGrey,
            currentIndex: _currentIndex,
            unselectedFontSize: 12.sp,
            unselectedLabelStyle:
            const TextStyle(fontWeight: FontWeight.w400),
            selectedFontSize: 14.sp,
            selectedLabelStyle:
            const TextStyle(fontWeight: FontWeight.w500),
            items: [
              BottomNavigationBarItem(
                  label: translations.home,
                  icon: Image.asset(
                    _currentIndex == 0
                        ? 'assets/selected_home_icon.png'
                        : 'assets/home_icon.png',
                    fit: BoxFit.contain,
                  )),
              BottomNavigationBarItem(
                  label: translations.announcements,
                  icon: Image.asset(
                    _currentIndex == 1
                        ? 'assets/selected_announcements_icon.png'
                        : 'assets/announcements_icon.png',
                    fit: BoxFit.contain,
                  )),
              BottomNavigationBarItem(
                  label: translations.profile,
                  icon: Image.asset(
                    _currentIndex == 2
                        ? 'assets/selected_profile_icon.png'
                        : 'assets/profile_icon.png',
                    fit: BoxFit.contain,
                  )),
            ],
          ),
        ),
      ) : Scaffold(
        body: SafeArea(
          child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(translations.noInternet, style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500
                  ),),

                  SizedBox(
                    height: 15.h,
                  ),

                  TextButton(onPressed: () {
                    checkInternet().then((value) {
                      if(value) {
                        setState(() {
                          internetConnected = true;
                        });
                      }
                    });
                  }, child: Text(translations.tryAgain, style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600
                  ),))
                ],
              )
          ),
        )
      )
    );
  }

  Widget _buildOffstageNavigator(String tabItem) {
    return Offstage(
      offstage: _currentPage != tabItem,
      child: TabNavigator(
        navigatorKey: _navigatorKeys[tabItem]!,
        tabItem: tabItem,
      ),
    );
  }
}

class TabNavigator extends StatelessWidget {
  final GlobalKey<NavigatorState> navigatorKey;
  final String tabItem;
  const TabNavigator(
      {Key? key,
        required this.navigatorKey,
        required this.tabItem})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget child;
    if (tabItem == 'home')
      child = HomeScreen();
    else if (tabItem == 'announcements')
      child = AnnouncementsScreen();
    else if (tabItem == 'profile')
      child = ProfileScreen();
    else
      child = HomeScreen();

    return Navigator(
      key: navigatorKey,
      onGenerateRoute: (routeSettings) {
        return MaterialPageRoute(builder: (context) => child);
      },
    );
  }
}
