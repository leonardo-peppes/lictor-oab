// lib/features/questions/repositories/mock_question_repository.dart
// Repositório mock com questões estáticas para desenvolvimento e testes.
// Substituir por SupabaseQuestionRepository na integração com backend.

import '../models/question_model.dart';
import 'question_repository.dart';

class MockQuestionRepository implements QuestionRepository {
  // ─── Banco de questões mock ───────────────────────────────────────────────
  static const List<Question> _questions = [
    Question(
      id: 'q001',
      subject: 'Direito Civil',
      topic: 'Negócio Jurídico',
      difficulty: Difficulty.medium,
      statement:
          'João, com 16 anos, sem assistência de seus pais, celebrou contrato de compra e venda de um imóvel. Sobre a validade desse negócio jurídico, assinale a alternativa correta:',
      alternatives: [
        Alternative(letter: 'A', text: 'O negócio é nulo, pois João é absolutamente incapaz.'),
        Alternative(letter: 'B', text: 'O negócio é anulável, pois João é relativamente incapaz e atuou sem assistência do representante legal.'),
        Alternative(letter: 'C', text: 'O negócio é válido, pois João já tem 16 anos e possui capacidade civil plena.'),
        Alternative(letter: 'D', text: 'O negócio é inexistente, por ausência de objeto lícito.'),
        Alternative(letter: 'E', text: 'O negócio é válido, mas ineficaz até a maioridade.'),
      ],
      correctAlternative: 'B',
      explanationConcept:
          'O Código Civil distingue absolutamente incapazes (art. 3º) dos relativamente incapazes (art. 4º). Os relativamente incapazes, como os maiores de 16 e menores de 18 anos, precisam de assistência dos representantes legais para a prática de atos da vida civil. A ausência da assistência gera anulabilidade, não nulidade.',
      explanationCorrect:
          'João tem 16 anos, o que o coloca na categoria de relativamente incapaz (art. 4º, I, CC). O negócio jurídico praticado por relativamente incapaz sem a devida assistência é anulável (art. 171, I, CC), não nulo. A diferença é fundamental: o ato nulo não produz efeitos desde o início; o anulável produz efeitos até ser desconstituído.',
      explanationWrongPattern:
          'Erro comum: confundir absolutamente incapaz com relativamente incapaz. Menores de 16 anos são absolutamente incapazes (nulidade); entre 16 e 18 são relativamente incapazes (anulabilidade). Outro erro frequente é achar que a alternativa D faz sentido — inexistência não se aplica aqui pois há objeto lícito (imóvel).',
      tip: 'Grave: absoluto = nulo; relativo = anulável. Nunca troque as consequências.',
    ),
    Question(
      id: 'q002',
      subject: 'Direito Constitucional',
      topic: 'Direitos Fundamentais',
      difficulty: Difficulty.easy,
      statement:
          'A Constituição Federal de 1988 estabelece que são invioláveis a intimidade, a vida privada, a honra e a imagem das pessoas. Em caso de dano decorrente de sua violação, assegura-se:',
      alternatives: [
        Alternative(letter: 'A', text: 'O direito a indenização, mas apenas por danos materiais comprovados.'),
        Alternative(letter: 'B', text: 'O direito de representação criminal, sem possibilidade de indenização civil.'),
        Alternative(letter: 'C', text: 'O direito à indenização pelo dano material ou moral decorrente de sua violação.'),
        Alternative(letter: 'D', text: 'O direito à indenização apenas se houver dano moral, excluindo o material.'),
        Alternative(letter: 'E', text: 'O direito à reparação simbólica, sem valor econômico.'),
      ],
      correctAlternative: 'C',
      explanationConcept:
          'O art. 5º, X, da CF/88 protege a intimidade, vida privada, honra e imagem das pessoas, assegurando o direito à indenização pelo dano material ou moral decorrente de sua violação. A norma constitucional reconhece expressamente ambas as modalidades de dano.',
      explanationCorrect:
          'O dispositivo constitucional é expresso: "são invioláveis a intimidade, a vida privada, a honra e a imagem das pessoas, assegurado o direito a indenização pelo dano material ou moral decorrente de sua violação" (art. 5º, X). Portanto, tanto dano material quanto moral são indenizáveis, sem exclusão de nenhum.',
      explanationWrongPattern:
          'Armadilha clássica: as alternativas A e D tentam limitar a indenização a apenas uma modalidade. O texto constitucional usa "ou" com sentido inclusivo, abrangendo ambas. Não caia na restrição artificial.',
      tip: 'Memorize: "dano material OU moral" na CF = os dois são cabíveis, não excludentes.',
    ),
    Question(
      id: 'q003',
      subject: 'Direito Penal',
      topic: 'Crimes Contra o Patrimônio',
      difficulty: Difficulty.hard,
      statement:
          'Pedro, mediante grave ameaça, subtraiu o celular de Carla. Dias depois, Paulo, sem usar violência ou grave ameaça, subtraiu o notebook de Bruno enquanto ele dormia. Considerando apenas o Código Penal, assinale a alternativa correta:',
      alternatives: [
        Alternative(letter: 'A', text: 'Ambos praticaram roubo.'),
        Alternative(letter: 'B', text: 'Pedro praticou roubo e Paulo praticou furto qualificado.'),
        Alternative(letter: 'C', text: 'Pedro praticou roubo e Paulo praticou furto simples.'),
        Alternative(letter: 'D', text: 'Ambos praticaram furto, com diferentes qualificadoras.'),
        Alternative(letter: 'E', text: 'Pedro praticou extorsão e Paulo praticou furto simples.'),
      ],
      correctAlternative: 'C',
      explanationConcept:
          'Roubo (art. 157 CP) é a subtração mediante violência ou grave ameaça à pessoa. Furto (art. 155 CP) é a subtração sem esses elementos. O furto qualificado exige circunstâncias específicas previstas no §4º do art. 155 — dormir não é qualificadora.',
      explanationCorrect:
          'Pedro praticou roubo (art. 157), pois usou grave ameaça. Paulo praticou furto simples (art. 155, caput): subtraiu coisa alheia móvel sem violência ou grave ameaça. O fato de a vítima estar dormindo não configura nenhuma das qualificadoras do §4º do art. 155 (destruição/rompimento de obstáculo, abuso de confiança, fraude, escalada, destreza). Portanto, furto simples.',
      explanationWrongPattern:
          'Muitos candidatos marcam furto qualificado por acharem que a situação de vulnerabilidade da vítima gera qualificadora. Erro grave: o art. 155, §4º traz um rol taxativo. "Vítima dormindo" não está lá. Outro erro: confundir roubo com extorsão — na extorsão, a vítima faz algo; no roubo, o agente subtrai.',
      tip: 'Revise o rol taxativo do §4º do art. 155 CP. Se não está lá, não é qualificadora.',
    ),
    Question(
      id: 'q004',
      subject: 'Ética e Estatuto da OAB',
      topic: 'Impedimentos e Incompatibilidades',
      difficulty: Difficulty.medium,
      statement:
          'Ana é Defensora Pública Estadual. Seu marido, Carlos, pretende advogar. Sobre a possibilidade de Carlos exercer a advocacia, segundo o EAOAB:',
      alternatives: [
        Alternative(letter: 'A', text: 'Carlos pode advogar livremente, pois a restrição é pessoal de Ana.'),
        Alternative(letter: 'B', text: 'Carlos está impedido de advogar contra a Fazenda Pública do Estado em que Ana atua como Defensora.'),
        Alternative(letter: 'C', text: 'Carlos está absolutamente impedido de exercer a advocacia enquanto Ana for Defensora Pública.'),
        Alternative(letter: 'D', text: 'Carlos pode advogar, exceto em processos em que Ana seja parte.'),
        Alternative(letter: 'E', text: 'Carlos pode advogar livremente, pois a Defensoria Pública não gera impedimento ao cônjuge.'),
      ],
      correctAlternative: 'A',
      explanationConcept:
          'O Estatuto da OAB (Lei 8.906/94) prevê impedimentos e incompatibilidades para o exercício da advocacia. Os impedimentos do art. 30 são pessoais — atingem a pessoa que ocupa determinado cargo ou função. O cônjuge ou companheiro do impedido, em regra, não sofre a mesma restrição.',
      explanationCorrect:
          'O impedimento é de Ana, não de Carlos. Carlos pode advogar livremente, inclusive no mesmo Estado onde Ana exerce a Defensoria. O EAOAB não estende os impedimentos do art. 30 ao cônjuge ou companheiro do impedido, salvo disposição específica. A alternativa A está correta.',
      explanationWrongPattern:
          'Armadilha: a banca tenta confundir o candidato criando restrições inexistentes no EAOAB para familiares de agentes públicos. Lembre-se: impedimento é pessoal. Não crie restrições onde a lei não criou.',
      tip: 'Impedimentos do EAOAB são pessoais. Não confunda com os impedimentos de juízes no CPC.',
    ),
    Question(
      id: 'q005',
      subject: 'Direito do Trabalho',
      topic: 'Contrato de Trabalho',
      difficulty: Difficulty.easy,
      statement:
          'Marina trabalha todos os dias para a empresa X, de segunda a sexta, das 8h às 17h, recebendo pagamento semanal em dinheiro. A empresa afirma que é prestadora de serviço autônoma. Diante dos fatos narrados, assinale a alternativa correta:',
      alternatives: [
        Alternative(letter: 'A', text: 'A relação é autônoma, pois assim foi convencionado entre as partes.'),
        Alternative(letter: 'B', text: 'A relação é de emprego, pois estão presentes os requisitos do art. 3º da CLT.'),
        Alternative(letter: 'C', text: 'A relação é autônoma, pois o pagamento em dinheiro afasta o vínculo empregatício.'),
        Alternative(letter: 'D', text: 'Não é possível definir sem o contrato escrito entre as partes.'),
        Alternative(letter: 'E', text: 'A relação é de emprego apenas se houver anotação em CTPS.'),
      ],
      correctAlternative: 'B',
      explanationConcept:
          'O art. 3º da CLT define empregado como pessoa física que presta serviços de natureza não eventual a empregador, sob a dependência deste e mediante salário. Os requisitos são: pessoalidade, não eventualidade, subordinação e onerosidade. O princípio da primazia da realidade determina que a realidade fática prevalece sobre a forma.',
      explanationCorrect:
          'Marina atende a todos os requisitos: é pessoa física (pessoalidade), trabalha todos os dias (não eventualidade), cumpre horário fixo e recebe ordens (subordinação), e recebe pagamento (onerosidade). Pelo princípio da primazia da realidade, o contrato escrito não afasta o vínculo empregatício quando a realidade comprova os requisitos.',
      explanationWrongPattern:
          'Erro clássico: acreditar que o rótulo dado pelas partes define a natureza jurídica da relação. No Direito do Trabalho, o que importa é a realidade fática. A anotação em CTPS é mera formalidade — sua ausência não afasta o vínculo já constituído.',
      tip: 'Primazia da realidade: a verdade dos fatos sempre prevalece sobre a forma ou o nome dado ao contrato.',
    ),
    Question(
      id: 'q006',
      subject: 'Direito Processual Civil',
      topic: 'Competência',
      difficulty: Difficulty.medium,
      statement:
          'Ação de alimentos proposta por filha menor domiciliada em São Paulo contra seu pai domiciliado no Rio de Janeiro. Considerando o CPC/2015, qual o foro competente?',
      alternatives: [
        Alternative(letter: 'A', text: 'Rio de Janeiro, domicílio do réu, regra geral do CPC.'),
        Alternative(letter: 'B', text: 'São Paulo, domicílio do alimentando, conforme regra especial.'),
        Alternative(letter: 'C', text: 'O autor pode escolher entre São Paulo e Rio de Janeiro.'),
        Alternative(letter: 'D', text: 'A competência é da Justiça Federal, por envolver menor de idade.'),
        Alternative(letter: 'E', text: 'Brasília, por ser matéria de interesse nacional.'),
      ],
      correctAlternative: 'B',
      explanationConcept:
          'O CPC/2015 prevê regras especiais de competência territorial que derrogam a regra geral do domicílio do réu. O art. 53, II, estabelece que nas ações de alimentos a competência é do domicílio ou residência do alimentando. Trata-se de competência especial protetiva.',
      explanationCorrect:
          'O art. 53, II, do CPC/2015 é expresso: nas ações de alimentos, é competente o foro do domicílio ou residência do alimentando (quem pede os alimentos). Como a filha menor domicilia-se em São Paulo, este é o foro competente. A regra especial prevalece sobre a regra geral do domicílio do réu.',
      explanationWrongPattern:
          'Erro frequente: aplicar a regra geral (domicílio do réu) quando existe regra especial. Em ações de alimentos, o legislador optou por proteger o alimentando, estabelecendo foro em seu domicílio. Questão de competência exige conhecimento das exceções.',
      tip: 'Regras especiais de competência do art. 53 do CPC derrubam a regra geral. Estude cada uma delas.',
    ),
    Question(
      id: 'q007',
      subject: 'Direito Civil',
      topic: 'Responsabilidade Civil',
      difficulty: Difficulty.hard,
      statement:
          'Empresa de transporte coletivo causou acidente que resultou em dano a passageiro. A empresa alega caso fortuito externo como excludente de responsabilidade. Sobre a responsabilidade civil no caso, assinale a alternativa correta:',
      alternatives: [
        Alternative(letter: 'A', text: 'A responsabilidade é subjetiva, dependendo de prova de culpa.'),
        Alternative(letter: 'B', text: 'A responsabilidade é objetiva, mas o caso fortuito externo pode excluí-la.'),
        Alternative(letter: 'C', text: 'A responsabilidade é objetiva e o caso fortuito externo não a exclui.'),
        Alternative(letter: 'D', text: 'Não há responsabilidade, pois acidentes são riscos assumidos pelo passageiro.'),
        Alternative(letter: 'E', text: 'A responsabilidade é objetiva e nem o fortuito externo pode excluí-la.'),
      ],
      correctAlternative: 'B',
      explanationConcept:
          'O contrato de transporte gera responsabilidade objetiva da transportadora pela cláusula de incolumidade (art. 734 CC e CDC). Contudo, distingue-se fortuito interno (ligado à atividade do fornecedor) do fortuito externo (fato de terceiro, totalmente alheio). O externo exclui o nexo causal; o interno não.',
      explanationCorrect:
          'A responsabilidade é objetiva (independe de culpa), mas o caso fortuito EXTERNO — aquele completamente estranho à atividade empresarial — pode romper o nexo causal e excluir a responsabilidade. É diferente do fortuito interno (ex: pneu que estoura = risco do negócio). O STJ pacificou esse entendimento em julgados sobre assalto em ônibus (fortuito externo, exclui responsabilidade).',
      explanationWrongPattern:
          'Confusão clássica: achar que responsabilidade objetiva = responsabilidade absoluta. Não é. A responsabilidade objetiva dispensa prova de culpa, mas não elimina a possibilidade de exclusão por caso fortuito externo, fato exclusivo da vítima ou de terceiro. A alternativa E erra ao dizer que nem o fortuito externo exclui.',
      tip: 'Fortuito interno = risco do negócio = não exclui. Fortuito externo = alheio = exclui. Decoreba fundamental.',
    ),
    Question(
      id: 'q008',
      subject: 'Direito Constitucional',
      topic: 'Organização do Estado',
      difficulty: Difficulty.easy,
      statement:
          'Sobre o Distrito Federal, nos termos da Constituição Federal de 1988, assinale a alternativa INCORRETA:',
      alternatives: [
        Alternative(letter: 'A', text: 'O Distrito Federal não pode ser dividido em municípios.'),
        Alternative(letter: 'B', text: 'O Distrito Federal possui lei orgânica própria.'),
        Alternative(letter: 'C', text: 'O Distrito Federal acumula competências estaduais e municipais.'),
        Alternative(letter: 'D', text: 'O Distrito Federal pode se tornar Estado mediante plebiscito.'),
        Alternative(letter: 'E', text: 'O Distrito Federal é vedada a intervenção federal.'),
      ],
      correctAlternative: 'E',
      explanationConcept:
          'O Distrito Federal tem natureza sui generis: não é Estado, não é Município, mas acumula competências de ambos. A CF/88 veda sua divisão em municípios (art. 32, caput) e prevê sua lei orgânica (art. 32, §1º). A intervenção federal é cabível no DF (art. 35, IV c/c art. 36 CF) — a vedação não existe.',
      explanationCorrect:
          'A alternativa E está INCORRETA porque a CF/88 NÃO veda intervenção federal no Distrito Federal. Ao contrário, o art. 35 prevê hipóteses de intervenção nos Estados e no DF. A assertiva trocou a regra pela exceção inexistente.',
      explanationWrongPattern:
          'Cuidado com questões sobre o DF que afirmam "vedações" inexistentes na CF. As restrições reais são: não pode ser dividido em municípios e não pode ser território. Intervenção federal no DF é possível e está prevista expressamente.',
      tip: 'Questões sobre DF: saiba o que é permitido e o que é vedado. "Não pode ser dividido em municípios" é a vedação principal.',
    ),
    Question(
      id: 'q009',
      subject: 'Direito Penal',
      topic: 'Extinção da Punibilidade',
      difficulty: Difficulty.medium,
      statement:
          'Fernando foi condenado por crime de furto simples com pena de 1 ano de reclusão. A condenação transitou em julgado. Dois anos depois, Fernando veio a falecer. Em relação à extinção da punibilidade:',
      alternatives: [
        Alternative(letter: 'A', text: 'A morte do agente extingue a punibilidade, mas não afeta a obrigação de reparar o dano.'),
        Alternative(letter: 'B', text: 'A morte do agente extingue também a obrigação civil de reparar o dano.'),
        Alternative(letter: 'C', text: 'A morte do agente não extingue a punibilidade após o trânsito em julgado.'),
        Alternative(letter: 'D', text: 'A morte extingue a punibilidade e os herdeiros herdam a pena não cumprida.'),
        Alternative(letter: 'E', text: 'A morte extingue apenas a pena privativa de liberdade, mantendo a pena de multa.'),
      ],
      correctAlternative: 'A',
      explanationConcept:
          'O art. 107, I, do Código Penal elenca a morte do agente como causa de extinção da punibilidade. Essa extinção alcança a pretensão executória (mesmo após trânsito em julgado) e abrange todas as penas — privativas de liberdade, restritivas de direito e multa. Contudo, a extinção da punibilidade penal é personalíssima: não afeta a obrigação civil de reparar o dano, que se transmite aos herdeiros dentro das forças da herança.',
      explanationCorrect:
          'A morte extingue a punibilidade (art. 107, I CP) — inclusive após o trânsito em julgado e independentemente do tipo de pena. Porém, a responsabilidade civil é autônoma. Os herdeiros de Fernando respondem civilmente pelos danos causados, até os limites da herança (art. 943 CC). Penal e civil são esferas distintas.',
      explanationWrongPattern:
          'Erro frequente: achar que a morte extingue também a obrigação civil (alternativa B) ou que não alcança a pena de multa (alternativa E — a multa também se extingue). Outro erro: achar que herdeiros cumprem a pena (alternativa D — impossível, pena não se transmite).',
      tip: 'Morte do agente: extingue tudo no penal (inclusive multa); não extingue o dever civil de indenizar.',
    ),
    Question(
      id: 'q010',
      subject: 'Ética e Estatuto da OAB',
      topic: 'Sigilo Profissional',
      difficulty: Difficulty.hard,
      statement:
          'Advogado tomou conhecimento, no exercício da profissão, que seu cliente planeja cometer um crime que resultará em morte de terceiro. Sobre o sigilo profissional nessa situação, segundo o EAOAB e o CED:',
      alternatives: [
        Alternative(letter: 'A', text: 'O advogado deve denunciar às autoridades, pois o sigilo não prevalece diante de crime grave.'),
        Alternative(letter: 'B', text: 'O advogado pode revelar o fato para impedir o crime, mas não é obrigado a fazê-lo.'),
        Alternative(letter: 'C', text: 'O advogado deve manter sigilo absoluto, pois o EAOAB não admite exceções.'),
        Alternative(letter: 'D', text: 'O advogado deve comunicar ao tribunal competente, mantendo segredo das demais informações.'),
        Alternative(letter: 'E', text: 'O advogado perde o mandato automaticamente ao tomar conhecimento do fato.'),
      ],
      correctAlternative: 'B',
      explanationConcept:
          'O sigilo profissional é dever fundamental do advogado (art. 34, VII, EAOAB; art. 25 e ss. CED). Contudo, o Código de Ética e Disciplina da OAB (art. 27, parágrafo único) prevê que o advogado PODE (faculdade, não obrigação) revelar fatos sigilosos para evitar a prática de crime que resulte em grave dano. A revelação é facultativa e autorizada, mas não imposta.',
      explanationCorrect:
          'O art. 27, parágrafo único do CED-OAB é claro: o advogado pode revelar o fato para prevenir a prática de crime, quando necessário. É uma FACULDADE, não uma obrigação. O sistema ético da OAB prioriza o sigilo, mas reconhece que, diante de crime iminente grave, a revelação pode ser justificada. O advogado não é obrigado a delatar, mas está autorizado a fazê-lo.',
      explanationWrongPattern:
          'A alternativa A erra ao tornar obrigatória a denúncia. A alternativa C erra ao dizer que o sigilo é absoluto sem exceções — existem exceções previstas no próprio CED. A questão cobra a distinção entre faculdade e obrigatoriedade, que é o coração da questão.',
      tip: 'Sigilo OAB: regra = sigilo; exceção = pode revelar para evitar crime grave. Jamais é obrigação denunciar.',
    ),
  ];

  @override
  Future<List<Question>> getQuestions({
    String? subject,
    String? topic,
    Difficulty? difficulty,
    int? limit,
  }) async {
    // Simula latência de rede
    await Future.delayed(const Duration(milliseconds: 300));

    var result = List<Question>.from(_questions);

    if (subject != null) {
      result = result.where((q) => q.subject == subject).toList();
    }
    if (topic != null) {
      result = result.where((q) => q.topic == topic).toList();
    }
    if (difficulty != null) {
      result = result.where((q) => q.difficulty == difficulty).toList();
    }
    if (limit != null && limit < result.length) {
      result = result.take(limit).toList();
    }

    return result;
  }

  @override
  Future<Question?> getQuestionById(String id) async {
    await Future.delayed(const Duration(milliseconds: 100));
    try {
      return _questions.firstWhere((q) => q.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<String>> getSubjects() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _questions.map((q) => q.subject).toSet().toList()..sort();
  }

  @override
  Future<List<String>> getTopicsBySubject(String subject) async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _questions
        .where((q) => q.subject == subject)
        .map((q) => q.topic)
        .toSet()
        .toList()
      ..sort();
  }
}
