//
//  File.swift
//  GoodRecipeToDay
//
//  Created by apple on 12.06.2023.
//

import UIKit
import FirebaseFirestore

class PaginationViewController: UIViewController {

    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .systemBackground
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    private var viewModel: PaginationViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()

        viewModel = PaginationViewModel()
        viewModel.delegate = self
        viewModel.startListeningForChanges()

        viewModel.fetchFirstPage()
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.backgroundColor = .blue // Set the background color of the table view
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func fetchNextPage() {
        viewModel.fetchNextPage()
    }
}

extension PaginationViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dataSource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let recipe = viewModel.dataSource[indexPath.row]
        cell.textLabel?.text = recipe.title
        cell.backgroundColor = .red
        return cell
    }


    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastRowIndex = tableView.numberOfRows(inSection: 0) - 1
        if indexPath.row == lastRowIndex {
            self.fetchNextPage()
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 400
    }
}

extension PaginationViewController: PaginationViewModelDelegate {
    func didFetchData() {
        tableView.reloadData()
    }

    func didFail(with error: Error) {
        print("Error fetching data: \(error.localizedDescription)")
    }
}

// delay
