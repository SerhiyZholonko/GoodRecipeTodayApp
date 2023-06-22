//
//  ChatViewControllerViewModel.swift
//  GoodRecipeToDay
//
//  Created by apple on 16.06.2023.
//

import Foundation

protocol ChatViewControllerViewModelViewModelDelegate: AnyObject {
    func reloadTableView(viewModel: ChatViewControllerViewModel )
}
final class ChatViewControllerViewModel {
    weak var delegate: ChatViewControllerViewModelViewModelDelegate?
    public var massage: String = ""
    public var chat: [Chat] = []
    private let firebaseManager = FirebaseManager.shared
    private let recipe: Recipe
    
    init(recipe: Recipe) {
        self.recipe = recipe
        getChats()
    }
    public func returnChatCount() -> Int {
        return chat.count
    }
    public func getSingleChat(indexPath: IndexPath) -> Chat {
        return chat[indexPath.item]
    }
    public func saveMassage(massage: String) {
        firebaseManager.getRecipeIDForUser(username: recipe.username, recipeName: recipe.title) { [weak self] result in
            guard let strongSelf = self else {
                return
            }
            switch result {
             
            case .success(let id):
                self?.firebaseManager.updateRecipeForChat(username: strongSelf.recipe.username, recipeID: id, chatMessage: massage, recipe: strongSelf.recipe, completion: { error in
                    if let error = error {
                        print(error.localizedDescription)
                    }
                    strongSelf.getChats()
                })
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        firebaseManager.getRecipeIDForUserMain(recipeName: recipe.title) { [weak self] result in
            guard let strongSelf = self else {
                return
            }
            switch result {
             
            case .success(let id):
                self?.firebaseManager.updateRecipeMainForChat(username: strongSelf.recipe.username, recipeID: id, chatMessage: massage, recipe: strongSelf.recipe, completion: { error in
                    if let error = error {
                        print(error.localizedDescription)
                    }
                    strongSelf.getChats()
                })
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    public func getChats() {
        firebaseManager.getRecipeIDForUser(username: recipe.username, recipeName: recipe.title) { [weak self] result in
            guard let strongSelf = self else {
                return
            }
            switch result {
              
            case .success(let id):
                strongSelf.firebaseManager.getChatsForRecipe(username: strongSelf.recipe.username, recipeID: id) { chat, error in
                    if let error = error {
                        print(error.localizedDescription)
                    } else if let chat = chat {
                        strongSelf.chat = chat
                        strongSelf.delegate?.reloadTableView(viewModel: strongSelf)
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        firebaseManager.getRecipeIDForUserMain( recipeName: recipe.title) { [weak self] result in
            guard let strongSelf = self else {
                return
            }
            switch result {
              
            case .success(let id):
                strongSelf.firebaseManager.getChatsMainForRecipe(username: strongSelf.recipe.username, recipeID: id) { chat, error in
                    if let error = error {
                        print(error.localizedDescription)
                    } else if let chat = chat {
                        strongSelf.chat = chat
                        strongSelf.delegate?.reloadTableView(viewModel: strongSelf)
                    }
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
