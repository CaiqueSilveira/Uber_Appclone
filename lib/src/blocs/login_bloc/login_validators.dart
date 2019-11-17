import 'dart:async';

class Validators{
  final validatePhone = StreamTransformer<String, String>.fromHandlers(
      handleData: (String phone, EventSink<String> sink) {
        if (phone.isNotEmpty) {
          sink.add(phone);
        } else {
          sink.addError('O campo do telefone não pode ficar em branco!');
        }
      }
  );
}
