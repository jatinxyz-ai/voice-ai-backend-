# Voice-to-Voice AI Assistant

## iOS + Flask (GPT-4) App

### Backend
1. Set your OpenAI API key:
```bash
export OPENAI_API_KEY=your_key_here
python app.py
```

### iOS
- Add `NSMicrophoneUsageDescription` and `NSSpeechRecognitionUsageDescription` to Info.plist
- Run on a real device with network access
- Update the URL in `callAI()` to your backend IP if hosted remotely
