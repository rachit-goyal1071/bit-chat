import Foundation

struct Message: Identifiable, Codable {
    var id = UUID()
    let text: String
    let timestamp: Date
    let sender: String
    
    var isSentByCurrentUser: Bool {
        sender == UserDefaults.standard.string(forKey: "username")
    }
}
