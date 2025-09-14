import SwiftUI

struct ChatBubble: View {
    var message: Message
    var body: some View {
        let messageSender: Bool = message.isSentByCurrentUser
        HStack {
            if messageSender {
                Spacer()
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(message.text)
                    .padding()
                    .foregroundColor(messageSender ? .white : .black)
                    .background(messageSender ? Color.blue : Color.gray.opacity(0.2))
                    .cornerRadius(12)
                
                Text(formattedTime(from: message.timestamp))
                    .font(.caption2)
                    .foregroundColor(.gray)
                    .padding(.horizontal, 6)
            }
            .frame(maxWidth: 280, alignment: messageSender ? .trailing : .leading)
            
            if !messageSender {
                Spacer()
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 4)
    }
    
    func formattedTime(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}
