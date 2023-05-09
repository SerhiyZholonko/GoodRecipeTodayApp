//
//  AddViewControllerViewModel.swift
//  GoodRecipeToDay
//
//  Created by apple on 28.04.2023.
//

import UIKit

final class AddViewControllerViewModel {
    let firebaseManager = FirebaseManager.shared
    let title = "Adding"
    var ingregients = [AddIngredientTableViewCellViewModel]()
    var instructions = [CookingTableViewCellViewModel]()
    init() {
        addIngredients()
        addInstructions()
    }
     func addInstructions() {
        let newInstructions = CookingTableViewCellViewModel(instruction: "", image: UIImage(named: "add"))
        self.instructions.append(newInstructions)
    }
    
   private  func addIngredients() {
        let newIngredients = [AddIngredientTableViewCellViewModel(ingredient: "2 eggs"), AddIngredientTableViewCellViewModel(ingredient: "100g wather")]
        self.ingregients.append(contentsOf: newIngredients)
    }
     func addOneInfredient() {
        let newIngredient = AddIngredientTableViewCellViewModel(ingredient: "quantity / product")
        self.ingregients.append(newIngredient)
    }
    func getIndex(cell: CookingTableViewCell) -> Int? {
        guard let image = cell.photoImageView.image else { return  nil}
        let images = instructions.map{$0.image}
        if let index = images.firstIndex(of: image) {
            return index
        } else {
            return nil
        }
    }
    func addToFirebase(mainImage: UIImage?, title: String, description: String, category: String, quantity: String, time: String, ingredient: [Ingredient], step: [Step], complition: @escaping () -> Void) {
        guard let mainImage = mainImage else { return }
        firebaseManager.uploadImage(mainImage) { result in
            switch result {
                
            case .success(let success):
                self.firebaseManager.createRecipe(Recipe(mainImage: success, title: title, description: description, category: category, quantity: quantity, time: time, steps: step, ingredients: ingredient)) { result in
                    switch result {
                        
                    case .success():
                        print("Success created firebase recipe")
                        complition()
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            case .failure(let err):
                print(err.localizedDescription)
            }
        }
    
    }
}
