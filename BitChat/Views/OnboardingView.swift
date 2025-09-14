import SwiftUI

struct OnboardingView: View {
    @State private var username : String = ""
    @AppStorage("username") var storedUsername: String?
    
    var body: some View {
        VStack(spacing: 30){
            Spacer()
            
            AppText(text: "Welcome to Bitchat", size: 28, weight: .bold)
            AppText(text: "Let' get started by setting you username", size: 14, color: .gray)
            
            AppTextField(placeHolder: "Enter your username", text: $username)
            
            AppButton(title: "Continue") {
                if !username.trimmingCharacters(in: .whitespaces).isEmpty{
                    storedUsername = username
                }
                storedUsername = username
            }
            
        }
        .padding()
    }
}

#Preview {
    OnboardingView()
}
