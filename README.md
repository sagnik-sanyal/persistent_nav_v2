# Persistent Bottom Navigation Bar Version 2

[![Build](https://github.com/jb3rndt/PersistentBottomNavBarV2/actions/workflows/tests.yaml/badge.svg?branch=master)](https://github.com/jb3rndt/PersistentBottomNavBarV2/actions)
[![Coverage](https://codecov.io/gh/jb3rndt/PersistentBottomNavBarV2/branch/master/graph/badge.svg)](https://app.codecov.io/gh/jb3rndt/PersistentBottomNavBarV2/)
[![Pub package version](https://img.shields.io/pub/v/persistent_bottom_nav_bar_v2)](https://pub.dev/packages/persistent_bottom_nav_bar_v2)
[![License](https://img.shields.io/github/license/jb3rndt/PersistentBottomNavBarV2)](https://github.com/jb3rndt/PersistentBottomNavBarV2/blob/master/LICENSE)
[![GitHub issues](https://badgen.net/github/issues/jb3rndt/PersistentBottomNavBarV2/)](https://gitHub.com/jb3rndt/PersistentBottomNavBarV2/issues/)
[![GitHub stars](https://img.shields.io/github/stars/jb3rndt/PersistentBottomNavBarV2?logo=github&colorB=dargreen)](https://gitHub.com/jb3rndt/PersistentBottomNavBarV2/stargazers/)

A highly customizable bottom navigation bar for Flutter. It is shipped with 17 prebuilt styles you can choose from (see below), but can also be used with your very own style without sacrificing any features.

NOTE: This package is a continuation of [persistent_bottom_nav_bar](https://pub.dev/packages/persistent_bottom_nav_bar).

<p align="center">
<img src="gifs/persistent.gif" alt="Preview" style="height:400px;"/>
</p>

<details>
  <summary><h2>Table of Contents</h2></summary>

- [Styles](#styles)
- [Features](#features)
- [Getting Started](#getting-started)
  - [1. Install the package](#1-install-the-package)
  - [2. Import the package](#2-import-the-package)
  - [3. Use the `PersistentTabView`](#3-use-the-persistenttabview)
- [Styling](#styling)
- [Using a custom Navigation Bar](#using-a-custom-navigation-bar)
- [Controlling the Navigation Bar programmatically](#controlling-the-navigation-bar-programmatically)
- [Navigation](#navigation)
- [Useful Tips](#useful-tips)

</details>

## Styles

| Style15                      | Style16                       | Style9                       |
| ---------------------------- | ----------------------------- | ---------------------------- |
| ![style1](gifs/style-15.gif) | ![style10](gifs/style-16.gif) | ![style10](gifs/style-9.gif) |

| Style1                      | Style9                       |
| --------------------------- | ---------------------------- |
| ![style1](gifs/style-1.gif) | ![style10](gifs/style-9.gif) |

| Style7                      | Style10                      |
| --------------------------- | ---------------------------- |
| ![style3](gifs/style-7.gif) | ![style5](gifs/style-10.gif) |

| Style12                      | Style13                      |
| ---------------------------- | ---------------------------- |
| ![style6](gifs/style-12.gif) | ![style8](gifs/style-13.gif) |

| Style3                      | Style6                      |
| --------------------------- | --------------------------- |
| ![style6](gifs/style-3.gif) | ![style8](gifs/style-6.gif) |

| Neumorphic                          | Neumorphic without subtitle                |
| ----------------------------------- | ------------------------------------------ |
| ![neumorphic1](gifs/neumorphic.gif) | ![neumorphic2](gifs/neumorphic-nosubs.gif) |

Note: These do not include all style variations

## Features

- New pages can be pushed below or above the navigation bar.
- 17 prebuilt navigation bar styles ready to use.
- Each style is fully customizable ([see below](#styling))
- Supports custom navigation bars
- Persistent Tabs -> Navigation Stack is not discarded when switching to another tab
- Supports transparency and blur effects
- Handles hardware/software Android back button.

## Getting Started

### 1. Install the package

```yaml
dependencies:
  persistent_bottom_nav_bar_v2: any
```

### 2. Import the package

```dart
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';
```

### 3. Use the `PersistentTabView`

The `PersistentTabView` is your top level container that will hold both your navigation bar and all the pages (just like a `Scaffold`). Thats why it is not recommended, to wrap the `PersistentTabView` inside a `Scaffold.body`, because it does all of that for you. So just create the config for each tab and insert the `PersistentTabView` like this and you are good to go:

```dart
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

void main() => runApp(PersistenBottomNavBarDemo());

class PersistenBottomNavBarDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Persistent Bottom Navigation Bar Demo',
      home: PersistentTabView(
        tabs: [
          PersistentTabConfig(
            screen: YourFirstScreen(),
            item: ItemConfig(
              icon: Icon(Icons.home),
              title: "Home",
            ),
          ),
          PersistentTabConfig(
            screen: YourSecondScreen(),
            item: ItemConfig(
              icon: Icon(Icons.message),
              title: "Messages",
            ),
          ),
          PersistentTabConfig(
            screen: YourThirdScreen(),
            item: ItemConfig(
              icon: Icon(Icons.settings),
              title: "Settings",
            ),
          ),
        ],
        navBarBuilder: (navBarConfig) => Style1BottomNavBar(
          navBarConfig: navBarConfig,
          navBarDecoration: NavBarDecoration(
            decoration: BoxDecoration(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
```

## Styling

You can customize the Navigation Bar with all the parameters, each style allows. Here, for example, you could set a different border radius by passing `BorderRadius.circular(8)` to the `BoxDecoration`. Styles that include animations also allow you to adjust the timings and interpolation curves.

## Using a custom Navigation Bar

You can replace the `Style1BottomNavBar` widget with your own custom widget. As you can see, the `navBarBuilder` gives you a `navBarConfig`, which should be everything you need to build your custom navigation bar. Here is an example:

```dart
class CustomNavBar extends StatelessWidget {
  final NavBarConfig navBarConfig;
  final NavBarDecoration navBarDecoration;

  CustomNavBar({
    Key key,
    @required this.navBarConfig,
    this.navBarDecoration = const NavBarDecoration(),
  }) : super(key: key);

  Widget _buildItem(ItemConfig item, bool isSelected) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: IconTheme(
            data: IconThemeData(
                size: item.iconSize,
                color: isSelected
                    ? item.activeColorPrimary
                    : item.inactiveColorPrimary),
            child: isSelected ? item.icon : item.inactiveIcon,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 15.0),
          child: Material(
            type: MaterialType.transparency,
            child: FittedBox(
              child: Text(
                item.title,
                style: item.textStyle.apply(
                  color: isSelected
                      ? item.activeColorPrimary
                      : item.inactiveColorPrimary,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return DecoratedNavBar(
      decoration: this.navBarDecoration,
      filter: this.navBarConfig.selectedItem.filter,
      opacity: this.navBarConfig.selectedItem.opacity,
      height: this.navBarConfig.navBarHeight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: this.navBarConfig.items.map((item) {
          int index = this.navBarConfig.items.indexOf(item);
          return Expanded(
            child: InkWell(
              onTap: () {
                this.navBarConfig.onItemSelected(index); // This is the most important part. Without this, nothing would happen if you tap on an item.
              },
              child: _buildItem(
                item,
                this.navBarConfig.selectedIndex == index,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
```

In your `PersistentTabView`, you can use it just like the predefined style:

```dart
PersistentTabView(
  tabs: ...,
  navBarBuilder: (navBarConfig) => CustomNavBar(
    navBarConfig: navBarConfig,
    navBarDecoration: NavBarDecoration(
      decoration: BoxDecoration(
        color: Colors.white,
      ),
    ),
  ),
),
```

The most important thing is that you call the `navBarConfig.onItemSelected` function with the index of the tapped item, otherwise the `PersistentTabView` will not react to anything.

You dont need to use either the `DecoratedNavBar` widget, nor the `NavBarDecoration`, it is just a helper for you. You can do whatever you want in that custom navigation bar widget, as long as you remember to invoke the `onItemSelected` callback.

## Controlling the Navigation Bar programmatically

Internally, the `PersistentTabView` uses a `PersistentTabController`. So you can pass a controller to the `PersistentTabView` to use it later for changing the tab programmatically:

```dart
PersistentTabController _controller = PersistentTabController(initialIndex: 0);

PersistentTabView(
  controller: _controller,
  ...
);

_controller.jumpToTab(2);

```

## Navigation

Each of your Tabs will get its own Navigator, so they dont interfere with eachother. That means there will now be a difference between calling `Navigator.of(context).push()` (which will push a new screen inside the current tab) and `Navigator.of(context, rootNavigator: true).push()` (which will push a new screen above the whole `PersistentTabView`, ultimately hiding your navigation bar).

The package includes the following utility functions for expressive navigation.

```dart
pushScreen(
  context,
  screen: MainScreen(),
  withNavBar: true/false,
);
```

```dart
pushWithNavBar(
  context,
  MaterialPageRoute(builder: (context) => ...)
);
```

```dart
pushWithoutNavBar(
  context,
  MaterialPageRoute(builder: (context) => ...)
);
```

By default, each of the tabs navigators will inherit all the settings of the root navigator. So every configuration you do to the named routes (etc.) of the root navigator, will work just the same in each tab. If you want specific settings for each navigator (like additional routes, `NavigatorObservers` etc.), you can do so by passing a `NavigatorConfig` to the respective `PersistentTabConfig`.

The `PersistentTabView` has the ability to remember the navigation stack for each tab, so when you switch back to it you will see the exact same content when you left. This behavior can be toggled with the `PersistentTabView.stateManagement` parameter.

## Useful Tips

- Try the [interactive example project](https://github.com/jb3rndt/PersistentBottomNavBarV2/tree/master/example) in the official git repo to get a better feeling for the package

- Pop to any screen in the navigation graph for a given tab:

    ```dart
    Navigator.of(context).popUntil((route) {
        return route.settings.name == "ScreenToPopBackTo";
    });
    ```

- Pop back to first screen in the navigation graph for a given tab:

    ```dart
    Navigator.of(context).popUntil(ModalRoute.withName("/"));
    ```

    ```dart
    Navigator.of(context).pushAndRemoveUntil(
        CupertinoPageRoute(
        builder: (BuildContext context) {
            return FirstScreen();
        },
        ),
        (_) => false,
    );
    ```

- To push bottom sheet on top of the Navigation Bar, use showModalBottomScreen and set it's property `useRootNavigator` to true. See example project for an illustration.

- If you need e.g. notification counters on the icons in the navBar, you can use the [badges package](https://pub.dev/packages/badges) like so: (see [Issue 11](https://github.com/jb3rndt/PersistentBottomNavBarV2/issues/11))

    ```dart
    PersistentTabConfig(
        screen: ...,
        item: ItemConfig(
            icon: Badge(
                animationType: BadgeAnimationType.scale,
                badgeContent: UnreadIndicator(),
                child: const Icon(
                    Icons.chat_rounded,
                ),
            ),
            title: "Chat",
        ),
    ),
    ```
