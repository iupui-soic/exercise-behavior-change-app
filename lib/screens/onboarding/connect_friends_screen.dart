import 'package:flutter/material.dart';
import '../../widgets/app_button.dart';
import '../dashboard/dashboard_screen.dart';

class ConnectFriendsScreen extends StatefulWidget {
  const ConnectFriendsScreen({Key? key}) : super(key: key);

  @override
  _ConnectFriendsScreenState createState() => _ConnectFriendsScreenState();
}

class _ConnectFriendsScreenState extends State<ConnectFriendsScreen> {
  final TextEditingController _emailController = TextEditingController();
  List<String> invitedEmails = [];

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Connect with your friends',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40.0),

            const Text(
              'Invite friends and compare your progress',
              style: TextStyle(fontSize: 16.0, fontFamily: 'Outfit'),
            ),
            const SizedBox(height: 20.0),

            // Email invite field
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      hintText: 'Enter email',
                      hintStyle: const TextStyle(color: Colors.white),
                      filled: true,
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      suffixIcon: Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: TextButton(
                          onPressed: _sendInvite,
                          child: const Text(
                            'Send Invite',
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an email';
                      }
                      if (!value.contains('@') || !value.contains('.')) {
                        return 'Invalid email';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20.0),

            // List of invited friends (shown if any invites were sent)
            if (invitedEmails.isNotEmpty) ...[
              const Text(
                'Invited Friends:',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10.0),
              Expanded(
                child: ListView.builder(
                  itemCount: invitedEmails.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(invitedEmails[index]),
                      trailing: const Icon(Icons.check_circle, color: Colors.green),
                    );
                  },
                ),
              ),
            ] else ...[
              const Spacer(),
            ],

            // Finish button
            AppButton(
              text: 'Finish',
              onPressed: () {
                // Complete onboarding and navigate to dashboard
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const DashboardScreen()),
                      (route) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  void _sendInvite() {
    final email = _emailController.text.trim();

    if (email.isNotEmpty && email.contains('@') && email.contains('.')) {
      setState(() {
        invitedEmails.add(email);
        _emailController.clear();
      });

      // Show confirmation
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invitation sent to $email')),
      );
    } else {
      // Show error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid email address')),
      );
    }
  }
}