import 'package:flutter/material.dart';
import '../services/api_service.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final ApiService apiService = ApiService();
  List<dynamic> availableFandoms = [];
  List<dynamic> selectedFandoms = [];

  @override
  void initState() {
    super.initState();
    fetchFandoms();
  }

  void fetchFandoms() async {
    try {
      final fetchedFandoms = await apiService.fetchFandoms();
      setState(() {
        availableFandoms = fetchedFandoms;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Error al cargar fandoms'),
        backgroundColor: Colors.red,
      ));
    }
  }

  void toggleFandomSelection(dynamic fandom) {
    setState(() {
      if (selectedFandoms.contains(fandom)) {
        selectedFandoms.remove(fandom);
        availableFandoms.add(fandom);
      } else {
        selectedFandoms.add(fandom);
        availableFandoms.remove(fandom);
      }
    });
  }

  void registerUser(BuildContext context) async {
    if (selectedFandoms.isEmpty ||
        nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Todos los campos son obligatorios'),
        backgroundColor: Colors.red,
      ));
      return;
    }

    try {
      final selectedFandomNames = selectedFandoms.map((f) => f['name']).join(', ');

      final response = await apiService.registerUser(
        nameController.text,
        emailController.text,
        passwordController.text,
        selectedFandomNames,
      );

      if (response['success']) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Registro exitoso'),
          backgroundColor: Colors.green,
        ));
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(response['error']),
          backgroundColor: Colors.red,
        ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Error al registrar usuario'),
        backgroundColor: Colors.red,
      ));
    }
  }

  void showFandomModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Selecciona tus Fandoms'),
          content: SizedBox(
            width: double.maxFinite,
            height: 400,
            child: availableFandoms.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
                childAspectRatio: 0.8,
              ),
              itemCount: availableFandoms.length,
              itemBuilder: (context, index) {
                final fandom = availableFandoms[index];
                return GestureDetector(
                  onTap: () => toggleFandomSelection(fandom),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 2.0),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          fandom['name'],
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10),
                        Expanded(
                          child: Image.network(
                            fandom['image_url'] ?? '',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.4,
            decoration: const BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(50),
                bottomRight: Radius.circular(50),
              ),
            ),
          ),
          Positioned(
            top: 40,
            left: 10,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const Text(
                      'REGISTER',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Name',
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: nameController,
                            decoration: const InputDecoration(
                              hintText: 'John Doe',
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Email',
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: emailController,
                            decoration: const InputDecoration(
                              hintText: 'example@gmail.com',
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            'Password',
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: passwordController,
                            obscureText: true,
                            decoration: const InputDecoration(
                              hintText: '********',
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          selectedFandoms.isNotEmpty
                              ? Wrap(
                            spacing: 8.0,
                            children: selectedFandoms.map((fandom) {
                              return Chip(
                                label: Text(fandom['name']),
                                deleteIcon: const Icon(Icons.close),
                                onDeleted: () => toggleFandomSelection(fandom),
                              );
                            }).toList(),
                          )
                              : const Text(
                            'No has seleccionado fandoms',
                            style: TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(height: 20),
                          Center(
                            child: Container(
                              width: double.infinity,
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF42A5F5),
                                    Color(0xFF1E88E5),
                                  ],
                                ),
                              ),
                              child: MaterialButton(
                                onPressed: () => showFandomModal(context),
                                child: const Text(
                                  'Seleccionar Fandoms',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Center(
                            child: Container(
                              width: double.infinity,
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF42A5F5),
                                    Color(0xFF1E88E5),
                                  ],
                                ),
                              ),
                              child: MaterialButton(
                                onPressed: () => registerUser(context),
                                child: const Text(
                                  'SIGNUP',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Center(
                            child: TextButton(
                              onPressed: () => Navigator.pushNamed(context, '/login'),
                              child: const Text(
                                'Already have an account? Sign In',
                                style: TextStyle(color: Colors.blue),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
