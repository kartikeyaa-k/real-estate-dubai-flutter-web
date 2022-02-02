import 'dart:math';

import 'package:flutter/material.dart';

class PaginationIndicator extends StatefulWidget {
  const PaginationIndicator({
    Key? key,
    this.selectedColor = Colors.blue,
    this.unselectedColor = Colors.grey,
    this.visiblePageCount = 5,
    required this.onPageChanged,
    required this.pageCount,
    this.initialValue = 1,
  }) : super(key: key);
  final Color selectedColor;
  final Color unselectedColor;
  final int visiblePageCount;
  final ValueChanged<int> onPageChanged;
  final int pageCount;
  final int initialValue;

  @override
  _PaginationIndicatorState createState() => _PaginationIndicatorState();
}

class _PaginationIndicatorState extends State<PaginationIndicator> {
  late int _pageCount;
  late int _selectedPage;
  late List<bool> _selectedPageList;
  late ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
    _pageCount = widget.pageCount;
    _selectedPage = widget.initialValue;

    _selectedPageList = List.generate(
      _pageCount,
      (index) => _selectedPage == (index + 1),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _selectedPage = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: _getWidth(),
          height: 48,
          child: ListView(
            controller: _controller,
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            children: [
              ToggleButtons(
                constraints: const BoxConstraints.expand(height: 48, width: 48),
                children: List.generate(_pageCount, (index) => Text("${index + 1}")),
                isSelected: _selectedPageList,
                color: widget.unselectedColor,
                selectedColor: widget.selectedColor,
                onPressed: (index) {
                  _onPressed(index);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  double _getWidth() => widget.pageCount <= widget.visiblePageCount
      ? (48 * widget.pageCount) + widget.pageCount + 1
      : (48 * widget.visiblePageCount) + widget.visiblePageCount + 1;

  void _onPressed(int index) {
    _selectedPage = index + 1;
    setState(() {
      _selectedPageList = List.generate(
        _pageCount,
        (index) => _selectedPage == (index + 1),
      );
    });
    _controller.animateTo((48 * max(0, index - 2)) + max(0, index - 2),
        duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);

    widget.onPageChanged(_selectedPage);
  }
}
