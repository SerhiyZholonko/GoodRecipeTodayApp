//
//  Politic .swift
//  GoodRecipeToDay
//
//  Created by apple on 04.08.2023.
//



import UIKit

class PrivacyPolicyViewController: UIViewController {

    private var textView: UITextView = {
       let tv = UITextView()
        tv.isEditable = false
        tv.layer.borderColor = UIColor.systemGray.cgColor
        tv.layer.borderWidth = 2
        tv.layer.cornerRadius = 20
        let inset: CGFloat = 10 // Adjust the value as per your desired inset
            tv.textContainerInset = UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
        tv.showsVerticalScrollIndicator = false
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    private lazy var closeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "xmark"), for: .normal)
        button.tintColor = .label
        button.addTarget(self, action: #selector(didDismiss), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(textView)
        view.addSubview(closeButton)
        addConstraints()
        getFilePrivacyPolicy()
    }
    
    private func addConstraints() {
       let closeButtonConstraints = [
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            closeButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20)
        ]
        NSLayoutConstraint.activate(closeButtonConstraints)
       let textViewConstraints = [
        
        textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            textView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            textView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            textView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
        ]
        NSLayoutConstraint.activate(textViewConstraints)
    }
    private func getFilePrivacyPolicy() {
        if let privacyPolicyPath = Bundle.main.path(forResource: "PrivacyPolicy", ofType: "txt") {
            if let privacyPolicyAttributedText = try? NSAttributedString(url: URL(fileURLWithPath: privacyPolicyPath), options: [:], documentAttributes: nil) {
                textView.attributedText = privacyPolicyAttributedText
            } else {
                textView.text = "Error loading privacy policy."
            }
        } else {
            textView.text = "Privacy policy file not found."
        }
    }
    @objc private func didDismiss() {
        dismiss(animated: true)
    }
}
