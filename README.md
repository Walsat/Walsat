# Land Archive - Document Management App

A comprehensive Flutter application for archiving and managing land documents with AI-powered features.

## Features

### Core Features
- ✅ **Document Management**: Add, view, edit, and delete land documents
- ✅ **Image Support**: Attach multiple images to each document
- ✅ **Smart Search**: Full-text search across all document fields
- ✅ **Categorization**: Organize documents by type (Deed, Contract, Survey, etc.)
- ✅ **Status Tracking**: Track document status (Active, Archived, Pending)
- ✅ **Tags System**: Tag documents for easy organization

### AI-Powered Features
- 🤖 **AI Document Analysis**: Automatic analysis of document images using OpenAI Vision API
- 🤖 **Text Extraction**: Extract text from document images (OCR)
- 🤖 **Smart Tagging**: AI-generated relevant tags
- 🤖 **Document Summary**: Generate professional summaries
- 🤖 **Category Suggestion**: Automatic document type classification
- 🤖 **Completeness Check**: Validate document information

### Additional Features
- 📄 **PDF Generation**: Create professional PDF reports
- 🖨️ **Print Support**: Direct printing of documents
- 📤 **Share**: Share documents as PDF
- 📊 **Statistics Dashboard**: View document statistics
- 🌙 **Dark Mode**: Full dark mode support
- 💾 **Local Storage**: Fast, offline-first storage with Hive

## Technology Stack

- **Framework**: Flutter 3.0+
- **State Management**: Provider
- **Local Database**: Hive
- **AI Integration**: OpenAI API (GPT-4 Vision, GPT-4)
- **PDF Generation**: pdf, printing packages
- **Image Handling**: image_picker, image packages

## Project Structure

```
lib/
├── models/
│   └── document.dart              # Document data model
├── screens/
│   ├── home_screen.dart           # Home dashboard
│   ├── documents_list_screen.dart # List all documents
│   ├── add_document_screen.dart   # Add new document
│   ├── document_detail_screen.dart # View document details
│   └── search_screen.dart         # Search functionality
├── services/
│   ├── storage_service.dart       # Local storage management
│   ├── ai_service.dart            # AI integration (OpenAI)
│   └── print_service.dart         # PDF generation & printing
└── main.dart                      # App entry point
```

## Setup Instructions

### Prerequisites
- Flutter SDK (3.0 or higher)
- Dart SDK
- Android Studio / VS Code with Flutter extensions
- OpenAI API Key (for AI features)

### Installation

1. **Clone the repository**:
   ```bash
   git clone https://github.com/Walsat/Walsat.git
   cd Walsat
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Generate Hive adapters**:
   ```bash
   flutter packages pub run build_runner build
   ```

4. **Configure AI Service** (Optional):
   - Open `lib/main.dart`
   - Uncomment and configure the AI service initialization:
   ```dart
   aiService.init(
     apiKey: 'YOUR_OPENAI_API_KEY',
     apiEndpoint: 'https://api.openai.com/v1',
   );
   ```

5. **Run the app**:
   ```bash
   flutter run
   ```

## Configuration

### Environment Variables

For production deployment, it's recommended to use environment variables for sensitive data:

```dart
// Create a .env file (not committed to git)
OPENAI_API_KEY=your_api_key_here
OPENAI_ENDPOINT=https://api.openai.com/v1
```

### API Configuration

The app uses OpenAI API for AI features. Configure in `lib/services/ai_service.dart`:

- **GPT-4 Vision**: For image analysis and OCR
- **GPT-4**: For text generation, summaries, and validation

## Usage Guide

### Adding a Document

1. Tap the "+" button on the home screen
2. Fill in document information:
   - Title (required)
   - Type (required)
   - Description (required)
   - Owner name (optional)
   - Location (optional)
   - Area (optional)
3. Add images (tap "Add Images")
4. Optional: Use "AI Analyze" to automatically extract information
5. Add tags for organization
6. Tap "SAVE"

### Searching Documents

1. Tap the search icon in the app bar
2. Type your search query
3. Results update in real-time
4. Tap any document to view details

### Managing Documents

- **View**: Tap any document to see full details
- **Edit**: Use the edit icon in document details (coming soon)
- **Delete**: Use the menu (⋮) → Delete
- **Print**: Use the menu (⋮) → Print
- **Share**: Use the menu (⋮) → Share PDF

## AI Features Configuration

### Required API Permissions

The AI service requires:
- OpenAI API access
- GPT-4 Vision API access
- Sufficient API quota

### API Usage

- **Image Analysis**: ~$0.03 per image (GPT-4 Vision)
- **Text Generation**: ~$0.002 per request (GPT-4)

## Troubleshooting

### Common Issues

1. **Hive Adapter Error**:
   ```bash
   flutter packages pub run build_runner build --delete-conflicting-outputs
   ```

2. **Image Picker Issues**:
   - Android: Add permissions in `android/app/src/main/AndroidManifest.xml`
   - iOS: Add permissions in `ios/Runner/Info.plist`

3. **AI Service Errors**:
   - Verify API key is correct
   - Check API endpoint configuration
   - Ensure you have sufficient API quota

## Building for Production

### Android

```bash
flutter build apk --release
# or
flutter build appbundle --release
```

### iOS

```bash
flutter build ios --release
```

## Future Enhancements

- [ ] Cloud sync support
- [ ] Multi-user support
- [ ] Document scanning with camera
- [ ] Advanced filtering and sorting
- [ ] Export/Import functionality
- [ ] Document versioning
- [ ] Offline AI with on-device models
- [ ] Web platform support

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For issues, questions, or suggestions, please open an issue on GitHub.

## Credits

Developed by Walsat Team
Powered by Flutter and OpenAI

---

**Note**: This is a document management application. Please ensure you comply with local regulations regarding document storage and data privacy.
