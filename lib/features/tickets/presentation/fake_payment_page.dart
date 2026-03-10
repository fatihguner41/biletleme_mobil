import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ticketing/features/auth/presentation/auth_gate.dart';

class FakePaymentPage extends StatefulWidget {
  final String eventId;
  final String eventName;

  const FakePaymentPage({
    super.key,
    required this.eventId,
    required this.eventName,
  });

  @override
  State<FakePaymentPage> createState() => _FakePaymentPageState();
}

class _FakePaymentPageState extends State<FakePaymentPage> {
  final cardNo = TextEditingController();
  final expiryMonth = TextEditingController();
  final expiryYear = TextEditingController();
  final cvv = TextEditingController();

  bool loading = false;

  @override
  void dispose() {
    cardNo.dispose();
    expiryMonth.dispose();
    expiryYear.dispose();
    cvv.dispose();
    super.dispose();
  }

  bool _validate() {
    final c = cardNo.text.replaceAll(' ', '');
    final eMonth = expiryMonth.text.trim();
    final eYear = expiryYear.text.trim();
    final v = cvv.text.trim();

    if (c.length != 16) return false;
    if (!RegExp(r'^\d{16}$').hasMatch(c)) return false;

    if (!RegExp(r'^\d{2}$').hasMatch(eMonth)) return false;
    if (!RegExp(r'^\d{2}$').hasMatch(eYear)) return false;

    if (!RegExp(r'^\d{3}$').hasMatch(v)) return false;

    return true;
  }

  Future<void> _pay() async {
    if (!_validate()) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Payment info invalid')));
      return;
    }

    setState(() => loading = true);
    await Future.delayed(const Duration(milliseconds: 700));
    setState(() => loading = false);

    if (!mounted) return;

    // şimdilik sadece success dön
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Payment')),
      body: AuthGate(
        title: 'Payment',
        message: 'Please login to pay for this event.',
        child: AbsorbPointer(
          absorbing: loading,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  widget.eventName,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: cardNo,
                  decoration: const InputDecoration(
                    labelText: 'Card Number (16 digits)',
                    counterText: '',
                  ),
                  keyboardType: TextInputType.number,
                  maxLength: 16,
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: expiryMonth,
                        decoration: const InputDecoration(
                          labelText: 'MM',
                          counterText: '',
                        ),
                        keyboardType: TextInputType.number,
                        maxLength: 2,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        "/",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        controller: expiryYear,
                        decoration: const InputDecoration(
                          labelText: 'YY',
                          counterText: '',
                        ),
                        keyboardType: TextInputType.number,
                        maxLength: 2,
                      ),
                    ),
                  ],
                ),


                TextField(
                  controller: cvv,
                  decoration: const InputDecoration(
                    labelText: 'CVV (3 digits)',
                    counterText: '',
                  ),
                  keyboardType: TextInputType.number,
                  maxLength: 3,
                  obscureText: true,
                ),
                const SizedBox(height: 30),
                ElevatedButton(onPressed: _pay, child: const Text('Pay')),
                if (loading)
                  const Padding(
                    padding: EdgeInsets.only(top: 12),
                    child: CircularProgressIndicator(),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
