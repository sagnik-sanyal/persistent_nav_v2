# V4 -> V5 Migration Guide

## Using Predefined Navigation Bar Styles

To specify the style you want to use, you now have to use the corresponding widget directly, instead of `NavBarStyle.style1`. Also notice that the parameter is named differently:

<table>
<tr>
<td> Old </td> <td> New </td>
</tr>
<td>

```dart
PersistentTabView(
  ...,
  navBarStyle: NavBarStyle.style1
),
```

</td>
<td>

```dart
PersistentTabView(
  ...,
  navBarBuilder: (navBarConfig) =>
      Style1BottomNavBar(
          navBarConfig: navBarConfig
      )
),
```

</td>
</tr>
</table>

## Using Custom Navigation Bar Styles

The additional constructor `PersistentTabView.custom` now is gone, so you now can also use the other one. Also, in your `onItemSelected` function you dont need to call `setState`, just call the `navBarConfig.onItemSelected` (either by passing the function (like here) or by passing `navBarConfig` into your navigatino bar widget (like in the example in the main Readme)):

<table>
<tr>
<td> Old </td> <td> New </td>
</tr>
<td>

```dart
PersistentTabView.custom(
  ...,
  customWidget: (navBarEssentials) =>
  CustomNavBarWidget(
      items: _navBarItems(),
      onItemSelected: (index) {
        setState(() {
            navBarEssentials
            .onItemSelected(index);
        })
      },
      selectedIndex: _controller.index,
  )
),
```

</td>
<td>

```dart
PersistentTabView(
  ...,
  navBarBuilder: (navBarConfig) =>
  CustomNavBarWidget(
      items: navBarConfig.items,
      onItemSelected:
        navBarConfig
        .onItemSelected,
      selectedIndex:
        navBarConfig
        .selectedIndex,
  )
),
```

</td>
</tr>
</table>


<details>
  <summary>Removed Parameters</summary>

- itemCount
- routeAndNavigatorSettings: They are now applied inside `ItemConfig` if you need. By default they are inherited from the root navigator.

</details>

## Tabs and Screens

Previously, there were two lists, one for the tab items and one for the screens. They are merged into one list now. Also, the `PersistentBottomNavBarItem` got renamed to `ItemConfig`. That concludes to the following change:

<table>
<tr>
<td> Old </td> <td> New </td>
</tr>
<td>

```dart
PersistentTabView(
  ...,
  screens: <Widget>[
    Screen1(),
    Screen2(),
    Screen3(),
  ],
  items: [
    PersistentBottomNavBarItem(
      icon: Icon(Icons.home),
      title: "Home"
    ),
    PersistentBottomNavBarItem(
      icon: Icon(Icons.home),
      title: "Home"
    ),
    PersistentBottomNavBarItem(
      icon: Icon(Icons.home),
      title: "Home"
    ),
  ]
),
```

</td>
<td>

```dart
PersistentTabView(
  ...,
  tabs: [
    PersistentTabConfig(
      screen: Screen1(),
      item: ItemConfig(
        icon: Icon(Icons.home),
        title: "Home",
      ),
    ),
    PersistentTabConfig(
      screen: Screen2(),
      item: ItemConfig(
        icon: Icon(Icons.home),
        title: "Home",
      ),
    ),
    PersistentTabConfig(
      screen: Screen3(),
      item: ItemConfig(
        icon: Icon(Icons.home),
        title: "Home",
      ),
    ),
  ],
),
```

</td>
</tr>
</table>

## `PersistentTabView` and `PersistentTabView.custom`

Some of the parameters of these constructors have been removed, some changed in behavior and some got added. So everything that changed is listed here:

### Removed

- **`screens`**: Is now incorporated in `tabs` (see [above](#tabs-and-screens))
- **`bottomScreenMargin`**: The same functionality can be accomplished with `navBarOverlap: NavBarOverlap.custom(overlap: x)`
- **`context`**

### Changed

- **`backgroundColor`**: This did previously set the color of the navigation bar. Now is sets the background of the whole `PersistentTabView`.
- **`confineToSafeArea`**: Renamed to `avoidBottomPadding`
- **`selectedTabScreenContext`**: Renamed to `selectedTabContext`

### Added

- **`floatingActionButtonLocation`**: Can be used to set the location of the `floatingActionButton` like in a Scaffold
- **`navBarOverlap`**: Can be used to specify to which extend the navbar should overlap the content

## PersistentBottomNavBarItem

This got renamed to `ItemConfig`.

### Colors

The behavior of primary and secondary colors and their defaults got changed (hopefully in favor of better understandability). Without going into too much detail, the roles of primary and secondary colors swapped. Also the `activeColorPrimary` no longer serves as a default for `activeColorSecondary` (but the other way around).

<table>
<tr>
<td> Old </td> <td> New </td>
</tr>
<td>

```dart
PersistentBottomNavBarItem(
  ...,
  activeColorPrimary: Colors.red,
  inactiveColorPrimary: Colors.white,
  activeColorSecondary: Colors.blue,
  inactiveColorSecondary: Colors.grey,
),
```

</td>
<td>

```dart
ItemConfig(
  ...,
  activeColorPrimary: Colors.blue,
  inactiveColorPrimary: Colors.grey,
  activeColorSecondary: Colors.red,
  inactiveColorSecondary: Colors.white,
),
```

</td>
</tr>
</table>

## NavigatorSettings

## NavBarDecoration

Most of its attributes just moved to the `decoration` attribute, which is a `BoxDecoration` and thus includes some more options. Extra notes on the following attributes:

- the attribute `colorBehindNavBar` moved to `PersistentTabView.backgroundColor` (which previously was the navigation bar color. The color of the navigation bar must now be set in `NavBarDecoration.decoration.color`)
- the attribute `adjustScreenBottomPaddingOnCurve` got removed in favor of more flexibility. You can accomplish the same functionality by setting `NavBarOverlap.custom(overlap: navBarDecoration.exposedHeight)` on `PersistentTabView.navBarOverlap` where `navBarDecoration` must be what you pass to you navigation bar so you might need to store that somewhere in between.

## Styles

All navigation bar styles receive the `NavBarDecoration` ([see here](#navbardecoration) for the migration of that) directly, instead of being passed through the `PersistentTabView`. So just move the `NavBarDecoration` from the `PersistentTabView` to the navigation bar widget you use:

<table>
<tr>
<td> Old </td> <td> New </td>
</tr>
<td>

```dart
PersistentTabView(
    ...,
    decoration: NavBarDecoration(
        decoration: BoxDecoration(
            color: Colors.white,
        ),
    ),
),
```

</td>
<td>

```dart
Style1BottomNavBar(
    ...,
    navBarDecoration: NavBarDecoration(
        decoration: BoxDecoration(
            color: Colors.white,
        ),
    ),
),
```

</td>
</tr>
</table>

### Neumorphic Style
`NeumorphicBottomNavBar` got renamed to `NeumorphicBottomNavBar`
