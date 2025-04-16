import SwiftUI

struct MainView: View {
    @StateObject private var controller = TranslateController()
    @State private var selectedTab: Tab = .translator

    enum Tab {
        case translator
        case settings
    }

    var body: some View {
        NavigationView {
            ZStack {
                // Background gradient
                LinearGradient(
                    gradient: Gradient(colors: [
                        Color(red: 237/255, green: 248/255, blue: 243/255),
                        Color(red: 193/255, green: 234/255, blue: 211/255)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()

                VStack {
                    // Screen content
                    if selectedTab == .translator {
                        translatorView
                    } else {
                        SettingsView()
                    }

                    Spacer()

                    // Bottom tab bar
                    HStack {
                        Button(action: {
                            selectedTab = .translator
                        }) {
                            VStack {
                                Image("translator_png")
                                    .resizable()
                                    .frame(width: 24, height: 24)

                                Text("Translator")
                                    .fontWeight(selectedTab == .translator ? .bold : .regular)
                            }
                            .frame(width: 63, height: 44)
                        }
                        .frame(maxWidth: .infinity)

                        Button(action: {
                            selectedTab = .settings
                        }) {
                            VStack {
                                Image("clicker_png")
                                    .resizable()
                                    .frame(width: 24, height: 24)

                                Text("Clicker")
                                    .fontWeight(selectedTab == .settings ? .bold : .regular)
                            }
                            .frame(width: 63, height: 44)
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .frame(width: 216, height: 82)
                    .padding()
                    .background(Color.white.opacity(0.9))
                    .cornerRadius(20)
                    .shadow(radius: 5)
                    .padding(.bottom, 10)
                    .font(.caption)
                    .foregroundColor(.black)
                }
                .onAppear {
                    controller.isPetToHuman = true
                    controller.translatedText = ""
                    controller.isRecording = false
                    controller.isProcessing = false

#if !DEBUG
                    controller.requestMicrophoneAccess()
#endif
                }
            }
        }
    }

    // MARK: - Translator View

    private var translatorView: some View {
        VStack {
            Text("Translator")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 20)

            // Translation direction toggle
            HStack {
                Text(controller.isPetToHuman ? "PET" : "HUMAN")
                    .font(.headline)
                    .padding(.trailing, 10)

                Button(action: {
                    controller.toggleTranslationMode()
                }) {
                    Image(systemName: "arrow.left.arrow.right")
                        .font(.title2)
                        .foregroundColor(.black)
                }
                .padding(.horizontal, 10)

                Text(controller.isPetToHuman ? "HUMAN" : "PET")
                    .font(.headline)
                    .padding(.leading, 10)
            }
            .padding()

            Spacer()

            // Record button + pet selection
            HStack {
                Button(action: {
                    controller.startRecording()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        controller.stopRecording()
                    }
                }) {
                    VStack {
                        if controller.isRecording {
                            Image("waveform_gif")
                                .resizable()
                                .frame(width: 163, height: 95)

                            Text("Recording...")
                        } else {
                            Image("microphone_png")
                                .resizable()
                                .frame(width: 70, height: 70)

                            Text("Start Speak")
                        }
                    }
                }
                .frame(width: 178, height: 178)
                .padding()
                .background(Color.white)
                .cornerRadius(8)
                .shadow(radius: 5)
                .foregroundColor(.black)

                VStack(spacing: 24) {
                    Button(action: {
                        controller.selectPet(isCat: true)
                    }) {
                        Image("cat_png")
                            .resizable()
                            .frame(width: 83, height: 70)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(controller.isCatSelected ? Color.blue : Color.clear, lineWidth: 3)
                            )
                    }

                    Button(action: {
                        controller.selectPet(isCat: false)
                    }) {
                        Image("dog_png")
                            .resizable()
                            .frame(width: 83, height: 70)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(!controller.isCatSelected ? Color.blue : Color.clear, lineWidth: 3)
                            )
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(16)
                .shadow(radius: 5)
            }
            .padding(.bottom, 40)

            // Selected pet image
            Image(controller.getSelectedPetImage())
                .resizable()
                .frame(width: 184, height: 184)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .shadow(radius: 5)
                .padding()

            Spacer()

            // Navigation to result screen
            NavigationLink(
                destination: ResultView(
                    translatedText: controller.translatedText,
                    selectedPetImage: controller.getSelectedPetImage(),
                    isPetToHuman: controller.isPetToHuman
                ),
                isActive: Binding(
                    get: { !controller.translatedText.isEmpty },
                    set: { _ in }
                )
            ) {
                EmptyView()
            }

            Spacer()
        }
    }
}

#Preview {
    MainView()
}
