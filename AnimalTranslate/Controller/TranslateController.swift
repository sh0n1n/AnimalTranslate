import AVFoundation
import Foundation

/// ViewModel for handling audio recording and translation logic
final class TranslateController: ObservableObject {
    
    // MARK: - Private properties
    private var audioRecorder: AVAudioRecorder?
    private let model = TranslateModel()
    private var player: AVPlayer?
    
    // MARK: - Published properties
    @Published var isRecording = false
    @Published var isProcessing = false
    @Published var translatedText: String = ""
    @Published var isPetToHuman = true
    @Published var isCatSelected = false

    // MARK: - Microphone Access
    /// Requests microphone access from the user
    func requestMicrophoneAccess() {
        AVAudioSession.sharedInstance().requestRecordPermission { granted in
            if !granted {
                print("⚠️ Microphone access denied")
            }
        }
    }
    
    // MARK: - Audio Recording
    /// Starts audio recording
    func startRecording() {
        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession.setCategory(.playAndRecord, mode: .default, options: .defaultToSpeaker)
            try audioSession.setActive(true)
        } catch {
            print("❌ Failed to configure audio session: \(error.localizedDescription)")
            return
        }
        
        let fileURL = FileManager.default.temporaryDirectory.appendingPathComponent("recording.m4a")
        let settings: [String: Any] = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 44_100,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            audioRecorder = try AVAudioRecorder(url: fileURL, settings: settings)
            audioRecorder?.record()
            isRecording = true
            print("🎙️ Recording started")
        } catch {
            print("❌ Failed to start recording: \(error.localizedDescription)")
        }
    }
    
    /// Stops recording and processes translation
    func stopRecording() {
        audioRecorder?.stop()
        isRecording = false
        isProcessing = true
        print("🛑 Recording stopped. Processing...")

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.isProcessing = false
            self.translatedText = self.model.processTranslation("Human speech", isCatSelected: self.isCatSelected)
            print("✅ Translation result: \(self.translatedText)")
        }
    }

    // MARK: - State Management
    /// Switches translation direction
    func toggleTranslationMode() {
        isPetToHuman.toggle()
        print("🔁 Translation mode: \(isPetToHuman ? "PET → HUMAN" : "HUMAN → PET")")
    }
    
    /// Sets the selected pet type
    func selectPet(isCat: Bool) {
        isCatSelected = isCat
        print("🐾 Selected pet: \(isCat ? "Cat" : "Dog")")
    }
    
    /// Returns the current pet image name
    func getSelectedPetImage() -> String {
        return isCatSelected ? "cat_png" : "dog_png"
    }
}
