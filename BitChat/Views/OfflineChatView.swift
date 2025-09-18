import SwiftUI

struct OfflineChatView: View {
    @StateObject private var vm = OfflineChatViewModel()
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
                Text("Offline Chat Room")
                    .font(.headline)
                Spacer()
                Spacer().frame(width: 44)
            }
            .background(Color(.systemGray6))
            ScrollView {
                LazyVStack {
                    ForEach(vm.messages) { message in
                        ChatBubble(message: message)
                    }
                }
            }

            Divider()

            HStack {
                TextField("Message...", text: $vm.inputText)
                    .padding(12)
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
//        .navigationTitle("Offline Chat")
    }
}

