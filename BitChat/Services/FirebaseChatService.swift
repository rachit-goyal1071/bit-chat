import FirebaseFirestore

class FirebaseChatService {
    static let shared = FirebaseChatService()
    private let db = Firestore.firestore()
    
    func sendMessage(roomId: String, text: String, sender: String, completion: @escaping () -> Void) {
        let data: [String: Any] = [
            "text": text,
            "sender": sender,
            "timestamp": Timestamp(date: Date())
        ]
        
        db.collection("rooms").document(roomId).collection("messages").addDocument(data: data) { error in
            if error == nil {
                completion()
            }
            
        }
    }
}
