import 'package:flutter/material.dart';

main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Lazy Indexed Stacked',
      home: IndexStackExample(),
    );
  }
}

class LazyStackIndex extends StatefulWidget {
  const LazyStackIndex({
    Key? key,
    this.alignment = AlignmentDirectional.topStart,
    this.textDirection,
    this.sizing = StackFit.loose,
    this.index = 0,
    this.children = const <Widget>[],
  }) : super(key: key);

  final AlignmentGeometry alignment;
  final TextDirection? textDirection;
  final StackFit sizing;
  final List<Widget> children;
  final int index;

  @override
  State<LazyStackIndex> createState() => _LazyStackIndexState();
}

class _LazyStackIndexState extends State<LazyStackIndex> {
  late final List<bool> _activitatedList =
      List<bool>.generate(widget.children.length, (int i) => i == widget.index);

  List<Widget> _buildChildren(BuildContext context) {
    return List<Widget>.generate(widget.children.length, (int i) {
      if (_activitatedList[i]) {
        return widget.children[i];
      }
      return const SizedBox.shrink();
    });
  }

  @override
  void didUpdateWidget(LazyStackIndex oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.index != widget.index) {
      _activateIndex(widget.index);
    }
  }

  void _activateIndex(int? index) {
    if (index == null) {
      return;
    }
    if (!_activitatedList[index]) {
      setState(() {
        _activitatedList[index] = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return IndexedStack(
      alignment: widget.alignment,
      textDirection: widget.textDirection,
      sizing: widget.sizing,
      index: widget.index,
      children: widget.children,
    );
  }
}

class IndexStackExample extends StatefulWidget {
  const IndexStackExample({Key? key}) : super(key: key);

  @override
  State<IndexStackExample> createState() => _IndexStackExampleState();
}

class _IndexStackExampleState extends State<IndexStackExample> {
  int _index = 0;

  void _selectIndex(int index) {
    setState(() {
      _index = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Indexed Stack'),
      ),
      body: Column(
        children: [
          Expanded(
            child: LazyStackIndex(
              index: _index,
              children: List.generate(
                3,
                (int index) => _SubIndexPage(index),
              ),
            ),
          ),
          BottomNavigationBar(
            currentIndex: _index,
            onTap: _selectIndex,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.filter_1),
                label: '1',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.filter_2),
                label: '2',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.filter_3),
                label: '3',
              ),
            ],
          )
        ],
      ),
    );
  }
}

class _SubIndexPage extends StatefulWidget {
  const _SubIndexPage(this.index, {super.key});
  final int index;
  @override
  State<_SubIndexPage> createState() => _SubIndexPageState();
}

class _SubIndexPageState extends State<_SubIndexPage> {
  DateTime? _displayTime;

  @override
  void initState() {
    super.initState();
    Future<void>.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          _displayTime = DateTime.now().subtract(
            const Duration(milliseconds: 300),
          );
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const Spacer(),
        Text(
          'This is page ${widget.index}',
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                fontSize: 64,
              ),
          textAlign: TextAlign.center,
        ),
        if (_displayTime == null)
          const Spacer()
        else
          Expanded(child: Text('initState() ran at $_displayTime')),
      ],
    );
  }
}
