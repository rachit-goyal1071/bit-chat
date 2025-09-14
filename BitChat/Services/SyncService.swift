import Foundation
import CoreData
import FirebaseFirestore

class SyncService {
    static let shared = SyncService()
    private init() {}
    
    private var db = Firestore.firestore()
    
    //load unsynced message from core data
    func fetchUnsyncedMessages(constext: NSManagedObjectContext) -> [MessageEntity] {
        let request: NSFetchRequest<MessageEntity> = MessageEntity.fetchRequest()
        request.predicate = NSPredicate(format: "isSynced == %d", NSNumber(value: false))
        do {
            return try constext.fetch(request)
        } catch {
            print("Error fetching unsynced messages: \(error)")
            return []
        }
    }
    
    // simulating sending server
    func syncMessages(roomId: String,context: NSManagedObjectContext) {
        let unsynced = fetchUnsyncedMessages(constext: context)
        guard !unsynced.isEmpty else {
            print("No unsynced messages to send")
            return
        }
        
        for message in unsynced {
            guard let text = message.text,
                  let sender = message.sender,
                  let timestamp = message.timestamp else {
                continue
            }
            
            let newMessage: [String: Any] = [
                "text": text,
                "timestamp": Timestamp(date: timestamp),
                "sender": sender
            ]
            
            db.collection("rooms")
                .document(roomId)
                .collection("messages")
                .addDocument(data: newMessage) { error in
                    if let error = error {
                        print("Error adding document: \(error)")
                    } else {
                        print("Synced ")
                        message.isSynced = true
                        
                        do {
                            try context.save()
                        } catch {
                            print("failed to sync: \(error)")
                        }
                    }
                }
            print("syncing message: \(message.text ?? "No text")")
            
            message.isSynced = true
        }
    
        
        do {
            try context.save()
            print("synced \(unsynced.count) messages")
        } catch {
            print("failed to sync")
        }
    }
}
