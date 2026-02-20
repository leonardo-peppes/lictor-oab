# Lictor — Performance Jurídica
## Flutter MVP

> Treino estratégico para OAB 1ª Fase e concursos de alto nível.

---

## Estrutura do Projeto

```
lib/
├── main.dart                          # Entry point
├── app.dart                           # MaterialApp com GoRouter
├── core/
│   ├── constants/app_constants.dart   # Constantes globais, rotas, preços
│   ├── theme/app_theme.dart           # Design system completo (cores, tipografia)
│   ├── providers/app_providers.dart   # Providers Riverpod globais
│   ├── router/app_router.dart         # Rotas com GoRouter
│   └── widgets/app_widgets.dart       # Componentes reutilizáveis
└── features/
    ├── auth/screens/                  # Splash, Onboarding, Login, Signup
    ├── dashboard/screens/             # Dashboard principal
    ├── questions/
    │   ├── models/question_model.dart          # Modelos Question + Alternative
    │   ├── repositories/question_repository.dart      # Interface abstrata
    │   ├── repositories/mock_question_repository.dart # Implementação mock
    │   └── screens/training_screen.dart        # Tela de treino
    ├── explanation/screens/           # Tela de explicação standalone
    ├── simulation/screens/            # Simulado + Resultado
    ├── stats/screens/                 # Análise Estratégica
    └── subscription/screens/          # Tela Premium
```

---

## Setup

### 1. Pré-requisitos
- Flutter SDK (stable) >= 3.0.0
- Dart >= 3.0.0

### 2. Instalar dependências

```bash
flutter pub get
```

### 3. Rodar o app

```bash
flutter run
```

---

## Fontes

O app usa **DM Sans** via `google_fonts`. Para fontes locais (offline), adicione os arquivos em `assets/fonts/` e configure no `pubspec.yaml`.

---

## Integração Supabase (Futura)

### 1. Adicionar dependência

```yaml
dependencies:
  supabase_flutter: ^2.0.0
```

### 2. Inicializar no main.dart

```dart
await Supabase.initialize(
  url: 'YOUR_SUPABASE_URL',
  anonKey: 'YOUR_SUPABASE_ANON_KEY',
);
```

### 3. Criar SupabaseQuestionRepository

```dart
class SupabaseQuestionRepository implements QuestionRepository {
  final _client = Supabase.instance.client;

  @override
  Future<List<Question>> getQuestions({...}) async {
    final response = await _client
        .from('questions')
        .select()
        .limit(limit ?? 50);
    return (response as List).map((e) => Question.fromJson(e)).toList();
  }
  // ...
}
```

### 4. Trocar provider (UMA linha)

Em `lib/core/providers/app_providers.dart`:

```dart
// Antes:
final questionRepositoryProvider = Provider<QuestionRepository>((ref) {
  return MockQuestionRepository();
});

// Depois:
final questionRepositoryProvider = Provider<QuestionRepository>((ref) {
  return SupabaseQuestionRepository();
});
```

### 5. Auth com Supabase

Em `login_screen.dart` e `signup_screen.dart`, substituir os comentários `// TODO: Substituir por Supabase Auth` pelas chamadas reais:

```dart
// Login
final response = await Supabase.instance.client.auth.signInWithPassword(
  email: _emailController.text,
  password: _passwordController.text,
);

// Signup
final response = await Supabase.instance.client.auth.signUp(
  email: _emailController.text,
  password: _passwordController.text,
  data: {'name': _nameController.text},
);
```

---

## Design System

### Paleta de cores (monocromática)

| Token | Hex | Uso |
|-------|-----|-----|
| `background` | `#080808` | Fundo principal |
| `surface` | `#111111` | Cards e surfaces |
| `surfaceElevated` | `#1A1A1A` | Modais e panels |
| `border` | `#242424` | Bordas sutis |
| `silver` | `#C0C0C0` | Destaque metálico |
| `textPrimary` | `#F0F0F0` | Texto principal |
| `textSecondary` | `#9A9A9A` | Texto secundário |
| `correctAccent` | `#4CAF50` | Feedback correto |
| `wrongAccent` | `#E57373` | Feedback errado |
| `premiumGold` | `#B8960C` | Elementos premium |

### Tipografia

- **Display / Headings**: DM Sans (Bold, ExtraBold)
- **Body / Reading**: Inter (Regular)
- **Labels / Caps**: DM Sans (SemiBold, tracking amplo)

---

## Funcionalidades por Plano

### Free (isSubscriber = false)
- ✅ 10 questões/dia
- ✅ Estatísticas básicas
- ❌ Simulado (bloqueado → modal premium)
- 🔒 Análise avançada (cards com cadeado)

### Premium (isSubscriber = true)
- ✅ Questões ilimitadas
- ✅ Simulados com temporizador
- ✅ Análise estratégica completa por disciplina
- ✅ Histórico e mapeamento de erros

---

## Assets necessários

### Sons (feedbacks)
Adicionar em `assets/sounds/`:
- `correct.mp3` — som discreto de acerto
- `wrong.mp3` — som sutil de erro

Descomentar os blocos `// TODO: Adicionar feedback sonoro` no `training_screen.dart`.

---

## Performance

- `const` widgets em todos os lugares possíveis
- `ListView.builder` para listas longas
- `PageView` para navegação entre questões
- Providers auto-dispose nas telas de questão
- Zero rebuilds globais desnecessários

---

## Branding

**Lictor** — Performance Jurídica

> "A aprovação não é sorte. É método. Lictor. Treine como quem já vai passar."

Posicionamento: Ferramenta de treino estratégico. Não é cursinho. Não é banco de questões genérico.
