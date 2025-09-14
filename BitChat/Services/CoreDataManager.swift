import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    let container: NSPersistentContainer
    
    init() {
        container = NSPersistentContainer(name: "BitChatModel")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Core data failed to load \(error)")
            }
        }
    }
    
    func saveContext() {
        let context = container.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Failed to save context \(error)")
            }
        }
    }
}
