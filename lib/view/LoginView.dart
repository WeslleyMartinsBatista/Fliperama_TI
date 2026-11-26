import 'package:flutter/material.dart';
import 'package:fliperama_ti/controller/LoginController.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _loginFieldController = TextEditingController();
  final _passwordController = TextEditingController();
  late final LoginController _loginController;

  late final AnimationController _bgController;
  late final Animation<Alignment> _beginAlignment;
  late final Animation<Alignment> _endAlignment;

  bool _obscurePassword = true;

  // Paleta nostálgica de fliperama: roxo profundo de CRT, magenta neon e ciano retrô
  static const List<Color> _arcadeGradientColors = [
    Color(0xFF0B0718), // Fundo escuro estilo gabinete / monitor CRT
    Color(0xFF2A0B4E), // Roxo arcade clássico
    Color(0xFF9E1B64), // Magenta/pink retrô
    Color(0xFF00A8CC), // Ciano neon dos anos 80/90
  ];

  @override
  void initState() {
    super.initState();
    _loginController = LoginController();

    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat(reverse: true);

    final curvedAnimation = CurvedAnimation(
      parent: _bgController,
      curve: Curves.easeInOut,
    );

    _beginAlignment = AlignmentTween(
      begin: Alignment.topLeft,
      end: Alignment.bottomLeft,
    ).animate(curvedAnimation);

    _endAlignment = AlignmentTween(
      begin: Alignment.bottomRight,
      end: Alignment.topRight,
    ).animate(curvedAnimation);
  }

  @override
  void dispose() {
    _loginController.dispose();
    _bgController.dispose();
    _loginFieldController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    final success = await _loginController.login(
      login: _loginFieldController.text,
      password: _passwordController.text,
    );

    if (!mounted) return;

    if (success) {
      final colaborador = _loginController.authenticatedColaborador!;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'PLAYER 1 READY  ${colaborador.nomeCompleto.toUpperCase()} (${colaborador.perfilNome.toUpperCase()})',
          ),
          backgroundColor: const Color(0xFF00E5FF),
          behavior: SnackBarBehavior.floating,
        ),
      );

      // switch (colaborador.perfilNome) {
      //   case 'caixa': ...
      //   case 'gerente': ...
      //   case 'tecnico': ...
      //   case 'administrador': ...
      // }
    } else if (_loginController.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_loginController.errorMessage!),
          backgroundColor: Colors.red.shade700,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _bgController,
        builder: (context, child) {
          return Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: _beginAlignment.value,
                end: _endAlignment.value,
                colors: _arcadeGradientColors,
                stops: const [0.0, 0.42, 0.78, 1.0],
              ),
            ),
            child: child,
          );
        },
        // Passar o Center/Form como `child` evita reconstruir o card a cada frame
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Card(
                elevation: 12,
                color: const Color(0xFF140D26).withValues(alpha: 0.92),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(
                    color: const Color(0xFF00E5FF).withValues(alpha: 0.45),
                    width: 1.2,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Icon(
                          Icons.sports_esports_rounded,
                          size: 56,
                          color: Color(0xFFFF2A85),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'ARCADE SYSTEM',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineSmall
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                letterSpacing: 2.0,
                                color: const Color(0xFF00E5FF),
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Insira suas credenciais para iniciar',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: Colors.white70),
                        ),
                        const SizedBox(height: 32),
                        TextFormField(
                          controller: _loginFieldController,
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            labelText: 'Login',
                            hintText: 'user.perfil',
                            prefixIcon: const Icon(
                              Icons.person_outline,
                              color: Color(0xFFFFE600),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Por favor, digite seu login';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (_) => _handleLogin(),
                          decoration: InputDecoration(
                            labelText: 'Senha',
                            prefixIcon: const Icon(
                              Icons.key_outlined,
                              color: Color(0xFFFFE600),
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Por favor, digite sua senha';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {},
                            child: const Text(
                              'Esqueceu a senha?',
                              style: TextStyle(color: Color(0xFF00E5FF)),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        ListenableBuilder(
                          listenable: _loginController,
                          builder: (context, _) {
                            final isLoading = _loginController.isLoading;
                            return FilledButton(
                              onPressed: isLoading ? null : _handleLogin,
                              style: FilledButton.styleFrom(
                                backgroundColor: const Color(0xFFFF2A85),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: isLoading
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                  : const Text(
                                      'ENTRAR',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1.2,
                                      ),
                                    ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
