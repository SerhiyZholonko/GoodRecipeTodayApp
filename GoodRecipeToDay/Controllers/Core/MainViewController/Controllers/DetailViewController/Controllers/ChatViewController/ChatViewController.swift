//
//  ChatViewController.swift
//  GoodRecipeToDay
//
//  Created by apple on 16.06.2023.
//

import UIKit


class ChatViewController: UIViewController {
    //MARK: - Properties
    
    var viewModel: ChatViewControllerViewModel
    
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
            chatTableView.bottomAnchor.constraint(equalTo: sendTextView.topAnchor),
        ]
        NSLayoutConstraint.activate(chatTableViewConstraints)
    }
}



//MARK: - TableView

extension ChatViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.returnChatCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ChatTableViewCell.identifier, for: indexPath) as? ChatTableViewCell else { return UITableViewCell() }
        cell.delegate = self
        cell.configure(viewModel: ChatTableViewCellViewModel(chat: viewModel.getSingleChat(indexPath: indexPath)))
        return cell
    }

}

//MARK: - delegate

extension ChatViewController: TextFildButtonViewDelegate {
    func massageSended(massage: String) {
        viewModel.saveMassage(massage: massage)

    }
    
    
}

extension ChatViewController: ChatViewControllerViewModelViewModelDelegate {
    func reloadTableView(viewModel: ChatViewControllerViewModel) {
        self.viewModel = viewModel
        chatTableView.reloadData()
        sendTextView.endEditing(true)
    }
    
    
}


extension ChatViewController: ChatTableViewCelldelegate {
    func reloadTableView() {
        viewModel.getChats()
    }
}
