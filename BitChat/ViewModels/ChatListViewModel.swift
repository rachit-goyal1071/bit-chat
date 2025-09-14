import Foundation
import FirebaseFirestore


class ChatListViewModel: ObservableObject {
    @Published var rooms: [ChatRoom] = []
    private var db = Firestore.firestore()
    
    init() {
        fetchRooms()
    }
    
    func fetchRooms() {
        db.collection("rooms").addSnapshotListener { snapshot, error in
            guard let documents = snapshot?.documents else { return }
            self.rooms = documents.compactMap { doc in
                let data = doc.data()
                guard let name = data["name"] as? String else {
                    print("Invalid document data \(doc.documentID)")
                    return nil
                }
                return ChatRoom(id: doc.documentID, name: name)
            }
        }
    }
    func createRoom(name: String) {
        let newRoom = ChatRoom(name: name)
        do {
            _ = try db.collection("rooms").addDocument(from: newRoom)
        } catch {
            print("Error creating room: \(error)")
        }
    }
}
