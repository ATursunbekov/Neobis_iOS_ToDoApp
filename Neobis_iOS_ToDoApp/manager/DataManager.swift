import Foundation

class DataManager {
    static let shared = DataManager()
    
    var tasks: [Task] = []
    
    private init() {}
}
