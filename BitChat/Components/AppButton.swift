import SwiftUI

struct AppButton: View {
    var title: String
    var action: ()->Void
    var bgColor: Color = .blue
    var textColor: Color = .white
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .frame(maxWidth: .infinity)
                .padding()
                .background(bgColor)
                .foregroundColor(textColor)
                .cornerRadius(10)
        }
    }
}
