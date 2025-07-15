import 'package:find_it/utils/screens/view_items_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:uuid/uuid.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

class PostItemScreen extends StatefulWidget {
  const PostItemScreen({Key? key}) : super(key: key);

  @override
  State<PostItemScreen> createState() => _PostItemScreenState();
}

class _PostItemScreenState extends State<PostItemScreen> {
  final supabaseClient = supabase.Supabase.instance.client;

  Widget _buildInputField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(labelText: label, border: OutlineInputBorder()),
    );
  }

  Widget _buildDropdownField(String label, List<String> options, Function(String?) onChanged) {
    return DropdownButtonFormField(
      decoration: InputDecoration(labelText: label, border: OutlineInputBorder()),
      items: options.map((option) => DropdownMenuItem(value: option, child: Text(option))).toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildLargeInputField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      maxLines: 5,
      decoration: InputDecoration(labelText: label, border: OutlineInputBorder()),
    );
  }

  File? _image;
  final picker = ImagePicker();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String? selectedCategory;
  String? selectedStatus;
  bool isPosting = false;

  final List<String> categories = ['ID Cards', 'Documents', 'Electronics', 'Personal Items', 'Keys', 'Bags & Accessories', 'Sports gear', 'Other'];
  final List<String> statuses = ['Lost', 'Found'];

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _image = File(pickedFile.path));
    }
  }

  Future<String> _uploadImage(File image) async {
    try {
      final fileName = '${const Uuid().v4()}.jpg';
      final filePath = 'images/$fileName';

      // Upload the file
      await supabaseClient.storage.from('images').upload(filePath, image);

      // Get the public URL of the uploaded image
      final imageUrl = await supabaseClient.storage.from('images').getPublicUrl(filePath);
      
      return imageUrl;
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }

  Future<void> _postItem() async {
  final firebaseUser = FirebaseAuth.instance.currentUser;
  final supabaseUser = supabaseClient.auth.currentUser;

  if (firebaseUser == null && supabaseUser == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('You must be logged in to post an item.')),
    );
    return;
  }

  setState(() => isPosting = true);

  try {
    final currentUser = supabaseClient.auth.currentUser;
    if (currentUser == null) throw Exception('Supabase session not active');

    // Fetch user details from the 'users' table
    final userDataResponse = await supabaseClient
        .from('users')
        .select('name, profile_image_url')
        .eq('id', currentUser.id)
        .single();

    final String userName = userDataResponse['name'] as String? ?? 'Unknown User';
    final String userProfileImageUrl = userDataResponse['profile_image_url'] as String? ?? 'default_image_url';

    // Upload image (if exists)
    String? imageUrl;
    if (_image != null) {
      imageUrl = await _uploadImage(_image!);
    }

    // Insert post
    final response = await supabaseClient.from('posts').insert({
      'title': _titleController.text,
      'description': _descriptionController.text,
      'category': selectedCategory,
      'status': selectedStatus,
      'image_url': imageUrl,
      'user_id': currentUser.id,
      'timestamp': DateTime.now().toIso8601String(),
      'source_name': userName, // Use the name fetched from 'users' table
      'source_profile_image_url': userProfileImageUrl, // Use the URL fetched from 'users' table
    }).select('id').single();

    // Extract post ID from the response
    final id = response['id'];

    // Store the values before clearing for navigation
    final String postedTitle = _titleController.text;
    final String postedDescription = _descriptionController.text;
    final String postedCategory = selectedCategory ?? '';
    final String postedStatus = selectedStatus ?? '';
    final String postedImageUrl = imageUrl ?? '';


    // Clear form
    _titleController.clear();
    _descriptionController.clear();
    setState(() {
      _image = null;
      selectedCategory = null;
      selectedStatus = null;
    });


    // Navigate to ViewItemScreen with the necessary data
    // Use the stored values here
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ViewItemScreen(
          title: postedTitle,
          category: postedCategory,
          status: postedStatus,
          description: postedDescription,
          imageUrl: postedImageUrl,
          sourceName: userName,
          sourceId: currentUser.id,
          sourceProfileImageUrl: userProfileImageUrl,
          id: id,
        ),
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Item posted successfully!')),
    );

  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: ${e.toString()}')),
    );
  } finally {
    if (mounted) setState(() => isPosting = false);
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 34.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
            ),
            Text('Post an Item', style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w700)),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 250,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceVariant,
                  border: Border.all(color: Theme.of(context).primaryColor, width: 1),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: _image == null
                    ? const Center(child: Icon(Icons.add, size: 50, color: Colors.black54))
                    : Image.file(_image!, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(height: 20),
            _buildInputField('Title', _titleController),
            const SizedBox(height: 20),
            _buildDropdownField('Category', categories, (value) => setState(() => selectedCategory = value)),
            const SizedBox(height: 20),
            _buildDropdownField('Status', statuses, (value) => setState(() => selectedStatus = value)),
            const SizedBox(height: 20),
            _buildLargeInputField('Description', _descriptionController),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: isPosting ? null : _postItem,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                    ),
                    child: isPosting
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text('Post', style: GoogleFonts.poppins(fontSize: 14, color: Colors.white)),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Cancel', style: GoogleFonts.poppins(fontSize: 14)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
