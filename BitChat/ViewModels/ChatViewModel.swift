import Foundation
import SwiftUI
import FirebaseFirestore


class ChatViewModel: ObservableObject {
    @Published var messages: [Message] = []
    @Published var inputText: String = ""
    
    @AppStorage("username") var username: String?
    private var db = Firestore.firestore()
    private var roomId: String
    
    init(roomId: String) {
        self.roomId = roomId
        listenForMessage()
    }
    
    func sendMessage() {
        guard let username = username,
              !inputText.trimmingCharacters(in: .whitespaces).isEmpty else {return}
        
        let newMessage: [String: Any] = [
            "text": inputText,
            "timestamp": Timestamp(date: Date()),
            "sender": username
        ]
        
//        messages.append(newMessage)
        db.collection("rooms")
            .document(roomId)
            .collection("messages")
            .addDocument(data: newMessage)
        inputText = ""
    }
    
    func listenForMessage() {
        db.collection("rooms")
            .document(roomId)
            .collection("messages")
            .order(by: "timestamp", descending: false)
            .addSnapshotListener { snapshot, error in
                guard let documents = snapshot?.documents else {return}
                self.messages = documents.compactMap{doc -> Message? in
                    let data = doc.data()
                    guard let text = data["text"] as? String,
                          let timestamp = data["timestamp"] as? Timestamp,
                          let sender = data["sender"] as? String else {return nil}
                    return Message(text: text, timestamp: timestamp.dateValue(), sender: sender)
                }
            }
    }
}
