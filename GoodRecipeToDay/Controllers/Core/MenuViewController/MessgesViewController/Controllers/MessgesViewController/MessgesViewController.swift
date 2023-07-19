//
//  MessgesViewController.swift
//  GoodRecipeToDay
//
//  Created by apple on 05.07.2023.
//

import UIKit

class MessgesViewController: UIViewController {
    //MARK: - Properties
    private var viewModel: MessgesViewControllerViewModel?
    
    var cellHeights: [IndexPath: CGFloat] = [:]

    
    let emptyChatLabel: UILabel = {
       let label = UILabel()
        label.text = "No Massages"
        label.backgroundColor = .red
//        label.isHidden = true
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
        tv.backgroundColor = .secondarySystemBackground
        tv.register(MessageCell.self, forCellReuseIdentifier: MessageCell.identifair)
        tv.separatorStyle = .none
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    //MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBesicUI()
        view.addSubview(chatTableView)
        view.addSubview(sendTextView)
        view.addSubview(emptyChatLabel)
        addConstraints()
        
        chatTableView.delegate = self
        chatTableView.dataSource = self
        viewModel?.delegate = self
        
        keyboardBehavior()

    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    //MARK: - Functions
    public func configure(viewModel: MessgesViewControllerViewModel) {
        self.viewModel = viewModel
    }
    private func setupBesicUI() {
        view.backgroundColor = .secondarySystemBackground
        navigationController?.navigationBar.tintColor = .label
        navigationItem.title = viewModel?.title ?? "No titile"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(didTapClose))
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
    @objc private func viewTapped() {
        sendTextView.resignFirstResponder()
        sendTextView.endEditing(true)
    }
    
    fileprivate func keyboardBehavior() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        view.addGestureRecognizer(tapGesture)
    }
    @objc func didTapClose() {
        dismiss(animated: true)
    }
}


extension MessgesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if viewModel?.messages.count ?? 0 == 0 {
//            emptyChatLabel.isHidden = false
//        } else {
//            emptyChatLabel.isHidden = true
//        }
        return viewModel?.messages.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MessageCell.identifair, for: indexPath) as? MessageCell else {
            return UITableViewCell()
        }
        cell.delegate = self
        guard let viewModel = viewModel else { return UITableViewCell() }

        cell.congifure(viewModel: MessageCellViewModel(chat: viewModel.messages[indexPath.row]))
        return cell
    }

    
}


//MARK: - Delegate

extension MessgesViewController: MessageCellDelegate {
    func cellHeightUpdated(for cell: MessageCell) {
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


extension MessgesViewController: MessgesViewControllerViewModelDelegate {
    func updateVM(viewModel: MessgesViewControllerViewModel) {
        self.viewModel = viewModel
        chatTableView.reloadData()
    }
    
    
}

extension MessgesViewController: TextFildButtonViewDelegate {
    func massageSended(massage: String) {
        guard let viewModel = viewModel else { return }
        viewModel.saveMessage(message: massage)
        sendTextView.endEditing(true)
        

    }
}
