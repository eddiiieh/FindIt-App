import 'package:find_it/utils/screens/view_items_screen.dart';
import 'package:find_it/widgets/custom_bottom_navigation.dart';
import 'package:find_it/widgets/identity_card_item.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class CategoryScreen extends StatefulWidget {
  final String category;

  const CategoryScreen({Key? key, required this.category}) : super(key: key);

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final supabaseClient = Supabase.instance.client;
  List<Map<String, dynamic>> posts = [];
  List<Map<String, dynamic>> filteredPosts = [];
  bool isLoading = true;
  int itemCount = 0;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchItems();
  }

  Future<void> _fetchItems() async {
    setState(() => isLoading = true);
    try {
      final response = await supabaseClient
          .from('posts')
          .select()
          .eq('category', widget.category)
          .order('timestamp', ascending: false);

      setState(() {
        posts = List<Map<String, dynamic>>.from(response);
        filteredPosts = posts;
        itemCount = posts.length;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading posts: $e')),
      );
    }
  }

  void _filterSearchResults(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredPosts = posts;
      } else {
        filteredPosts = posts
            .where((post) =>
                post['title'].toLowerCase().contains(query.toLowerCase()) ||
                post['description'].toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
      itemCount = filteredPosts.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _fetchItems,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back button and title
              Padding(
                padding: const EdgeInsets.only(left: 15.0, top: 15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, size: 24, color: theme.colorScheme.onBackground),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(height: 0),
                    Padding(
                      padding: const EdgeInsets.only(left: 12.0),
                      child: Text(
                        widget.category, // Dynamic category title
                        style: GoogleFonts.poppins(
                          fontSize: 28.0,
                          fontWeight: FontWeight.w700,
                          color: theme.colorScheme.onBackground,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),

              // Search Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: TextField(
                  controller: _searchController,
                  onChanged: _filterSearchResults,
                  decoration: InputDecoration(
                    hintText: 'Search ${widget.category}...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  children: [
                    Text(
                      '$itemCount ${itemCount == 1 ? 'item' : 'items'} found',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: theme.colorScheme.onBackground,
                      ),
                    ),
                    const Spacer(),
                    Icon(Icons.filter_list, size: 20, color: theme.colorScheme.onBackground),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // List of Items
              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : filteredPosts.isEmpty
                        ? Center(
                            child: Text(
                              'No ${widget.category} found',
                              style: TextStyle(color: theme.colorScheme.onBackground),
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0),
                            itemCount: filteredPosts.length,
                            itemBuilder: (context, index) {
                              final post = filteredPosts[index];
                              return Column(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      // Navigate to ViewItemScreen with the postId
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ViewItemScreen(
                                          id: post['id'],
                                          title: post['title'],
                                          category: post['category'],
                                          status: post['status'],
                                          description: post['description'],
                                          imageUrl: post['image_url'],
                                          sourceName: post['source_name'],
                                          sourceId: post['source_id'] ?? post['user_id'] ?? '',
                                          sourceProfileImageUrl: post['source_profile_image_url'],  // Pass the postId dynamically
                                          ),
                                        ),
                                      );
                                    },
                                    child: IdentityCardItem(
                                      imageUrl: post['image_url'] ?? '',
                                      title: post['title'] ?? 'Untitled',
                                      description: post['description'] ?? 'No description provided',
                                      status: post['status'] ?? 'Unknown',
                                      isLost: post['status'] == 'Lost', 
                                      category: post['category'] ?? '',  // Replace with the actual category value from the post
                                      sourceName: post['source_name'] ?? '',  // Replace with the actual source name value from the post
                                      sourceId: post['source_id'] ?? post['user_id'] ?? '',
                                      contactName: post['contact_name'] ?? '',  // Replace with the actual contact name from the post
                                      contactNumber: post['contact_number'] ?? '',  // Replace with the actual contact number from the post
                                      sourceProfileImageUrl: post['source_profile_image_url'] ?? '', 
                                      id: post['id'],  // Replace with the actual source profile image URL from the post
                                    ),
                                  ),
                                  if (index < filteredPosts.length - 1) const SizedBox(height: 20),
                                ],
                              );
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigation(
        onHomePressed: () => Navigator.pushNamed(context, '/home'),
        onAddPressed: () => Navigator.pushNamed(context, '/post_item_screen'),
        onMessagePressed: () => Navigator.pushNamed(context, '/message_screen'),
        onSettingsPressed: () => Navigator.pushNamed(context, '/settings_screen'),
      ),
    );
  }
}
