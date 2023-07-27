//
//  SenderViewController.swift
//  GoodRecipeToDay
//
//  Created by apple on 07.07.2023.
//

import UIKit

class SenderViewController: UIViewController {
    //MARK: - Properties
    private var viewModel = SenderViewControllerViewModel()
    
//    var cellHeights: [IndexPath: CGFloat] = [:]

    
    let emptyChatLabel: UILabel = {
       let label = UILabel()
        label.text = "No Massages"
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let chatTableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = .secondarySystemBackground
        tv.register(SenderCell.self, forCellReuseIdentifier: SenderCell.identifier)
        tv.separatorStyle = .none
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    //MARK: - Init
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBesicUI()
        view.addSubview(chatTableView)
        view.addSubview(emptyChatLabel)
        addConstraints()
        
        chatTableView.delegate = self
        chatTableView.dataSource = self
        viewModel.delegate = self
        
//        keyboardBehavior()

    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    //MARK: - Functions
    private func setupBesicUI() {
        view.backgroundColor = .secondarySystemBackground
        navigationController?.navigationBar.tintColor = .label
        navigationItem.title = viewModel.title
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(didTapClose))
    }
    
    private func addConstraints() {
    
        
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

    @objc func didTapClose() {
        dismiss(animated: true)
    }
}


extension SenderViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.users.count == 0 {
            emptyChatLabel.isHidden = false
        } else {
            emptyChatLabel.isHidden = true
        }
        return viewModel.users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SenderCell.identifier, for: indexPath) as? SenderCell else {
            return UITableViewCell()
        }

        cell.congifure(viewModel: SenderCellViewModel(username: viewModel.users[indexPath.row]))
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let vc = MessgesViewController()
        vc.configure(viewModel: MessgesViewControllerViewModel(for: viewModel.users[indexPath.row]))
        navigationController?.pushViewController(vc, animated: true)
    }
    
}


//MARK: - Delegate

//
extension SenderViewController: SenderViewControllerViewModelDelegate {
    func updateVM(viewModel: SenderViewControllerViewModel) {
        self.viewModel = viewModel
        chatTableView.reloadData()
    }
    
    
    
    
}

