//
//  ContentViewControllerViewModel.swift
//  GoodRecipeToDay
//
//  Created by apple on 09.07.2023.
//

import Foundation

protocol ContentViewControllerViewModelDelegate: AnyObject {
    func updateViewModel(viewModel: ContentViewControllerViewModel)
}
final class ContentViewControllerViewModel {
    //MARK: - Properties
    weak var delegate: ContentViewControllerViewModelDelegate?
    let firebaseManager = FirebaseManager.shared
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
    
    
    func isAuth() -> Bool {
        return  firebaseManager.curenUser() == nil
    }
}
