import Foundation

class DataManager {
    static let shared = DataManager()
    
    var tasks: [Task] = [
        Task(title: "Task 1", description: "Something", isDone: false),
        Task(title: "Task 2", description: "Something", isDone: true),
        Task(title: "Альберт Эйнштейн", description: "Альбе́рт Эйнште́йн — американский, немецкий и швейцарский физик-теоретик и общественный деятель-гуманист, один из основателей современной теоретической физики. Лауреат Нобелевской премии по физике 1921 года", isDone: false),
    ]
    
    private init() {}
}
