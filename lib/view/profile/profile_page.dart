import 'package:avodha_interview_test/model/userModel/userModel.dart';
import 'package:avodha_interview_test/view/authPages/login_page.dart';
import 'package:avodha_interview_test/view/customWidget/toast.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _passwordController;

  late UserModel _user;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  void _loadUser() {
    final sessionBox = Hive.box("sessionBox");
    final email = sessionBox.get("email");

    final userBox = Hive.box("userBox");
    final userMap = userBox.get(email);

    if (userMap != null) {
      _user = UserModel.fromMap(Map<String, dynamic>.from(userMap));
    } else {
      _user = UserModel(name: '', phoneNo: 0, email: '', password: '');
    }

    _nameController = TextEditingController(text: _user.name);
    _phoneController = TextEditingController(text: _user.phoneNo.toString());
    _passwordController = TextEditingController(text: _user.password);
  }

  void _updateUser() async {
    final userBox = Hive.box("userBox");
    final sessionBox = Hive.box("sessionBox");
    final email = sessionBox.get("email");

    final updatedUser = _user.copyWith(
      name: _nameController.text,
      phoneNo: int.tryParse(_phoneController.text) ?? _user.phoneNo,
      password: _passwordController.text,
    );

    if (updatedUser.email != email) {
      await userBox.delete(email);
      sessionBox.put("email", updatedUser.email);
    }

    await userBox.put(updatedUser.email, updatedUser.toMap());

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Account updated successfully')),
    );

    setState(() {
      _user = updatedUser;
    });
  }

  void _logout() async {
    final sessionBox = Hive.box("sessionBox");
    await sessionBox.clear();
    Utils().showToast("logout Successfully");
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => LoginPage()),
    );
  }

  Widget _buildField({
    required String label,
    required TextEditingController controller,
    bool isPassword = false,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          prefixIcon: Icon(
            label == "Name"
                ? Icons.person
                : label == "Phone Number"
                ? Icons.phone
                : label == "Email"
                ? Icons.email
                : Icons.lock,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f5f5),
      appBar: AppBar(
        title: const Text("Account"),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(
            onPressed: _logout,
            icon: const Icon(Icons.logout),
            tooltip: "Logout",
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Profile card
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _buildField(label: "Name", controller: _nameController),
                      _buildField(
                        label: "Phone Number",
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                      ),

                      _buildField(
                        label: "Password",
                        controller: _passwordController,
                        isPassword: true,
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepPurple,
                          padding: const EdgeInsets.symmetric(
                            vertical: 14,
                            horizontal: 24,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: _updateUser,
                        child: const Text(
                          "Update Details",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 2,
              child: ListTile(
                leading: const Icon(Icons.logout, color: Colors.deepPurple),
                title: Text("Logout", style: TextStyle(color: Colors.black)),
                onTap: _logout,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
