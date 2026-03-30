import 'package:flutter/material.dart';
import '../models/post.dart';

class PostForm extends StatefulWidget {
  final Post? post;
  final Function(Post) onSubmit;

  const PostForm({
    Key? key,
    this.post,
    required this.onSubmit,
  }) : super(key: key);

  @override
  State<PostForm> createState() => _PostFormState();
}

class _PostFormState extends State<PostForm> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _titleController;
  late TextEditingController _bodyController;
  late TextEditingController _userNameController;
  late TextEditingController _userEmailController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.post?.title ?? '');
    _bodyController = TextEditingController(text: widget.post?.body ?? '');
    
    // For editing, we'll use empty values since we don't store user info
    _userNameController = TextEditingController();
    _userEmailController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    _userNameController.dispose();
    _userEmailController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Generate a random userId between 1 and 100 for new posts
      final userId = widget.post?.userId ?? 
          (DateTime.now().millisecondsSinceEpoch % 100 + 1).toInt();
      
      final post = Post(
        id: widget.post?.id,
        userId: userId,
        title: _titleController.text,
        body: _bodyController.text,
      );
      widget.onSubmit(post);
      
      if (widget.post == null) {
        // Only show this for new posts
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Post created by: ${_userNameController.text}'),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.post != null;
    final screenHeight = MediaQuery.of(context).size.height;
    final isApiPost = widget.post != null && 
        widget.post!.id != null && 
        widget.post!.id! > 0 && 
        widget.post!.id! <= 100;

    return Container(
      height: screenHeight * 0.75,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        color: Colors.white,
      ),
      child: Column(
        children: [
          // Handle bar for dragging
          Container(
            margin: const EdgeInsets.only(top: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 16,
                right: 16,
                top: 8,
              ),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Header
                      Text(
                        isEditing ? 'Edit Post' : 'Create New Post',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // For new posts only - show user fields
                      if (!isEditing) ...[
                        // User Name Field
                        TextFormField(
                          controller: _userNameController,
                          decoration: const InputDecoration(
                            labelText: 'Your Name',
                            hintText: 'Enter your full name',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.person, color: Colors.blue),
                            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // User Email Field
                        TextFormField(
                          controller: _userEmailController,
                          decoration: const InputDecoration(
                            labelText: 'Your Email',
                            hintText: 'Enter your email address',
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.email, color: Colors.blue),
                            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            if (!value.contains('@')) {
                              return 'Please enter a valid email';
                            }
                            return null;
                          },
                        ),
                        
                        const SizedBox(height: 16),
                        const Divider(),
                        const SizedBox(height: 8),
                      ],
                      
                      // Info message for editing
                      if (isEditing && isApiPost)
                        Container(
                          padding: const EdgeInsets.all(12),
                          margin: const EdgeInsets.only(bottom: 16),
                          decoration: BoxDecoration(
                            color: Colors.orange.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.orange.shade200),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.info_outline, color: Colors.orange.shade700, size: 20),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Editing an existing post from the API. Your changes will be saved locally.',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.orange.shade700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      
                      // Post Title Field
                      TextFormField(
                        controller: _titleController,
                        decoration: const InputDecoration(
                          labelText: 'Post Title',
                          hintText: 'Enter a title for your post',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.title, color: Colors.blue),
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                        ),
                        maxLines: 2,
                        minLines: 1,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter a title';
                          }
                          return null;
                        },
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Post Body Field
                      TextFormField(
                        controller: _bodyController,
                        decoration: const InputDecoration(
                          labelText: 'Post Content',
                          hintText: 'Write your post content here...',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.description, color: Colors.blue),
                          alignLabelWithHint: true,
                          contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                        ),
                        maxLines: 6,
                        minLines: 4,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the post content';
                          }
                          return null;
                        },
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Action Buttons
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => Navigator.pop(context),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                side: BorderSide(color: Colors.grey.shade400),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text(
                                'Cancel',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _submitForm,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: Text(
                                isEditing ? 'Update Post' : 'Create Post',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Info note for new posts
                      if (!isEditing)
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.info, size: 16, color: Colors.blue.shade700),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  'Your post will be added to the list with your name and email',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.blue.shade700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}