import 'package:flutter/material.dart';
import 'package:study/services/rtdb_service.dart';
import 'package:study/widgets/profile_avatart.dart';

class ProfileInfo extends StatefulWidget {
  final String? displayName;
  final String? email;

  const ProfileInfo({super.key, this.displayName, this.email});

  @override
  State<ProfileInfo> createState() => _ProfileInfoState();
}

class _ProfileInfoState extends State<ProfileInfo> {
  final RTDBService _rtdbService = RTDBService();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();
  Map<String, dynamic>? _userInfo;

  @override
  void initState() {
    super.initState();
    _fetchUserInfo();
  }

  Future<void> _fetchUserInfo() async {
    final userInfo = await _rtdbService.getUserInformation();
    if (mounted) {
      setState(() {
        _userInfo = userInfo;
        _fullNameController.text = userInfo?['fullName'] ?? '';
        _dateOfBirthController.text = userInfo?['dateOfBirth'] ?? '';
      });
    }
  }

  Future<void> _updateUserInfo() async {
    await _rtdbService.updateUserInfoToRTDB(
      _userInfo?['displayName'],
      _fullNameController.text,
      _userInfo?['dateOfBirth'],
    );
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Updated successfully')));
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _dateOfBirthController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_userInfo == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const ProfileAvatart(),
          const SizedBox(height: 20),
          Center(
            child: Text(
              _userInfo!['displayName'] ?? 'UserName',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 30),
          _buildSectionHeader('Basic Information', _updateUserInfo),
          const SizedBox(height: 10),
          _buildTextField('Full Name', _fullNameController),
          const SizedBox(height: 10),
          _buildDatePickerField('Date of Birth', _dateOfBirthController),
          const SizedBox(height: 30),
          _buildSectionHeader('About Me', () {}),
          const SizedBox(height: 10),
          const Text(
            'Bahay Kubo, Kahit Maliit na gagamba umakyat sa sanga',
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, VoidCallback onPressed) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        TextButton(onPressed: onPressed, child: const Text('Update')),
      ],
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      style: const TextStyle(fontSize: 16),
    );
  }

  Widget _buildDatePickerField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      onTap: () async {
        DateTime? selectedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.tryParse(controller.text) ?? DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime(2100),
        );
        if (selectedDate != null) {
          setState(() {
            controller.text = selectedDate.toIso8601String();
            _userInfo?['dateOfBirth'] = selectedDate.toIso8601String();
          });
        }
      },
    );
  }
}
