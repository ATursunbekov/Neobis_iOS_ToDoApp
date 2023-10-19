import UIKit

class TaskCell: UITableViewCell {
    var done = false
    weak var delegate: TaskCellDelegate?
    
    // Define your cell's UI elements here
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let desc: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let isDone: UIButton = {
       let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let checkImage: UIImageView = {
        let image = UIImageView()
        //image.image = UIImage(systemName: "checkmark.circle")
        image.image = UIImage(systemName: "circle")
        image.contentMode = .scaleAspectFit
        image.tintColor = UIColor(red: 240 / 255, green: 158 / 255 , blue: 30 / 255, alpha: 1)
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let infoImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "info.circle")
        image.contentMode = .scaleAspectFit
        image.tintColor = UIColor.systemBlue
        //image.backgroundColor = UIColor.red
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    let arrowImage: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "chevron.right")
        image.contentMode = .scaleAspectFit
        image.tintColor = UIColor.lightGray
        //image.backgroundColor = UIColor.red
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupConstraints()
        isDone.addTarget(self, action: #selector(donePressed), for: .touchUpInside)
    }
    
    func setupConstraints() {
        contentView.addSubview(infoImage)
        contentView.addSubview(arrowImage)
        contentView.addSubview(titleLabel)
        contentView.addSubview(desc)
        contentView.addSubview(isDone)
        isDone.addSubview(checkImage)
        
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
            
            desc.leadingAnchor.constraint(equalTo: isDone.trailingAnchor, constant: 8),
            desc.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            desc.trailingAnchor.constraint(equalTo: infoImage.leadingAnchor, constant: -8),
            desc.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    @objc func donePressed() {
        if done {
            done = false
            checkImage.image = UIImage(systemName: "circle")
        } else {
            done = true
            checkImage.image = UIImage(systemName: "checkmark.circle")
        }
        
        delegate?.taskCellDidToggleDone(for: self)
    }
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize) -> CGSize {
            let fittingSize = CGSize(width: targetSize.width, height: UIView.layoutFittingCompressedSize.height)
            return contentView.systemLayoutSizeFitting(fittingSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
        }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
