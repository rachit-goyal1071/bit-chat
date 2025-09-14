import SwiftUI

struct AppText: View {
    var text: String
    var size: CGFloat = 16
    var weight: Font.Weight = .regular
    var color: Color = .primary
    
    var body: some View {
        Text(text)
            .font(.system(size: size))
            .fontWeight(weight)
            .foregroundColor(color)
    }
}
