import SwiftUI
import Speech
import AVFoundation

struct ContentView: View {
    @State private var isRecording = false
    @State private var transcribedText = ""
    @State private var aiResponse = ""
    let synthesizer = AVSpeechSynthesizer()

    var body: some View {
        VStack(spacing: 20) {
            Text("You: \(transcribedText)")
            Text("Jarvis: \(aiResponse)")
            Button(isRecording ? "Stop" : "Start") {
                if isRecording {
                    stopRecording()
                } else {
                    startRecording()
                }
                isRecording.toggle()
            }
        }
        .padding()
    }

    func startRecording() {
        SpeechRecognizer.shared.start { text in
            transcribedText = text
            callAI(with: text)
        }
    }

    func stopRecording() {
        SpeechRecognizer.shared.stop()
    }

    func callAI(with prompt: String) {
        guard let url = URL(string: "http://localhost:5000/chat") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: ["message": prompt])

        URLSession.shared.dataTask(with: request) { data, _, _ in
            guard let data = data,
                  let response = try? JSONDecoder().decode(ChatResponse.self, from: data) else { return }
            DispatchQueue.main.async {
                aiResponse = response.reply
                let utterance = AVSpeechUtterance(string: response.reply)
                synthesizer.speak(utterance)
            }
        }.resume()
    }
}

struct ChatResponse: Codable {
    let reply: String
}
