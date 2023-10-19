//
//  EditingController.swift
//  Neobis_iOS_ToDoApp
//
//  Created by Alikhan Tursunbekov on 18/10/23.

import UIKit

class EditingViewController: UIViewController {
    //delegates and callback
    var isNew: Bool = true
    var taskTitle: String = ""
    var desc: String = ""
    var isDone: Bool?
    var index: Int?
    
    init(isNew: Bool, taskTitle: String, desc: String, index: Int? = nil, isDone: Bool? = nil) {
        super.init(nibName: nil, bundle: nil)
        self.isNew = isNew
        self.taskTitle = taskTitle
        self.desc = desc
        self.index = index
        self.isDone = isDone
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Название"
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let descLabel: UILabel = {
        let label = UILabel()
        label.text = "Описание"
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let textView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .white
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.borderWidth = 1.0
        textView.layer.cornerRadius = 5
        textView.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    let descTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .white
        textView.layer.borderColor = UIColor.lightGray.cgColor
        textView.layer.borderWidth = 1.0
        textView.layer.cornerRadius = 5
        textView.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    let separatorView: UIView = {
        let separatorView = UIView()
        separatorView.backgroundColor = UIColor.lightGray
        separatorView.translatesAutoresizingMaskIntoConstraints = false
        return separatorView
    }()
    
    let deleteButton: UIButton = {
        let button = UIButton()
        button.setTitle("Удалить", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    var titlePlaceholder : UILabel = {
        let placeholderLabel = UILabel()
        placeholderLabel.text = "Название"
        placeholderLabel.sizeToFit()
        placeholderLabel.textColor = .tertiaryLabel
        return placeholderLabel
    }()
    
    var descPlaceholder: UILabel = {
        let placeholderLabel = UILabel()
        placeholderLabel.text = "Описание"
        placeholderLabel.sizeToFit()
        placeholderLabel.textColor = .tertiaryLabel
        return placeholderLabel
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 246 / 255, green: 245 / 255, blue: 247 / 255, alpha: 1)
        let cancelButton = UIBarButtonItem(title: "Отмена", style: .plain, target: self, action: #selector(cancelButtonTapped))
        cancelButton.tintColor = .systemRed
        let saveButton = UIBarButtonItem(title: "Сохранить", style: .plain, target: self, action: #selector(saveButtonTapped))
        saveButton.tintColor = .systemBlue
        
        self.navigationItem.leftBarButtonItem = cancelButton
        self.navigationItem.rightBarButtonItem = saveButton
        
        setupConstraints()
        textView.delegate = self
        descTextView.delegate = self
        textView.text = taskTitle
        descTextView.text = desc
        if !isNew {
            titlePlaceholder.isHidden = true
            descPlaceholder.isHidden = true
        } else {
            deleteButton.isHidden = true
        }
    }
    
    func setupConstraints() {
        view.addSubview(separatorView)
        view.addSubview(titleLabel)
        view.addSubview(textView)
        view.addSubview(descLabel)
        view.addSubview(descTextView)
        view.addSubview(deleteButton)
        
        NSLayoutConstraint.activate([
            separatorView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            separatorView.heightAnchor.constraint(equalToConstant: 1),
            separatorView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
            
            titleLabel.topAnchor.constraint(equalTo: separatorView.bottomAnchor, constant: 6),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            
            textView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6),
            textView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 35),
            textView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -35),
            textView.heightAnchor.constraint(equalToConstant: 50),
            
            descLabel.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 6),
            descLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            
            descTextView.topAnchor.constraint(equalTo: descLabel.bottomAnchor, constant: 6),
            descTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 35),
            descTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -35),
            descTextView.heightAnchor.constraint(equalToConstant: 550),
            
            deleteButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            deleteButton.topAnchor.constraint(equalTo: descTextView.bottomAnchor, constant: 30),
        ])
        //Title textView
        textView.addSubview(titlePlaceholder)
        titlePlaceholder.font = .italicSystemFont(ofSize: (textView.font?.pointSize)!)
        titlePlaceholder.frame.origin = CGPoint(x: 5, y: (textView.font?.pointSize)! / 2)
        titlePlaceholder.isHidden = !textView.text.isEmpty
        //Desciption textView
        descTextView.addSubview(descPlaceholder)
        descPlaceholder.font = .italicSystemFont(ofSize: (descTextView.font?.pointSize)!)
        descPlaceholder.frame.origin = CGPoint(x: 5, y: (descTextView.font?.pointSize)! / 2)
        descPlaceholder.isHidden = !descTextView.text.isEmpty
        
        //Targets:
        
        deleteButton.addTarget(self, action: #selector(deleteTapped), for: .touchUpInside)
    }
    
    @objc func saveButtonTapped() {
        DispatchQueue.main.async {
            if self.isNew {
                DataManager.shared.tasks.append(Task(title: self.textView.text, description: self.descTextView.text, isDone: false))
            } else {
                DataManager.shared.tasks[self.index!] = Task(title: self.textView.text, description: self.descTextView.text, isDone: self.isDone ?? false)
            }
        }
        refreshLocalData()
        dismiss(animated: true)
    }
    
    @objc func cancelButtonTapped() {
        dismiss(animated: true)
    }
    
    @objc func deleteTapped() {
        
        DispatchQueue.main.async {
            DataManager.shared.tasks.remove(at: self.index!)

        }
        refreshLocalData()
        dismiss(animated: true)
    }
    
    func refreshLocalData() {
        let encoder = JSONEncoder()
        
        if let encoded = try? encoder.encode(DataManager.shared.tasks) {
            UserDefaults.standard.set(encoded, forKey: "tasks")
        }
    }
}

extension EditingViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if textView == self.textView {
            titlePlaceholder.isHidden = !textView.text.isEmpty
        } else if textView == self.descTextView {
            descPlaceholder.isHidden = !textView.text.isEmpty
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView == self.textView {
            titlePlaceholder.isHidden = !textView.text.isEmpty
        } else if textView == self.descTextView {
            descPlaceholder.isHidden = !textView.text.isEmpty
        }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView == self.textView {
            titlePlaceholder.isHidden = true
        } else if textView == self.descTextView {
            descPlaceholder.isHidden = true
        }
    }
}

