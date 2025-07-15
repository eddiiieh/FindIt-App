import 'package:find_it/utils/screens/conversation_screen.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

class ViewItemScreen extends StatefulWidget {
  final String id;
  final String title;
  final String category;
  final String status;
  final String description;
  final String imageUrl;
  final String sourceName;
  final String sourceId;
  final String sourceProfileImageUrl;

  const ViewItemScreen({
    Key? key,
    required this.id,
    required this.title,
    required this.category,
    required this.status,
    required this.description,
    required this.imageUrl,
    required this.sourceName,
    required this.sourceId,
    required this.sourceProfileImageUrl,
  }) : super(key: key);

  @override
  _ViewItemScreenState createState() => _ViewItemScreenState();
}

class _ViewItemScreenState extends State<ViewItemScreen> {
  final supabaseClient = supabase.Supabase.instance.client;
  bool isLoading = false;
  late String title, category, status, description, imageUrl, sourceName, sourceProfileImageUrl;

  @override
  void initState() {
    super.initState();
    // You can initialize the state with the passed data
    title = widget.title;
    category = widget.category;
    status = widget.status;
    description = widget.description;
    imageUrl = widget.imageUrl;
    sourceName = widget.sourceName;
    sourceProfileImageUrl = widget.sourceProfileImageUrl;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final contentPadding = EdgeInsets.symmetric(horizontal: screenWidth * 0.04);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      padding: contentPadding,
                      width: double.infinity,
                      constraints: const BoxConstraints(maxWidth: 480),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.arrow_back,
                                  color: isDarkMode ? Colors.white : Colors.black,
                                ),
                                onPressed: () => Navigator.of(context).pop(),
                                padding: EdgeInsets.zero,
                                constraints: const BoxConstraints(),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Item Details',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                  color: isDarkMode ? Colors.white : Colors.black,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 20),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: isDarkMode
                                      ? Colors.white.withOpacity(0.1)
                                      : Colors.black.withOpacity(0.25),
                                  blurRadius: 4,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: AspectRatio(
                                aspectRatio: 1.52,
                                child: Image.network(
                                  imageUrl,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            title,
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: isDarkMode ? Colors.white : Colors.black,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            'Category: $category',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              color: isDarkMode ? Colors.white70 : Colors.black,
                            ),
                          ),
                          const SizedBox(height: 9),
                          Text(
                            'Status: $status',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              color: isDarkMode ? Colors.greenAccent : Colors.black,
                            ),
                          ),
                          Divider(
                            thickness: 1,
                            color: isDarkMode
                                ? Colors.white.withOpacity(0.35)
                                : const Color.fromRGBO(24, 23, 23, 0.35),
                          ),
                          const SizedBox(height: 0),
                          Text(
                            'Description',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: isDarkMode ? Colors.white : Colors.black,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            description,
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 15,
                              fontWeight: FontWeight.w300,
                              color: isDarkMode ? Colors.white70 : Colors.black,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Divider(
                            thickness: 1,
                            color: isDarkMode
                                ? Colors.white.withOpacity(0.35)
                                : const Color.fromRGBO(24, 23, 23, 0.35),
                          ),

                          // Source and Contact Section
                          Container(
                            margin: const EdgeInsets.only(top: 5.0),
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Source and Profile
                                Row(
                                  children: [
                                    // Source Column
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Source',
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                            color: isDarkMode
                                                ? Colors.white70
                                                : Colors.black,
                                          ),
                                        ),
                                        Container(
                                          margin: const EdgeInsets.only(top: 15.0),
                                          width: 50,
                                          height: 50,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.circular(25),
                                            child: Image.network(
                                              sourceProfileImageUrl,
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(width: 10), 

                                    // Contact Info
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        const SizedBox(height: 30),
                                        Text(
                                          sourceName,
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: isDarkMode ? Colors.white : Colors.black,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                      ],
                                    ),
                                  ],
                                ),

                                // Message Button
                                Container(
                                  margin: const EdgeInsets.only(top: 40.0),
                                  padding: const EdgeInsets.all(9),
                                  decoration: BoxDecoration(
                                    color: isDarkMode
                                        ? Colors.grey[800]
                                        : const Color.fromRGBO(194, 189, 198, 0.5),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ConversationScreen(
                                                userName: sourceName,
                                                userId: widget.sourceId, 
                                                sourceProfileImageUrl: widget.sourceProfileImageUrl,                                             
                                                ),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      'Message me',
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: isDarkMode ? Colors.white : Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 70),
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
