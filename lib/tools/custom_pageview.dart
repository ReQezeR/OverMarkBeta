import 'package:flutter/material.dart';
import 'package:overmark/tools/CustomScrollBehavior.dart';

class NotifyingPageView extends StatefulWidget {
  final ValueNotifier<double> notifier;
  final List<Widget> pages;
  final Function(int) pageChanged;
  final int currentPage;

  NotifyingPageView({Key key, this.currentPage, this.pages, this.notifier, this.pageChanged}) : super(key: key);

  final _NotifyingPageViewState notifyingPageViewState = new _NotifyingPageViewState();

  @override
  _NotifyingPageViewState createState() => notifyingPageViewState;

  void navigateToPage(int pageIndex){
    createState().navigateToPage(pageIndex);
  }
}

class _NotifyingPageViewState extends State<NotifyingPageView> {
  PageController _pageController;

  void _onScroll() {
    widget.notifier?.value = _pageController.page;
  }

  void navigateToPage(int pageIndex){
    _pageController.animateToPage(pageIndex, duration: Duration(milliseconds: 400), curve: Curves.ease);
  }
  
  @override
  void initState() {
    _pageController = PageController(
      initialPage: widget.currentPage,
      viewportFraction: 1.1,
      keepPage: true,
    )..addListener(_onScroll);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: RemoveOverscrollIndicator(),
      child: GlowingOverscrollIndicator(
        axisDirection: AxisDirection.right,
        color: Colors.transparent,
        showLeading: false,
        showTrailing: false,
        child: PageView(
          children: widget.pages,
          controller: _pageController,
          onPageChanged:(index){
            widget.pageChanged(index);
          },
        ),
      ),
    );
  }
}