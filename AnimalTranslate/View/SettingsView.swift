import SwiftUI
import StoreKit // For open rate in App Store
struct SettingsView: View {
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color(red: 237/255, green: 248/255, blue: 243/255),
                    Color(red: 193/255, green: 234/255, blue: 211/255)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            VStack(spacing: 12) {
                Text("Settings")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 20)
                
                settingsButton(title: "Rate Us", action: rateApp)
                settingsButton(title: "Share App", action: shareApp)
                settingsButton(title: "Contact Us", action: contactUs)
                settingsButton(title: "Restore Purchases", action: restorePurchases)
                settingsButton(title: "Privacy Policy", action: openPrivacyPolicy)
                settingsButton(title: "Terms of Use", action: openTermsOfUse)
                
                Spacer()
            }
            .padding(.horizontal, 20)
        }
    }
    
    //Functions for creating buttons
    private func settingsButton(title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack {
                Text(title)
                    .foregroundColor(.black)
                    .font(.headline)
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.blue.opacity(0.2))
            .cornerRadius(10)
        }
    }
    
    //Rate App
    private func rateApp() {
        guard let writeReviewURL = URL(string: "") else { return }
        UIApplication.shared.open(writeReviewURL)
    }

    //Share App
    private func shareApp() {
        let appURL = "https://apps.apple.com/app/idYOUR_APP_ID"
        let activityVC = UIActivityViewController(activityItems: [appURL], applicationActivities: nil)
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let rootVC = windowScene.windows.first?.rootViewController {
            rootVC.present(activityVC, animated: true, completion: nil)
        }
    }

    //Open Contact Us
    private func contactUs() {
        let email = "support@example.com"
        if let emailURL = URL(string: "mailto:\(email)") {
            UIApplication.shared.open(emailURL)
        }
    }
    
    // Restore Purchases
    func restorePurchases() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }

    // Open Privacy Policy
    private func openPrivacyPolicy() {
        guard let url = URL(string: "https://www.apple.com/uk/legal/internet-services/itunes/uk/terms.html") else { return }
        UIApplication.shared.open(url)
    }

    // Open terns Of Use
    private func openTermsOfUse() {
        guard let url = URL(string: "https://www.apple.com/legal/internet-services/terms/site.html") else { return }
        UIApplication.shared.open(url)
    }
}

#Preview {
    SettingsView()
}
