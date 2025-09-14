import Foundation
import SwiftUI
import MultipeerConnectivity

class OfflineChatViewModel: ObservableObject, PeerManagerDelegate {
    @Published var messages: [Message] = []
    @Published var inputText: String = ""

    private var peerManager: PeerManager
    @AppStorage("username") var username: String?

    init(username: String?) {
        let name = username ?? "Unknown"
        self.peerManager = PeerManager(displayName: name)
        self.peerManager.delegate = self
        peerManager.start()
        loadOfflineMessages()
    }
    
    convenience init() {
            self.init(username: UserDefaults.standard.string(forKey: "username"))
        }

    func sendMessage() {
        guard let username = username,
              !inputText.trimmingCharacters(in: .whitespaces).isEmpty else { return }

        let newMessage = Message(text: inputText, timestamp: Date(), sender: username)
        messages.append(newMessage)
        peerManager.send(message: inputText)
            
        saveOfflineMessages(sender: username, text: inputText)
        inputText = ""
    }

    func didReceive(message: String, from peerID: MCPeerID) {
        let newMessage = Message(text: message, timestamp: Date(), sender: peerID.displayName)
        messages.append(newMessage)
    }
    
    func saveOfflineMessages(sender: String, text: String) {
        let context = CoreDataManager.shared.container.viewContext
        let message = MessageEntity(context: context)
        message.id = UUID()
        message.sender = sender
        message.text = text
        message.timestamp = Date()
        message.isSynced = false
        CoreDataManager.shared.saveContext()
        do {
                try context.save()
                print("Message saved to Core Data")
                
                debugPrintAllMessages()
            } catch {
                print("Failed to save message: \(error)")
            }
    }
    
    func loadOfflineMessages() {
        let context = CoreDataManager.shared.container.viewContext
        let fetchRequest = MessageEntity.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: true)]
        
        do {
            let results = try context.fetch(fetchRequest)
            self.messages = results.map {
                Message(
                    text: $0.text ?? "",
                    timestamp: $0.timestamp ?? Date(),
                    sender: $0.sender ?? "Unknown"
                )
            }
        } catch {
            print("Failed to fetch offline messages: \(error)")
        }
    }
 
    func debugPrintAllMessages() {
        let context = CoreDataManager.shared.container.viewContext
        let fetchRequest = MessageEntity.fetchRequest()

        do {
            let results = try context.fetch(fetchRequest)
            print("Found \(results.count) messages in Core Data")
            for msg in results {
                print("id: \(msg.id?.uuidString ?? "nil") sender: \(msg.sender ?? "nil") text: \(msg.text ?? "nil") timestamp: \(msg.timestamp ?? Date()) synced: \(msg.isSynced)")
            }
        } catch {
            print("Failed to fetch: \(error)")
        }
    }

}
