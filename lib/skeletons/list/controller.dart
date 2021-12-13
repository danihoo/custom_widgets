import 'dart:async';

import 'filter.dart';

class ListStreamController<T> {
  final StreamController<List<T>> _controller;
  List<T>? _objects;
  List<Filter<T>> _filters;

  final Future<List<T>> Function() _reloadFunction;

  ListStreamController({
    required Future<List<T>> Function() reloadFunction,
    List<Filter<T>> filters = const [],
  })  : _controller = StreamController(),
        _reloadFunction = reloadFunction,
        _filters = filters {
    reload();
  }

  StreamSink<List<T>> get sink => _controller.sink;

  Stream<List<T>> get stream => _controller.stream;

  /*
    Compares elements with == function and replaces an equal element with the
    new one or just adds if no equal element exists
   */
  void addOrReplace(T object) {
    if (_objects == null) {
      _objects = [object];
    } else {
      int index = _objects!.indexOf(object);
      _objects!.removeAt(index);
      _objects!.insert(index, object);
    }
    _controller.add(_objects!);
  }

  void remove(T object) {
    if (_objects != null) {
      _objects!.remove(object);
      _controller.add(_objects!);
    }
  }

  void reload() {
    _reloadFunction().then(replace).catchError(_onError);
  }

  void replace(List<T> objects) {
    _objects = [];

    // apply filters
    for (var element in objects) {
      try {
        _filters.firstWhere((filter) => !filter.allows(element));
      } catch (_) {
        _objects!.add(element); // all filters allow the element
      }
    }

    _controller.add(_objects!);
  }

  void _onError(var error) {
    _controller.addError(error);
  }
}
