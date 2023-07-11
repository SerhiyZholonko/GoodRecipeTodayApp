//
//  ChatViewController.swift
//  GoodRecipeToDay
//
//  Created by apple on 16.06.2023.
//

import UIKit

protocol ChatViewControllerDelegate: AnyObject {
   func reloadVM()
}

class ChatViewController: UIViewController {
    //MARK: - Properties

    var viewModel: ChatViewControllerViewModel
    
    weak var delegate: ChatViewControllerDelegate?
    
    var cellHeights: [IndexPath: CGFloat] = [:]

    
    let emptyChatLabel: UILabel = {
       let label = UILabel()
        label.text = "No Massages"
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var sendTextView: TextFildButtonView = {
        let view = TextFildButtonView()
        view.backgroundColor = .secondarySystemBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        return view
    }()
    let chatTableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = .systemBackground
        tv.register(ChatTableViewCell.self, forCellReuseIdentifier: ChatTableViewCell.identifier)
        tv.separatorStyle = .none
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    //MARK: - Lifecycle
    init(viewModel: ChatViewControllerViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        viewModel.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(chatTableView)
        view.addSubview(sendTextView)
        view.addSubview(emptyChatLabel)
        addConstraints()
        
        chatTableView.delegate = self
        chatTableView.dataSource = self
        
        keyboardBehavior()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    //MARK: - Keyboard Handling
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {
            return
        }
        
        let keyboardHeight = keyboardFrame.height
        
        UIView.animate(withDuration: 0.3) {
            self.sendTextView.transform = CGAffineTransform(translationX: 0, y: -keyboardHeight)
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.3) {
            self.sendTextView.transform = .identity
        }
    }
    
    //MARK: - Gesture Handling
    @objc private func viewTapped() {
        sendTextView.resignFirstResponder()
        sendTextView.endEditing(true)
    }
    
    //MARK: - Functions
    fileprivate func keyboardBehavior() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        view.addGestureRecognizer(tapGesture)
    }
    private func addConstraints() {
        let sendTextViewConstraints = [
            sendTextView.leftAnchor.constraint(equalTo: view.leftAnchor),
            sendTextView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 10),
            sendTextView.rightAnchor.constraint(equalTo: view.rightAnchor),
            sendTextView.heightAnchor.constraint(equalToConstant: 80)
        ]
        NSLayoutConstraint.activate(sendTextViewConstraints)
        
        let chatTableViewConstraints = [
            chatTableView.topAnchor.constraint(equalTo: view.topAnchor),
            chatTableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            chatTableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            chatTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -80),
        ]
        NSLayoutConstraint.activate(chatTableViewConstraints)
        let emptyChatLabelCoctraints = [
            emptyChatLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyChatLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ]
        NSLayoutConstraint.activate(emptyChatLabelCoctraints)
    }
}



//MARK: - TableView

extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.returnChatCount() == 0 {
            emptyChatLabel.isHidden = false
        } else {
            emptyChatLabel.isHidden = true
        }
        return viewModel.returnChatCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ChatTableViewCell.identifier, for: indexPath) as? ChatTableViewCell else {
            return UITableViewCell()
        }
        cell.delegate = self
        cell.configure(viewModel: ChatTableViewCellViewModel(chat: viewModel.getSingleChat(indexPath: indexPath)))
        if let cellHeight = cellHeights[indexPath] {
            cell.heightConstraint.constant = cellHeight
        }
        return cell
    }

    
}

//MARK: - delegate

extension ChatViewController: TextFildButtonViewDelegate {
    func massageSended(massage: String) {
        viewModel.saveMassage(massage: massage)
        sendTextView.endEditing(true)
        delegate?.reloadVM()
    }
}
extension ChatViewController: ChatViewControllerViewModelViewModelDelegate {
    func reloadTableView(viewModel: ChatViewControllerViewModel) {
        self.viewModel = viewModel
        delegate?.reloadVM()
        chatTableView.reloadData()

    }
}


extension ChatViewController: ChatTableViewCellDelegate {
    func cellHeightUpdated(for cell: ChatTableViewCell) {
        guard let indexPath = chatTableView.indexPath(for: cell) else {
            return
        }
        
        let previousHeight = cellHeights[indexPath] ?? 0
        let newHeight = cell.heightConstraint.constant
        
        if previousHeight != newHeight {
            cellHeights[indexPath] = newHeight
            chatTableView.reloadRows(at: [indexPath], with: .automatic)
        }

    }

}
