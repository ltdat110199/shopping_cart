import 'package:flutter/material.dart';

class QuantityDialog extends StatefulWidget {
  final String name;
  final int initialQuantity;
  final void Function(int) onQuantityChanged;

  const QuantityDialog({
    super.key,
    required this.name,
    required this.initialQuantity,
    required this.onQuantityChanged,
  });

  @override
  _QuantityDialogState createState() => _QuantityDialogState();
}

class _QuantityDialogState extends State<QuantityDialog> {
  late int newQuantity;
  final TextEditingController controller = TextEditingController();
  String? errorMessage;
  final FocusNode focusNode = FocusNode();
  @override
  void initState() {
    super.initState();
    newQuantity = widget.initialQuantity;
    controller.text = newQuantity.toString();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(FocusNode());
      controller.selection = TextSelection.fromPosition(
        TextPosition(offset: controller.text.length),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(50),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: SingleChildScrollView(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 300),
          child: Wrap(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      widget.name,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          fontWeight: FontWeight.w500, fontSize: 20),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: TextField(
                        controller: controller,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        onChanged: (value) {
                          setState(() {
                            newQuantity = int.tryParse(value) ?? 1;
                            if (newQuantity < 1) {
                              errorMessage = 'Quantity must be at least 1';
                            } else if (newQuantity > 999) {
                              errorMessage = 'Quantity cannot exceed 999';
                            } else {
                              errorMessage = null;
                            }
                          });
                        },
                        focusNode: focusNode,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: errorMessage != null
                                  ? Colors.red
                                  : Colors.grey,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: errorMessage != null
                                  ? Colors.red
                                  : Colors.amber,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (errorMessage != null)
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          errorMessage!,
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 16, 0, 0),
                      child: GestureDetector(
                        onTap: () {
                          if (errorMessage == null) {
                            widget.onQuantityChanged(newQuantity);
                            Navigator.of(context).pop();
                          }
                        },
                        child: Container(
                          height: 50,
                          alignment: Alignment.center,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: errorMessage != null
                                ? Colors.grey[400]
                                : Colors.amber,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(8)),
                          ),
                          child: const Text(
                            'Submit',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
