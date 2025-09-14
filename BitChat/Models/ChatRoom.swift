import Foundation
import FirebaseFirestore

struct ChatRoom: Identifiable, Codable{
    var id: String?
    var name: String
}
