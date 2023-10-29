import UIKit

protocol TaskCellDelegate: AnyObject {
    func taskCellDidToggleDone(for cell: TaskCell)
}

class ViewController: UIViewController {
    var dataManager = DataManager.shared
    
    var isEditingMode = false
    var isNew = false
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(TaskCell.self, forCellReuseIdentifier: "CellIdentifier")
        tableView.tableHeaderView = UIView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.sectionFooterHeight = 100
        return tableView
    }()
    
    var addButton = UIButton()
    
    var addImage: UIImageView = {
        let image = UIImageView(image: UIImage(systemName: "plus.circle.fill"))
        image.contentMode = .scaleAspectFit
        image.tintColor = .systemGreen
        return image
    }()
    
    var editButton = UIButton()
    
    var editImage: UIImageView = {
        let image = UIImageView(image: UIImage(systemName: "pencil.circle.fill"))
        image.contentMode = .scaleAspectFit
        image.tintColor = .systemBlue
        return image
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupConstraints()
        addAllTargets()
    }
    
    override func viewIsAppearing(_ animated: Bool) {
        tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 100))
        let labelWidth: CGFloat = 270
        let labelHeight: CGFloat = 100
        let labelX = (footerView.bounds.width - labelWidth) / 2
        let footerLabel = UILabel(frame: CGRect(x: labelX, y: 0, width: labelWidth, height: labelHeight))
        footerLabel.textAlignment = .center
        footerLabel.numberOfLines = 0
        footerLabel.text = "Создайте новую задачу нажав на кнопку плюс."
        footerLabel.textColor = .black
        footerView.addSubview(footerLabel)
        return footerView
    }
    
    func setupConstraints() {
        view.addSubview(tableView)
        view.addSubview(addButton)
        addButton.addSubview(addImage)
        view.addSubview(editButton)
        editButton.addSubview(editImage)
        
        [tableView, addButton, addImage, editImage, editButton].forEach{$0.translatesAutoresizingMaskIntoConstraints = false}
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            addButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -70),
            addButton.heightAnchor.constraint(equalToConstant: 55),
            addButton.widthAnchor.constraint(equalToConstant: 55),
            addImage.centerXAnchor.constraint(equalTo: addButton.centerXAnchor),
            addImage.centerYAnchor.constraint(equalTo: addButton.centerYAnchor),
            addImage.heightAnchor.constraint(equalToConstant: 55),
            addImage.widthAnchor.constraint(equalToConstant: 55),
            
            editButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            editButton.bottomAnchor.constraint(equalTo: addButton.topAnchor, constant: -25),
            editButton.heightAnchor.constraint(equalToConstant: 55),
            editButton.widthAnchor.constraint(equalToConstant: 55),
            editImage.centerXAnchor.constraint(equalTo: editButton.centerXAnchor),
            editImage.centerYAnchor.constraint(equalTo: editButton.centerYAnchor),
            editImage.heightAnchor.constraint(equalToConstant: 55),
            editImage.widthAnchor.constraint(equalToConstant: 55),
        ])
    }
    
    func addAllTargets() {
        addButton.addTarget(self, action: #selector(addPressed), for: .touchUpInside)
        editButton.addTarget(self, action: #selector(editPressed), for: .touchUpInside)
    }
    
    @objc func editPressed() {
        addButton.isHidden = !isEditingMode
        tableView.isEditing = !isEditingMode
        editImage.image = isEditingMode ? UIImage(systemName: "pencil.circle.fill") : UIImage(systemName: "x.circle.fill")
        for cell in tableView.visibleCells {
            if let taskCell = cell as? TaskCell {
                taskCell.setEditingMode(!isEditingMode)
            }
        }
        isEditingMode.toggle()
    }
    
    @objc func addPressed() {
        isNew = true
        let vc = UINavigationController(rootViewController: EditingViewController(task: Task(title: "", description: "", isDone: false), isNew: true))
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
}


extension ViewController: UITableViewDataSource, UITableViewDelegate, TaskCellDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataManager.getCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier", for: indexPath) as! TaskCell
        cell.delegate = self
        cell.configureCell(title: dataManager.tasks[indexPath.row].title, descriptionText: dataManager.tasks[indexPath.row].description, isDone: dataManager.tasks[indexPath.row].isDone, image: (dataManager.tasks[indexPath.row].isDone ? "checkmark.circle" : "circle"))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == dataManager.tasks.count - 1 {
            cell.separatorInset.left = cell.bounds.size.width
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        isNew = false
        
        let task = Task(title: dataManager.tasks[indexPath.row].title, description: dataManager.tasks[indexPath.row].description, isDone: dataManager.tasks[indexPath.row].isDone)
        let vc = UINavigationController(rootViewController: EditingViewController(task: task, isNew: false, index:indexPath.row))
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            dataManager.removeTask(index: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        dataManager.moveTask(from: sourceIndexPath.row, into: destinationIndexPath.row)
    }
    
    func taskCellDidToggleDone(for cell: TaskCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            dataManager.toggleDone(index: indexPath.row, isDone: cell.doneTask)
            tableView.reloadRows(at: [indexPath], with: .none)
            dataManager.refreshData()
        }
    }
}
