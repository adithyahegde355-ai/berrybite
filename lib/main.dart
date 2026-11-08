class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> _indianDishes = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    try {
      final resIndian = await http.get(Uri.parse('https://www.themealdb.com/api/json/v1/1/filter.php?a=Indian'));
      if (resIndian.statusCode == 200) {
        final data = jsonDecode(resIndian.body);
        setState(() {
          _indianDishes = data['meals'] ?? [];
          _loading = false;
        });
      } else {
        setState(() => _loading = false);
      }
    } catch (e) {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFF8F5),
        elevation: 0,
        title: Row(
          children: const [
            Text("🍓 ", style: TextStyle(fontSize: 24)),
            Text("BerryBite", style: TextStyle(color: Color(0xFF49323A), fontWeight: FontWeight.bold, fontSize: 22)),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text("Namaste, User 👋", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF49323A))),
          const Text("A little inspiration for every bite.", style: TextStyle(color: Color(0xFF927D83), fontSize: 14)),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFF9DCE3)),
            ),
            child: const TextField(
              decoration: InputDecoration(
                icon: Icon(Icons.search, color: Color(0xFFC95675)),
                hintText: "What are you craving today?",
                border: InputBorder.none,
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text("Authentic Indian Cuisine 🍛", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF49323A))),
          const SizedBox(height: 12),
          _loading
              ? const Center(child: Padding(padding: EdgeInsets.all(20.0), child: CircularProgressIndicator(color: Color(0xFFC95675))))
              : _indianDishes.isEmpty
                  ? const Text("No dishes found. Check internet connection.", style: TextStyle(color: Color(0xFF927D83)))
                  : SizedBox(
                      height: 200,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _indianDishes.length,
                        itemBuilder: (context, index) {
                          final item = _indianDishes[index];
                          return GestureDetector(
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => RecipeDetailScreen(mealId: item['idMeal']))),
                            child: Container(
                              width: 150,
                              margin: const EdgeInsets.only(right: 12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: const Color(0xFFF9DCE3)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                                    child: Image.network(
                                      item['strMealThumb'],
                                      height: 120,
                                      width: 150,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) => Container(
                                        height: 120,
                                        width: 150,
                                        color: Colors.grey[200],
                                        child: const Icon(Icons.broken_image, color: Colors.grey),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      item['strMeal'],
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF49323A)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
        ],
      ),
    );
  }
}
),
              ],
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: _ingredients.map((ing) => Chip(
                label: Text(ing),
                backgroundColor: const Color(0xFFF9DCE3),
                onDeleted: () => setState(() => _ingredients.remove(ing)),
              )).toList(),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _searchRecipes,
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFC95675)),
              child: const Text("Find Recipes", style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _matchingRecipes.length,
                itemBuilder: (context, index) {
                  final recipe = _matchingRecipes[index];
                  return ListTile(
                    leading: Image.network(recipe['strMealThumb'], width: 50, height: 50, fit: BoxFit.cover),
                    title: Text(recipe['strMeal']),
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => RecipeDetailScreen(mealId: recipe['idMeal']))),
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

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: Text("Explore Cuisines")));
}

class SavedScreen extends StatelessWidget {
  const SavedScreen({super.key});
  @override
  Widget build(BuildContext context) => const Scaffold(body: Center(child: Text("Saved Recipes")));
}

class ProfileScreen extends StatelessWidget {
  final String userName;
  final Function(String) onNameChanged;
  const ProfileScreen({super.key, required this.userName, required this.onNameChanged});
  @override
  Widget build(BuildContext context) => Scaffold(body: Center(child: Text("Profile: $userName")));
}

class RecipeDetailScreen extends StatelessWidget {
  final String mealId;
  const RecipeDetailScreen({super.key, required this.mealId});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: const Text("Recipe Details")), body: Center(child: Text("Meal ID: $mealId")));
}
