import 'package:flutter/material.dart';
import '../services/api_service.dart';

class LoginScreen extends StatelessWidget {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final ApiService apiService = ApiService();

  void loginUser(BuildContext context) async {
    try {
      final response = await apiService.loginUser(
        emailController.text,
        passwordController.text,
      );

      if (response['success']) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Inicio de sesión exitoso'),
          backgroundColor: Colors.green,
        ));
        Navigator.pushNamed(context, '/home');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(response['error']),
          backgroundColor: Colors.red,
        ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error al iniciar sesión: $e'),
        backgroundColor: Colors.red,
      ));
    }
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
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Título principal
                    const Text(
                      'LOGIN',
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Contenedor blanco
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
                          // Campo de correo electrónico
                          const Text(
                            'Username',
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: emailController,
                            decoration: InputDecoration(
                              hintText: 'example@email.com',
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
                            decoration: InputDecoration(
                              hintText: '********',
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.blue),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),

                          const SizedBox(height: 20),
                          Center(
                            child: Container(
                              width: double.infinity,
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF42A5F5), // Azul claro
                                    Color(0xFF1E88E5), // Azul oscuro
                                  ],
                                ),
                              ),
                              child: MaterialButton(
                                onPressed: () => loginUser(context),
                                child: const Text(
                                  'LOGIN',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Center(
                            child: TextButton(
                              onPressed: () =>
                                  Navigator.pushNamed(context, '/register'),
                              child: const Text(
                                'Don\'t have an account? Register here',
                                style: TextStyle(
                                  color: Colors.blue,
                                ),
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
