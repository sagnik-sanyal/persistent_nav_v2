part of persistent_bottom_nav_bar_v2;

class BottomNavStyle12 extends StatefulWidget {
  final NavBarEssentials navBarEssentials;
  final NavBarAppearance navBarDecoration;

  /// This controls the animation properties of the items of the NavBar.
  final ItemAnimationProperties itemAnimationProperties;

  BottomNavStyle12({
    Key? key,
    required this.navBarEssentials,
    this.navBarDecoration = const NavBarAppearance(),
    this.itemAnimationProperties = const ItemAnimationProperties(),
  });

  @override
  _BottomNavStyle12State createState() => _BottomNavStyle12State();
}

class _BottomNavStyle12State extends State<BottomNavStyle12>
    with TickerProviderStateMixin {
  late List<AnimationController> _animationControllerList;
  late List<Animation<Offset>> _animationList;

  int? _lastSelectedIndex;
  int? _selectedIndex;

  @override
  void initState() {
    super.initState();
    _lastSelectedIndex = 0;
    _selectedIndex = 0;
    _animationControllerList = List<AnimationController>.empty(growable: true);
    _animationList = List<Animation<Offset>>.empty(growable: true);

    for (int i = 0; i < widget.navBarEssentials.items.length; ++i) {
      _animationControllerList.add(AnimationController(
          duration: widget.itemAnimationProperties.duration, vsync: this));
      _animationList.add(Tween(
              begin: Offset(0, widget.navBarEssentials.navBarHeight),
              end: Offset(0, 0.0))
          .chain(CurveTween(curve: widget.itemAnimationProperties.curve))
          .animate(_animationControllerList[i]));
    }

    _ambiguate(WidgetsBinding.instance)!.addPostFrameCallback((_) {
      _animationControllerList[_selectedIndex!].forward();
    });
  }

  Widget _buildItem(ItemConfig item, bool isSelected, int itemIndex) {
    return AnimatedBuilder(
      animation: _animationList[itemIndex],
      builder: (context, child) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: IconTheme(
              data: IconThemeData(
                size: item.iconSize,
                color: isSelected
                    ? item.activeColorPrimary
                    : item.inactiveColorPrimary,
              ),
              child: isSelected ? item.icon : item.inactiveIcon,
            ),
          ),
          AnimatedOpacity(
            opacity: isSelected ? 1.0 : 0.0,
            duration: widget.itemAnimationProperties.duration,
            child: Transform.translate(
              offset: _animationList[itemIndex].value,
              child: Container(
                height: 5.0,
                width: 5.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100.0),
                  color: item.activeColorPrimary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    for (int i = 0; i < widget.navBarEssentials.items.length; ++i) {
      _animationControllerList[i].dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.navBarEssentials.items.length !=
        _animationControllerList.length) {
      _animationControllerList =
          List<AnimationController>.empty(growable: true);
      _animationList = List<Animation<Offset>>.empty(growable: true);

      for (int i = 0; i < widget.navBarEssentials.items.length; ++i) {
        _animationControllerList.add(AnimationController(
            duration: widget.itemAnimationProperties.duration, vsync: this));
        _animationList.add(Tween(
                begin: Offset(0, widget.navBarEssentials.navBarHeight),
                end: Offset(0, 0.0))
            .chain(CurveTween(curve: widget.itemAnimationProperties.curve))
            .animate(_animationControllerList[i]));
      }
    }
    if (widget.navBarEssentials.selectedIndex != _selectedIndex) {
      _lastSelectedIndex = _selectedIndex;
      _selectedIndex = widget.navBarEssentials.selectedIndex;
      _animationControllerList[_selectedIndex!].forward();
      _animationControllerList[_lastSelectedIndex!].reverse();
    }
    return DecoratedNavBar(
      appearance: widget.navBarDecoration,
      filter: widget.navBarEssentials
          .items[widget.navBarEssentials.selectedIndex].filter,
      opacity: widget.navBarEssentials
          .items[widget.navBarEssentials.selectedIndex].opacity,
      height: widget.navBarEssentials.navBarHeight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: widget.navBarEssentials.items.map((item) {
          int index = widget.navBarEssentials.items.indexOf(item);
          return Expanded(
            child: GestureDetector(
              onTap: () {
                bool didSwitchTab =
                    widget.navBarEssentials.onItemSelected!(index);
                if (didSwitchTab) {
                  if (index != _selectedIndex) {
                    _lastSelectedIndex = _selectedIndex;
                    _selectedIndex = index;
                    _animationControllerList[_selectedIndex!].forward();
                    _animationControllerList[_lastSelectedIndex!].reverse();
                  }
                }
              },
              child: _buildItem(
                item,
                widget.navBarEssentials.selectedIndex == index,
                index,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
