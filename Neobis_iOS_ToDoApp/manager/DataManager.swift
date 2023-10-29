import Foundation

class DataManager {
    static let shared = DataManager()
    
    var tasks: [Task] = []
    
    private init() {}
    
    func refreshData() {
        let encoder = JSONEncoder()
        
        if let encoded = try? encoder.encode(tasks) {
            UserDefaults.standard.set(encoded, forKey: "tasks")
        }
    }
    
    func getCount() -> Int{
        return tasks.count
    }
    
    func removeTask(index: Int) {
        tasks.remove(at: index)
        refreshData()
    }
    
    func moveTask(from: Int, into: Int) {
        let movedTask = tasks.remove(at: from)
        tasks.insert(movedTask, at: into)
    }
    
    func toggleDone(index: Int, isDone: Bool) {
        tasks[index].isDone = isDone
    }
}
