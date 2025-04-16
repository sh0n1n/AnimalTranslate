import SwiftUI
import AVFoundation

/// Result screen showing translation or animal sound
struct ResultView: View {
    let translatedText: String
    let selectedPetImage: String
    let isPetToHuman: Bool

    @State private var showProcessingText = true
    @State private var showTranslatedText = false
    @State private var showRepeatButton = false
    @Environment(\.presentationMode) var presentationMode

    @State private var audioPlayer: AVAudioPlayer?

    var body: some View {
        ZStack {
            backgroundGradient

            VStack {
                topBar

                Spacer()

                if isPetToHuman {
                    petToHumanContent
                } else {
                    humanToPetContent
                }

                petImage

                Spacer()
            }
            .onAppear {
                setupAudioSession()

                if isPetToHuman {
                    showTranslatedTextSequence()
                }
            }
        }
    }

    // MARK: - Subviews

    private var backgroundGradient: some View {
        LinearGradient(
            gradient: Gradient(colors: [
                Color(red: 237/255, green: 248/255, blue: 243/255),
                Color(red: 193/255, green: 234/255, blue: 211/255)
            ]),
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
    }

    private var topBar: some View {
        HStack {
            Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image("x_png")
                    .font(.title2)
                    .foregroundColor(.black)
                    .padding(10)
                    .background(Color.white)
                    .clipShape(Circle())
                    .shadow(radius: 3)
            }
            .padding(.leading, 20)

            Spacer()

            Text("Result")
                .font(.largeTitle)
                .fontWeight(.bold)

            Spacer()
            Spacer().frame(width: 40) // for symmetry
        }
        .padding(.top, 20)
        .navigationBarHidden(true)
    }

    private var petToHumanContent: some View {
        Group {
            if showProcessingText {
                Text("Processing translation...")
                    .font(.headline)
                    .transition(.opacity)
            } else if showTranslatedText {
                ZStack(alignment: .bottomTrailing) {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.blue.opacity(0.2))
                        .frame(width: 250, height: 80)

                    Text(translatedText)
                        .padding()
                        .frame(width: 230)
                        .multilineTextAlignment(.center)
                        .transition(.opacity)
                        .animation(.easeInOut(duration: 0.5), value: showTranslatedText)
                }
            } else if showRepeatButton {
                repeatButton(action: restartTranslation)
            }
        }
    }

    private var humanToPetContent: some View {
        repeatButton(action: playAnimalSound)
            .onAppear {
                playAnimalSound()
            }
    }

    private func repeatButton(action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack {
                Image(systemName: "arrow.clockwise")
                Text("Repeat")
            }
            .font(.headline)
            .padding()
            .frame(width: 291, height: 54)
            .background(Color.blue.opacity(0.2))
            .foregroundColor(.black)
            .cornerRadius(10)
        }
    }

    private var petImage: some View {
        Image(selectedPetImage)
            .resizable()
            .frame(width: 184, height: 184)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .shadow(radius: 5)
            .padding()
    }

    // MARK: - Logic

    private func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("❌ AVAudioSession setup error: \(error.localizedDescription)")
        }
    }

    private func playAnimalSound() {
        let soundFile = selectedPetImage == "cat_png" ? "cat.mp3" : "dog.mp3"

        guard let url = Bundle.main.url(forResource: soundFile, withExtension: nil) else {
            print("❌ Sound file not found: \(soundFile)")
            return
        }

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        } catch {
            print("❌ Playback error: \(error.localizedDescription)")
        }
    }

    private func showTranslatedTextSequence() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            withAnimation {
                showProcessingText = false
                showTranslatedText = true
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                withAnimation {
                    showTranslatedText = false
                    showRepeatButton = true
                }
            }
        }
    }

    private func restartTranslation() {
        showProcessingText = true
        showTranslatedText = false
        showRepeatButton = false

        showTranslatedTextSequence()
    }
}

// MARK: - Preview

#Preview {
    ResultView(
        translatedText: "What are you doing, human?",
        selectedPetImage: "dog_png",
        isPetToHuman: false
    )
}
