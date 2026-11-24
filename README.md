# O Que Tem No Meu Cosmético? 🌿🔍
### Aplicativo Mobile Flutter

Aplicativo móvel desenvolvido em **Flutter** para análise técnica, toxicológica e regulatória de rótulos cosméticos em tempo real. Utiliza reconhecimento óptico de caracteres (**OCR on-device via Google ML Kit**) e integração com a API de inteligência cosmética.

---

## 📱 Funcionalidades Principais

1. **Captura Inteligente & OCR On-Device:**
   - Captura via Câmera ou Galeria de Fotos.
   - Recorte guiado (`image_cropper`) para isolar a lista de composição (INCI).
   - Extração textual de alta precisão com Google ML Kit Text Recognition.
   - Higienização e sanitização automática de quebras de linha preservando delimitadores (`,`, `/`).
   - Modal de revisão de texto OCR e opção para inserção manual direta.

2. **Análise Rápida Instantânea (`POST /api/analyze/quick`):**
   - **Score Geral de Segurança (0 a 100):** com gradiente dinâmico por criticidade (Verde > 80, Amarelo 60–79, Vermelho < 60).
   - **Selos de Conformidade Automáticos:** *Vegano*, *Clean Beauty*, *Cruelty-Free*, *Paraben-Free*, *Sulfate-Free*, *Silicone-Free*, *Low Poo* e *No Poo*.
   - **Card de Alertas Críticos (Redflags):** Destaque visual imediato para ingredientes cancerígenos, desreguladores endócrinos, poluentes persistentes ou com impurezas de processo (ex: 1,4-dioxano, hidrocarbonetos aromáticos policíclicos).
   - **Listagem Estruturada de Ingredientes:** Classificação por nível de risco (Baixo, Médio, Alto), toxicidade, comedogenicidade (0–5), potencial alergênico e funções cosméticas.
   - **Listagem de Ingredientes Não Identificados:** Alerta ao usuário sobre componentes não catalogados na base.

3. **Dossiê Técnico & Alternativas Limpas (`GET /api/ingredients/{id}`):**
   - Ao tocar em qualquer card de ingrediente (ex: *Petrolato / Vaselina*), o app consulta os detalhes aprofundados na API e abre um Bottom Sheet técnico contendo:
     - **Mecanismo de Ação e Impacto:** Explicação detalhada (oclusão, efeito cumulativo, impurezas PAH, bioacumulação).
     - **Status Regulatório Oficial:** Anvisa (Brasil), FDA (EUA), União Europeia (Regulamento CE 1223/2009) e CIR (*Cosmetic Ingredient Review*).
     - **Evidências Científicas:** Resumo de estudos toxicológicos indexados com fonte e ano.
     - **Alternativas Limpas e Seguras:** Sugestões inteligentes de substitutos verdes (ex: Manteiga de Karité, Óleo de Jojoba, Esqualano Vegetal).

4. **Configuração de Ambiente de Rede:**
   - Suporte transparente para conexões via emulador Android (`10.0.2.2`), USB/Wi-Fi reverse proxy (`localhost:8000`), ou IP de rede local.
   - Tela de configurações no app para alternar e testar o endpoint da API em tempo de execução com persistência via `SharedPreferences`.

---

## 🏛️ Arquitetura de Software

O aplicativo segue estritamente os padrões de **Clean Architecture Modular (Feature-First)** combinada com o padrão **BLoC / Cubit** para gerenciamento de estado previsível e desacoplado:

```
lib/
├── core/
│   ├── constants/           # Cores, espaçamentos, tema Material 3
│   ├── network/             # ApiClient, ApiEndpoints, Exceções tipadas
│   ├── services/            # OCR, ImagePicker, Sanitização de texto
│   ├── storage/             # SharedPreferences e persistência local
│   └── widgets/             # Componentes globais (botões, cards, badges)
└── features/
    ├── scanner/             # Fluxo de Câmera/Galeria, Crop e OCR
    │   ├── presentation/
    │   │   ├── cubit/       # ScannerCubit & ScannerState
    │   │   └── screens/     # ScannerScreen, ReviewDialog, ManualSheet
    ├── analysis/            # Análise Rápida e Relatório
    │   ├── data/            # Models, BadgesModel, AnalysisResultModel
    │   ├── presentation/
    │   │   ├── cubit/       # AnalysisCubit & AnalysisState
    │   │   ├── screens/     # ResultScreen
    │   │   └── widgets/     # ScoreHeroCard, BadgesGrid, CriticalAlerts
    ├── ingredient_detail/   # Dossiê Técnico do Ingrediente
    │   ├── data/            # IngredientDetailModel, RegulatoryStatusModel
    │   ├── presentation/
    │   │   ├── cubit/       # IngredientDetailCubit & State
    │   │   └── widgets/     # IngredientDetailSheet
    └── settings/            # Configurações de URL da API
```

---

## 🧪 Testes Automatizados

O projeto conta com suíte abrangente de testes unitários e de widgets utilizando `mocktail` e `bloc_test`:

- **Services & Helpers:** Sanitização de texto, parser de ingredientes e OCR.
- **Models:** Serialização e deserialização JSON de todos os nós (`AnalysisResultModel`, `BadgesModel`, `MappedIngredientModel`, `IngredientDetailModel`).
- **Cubits:** `ScannerCubit`, `AnalysisCubit`, `IngredientDetailCubit` cobrindo cenários de sucesso, erro e estados intermediários.
- **Widgets:** Renderização de tela, exibição de notas dinâmicas, modal de dossiê técnico e bottom sheets.

Para executar todos os testes:
```bash
flutter test
```

Para verificar análise estática e padrões de código:
```bash
flutter analyze
```

---

## 🚀 Como Executar o Projeto

### Pré-requisitos
- **Flutter SDK:** ^3.24.0 (Canal Stable)
- **Dart SDK:** ^3.5.0
- **Java JDK:** OpenJDK 17 LTS
- **Android Studio / VS Code** com plugins Flutter instalados

### Instalação

1. Clone o repositório:
```bash
git clone https://github.com/rochagi/oQueTemNoMeuCosmeticoApp.git
cd oQueTemNoMeuCosmeticoApp
```

2. Instale as dependências:
```bash
flutter pub get
```

3. Execute o aplicativo:
```bash
# No dispositivo conectado ou emulador
flutter run
```

---

## 📄 Licença
Propriedade do projeto **O Que Tem No Meu Cosmético?**. Todos os direitos reservados.
