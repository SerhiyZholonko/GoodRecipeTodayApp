//
//  AddDatePikerViewController.swift
//  GoodRecipeToDay
//
//  Created by apple on 05.05.2023.
//

import UIKit

protocol AddDatePikerViewControllerDelegate: AnyObject {
    func getDataString(string: String)
}

class AddDatePikerViewController: UIViewController {
    private var timeString: String = "1h:00m"
    //MARK: - Properties
    weak var delegate: AddDatePikerViewControllerDelegate?
    let timePicker : UIDatePicker = {
       let picker = UIDatePicker()
        picker.layer.cornerRadius = 10
        picker.clipsToBounds = true
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()

    lazy var saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Save", for: .normal)
        button.backgroundColor = .systemBackground
        button.layer.cornerRadius = 10
        button.tintColor = .label
        button.addTarget(self, action: #selector(didTappedSave), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    lazy var canselButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Cansel", for: .normal)
        button.backgroundColor = .systemBackground
        button.layer.cornerRadius = 10
        button.tintColor = .label
        button.addTarget(self, action: #selector(didTappedCansel), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    //MARK: - Livecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground.withAlphaComponent(0.5)
        timePicker.datePickerMode = .countDownTimer
        timePicker.minuteInterval = 60
        timePicker.addTarget(self, action: #selector(timeChanged), for: .valueChanged)

        // Set initial time to 1 hour
        let oneHourInSeconds: TimeInterval = 60 * 60
        timePicker.countDownDuration = oneHourInSeconds

        // Customize the appearance of the picker
        timePicker.backgroundColor = UIColor.white
        timePicker.tintColor = UIColor.blue

        // Add the picker to your view
        view.addSubview(timePicker)
        view.addSubview(canselButton)
        view.addSubview(saveButton)
        addConstraints()
        
    }
    //MARK: - Functions
    private func addConstraints() {
           let timePickerConstraints = [
               timePicker.widthAnchor.constraint(equalToConstant: 200),
               timePicker.heightAnchor.constraint(equalToConstant: 150),
               timePicker.centerXAnchor.constraint(equalTo: view.centerXAnchor),
               timePicker.centerYAnchor.constraint(equalTo: view.centerYAnchor)
           ]
           NSLayoutConstraint.activate(timePickerConstraints)
        let canselButtonConstraints = [
            canselButton.topAnchor.constraint(equalTo: timePicker.bottomAnchor, constant: 10),
            canselButton.leftAnchor.constraint(equalTo: timePicker.leftAnchor, constant: 10),
            canselButton.heightAnchor.constraint(equalToConstant: 50),
            canselButton.widthAnchor.constraint(equalToConstant: 80)
        ]
        NSLayoutConstraint.activate(canselButtonConstraints)
        let saveButtonConstraints = [
            saveButton.topAnchor.constraint(equalTo: timePicker.bottomAnchor, constant: 10),
            saveButton.rightAnchor.constraint(equalTo: timePicker.rightAnchor, constant: -10),
            saveButton.heightAnchor.constraint(equalToConstant: 50),
            saveButton.widthAnchor.constraint(equalToConstant: 80)
        ]
        NSLayoutConstraint.activate(saveButtonConstraints)
    }
    @objc func timeChanged(sender: UIDatePicker) {
        let selectedTime = sender.countDownDuration
        let hours = Int(selectedTime) / 3600
        let minutes = Int(selectedTime) % 3600 / 60
        let timeString = "\(hours)h:\(String(format: "%02d", minutes))m"
        self.timeString = timeString
        
    }
    @objc func didTappedSave() {
        delegate?.getDataString(string: timeString)
        dismiss(animated: true)
    }
    @objc func didTappedCansel() {
        dismiss(animated: true)
    }

}
