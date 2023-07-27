//
//  MenuViewControllerViewModel.swift
//  GoodRecipeToDay
//
//  Created by apple on 09.07.2023.
//

import Foundation


protocol MenuViewControllerViewModelDelegate: AnyObject {
    func updateViewModel(viewModel: MenuViewControllerViewModel)
}

final class MenuViewControllerViewModel {
    //MARK: - Properties
    weak var delegate: MenuViewControllerViewModelDelegate?
    let firebaseManager = FirebaseManager.shared
    public var urlPhoto: URL? {
        guard let user = user, let urlString = user.urlString else {return nil}
        return URL(string: urlString )
    }
    public var user: GUser?
    //MARK: - Init
    init() {
        getUser()

    }
    //MARK: - Functions
    func getUser() {
        firebaseManager.fetchCurrentUser { [weak self] user in
            guard let strongSelf = self else { return }
            strongSelf.user = user
            strongSelf.delegate?.updateViewModel(viewModel: strongSelf)
        }
    }
}

