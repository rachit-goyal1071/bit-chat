import SwiftUI

struct OfflineChatView: ObservableObject {
    @StateObject var vm = OfflineChatViewModel()
    var goBack: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button(action: goBack) {
                    Image(systemName: "chevron.left")
                        .font(.title2)
                        .padding()
                }
                Spacer()
                Text("Offline Chat")
                    .font(.headline)
                Spacer()
                Spacer().frame(width: 44)
            }
            .background(Color(.systemGray6))
            
            Divider()
            
            ScrollView {
                LazyVStack {
                    ForEach(vm.messages) { message in
                        ChatBubble(message: message)
                    }
                }
            }
            Divider()
            
            HStack {
                AppTextField(placeHolder: "Message...", text: $vm.inputText)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                
                Button(action: {
                    vm.sendMessage()
                }) {
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(.white)
                        .padding(12)
                        .background(Color.green)
                        .clipShape(Circle())
                }
            }
            .padding()
        }
        .navigationBarHidden(true)
    }
}
