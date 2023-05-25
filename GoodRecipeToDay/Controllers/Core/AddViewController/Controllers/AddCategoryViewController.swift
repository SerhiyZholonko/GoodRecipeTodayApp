//
//  AddCategoryViewController.swift
//  GoodRecipeToDay
//
//  Created by apple on 06.05.2023.
//

import UIKit
import SwiftUI

protocol AddCategoryViewControllerDelegate: AnyObject {
    func puchToViewController(category: Categories)
}


enum Categories: String, CaseIterable {
    case breakfast, lunch, dinner, dissert,snacksAppetizers, salads, soupsStews, pastaNoodles, grillingBarbecue, vegetarianVegan
    var title : String {
        switch self {
        case .breakfast:
            return "breakfast"
        case .lunch:
            return "lunch"
        case .dinner:
            return "dinner"
        case .dissert:
            return "dissert"
        case .snacksAppetizers:
            return "snacks appetizers"
        case .salads:
            return "salads"
        case .soupsStews:
            return "soups stews"
        case .pastaNoodles:
            return "pasta noodles"
        case .grillingBarbecue:
            return "grilling barbecue"
        case .vegetarianVegan:
            return "vegetarian vegan"
        }
    }
    var image: UIImage? {
        switch self {
            
        case .breakfast:
            return UIImage(named: "english-breakfast")
        case .lunch:
            return UIImage(named: "lunch")
        case .dinner:
            return UIImage(named: "christmas-dinner")
        case .dissert:
            return UIImage(named: "panna-cotta")
        case .snacksAppetizers:
            return UIImage(named: "nachos")
        case .salads:
            return UIImage(named: "salad")
        case .soupsStews:
            return UIImage(named: "goulash")
        case .pastaNoodles:
            return UIImage(named: "noodles")
        case .grillingBarbecue:
            return UIImage(named: "grilling")
        case .vegetarianVegan:
            return UIImage(named: "vegetable")
        }
    }
    var id :Int {
        switch self {
            
        case .breakfast:
            return 1
        case .lunch:
            return 2
        case .dinner:
            return 3
        case .dissert:
            return 4
        case .snacksAppetizers:
            return 5
        case .salads:
            return 6
        case .soupsStews:
            return 7
        case .pastaNoodles:
            return 8
        case .grillingBarbecue:
            return 9
        case .vegetarianVegan:
            return 10
        }
    }
}
class AddCategoryViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate  {
    
    
    //MARK: - Prooperties
    weak var delegate: AddCategoryViewControllerDelegate?
    let categories = Categories.allCases
//    [ CategoryModel(id: 1, name: "breakfast", image: "english-breakfast"),
//                                      CategoryModel(id: 2, name: "lunch", image: "lunch"),
//                                      CategoryModel(id: 3, name: "dinner", image: "christmas-dinner"),
//                                      CategoryModel(id: 4, name: "dissert", image: "panna-cotta"),
//                                      CategoryModel(id: 5, name: "snacks appetizers", image: "nachos"),
//                                      CategoryModel(id: 6, name: "salads", image: "salad"),
//                                      CategoryModel(id: 7, name: "soups stews", image: "goulash"),
//                                      CategoryModel(id: 8, name: "pasta noodles", image: "noodles"),
//                                      CategoryModel(id: 9, name: "grilling barbecue", image: "grilling"),
//                                      CategoryModel(id: 10, name: "vegetarian vegan", image: "vegetable")]
    var selectedNumber: Int?
    var result: Categories?
    
    lazy var saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .label
        button.setTitle("Save", for: .normal)
        button.backgroundColor = .systemBackground
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(didTappedSave), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    lazy var canselButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Cansel", for: .normal)
        button.tintColor = .label
        button.backgroundColor = .systemBackground
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(didTappedCansel), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    let pickerView: UIPickerView = {
        let picker = UIPickerView()
        picker.backgroundColor = .systemBackground
        picker.layer.cornerRadius = 10
        picker.clipsToBounds = true
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    //MARK: - Livecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground.withAlphaComponent(0.5)
        pickerView.delegate = self
        pickerView.dataSource = self
        
        // Add the picker to your view
        view.addSubview(pickerView)
        view.addSubview(saveButton)
        view.addSubview(canselButton)
        addConstraints()
    }
    
    //MARK: - Functions
    private func addConstraints() {
        let pickerViewConstraints = [
            pickerView.widthAnchor.constraint(equalToConstant: 300),
            pickerView.heightAnchor.constraint(equalToConstant: 150),
            pickerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            pickerView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ]
        NSLayoutConstraint.activate(pickerViewConstraints)
        let saveButtonConstraints = [
            saveButton.topAnchor.constraint(equalTo: pickerView.bottomAnchor, constant: 10),
            saveButton.rightAnchor.constraint(equalTo: pickerView.rightAnchor, constant: -10),
            saveButton.widthAnchor.constraint(equalToConstant: 80),
            saveButton.heightAnchor.constraint(equalToConstant: 50)
        ]
        NSLayoutConstraint.activate(saveButtonConstraints)
        let canselButtonConstraints = [
            canselButton.topAnchor.constraint(equalTo: pickerView.bottomAnchor, constant: 10),
            canselButton.leftAnchor.constraint(equalTo: pickerView.leftAnchor, constant: 10),
            canselButton.widthAnchor.constraint(equalToConstant: 80),
            canselButton.heightAnchor.constraint(equalToConstant: 50)
        ]
        NSLayoutConstraint.activate(canselButtonConstraints)
    }
    @objc private func didTappedSave() {
        guard let result = result else { return }
        delegate?.puchToViewController(category: result)
        dismiss(animated: true)
    }
    @objc private func didTappedCansel() {
        dismiss(animated: true)
    }
    // MARK: - UIPickerViewDataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }
    
    // MARK: - UIPickerViewDelegate
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(categories[row].title) "
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        result = categories[row]
    }
}
