# Lictor MVP — Guia de Arquitetura e Decisões Técnicas

## Stack de Tecnologias

| Camada | Tecnologia | Motivo |
|--------|-----------|--------|
| Framework | Flutter (stable) | Performance 60fps, UI expressiva, cross-platform |
| State Management | Riverpod 2.x | Type-safe, testável, escalável, autoDispose nativo |
| Navegação | GoRouter | Declarativo, suporte deep linking, integra com Riverpod |
| Persistência local | SharedPreferences | Dados simples (auth, plano, stats) sem overhead |
| Tipografia | Google Fonts | DM Sans + Inter sem dependência de assets locais |
| UI Charts | fl_chart | Leve, customizável, sem dependências nativas |
| Feedback tátil | vibration | Integração direta com Android/iOS haptics |
| Feedback sonoro | audioplayers | Suporte MP3/OGG, low latency |

---

## Princípios de Arquitetura

### 1. Feature-first, não Layer-first
Código organizado por feature (`auth`, `questions`, `simulation`) e não por camada técnica (`models`, `screens`, `providers`). Facilita escalabilidade e manutenção.

### 2. Repository Pattern com Interface Abstrata
```
QuestionRepository (interface)
  ├── MockQuestionRepository  ← Atual (dev/testes)
  └── SupabaseQuestionRepository ← Futuro (integração backend)
```
Troca de implementação em **uma linha** sem alterar nenhuma tela.

### 3. Provider Hierarchy Riverpod
```
ProviderScope (root)
  ├── sharedPreferencesProvider (override no main.dart)
  ├── questionRepositoryProvider
  ├── isLoggedInProvider (StateProvider)
  ├── isSubscriberProvider (StateProvider) ← controla Free/Premium
  ├── dailyQuestionCountProvider (StateProvider)
  └── statsProvider (StateNotifierProvider)
```

### 4. UX Bifurcada (Free vs Premium)
O `isSubscriberProvider` é o único ponto de controle. As telas lêem este provider e bifurcam:
- **Dashboard**: botões ativos vs. `_LockedActionCard` com modal
- **Stats**: cards de análise vs. `LockedFeatureCard` com cadeados
- **Training**: limite diário vs. ilimitado

---

## Fluxo de Treino (Training Mode)

```
TrainingScreen
  ├── FutureProvider: carrega questões do MockRepository
  ├── StateNotifier: _TrainingState (currentIndex, selectedAnswer, isAnswered)
  ├── _AlternativeCard: animação de cor ao responder (200ms)
  ├── HapticFeedback: lightImpact (acerto) / heavyImpact (erro)
  └── _ExplanationPanel: SlideTransition (bottom sheet) imediato após resposta
```

**Dinâmica Duolingo**: A explicação sobe IMEDIATAMENTE após a resposta no modo treino. No simulado, zero explicação durante as questões.

---

## Fluxo de Simulado

```
SimulationScreen
  ├── Timer.periodic (1 segundo) → UI atualiza apenas o contador
  ├── Map<int, String> _answers → respostas sem feedback visual
  ├── PageView sequencial → sem skip de questão permitido
  └── Finalização → SimulationResultScreen com lista completa
```

---

## Preparação Supabase

### Schema sugerido (PostgreSQL)

```sql
-- Tabela de questões
CREATE TABLE questions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  subject TEXT NOT NULL,
  topic TEXT NOT NULL,
  statement TEXT NOT NULL,
  difficulty TEXT CHECK (difficulty IN ('easy', 'medium', 'hard')),
  alternatives JSONB NOT NULL,
  correct_alternative TEXT NOT NULL,
  explanation_concept TEXT,
  explanation_correct TEXT,
  explanation_wrong_pattern TEXT,
  tip TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Tabela de respostas do usuário
CREATE TABLE user_answers (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id),
  question_id UUID REFERENCES questions(id),
  selected_alternative TEXT,
  is_correct BOOLEAN,
  answered_at TIMESTAMPTZ DEFAULT NOW()
);

-- Tabela de assinaturas
CREATE TABLE subscriptions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id) UNIQUE,
  plan TEXT CHECK (plan IN ('free', 'monthly', 'yearly')),
  status TEXT CHECK (status IN ('active', 'cancelled', 'expired')),
  expires_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW()
);
```

### Row Level Security (RLS)
```sql
-- Questões: leitura pública, escrita apenas admin
ALTER TABLE questions ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Questions are viewable by everyone" ON questions FOR SELECT USING (true);

-- Respostas: cada usuário vê apenas as suas
ALTER TABLE user_answers ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Users see own answers" ON user_answers USING (auth.uid() = user_id);
```

---

## Performance Guidelines

1. **const constructors** em todos os widgets que não mudam
2. **ListView.builder** em listas de alternativas (evita render de itens fora da viewport)
3. **autoDispose** nos providers de tela (libera memória ao sair da tela)
4. **AnimationController.dispose()** em todo StatefulWidget com animações
5. **HapticFeedback** no isolate principal (não bloqueia UI)
6. Evitar **setState** em nível de Scaffold; usar providers granulares

---

## Checklist de Integração Supabase

- [ ] Adicionar `supabase_flutter` no pubspec.yaml
- [ ] Criar projeto no Supabase e configurar schema
- [ ] Criar `SupabaseQuestionRepository implements QuestionRepository`
- [ ] Trocar provider em `app_providers.dart`
- [ ] Substituir mock de auth em `login_screen.dart` e `signup_screen.dart`
- [ ] Implementar `StatsNotifier` com sync para tabela `user_answers`
- [ ] Implementar verificação de assinatura via tabela `subscriptions`
- [ ] Configurar `supabase.auth.onAuthStateChange` para atualizar `isLoggedInProvider`
