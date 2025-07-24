import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import 'package:order_tracking/const.dart';
import 'package:order_tracking/widgets/custom_loading_overlay.dart';


class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final storage = FlutterSecureStorage();

  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _streetAddressController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _zipCodeController = TextEditingController();

  String _country = 'Morocco';
  File? _imageFile;
  Uint8List? _profileImageBytes;
  final picker = ImagePicker();

  final String _profileUrl = '$baseUrl/user/profile';
  final String _updateUrl = '$baseUrl/user/profile';

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initAnimation();
    _loadUserData();
  }

  void _initAnimation() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(
          CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
        );
  }

  Future<void> _loadUserData() async {
    final token = await storage.read(key: 'jwt');
    if (token == null) return;

    final response = await http.get(
      Uri.parse(_profileUrl),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      _usernameController.text = data['username'] ?? '';
      _emailController.text = data['email'] ?? '';
      _phoneController.text = data['phone'] ?? '';
      _streetAddressController.text = data['streetAddress'] ?? '';
      _cityController.text = data['city'] ?? '';
      _stateController.text = data['state'] ?? '';
      _zipCodeController.text = data['zipCode'] ?? '';
      _country = data['country'] ?? 'Morocco';

      if (data['profileImageUrl'] != null) {
        final fullUrl = '$ipadress${data['profileImageUrl']}';
        final imageBytes = await _loadProtectedImage(fullUrl);
        if (imageBytes != null) {
          _profileImageBytes = imageBytes;
        }
      }

      setState(() => _isLoading = false);
      _animationController.forward();
    } else {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load profile data')),
      );
    }
  }

  Future<Uint8List?> _loadProtectedImage(String url) async {
    final token = await storage.read(key: 'jwt');
    final response = await http.get(
      Uri.parse(url),
      headers: {'Authorization': 'Bearer $token'},
    );
    return response.statusCode == 200 ? response.bodyBytes : null;
  }

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) return;

    final token = await storage.read(key: 'jwt');
    if (token == null) return;

    final request = http.MultipartRequest('PUT', Uri.parse(_updateUrl));
    request.headers['Authorization'] = 'Bearer $token';

    request.fields['phone'] = _phoneController.text;
    request.fields['streetAddress'] = _streetAddressController.text;
    request.fields['city'] = _cityController.text;
    request.fields['state'] = _stateController.text;
    request.fields['zipCode'] = _zipCodeController.text;
    request.fields['country'] = _country;

    if (_imageFile != null) {
      final mimeType = lookupMimeType(_imageFile!.path) ?? 'image/jpeg';
      final mediaType = MediaType.parse(mimeType);
      request.files.add(
        await http.MultipartFile.fromPath(
          'profileImage',
          _imageFile!.path,
          contentType: mediaType,
        ),
      );
    }

    try {
      final response = await request.send();
      final responseBody = await http.Response.fromStream(response);

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully')),
        );
        _loadUserData();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update profile')),
        );
        print(responseBody.body);
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  Widget _buildAvatar() {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Center(
          child: Stack(
            children: [
              _imageFile != null
                  ? CircleAvatar(
                      radius: 45,
                      backgroundImage: FileImage(_imageFile!),
                    )
                  : (_profileImageBytes != null
                        ? CircleAvatar(
                            radius: 45,
                            backgroundImage: MemoryImage(_profileImageBytes!),
                          )
                        : CircleAvatar(
                            radius: 45,
                            backgroundColor: maincolor,
                            child: Text(
                              _usernameController.text.isNotEmpty
                                  ? _usernameController.text
                                        .substring(0, 2)
                                        .toUpperCase()
                                  : '',
                              style: const TextStyle(
                                fontSize: 24,
                                color: Colors.white,
                              ),
                            ),
                          )),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: maincolor, width: 2),
                    ),
                    padding: const EdgeInsets.all(4),
                    child: Icon(Icons.edit, size: 20, color: maincolor),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _readOnlyField(TextEditingController controller, String label) {
    return TextFormField(
      controller: controller,
      enabled: false,
      decoration: InputDecoration(labelText: label),
    );
  }

  Widget _editableField(TextEditingController controller, String label) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(labelText: label),
      validator: (value) => value!.isEmpty ? 'Enter $label' : null,
    );
  }

  Widget _buildCard(List<Widget> children) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: Colors.grey.shade300),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(children: children),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _isLoading
          ? const CustomLoadingOverlay()
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 0,
                        left: 10,
                        right: 0,
                        bottom: 0,
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 0),
                              child: IconButton(
                                icon: const Icon(Icons.arrow_back),
                                onPressed: () => Navigator.pop(context),
                              ),
                            ),
                          ),
                          const Center(
                            child: Text(
                              "Edit Profile",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              _buildAvatar(),
                              const SizedBox(height: 10),
                              const Text(
                                'Tap the icon to change your profile photo',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 20),
                              _buildCard([
                                _readOnlyField(_usernameController, "Username"),
                                _readOnlyField(_emailController, "Email"),
                              ]),
                              const SizedBox(height: 16),
                              _buildCard([
                                _editableField(_phoneController, "Phone"),
                                _editableField(
                                  _streetAddressController,
                                  "Street Address",
                                ),
                                _editableField(_cityController, "City"),
                                _editableField(_stateController, "State"),
                                _editableField(_zipCodeController, "ZIP Code"),
                                DropdownButtonFormField<String>(
                                  value: _country,
                                  decoration: const InputDecoration(
                                    labelText: 'Country',
                                  ),
                                  items: ['Morocco', 'France', 'United States']
                                      .map(
                                        (c) => DropdownMenuItem(
                                          value: c,
                                          child: Text(c),
                                        ),
                                      )
                                      .toList(),
                                  onChanged: (val) =>
                                      setState(() => _country = val!),
                                ),
                              ]),
                              const SizedBox(height: 20),
                              FadeTransition(
                                opacity: _fadeAnimation,
                                child: SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: _updateProfile,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: maincolor,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 14,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: const Text(
                                      'Save Changes',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
