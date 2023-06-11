//
//  FilterController.swift
//  GoodRecipeToDay
//
//  Created by apple on 28.05.2023.
//

import UIKit

protocol FilterControllerDelegate: AnyObject {
    func getFilterType(type: CheckmarkTextViewType)
}

class FilterController: UIViewController {
    //MARK: - Properties
    private var viewModel = FilterControllerViewModel()
    
    weak var delegate: FilterControllerDelegate?
    
    let backgroungImageView: UIImageView = {
       let iv = UIImageView()
//        iv.image = UIImage(named: "wood")
        iv.backgroundColor = .systemGray5
        iv.layer.cornerRadius = 10
        iv.clipsToBounds = true
        iv.layer.borderColor = UIColor.gray.cgColor
        iv.layer.borderWidth = 2
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    lazy var allView: CheckmarkTextView = {
        let view = CheckmarkTextView(frame: .zero, type: .all)
        view.text = "All"
        view.delegate = self
        return view
    }()
   
    lazy var rateView: CheckmarkTextView = {
        let view = CheckmarkTextView(frame: .zero, type: .rate)
        view.text = "Rate"
        view.delegate = self
        return view
    }()
    lazy var timeView: CheckmarkTextView = {
        let view = CheckmarkTextView(frame: .zero, type: .time)
        view.text = "Time"
        view.delegate = self
        return view
    }()
    lazy var dateView: CheckmarkTextView = {
        let view = CheckmarkTextView(frame: .zero, type: .date)
        view.text = "Date"
        view.delegate = self
        return view
    }()
    lazy var pointStackView: UIStackView = {
       let stackView = UIStackView(arrangedSubviews: [
       allView,
       rateView,
       timeView,
       dateView
       ])
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.isAccessibilityElement = true
        return stackView
    }()
    lazy var okButton: UIButton = {
       let button = UIButton(type: .system)
        button.setTitle("Ok", for: .normal)
        button.tintColor = .systemGreen
        button.backgroundColor = .secondarySystemBackground
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.gray.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapOk), for: .touchUpInside)
        return button
    }()
    lazy var canselButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Cansel", for: .normal)
        button.tintColor = .systemPink
        button.backgroundColor = .secondarySystemBackground
        button.layer.cornerRadius = 10
        button.clipsToBounds = true
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.gray.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(didTapCensel), for: .touchUpInside)
        return button
    }()
    //MARK: - Livecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(backgroungImageView)
        view.addSubview(pointStackView)
        view.addSubview(okButton)
        view.addSubview(canselButton)
        configure()
        dismissBehavior()
        addConstraints()
   
    }
    //MARK: - Functions
    private func configure() {
        view.backgroundColor = .clear
    }
    private func addConstraints() {
       let backgroungImageViewConstraints = [
        backgroungImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
        backgroungImageView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
        backgroungImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        backgroungImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ]
        NSLayoutConstraint.activate(backgroungImageViewConstraints)
        
        let pointStackViewConstraints = [
            pointStackView.topAnchor.constraint(equalTo: backgroungImageView.topAnchor, constant: 5),
            pointStackView.leftAnchor.constraint(equalTo: backgroungImageView.leftAnchor, constant: 20),
            pointStackView.rightAnchor.constraint(equalTo: backgroungImageView.rightAnchor, constant: -5),
            pointStackView.bottomAnchor.constraint(equalTo: backgroungImageView.bottomAnchor, constant: -5),
        ]
        NSLayoutConstraint.activate(pointStackViewConstraints)
        
        let okButtonConstraints = [
            okButton.topAnchor.constraint(equalTo: backgroungImageView.bottomAnchor, constant: 5),
            okButton.rightAnchor.constraint(equalTo: backgroungImageView.rightAnchor, constant: -5),
            okButton.widthAnchor.constraint(equalTo: backgroungImageView.widthAnchor, multiplier: 0.4),
            okButton.heightAnchor.constraint(equalToConstant: 50)
        ]
        NSLayoutConstraint.activate(okButtonConstraints)
        let canselButtonConstraints = [
            canselButton.topAnchor.constraint(equalTo: backgroungImageView.bottomAnchor, constant: 5),
            canselButton.leftAnchor.constraint(equalTo: backgroungImageView.leftAnchor, constant: 5),
            canselButton.widthAnchor.constraint(equalTo: backgroungImageView.widthAnchor, multiplier: 0.4),
            canselButton.heightAnchor.constraint(equalToConstant: 50)
        ]
        NSLayoutConstraint.activate(canselButtonConstraints)
    }
    private func dismissBehavior() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapDismiss))
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(tapGesture)
    }
    @objc private func didTapDismiss(_ sender: UITapGestureRecognizer) {
        let tapLocation = sender.location(in: backgroungImageView)
        if !backgroungImageView.bounds.contains(tapLocation) {
            dismiss(animated: true)
        }
    }
    @objc private func didTapOk() {
        delegate?.getFilterType(type: viewModel.type)
        dismiss(animated: true)
    }
    @objc private func didTapCensel() {
        dismiss(animated: true)
    }
}


//MARK: - Delegate

extension FilterController:  CheckmarkTextViewDelegate {
 
    
    func changeAllMarck() {
        UIView.animate(withDuration: 0.4, delay: 0) {[weak self] in
            self?.rateView.setIsChackedToFalse()
            self?.timeView.setIsChackedToFalse()
            self?.dateView.setIsChackedToFalse()
            self?.viewModel.setupType(type: .all)
        }
    }
    func changeRateMarck() {
        UIView.animate(withDuration: 0.4, delay: 0) {[weak self] in
            self?.allView.setIsChackedToFalse()
            self?.timeView.setIsChackedToFalse()
            self?.dateView.setIsChackedToFalse()
            self?.viewModel.setupType(type: .rate)
        }
    }
    func changeTimeMarck() {
        UIView.animate(withDuration: 0.4, delay: 0) { [weak self] in
            self?.rateView.setIsChackedToFalse()
            self?.allView.setIsChackedToFalse()
            self?.dateView.setIsChackedToFalse()
            self?.viewModel.setupType(type: .time)
        }
    }
    func changeDateMark() {
        UIView.animate(withDuration: 0.4, delay: 0) { [weak self] in
            self?.rateView.setIsChackedToFalse()
            self?.allView.setIsChackedToFalse()
            self?.timeView.setIsChackedToFalse()
            self?.viewModel.setupType(type: .date)
        }
    }
}
