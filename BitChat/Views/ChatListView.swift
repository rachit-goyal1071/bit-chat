import SwiftUI

struct ChatListView: View {
    @StateObject private var vm = ChatListViewModel()
    @State private var newRoomName = ""
    @State private var showCreateRoom = false
    var goBack : () -> Void
    
    
    var body: some View {
        NavigationStack {
            List(vm.rooms) { room in
                NavigationLink(destination: ChatView(roomId: room.id ?? "unknown", roomName: room.name)) {
                    AppText(text: room.name)
                        .font(.headline)
                }
            }
            .navigationTitle("Chat Rooms")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar{
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: goBack) {
                        Image(systemName: "chevron.left")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        showCreateRoom = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showCreateRoom) {
                VStack(spacing: 20) {
                    AppText(text: "Create Room")
                        .font(.title2)
                    AppTextField(placeHolder: "Room Name", text: $newRoomName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                    
                    AppButton(title: "Create", action: {
                        if !newRoomName.trimmingCharacters(in: .whitespaces).isEmpty {
                            vm.createRoom(name: newRoomName)
                            newRoomName = ""
                            showCreateRoom = false
                        }
                    })
                    Spacer()
                }
                .padding()
            }
        }
    }
}
