import 'dart:async';

class PayloadStream<T> {
  final _socketResponse = StreamController<T>();

  void Function(T) get addPayload {
    return isDisposed ? (_) {} : _socketResponse.sink.add;
  }

  bool get isDisposed => _socketResponse.isClosed;

  Stream<T> get getPayload => _socketResponse.stream;

  void dispose() {
    _socketResponse.close();
  }
}
