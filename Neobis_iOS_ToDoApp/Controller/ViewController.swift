import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, TaskCellDelegate {
    var dataManager = DataManager.shared
    
    var isChanging = false
    var isNew = false
    
    var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(TaskCell.self, forCellReuseIdentifier: "CellIdentifier")
        tableView.tableHeaderView = UIView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    var addButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var addImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "plus.circle.fill")
        image.contentMode = .scaleAspectFit
        image.tintColor = .systemGreen
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    var editButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var editImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "pencil.circle.fill")
        image.contentMode = .scaleAspectFit
        image.tintColor = .systemBlue
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        setupConstraints()
        addAllTargets()
        tableView.sectionFooterHeight = 100
    }
    
    override func viewIsAppearing(_ animated: Bool) {
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        // Create a view for the section footer
        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.width, height: 100)) // Set the desired height
        
        // Add a label to the footer view
        let labelWidth: CGFloat = 270
        let labelHeight: CGFloat = 100
        let labelX = (footerView.bounds.width - labelWidth) / 2 // Calculate X position for centering the label
        let footerLabel = UILabel(frame: CGRect(x: labelX, y: 0, width: labelWidth, height: labelHeight))
        footerLabel.textAlignment = .center
        footerLabel.numberOfLines = 0
        footerLabel.text = "Создайте новую задачу нажав на кнопку плюс."
        footerLabel.textColor = .black
        
        // Add the label to the footer view
        footerView.addSubview(footerLabel)
        
        return footerView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    func setupConstraints() {
        view.addSubview(tableView)
        view.addSubview(addButton)
        addButton.addSubview(addImage)
        view.addSubview(editButton)
        editButton.addSubview(editImage)
        
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
        if isChanging {
            isChanging = false
            editImage.image = UIImage(systemName: "pencil.circle.fill")
            addButton.isHidden = false
            tableView.isEditing = false
        } else {
            tableView.isEditing = true
            isChanging = true
            editImage.image = UIImage(systemName: "x.circle.fill")
            addButton.isHidden = true
        }
    }
    
    @objc func addPressed() {
        isNew = true
        let vc = UINavigationController(rootViewController: EditingViewController(isNew: true, taskTitle: "", desc: ""))
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    // MARK: - UITableViewDataSource Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataManager.tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellIdentifier", for: indexPath) as! TaskCell
        cell.selectionStyle = .none
        cell.delegate = self
        cell.titleLabel.text = dataManager.tasks[indexPath.row].title
        cell.desc.text = dataManager.tasks[indexPath.row].description
        cell.done = dataManager.tasks[indexPath.row].isDone
        cell.checkImage.image = dataManager.tasks[indexPath.row].isDone ? UIImage(systemName: "checkmark.circle") : UIImage(systemName: "circle")
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    // Remove separator insets for the first and last cells
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == dataManager.tasks.count - 1 {
            cell.separatorInset.left = cell.bounds.size.width
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        isNew = false
        let taskTitle = dataManager.tasks[indexPath.row].title
        let desc = dataManager.tasks[indexPath.row].description
        let done = dataManager.tasks[indexPath.row].isDone
        let vc = UINavigationController(rootViewController: EditingViewController(isNew: false, taskTitle: taskTitle, desc: desc, index:indexPath.row, isDone: done))
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            dataManager.tasks.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // Handle cell reordering
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedTask = dataManager.tasks.remove(at: sourceIndexPath.row)
        dataManager.tasks.insert(movedTask, at: destinationIndexPath.row)
    }
    
    func taskCellDidToggleDone(for cell: TaskCell) {
        // Get the index path of the cell
        if let indexPath = tableView.indexPath(for: cell) {
            // Update the isDone property of the corresponding Task object
            dataManager.tasks[indexPath.row].isDone = cell.done
            // Reload the cell to reflect the updated state
            tableView.reloadRows(at: [indexPath], with: .none)
            print(dataManager.tasks[indexPath.row].isDone)
        }
    }
}

//Protocol for cell
protocol TaskCellDelegate: AnyObject {
    func taskCellDidToggleDone(for cell: TaskCell)
}
