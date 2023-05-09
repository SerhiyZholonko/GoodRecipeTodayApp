//
//  CookingStepModel.swift
//  GoodRecipeToDay
//
//  Created by apple on 04.05.2023.
//

import UIKit

final class CookingTableViewCellViewModel {
    let id = UUID().uuidString
    var instruction: String
    var imageUrlString: String?
    var image: UIImage?
    init(instruction: String, image: UIImage? = nil) {
        self.instruction = instruction
        self.image = image
    }
     func updateImage(image: UIImage) {
        self.image = image
        FirebaseImageManager.shared.uploadImage(image) { [self] result in
            switch result {
            case .success(let url):
                self.imageUrlString = url.absoluteString
                print("Image uploaded to Firebase storage: \(url.absoluteString)")
            case .failure(let error):
                print("Error uploading image to Firebase storage: \(error.localizedDescription)")
            }
        }
    }
    
     func updateInstruction(newValve: String) {
        instruction = newValve
    }
}

