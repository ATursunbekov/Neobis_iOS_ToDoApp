import UIKit

class TaskCell: UITableViewCell {
    var doneTask = false
    weak var delegate: TaskCellDelegate?
    
    var isEditingMode = false
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    lazy var isDone: UIButton = {
        let button = UIButton()
        return button
    }()
    
    lazy var checkImage: UIImageView = {
        let image = UIImageView(image: UIImage(systemName: "circle"))
        image.contentMode = .scaleAspectFit
        image.tintColor = UIColor(red: 240 / 255, green: 158 / 255 , blue: 30 / 255, alpha: 1)
        return image
    }()
    
    lazy var infoImage: UIImageView = {
        let image = UIImageView(image: UIImage(systemName: "info.circle"))
        image.contentMode = .scaleAspectFit
        image.tintColor = UIColor.systemBlue
        return image
    }()
    
    lazy var arrowImage: UIImageView = {
        let image = UIImageView(image: UIImage(systemName: "chevron.right"))
        image.contentMode = .scaleAspectFit
        image.tintColor = UIColor.lightGray
        return image
    }()

    // func setupCell(task: Task) {
        // cell.selectionStyle = .none
        // cell.delegate = self
        // cell.titleLabel.text = dataManager.tasks[indexPath.row].title
        // cell.desc.text = dataManager.tasks[indexPath.row].description
        // cell.done = dataManager.tasks[indexPath.row].isDone
        // cell.checkImage.image = dataManager.tasks[indexPath.row].isDone ? UIImage(systemName: "checkmark.circle") : UIImage(systemName: "circle")
         
    // }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupConstraints()
        isDone.addTarget(self, action: #selector(donePressed), for: .touchUpInside)
        selectionStyle = .none
    }
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize) -> CGSize {
        let fittingSize = CGSize(width: targetSize.width, height: UIView.layoutFittingCompressedSize.height)
        return contentView.systemLayoutSizeFitting(fittingSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
    }
    
    func setupConstraints() {
        contentView.addSubview(infoImage)
        contentView.addSubview(arrowImage)
        contentView.addSubview(titleLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(isDone)
        isDone.addSubview(checkImage)
        
        [infoImage, arrowImage, titleLabel, descriptionLabel, isDone, checkImage].forEach{$0.translatesAutoresizingMaskIntoConstraints = false}
        
        NSLayoutConstraint.activate([
            isDone.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            isDone.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            isDone.heightAnchor.constraint(equalToConstant: 22),
            isDone.widthAnchor.constraint(equalToConstant: 22),
            checkImage.centerXAnchor.constraint(equalTo: isDone.centerXAnchor),
            checkImage.centerYAnchor.constraint(equalTo: isDone.centerYAnchor),
            checkImage.heightAnchor.constraint(equalToConstant: 22),
            checkImage.widthAnchor.constraint(equalToConstant: 22),
            
            arrowImage.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -8),
            arrowImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            arrowImage.heightAnchor.constraint(equalToConstant: 20),
            arrowImage.widthAnchor.constraint(equalToConstant: 20),
            
            infoImage.trailingAnchor.constraint(equalTo: arrowImage.leadingAnchor, constant: -8),
            infoImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            infoImage.heightAnchor.constraint(equalToConstant: 28),
            infoImage.widthAnchor.constraint(equalToConstant: 28),
            
            titleLabel.leadingAnchor.constraint(equalTo: isDone.trailingAnchor, constant: 8),
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: infoImage.leadingAnchor, constant: -8),
            
            descriptionLabel.leadingAnchor.constraint(equalTo: isDone.trailingAnchor, constant: 8),
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            descriptionLabel.trailingAnchor.constraint(equalTo: infoImage.leadingAnchor, constant: -8),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    @objc func donePressed() {
        checkImage.image = UIImage(systemName: doneTask ? "circle" : "checkmark.circle")
        doneTask.toggle()
        delegate?.taskCellDidToggleDone(for: self)
    }
    
    func setEditingMode(_ isEditing: Bool) {
        isEditingMode = isEditing
        infoImage.isHidden = isEditing
        arrowImage.isHidden = isEditing
    }
    
    func configureCell(title: String, descriptionText: String, isDone: Bool, image: String) {
        titleLabel.text = title
        descriptionLabel.text = descriptionText
        doneTask = isDone
        checkImage.image = UIImage(systemName: image)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
