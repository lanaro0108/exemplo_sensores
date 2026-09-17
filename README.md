# Exemplo Sensores

Aplicativo Flutter para registrar pontos com localização, áudio, imagens e
observações.

## Protótipo

[Abrir protótipo no Figma](https://www.figma.com/design/UOEUV8GlWtNpqF8dZTUK5f/wireframe-Registration---login-plus-homepage-design--Community-?node-id=0-1&t=Ar99oE0XPvMgVGi-1)

## Estrutura do projeto

```text
exemplo_sensores/
├── lib/
│   ├── main.dart                    # Ponto de entrada do aplicativo
│   ├── models/                      # Modelos de dados
│   │   └── ponto_registro.dart
│   ├── screens/                     # Telas do aplicativo
│   │   ├── home_screen.dart
│   │   ├── novo_registro_screen.dart
│   │   └── detalhe_screen.dart
│   └── services/                    # Serviços e recursos do dispositivo
│       ├── audio_service.dart       # Áudio
│       ├── db_service.dart          # Banco de dados local
│       ├── location_service.dart    # Localização
│       └── media_service.dart       # Imagens e mídia
├── test/                            # Testes automatizados
├── android/                         # Configurações do Android
├── pubspec.yaml                     # Dependências do projeto
└── README.md                        # Documentação
```

As telas ficam em `lib/screens`, os modelos em `lib/models` e as integrações
com recursos do dispositivo em `lib/services`.

## Requisitos

- Flutter instalado
- Emulador Android ou dispositivo físico conectado
- Dart `3.12.2` ou superior

## Como executar

Na raiz do projeto, instale as dependências:

```bash
flutter pub get
```

Inicie o aplicativo no dispositivo disponível:

```bash
flutter run
```

Para executar no emulador Android usado neste projeto:

```bash
flutter run -d emulator-5554
```

## Testes

Para executar os testes automatizados:

```bash
flutter test
```