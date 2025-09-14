import SwiftUI

struct ChatView: View {
    @StateObject private var vm: ChatViewModel
    var roomName: String
    @Environment(\.presentationMode) var presentationMode
    
    init(roomId: String, roomName: String) {
        self._vm = StateObject(wrappedValue: ChatViewModel(roomId: roomId))
        self.roomName = roomName
    }
    
    var body: some View {
        
        HStack {
            Button(action: {presentationMode.wrappedValue.dismiss()}) {
                Image(systemName: "chevron.left")
                    .font(.title2)
                    .padding()
            }
            Spacer()
            Text("Chat Room")
                .font(.headline)
            Spacer()
            Spacer().frame(width: 44)
        }
        .background(Color(.systemGray6))

        Divider()
        VStack(spacing: 0) {
            ScrollViewReader{scrollProxy in
                ScrollView {
                    LazyVStack(alignment: .leading) {
                        ForEach(vm.messages) { message in
                            ChatBubble(message: message)
                        }
                    }
                }
                .onChange(of: vm.messages.count) {
                    withAnimation {
                        scrollProxy.scrollTo(vm.messages.last?.id, anchor: .bottom)
                    }
                }
            }
            Divider()
            
            HStack {
                TextField("Message...", text: $vm.inputText)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(10)
                
                Button(action: {
                    vm.sendMessage()
                }) {
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(.white)
                        .padding(12)
                        .background(Color.purple)
                        .clipShape(Circle())
                }
            }
            .padding()
        }
        .navigationBarHidden(true)
    }
}
