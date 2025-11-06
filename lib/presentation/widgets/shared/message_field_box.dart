import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MessageFieldBox extends StatelessWidget {
  final ValueChanged<String> onValue;

  const MessageFieldBox({super.key, required this.onValue});

  @override
  Widget build(BuildContext context) {
    final textController = TextEditingController();
    final focusNode = FocusNode();

    final outlineInputBorder = UnderlineInputBorder(
      borderSide: const BorderSide(color: Colors.transparent),
      borderRadius: BorderRadius.circular(40),
    );

    final inputDecoration = InputDecoration(
      hintText: 'End your message with a "?"',
      enabledBorder: outlineInputBorder,
      focusedBorder: outlineInputBorder,
      filled: true,
      suffixIcon: IconButton(
        icon: const Icon(Icons.send_outlined),
        onPressed: () async {
          final textValue = textController.value.text;
          textController.clear();
          focusNode.requestFocus();
          onValue(textValue);
          await _sendHttpRequest(textValue);
        },
      ),
    );

    return TextFormField(
      onTapOutside: (event) {
        focusNode.unfocus();
      },
      focusNode: focusNode,
      controller: textController,
      decoration: inputDecoration,
      onFieldSubmitted: (value) async {
        textController.clear();
        focusNode.requestFocus();
        onValue(value);
        await _sendHttpRequest(value);
      },
    );
  }

  Future<void> _sendHttpRequest(String message) async {
    final url = Uri.parse('https://httpbin.org/get'); // Reemplaza con tu URL
    final response = await http.get(
      url,
    );

    if (response.statusCode == 200) {
      print('Mensaje enviado exitosamente');
      print(response.body);
    } else {
      print('Error al enviar el mensaje: ${response.statusCode}');
    }
  }
}