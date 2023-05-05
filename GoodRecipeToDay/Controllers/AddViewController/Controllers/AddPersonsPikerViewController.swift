//
//  AddPerconsPikerViewController.swift
//  GoodRecipeToDay
//
//  Created by apple on 05.05.2023.
//

import UIKit

protocol AddPersonsPikerViewControllerDelegate: AnyObject {
    func toPushViewController(quantityPerson: String)
}
class AddPersonsPikerViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate  {
    //MARK: - Prooperties
    weak var delegate: AddPersonsPikerViewControllerDelegate?
    let numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    var selectedNumber: Int?
    var result: String = "1 person"
    
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
            pickerView.widthAnchor.constraint(equalToConstant: 200),
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
        delegate?.toPushViewController(quantityPerson: result)
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
        return numbers.count
    }
    
    // MARK: - UIPickerViewDelegate
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(numbers[row]) \(numbers[row] == 1 ? "person" : "persons")"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedNumber = numbers[row]
        result = " \(selectedNumber ?? 0) \(selectedNumber == 1 ? "person" : "persons")"
    }
}
