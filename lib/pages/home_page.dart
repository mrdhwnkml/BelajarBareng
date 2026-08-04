import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'login_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final postController = TextEditingController();

  Future<void> addPost() async {
    try {
      if (postController.text.trim().isEmpty) {
        return;
      }

      final supabase = Supabase.instance.client;

      final user = supabase.auth.currentUser;

      if (user == null) {
        return;
      }

      final profile = await supabase
          .from('profiles')
          .select('username')
          .eq('id', user.id)
          .maybeSingle();

      if (profile == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Profile username tidak ditemukan."),
            backgroundColor: Colors.red,
          ),
        );

        return;
      }

      await supabase.from('posts').insert({
        'user_id': user.id,
        'username': profile['username'],
        'content': postController.text.trim(),
      });

      postController.clear();

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Post berhasil")));

      setState(() {});
    } catch (e) {
      print(e);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
      );
    }
  }

  Future<List<Map<String, dynamic>>> getPosts() async {
    final response = await Supabase.instance.client
        .from('posts')
        .select('id, username, content, created_at')
        .order('created_at', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE2E8F0),
      appBar: AppBar(
        backgroundColor: const Color(0xFF3B82F6),
        foregroundColor: Colors.white,
        elevation: 0,

        title: const Row(
          children: [
            SizedBox(width: 8),
            Text(
              "Belajar Bareng",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),

        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await Supabase.instance.client.auth.signOut();

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const LoginPage()),
              );
            },
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [
            Card(
              color: Colors.white,
              elevation: 6,
              shadowColor: Colors.black12,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: const [
                        CircleAvatar(
                          radius: 22,
                          backgroundColor: Color(0xFF3B82F6),
                          child: Icon(Icons.person, color: Colors.white),
                        ),

                        SizedBox(width: 12),

                        Text(
                          "Buat Postingan",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 15),

                    TextField(
                      controller: postController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: "Apa yang kamu pikirkan hari ini?",
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: addPost,
                        icon: const Icon(Icons.send),
                        label: const Text("Posting"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF3B82F6),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
            ),

            const SizedBox(height: 20),

            Expanded(
              child: FutureBuilder(
                future: getPosts(),

                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text("Belum ada postingan"));
                  }

                  final posts = snapshot.data!;

                  return ListView.builder(
                    itemCount: posts.length,

                    itemBuilder: (context, index) {
                      final post = posts[index];

                      return Card(
                        elevation: 3,

                        margin: const EdgeInsets.only(bottom: 12),

                        child: Padding(
                          padding: const EdgeInsets.all(15),

                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,

                            children: [
                              Text(
                                post['username'] ?? 'Unknown',
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF3B82F6),
                                ),
                              ),

                              const SizedBox(height: 8),

                              Text(
                                post['content'],
                                style: const TextStyle(fontSize: 16),
                              ),

                              const SizedBox(height: 10),

                              Text(
                                post['created_at'].toString(),

                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
