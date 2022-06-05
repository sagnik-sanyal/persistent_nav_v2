part of persistent_bottom_nav_bar_v2;

class PersistentBottomNavBar extends StatelessWidget {
  final EdgeInsets? margin;
  final bool? confineToSafeArea;
  final bool? hideNavigationBar;
  final Function(bool, bool)? onAnimationComplete;
  final NeumorphicProperties? neumorphicProperties;
  final NavBarEssentials? navBarEssentials;
  final NavBarDecoration? navBarDecoration;
  final Widget Function(NavBarEssentials) navBarBuilder;
  final bool? isCustomWidget;

  const PersistentBottomNavBar({
    Key? key,
    required this.navBarBuilder,
    this.margin,
    this.confineToSafeArea,
    this.hideNavigationBar,
    this.onAnimationComplete,
    this.neumorphicProperties = const NeumorphicProperties(),
    this.navBarEssentials,
    this.navBarDecoration,
    this.isCustomWidget = false,
  }) : super(key: key);

  Widget _navBarWidget() => Padding(
        padding: this.margin!,
        child: isCustomWidget!
            ? this.margin!.bottom > 0
                ? SafeArea(
                    top: false,
                    bottom: this.navBarEssentials!.navBarHeight == 0.0 ||
                            (this.hideNavigationBar ?? false)
                        ? false
                        : confineToSafeArea ?? true,
                    child: Container(
                      color: this.navBarEssentials!.backgroundColor,
                      height: this.navBarEssentials!.navBarHeight,
                      child:
                          this.navBarBuilder(this.navBarEssentials!),
                    ),
                  )
                : Container(
                    color: this.navBarEssentials!.backgroundColor,
                    child: SafeArea(
                      top: false,
                      bottom: this.navBarEssentials!.navBarHeight == 0.0 ||
                              (this.hideNavigationBar ?? false)
                          ? false
                          : confineToSafeArea ?? true,
                      child: Container(
                        height: this.navBarEssentials!.navBarHeight,
                        child: this.navBarBuilder(this.navBarEssentials!),
                      ),
                    ),
                  )
            : false/*this.navBarStyle == NavBarStyle.style15 ||
                    this.navBarStyle == NavBarStyle.style16*/ //TODO: Depend on navbarWidget type
                ? this.margin!.bottom > 0
                    ? SafeArea(
                        top: false,
                        right: false,
                        left: false,
                        bottom: this.navBarEssentials!.navBarHeight == 0.0 ||
                                (this.hideNavigationBar ?? false)
                            ? false
                            : confineToSafeArea ?? true,
                        child: Container(
                          decoration: getNavBarDecoration(
                            decoration: this.navBarDecoration,
                            color: this.navBarEssentials!.backgroundColor,
                            opacity: this
                                .navBarEssentials!
                                .items![this.navBarEssentials!.selectedIndex!]
                                .opacity,
                          ),
                          child: this.navBarBuilder(this.navBarEssentials!),
                        ),
                      )
                    : Container(
                        decoration: getNavBarDecoration(
                          decoration: this.navBarDecoration,
                          color: this.navBarEssentials!.backgroundColor,
                          opacity: this
                              .navBarEssentials!
                              .items![this.navBarEssentials!.selectedIndex!]
                              .opacity,
                        ),
                        child: SafeArea(
                          top: false,
                          right: false,
                          left: false,
                          bottom: this.navBarEssentials!.navBarHeight == 0.0 ||
                                  (this.hideNavigationBar ?? false)
                              ? false
                              : confineToSafeArea ?? true,
                          child: this.navBarBuilder(this.navBarEssentials!),
                        ),
                      )
                : Container(
                    decoration: getNavBarDecoration(
                      decoration: this.navBarDecoration,
                      showBorder: false,
                      color: this.navBarEssentials!.backgroundColor,
                      opacity: this
                          .navBarEssentials!
                          .items![this.navBarEssentials!.selectedIndex!]
                          .opacity,
                    ),
                    child: ClipRRect(
                      borderRadius: this.navBarDecoration!.borderRadius ??
                          BorderRadius.zero,
                      child: BackdropFilter(
                        filter: this
                                .navBarEssentials!
                                .items![this.navBarEssentials!.selectedIndex!]
                                .filter ??
                            ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
                        child: Container(
                          decoration: getNavBarDecoration(
                            showOpacity: false,
                            decoration: navBarDecoration,
                            color: this.navBarEssentials!.backgroundColor,
                            opacity: this
                                .navBarEssentials!
                                .items![this.navBarEssentials!.selectedIndex!]
                                .opacity,
                          ),
                          child: SafeArea(
                            top: false,
                            right: false,
                            left: false,
                            bottom:
                                this.navBarEssentials!.navBarHeight == 0.0 ||
                                        (this.hideNavigationBar ?? false)
                                    ? false
                                    : confineToSafeArea ?? true,
                            child: this.navBarBuilder(this.navBarEssentials!),
                          ),
                        ),
                      ),
                    ),
                  ),
      );

  @override
  Widget build(BuildContext context) {
    return this.hideNavigationBar == null
        ? _navBarWidget()
        : OffsetAnimation(
            hideNavigationBar: this.hideNavigationBar,
            navBarHeight: this.navBarEssentials!.navBarHeight,
            onAnimationComplete: (isAnimating, isComplete) {
              this.onAnimationComplete!(isAnimating, isComplete);
            },
            child: _navBarWidget(),
          );
  }

  PersistentBottomNavBar copyWith({
    EdgeInsets? margin,
    bool? confineToSafeArea,
    Widget Function(NavBarEssentials)? navBarBuilder,
    bool? hideNavigationBar,
    Function(bool, bool)? onAnimationComplete,
    NeumorphicProperties? neumorphicProperties,
    NavBarEssentials? navBarEssentials,
    NavBarDecoration? navBarDecoration,
    Widget? navBarWidget,
    bool? isCustomWidget,
  }) =>
      PersistentBottomNavBar(
        margin: margin ?? this.margin,
        navBarBuilder: navBarBuilder ?? this.navBarBuilder,
        confineToSafeArea: confineToSafeArea ?? this.confineToSafeArea,
        hideNavigationBar: hideNavigationBar ?? this.hideNavigationBar,
        onAnimationComplete: onAnimationComplete ?? this.onAnimationComplete,
        neumorphicProperties: neumorphicProperties ?? this.neumorphicProperties,
        navBarEssentials: navBarEssentials ?? this.navBarEssentials,
        navBarDecoration: navBarDecoration ?? this.navBarDecoration,
        isCustomWidget: isCustomWidget ?? this.isCustomWidget,
      );

  bool opaque(int? index) {
    return this.navBarEssentials!.items == null
        ? true
        : !(this.navBarEssentials!.items![index!].opacity < 1.0);
  }
}
