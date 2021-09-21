import 'package:flutter/material.dart';

class ExpandableFabTest extends StatefulWidget {
  const ExpandableFabTest(
      {Key? key, required this.icons, required this.onIconTapped})
      : super(key: key);

  final List<IconData> icons;
  final ValueChanged<int> onIconTapped;

  @override
  _ExpandableFabTestState createState() => _ExpandableFabTestState();
}

class _ExpandableFabTestState extends State<ExpandableFabTest>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children:
          List.generate(widget.icons.length, (int index) => _buildChild(index))
              .toList()
            ..add(
              _buildFab(),
            ),
    );
  }

  Widget _buildChild(int index) {
    Color backgroundColor = Theme.of(context).cardColor;
    Color foregroundColor = Theme.of(context).colorScheme.secondary;
    return Container(
      height: 70.0,
      width: 56.0,
      alignment: FractionalOffset.topCenter,
      child: ScaleTransition(
        scale: CurvedAnimation(
            parent: _controller,
            curve: Interval(0.0, 1.0 - index / widget.icons.length / 2.0,
                curve: Curves.easeOut)),
        child: FloatingActionButton.small(
          backgroundColor: backgroundColor,
          child: Icon(
            widget.icons[index],
            color: foregroundColor,
          ),
          onPressed: () => _onTapped(index),
        ),
      ),
    );
  }

  Widget _buildFab() {
    return FloatingActionButton.small(
      onPressed: () {
        if (_controller.isDismissed) {
          _controller.forward();
        } else {
          _controller.reverse();
        }
      },
      tooltip: "Increment",
      child: Icon(Icons.add),
      elevation: 2.0,
    );
  }

  void _onTapped(int index) {
    _controller.reverse();
    widget.onIconTapped(index);
  }
}

class AnchoredOverlay extends StatelessWidget {
  const AnchoredOverlay({
    Key? key,
    required this.showOverlay,
    required this.overlayBuilder,
    required this.child,
  }) : super(key: key);

  final bool showOverlay;
  final Widget Function(BuildContext context, Offset anchor) overlayBuilder;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return OverlayBuilder(
              showOverlay: showOverlay,
              overlayBuilder: (BuildContext overlayContext) {
                RenderBox box = context.findRenderObject() as RenderBox;
                final center =
                    box.size.center(box.localToGlobal(const Offset(0.0, 0.0)));
                return overlayBuilder(overlayContext, center);
              },
              child: child);
        },
      ),
    );
  }
}

class OverlayBuilder extends StatefulWidget {
  const OverlayBuilder(
      {Key? key,
      required this.showOverlay,
      required this.overlayBuilder,
      required this.child})
      : super(key: key);

  final bool showOverlay;
  final Widget Function(BuildContext) overlayBuilder;
  final Widget child;

  @override
  _OverlayBuilderState createState() => _OverlayBuilderState();
}

class _OverlayBuilderState extends State<OverlayBuilder> {
  OverlayEntry? overlayEntry;

  @override
  void initState() {
    super.initState();
    if (widget.showOverlay) {
      WidgetsBinding.instance!.addPostFrameCallback((_) => showOverlay());
    }
  }

  @override
  void didUpdateWidget(covariant OverlayBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);
    WidgetsBinding.instance!
        .addPostFrameCallback((_) => syncWidgetAndOverlay());
  }

  @override
  void reassemble() {
    super.reassemble();
    WidgetsBinding.instance!
        .addPostFrameCallback((_) => syncWidgetAndOverlay());
  }

  @override
  void dispose() {
    if (isShowingOverlay()) {
      hideOverlay();
    }
    super.dispose();
  }

  bool isShowingOverlay() => overlayEntry != null;

  void showOverlay() {
    overlayEntry = OverlayEntry(
      builder: widget.overlayBuilder,
    );
    addToOverlay(overlayEntry!);
  }

  void addToOverlay(OverlayEntry entry) async {
    print('addToOverlay');
    Overlay.of(context)!.insert(entry);
  }

  void hideOverlay() {
    print('hideOverlay');
    overlayEntry!.remove();
    overlayEntry = null;
  }

  void syncWidgetAndOverlay() {
    if (isShowingOverlay() && !widget.showOverlay) {
      hideOverlay();
    } else if (!isShowingOverlay() && widget.showOverlay) {
      showOverlay();
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

class CenterAbout extends StatelessWidget {
  const CenterAbout({Key? key, required this.position, required this.child})
      : super(key: key);

  final Offset position;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: position.dy,
      left: position.dx,
      child: FractionalTranslation(
        translation: const Offset(-0.5, -0.5),
        child: child,
      ),
    );
  }
}
