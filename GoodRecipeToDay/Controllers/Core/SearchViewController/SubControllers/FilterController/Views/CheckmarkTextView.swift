//
//  CheckmarkTextView.swift
//  GoodRecipeToDay
//
//  Created by apple on 28.05.2023.
//
import UIKit

protocol CheckmarkTextViewDelegate: AnyObject {
    func changeAllMarck()
    func changeRateMarck()
    func changeDateMark()
    func changeTimeMarck()
}

enum CheckmarkTextViewType: String {
    case all
    case rate
    case time
    case date
}

class CheckmarkTextView: UIView {
    weak var delegate: CheckmarkTextViewDelegate?
    let type: CheckmarkTextViewType
    private let checkmarkView: UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemBackground
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 2
        view.layer.borderColor = UIColor.green.cgColor // Change the color to your desired checkmark color
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let indicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .green // Change the color to your desired indicator color
        view.layer.cornerRadius = 4
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let textView: UILabel = {
        let textView = UILabel()
        textView.backgroundColor = .clear
        textView.font = UIFont.systemFont(ofSize: 16)
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()

    var text: String? {
        get {
            return textView.text
        }
        set {
            textView.text = newValue
        }
    }

    var isChecked: Bool = false {
        didSet {
            updateCheckmark()
        }
    }

     init(frame: CGRect, type: CheckmarkTextViewType) {
        self.type = type
        super.init(frame: frame)
        setupSubviews()
        setupGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    public func setIsChackedToFalse() {
        isChecked = false
    }
    private func setupSubviews() {
        addSubview(checkmarkView)
        addSubview(indicatorView)
        addSubview(textView)

        NSLayoutConstraint.activate([
            checkmarkView.leadingAnchor.constraint(equalTo: leadingAnchor),
            checkmarkView.centerYAnchor.constraint(equalTo: centerYAnchor),
            checkmarkView.widthAnchor.constraint(equalToConstant: 30),
            checkmarkView.heightAnchor.constraint(equalToConstant: 30),

            indicatorView.centerXAnchor.constraint(equalTo: checkmarkView.centerXAnchor),
            indicatorView.centerYAnchor.constraint(equalTo: checkmarkView.centerYAnchor),
            indicatorView.widthAnchor.constraint(equalToConstant: 30),
            indicatorView.heightAnchor.constraint(equalToConstant: 30),

            textView.leadingAnchor.constraint(equalTo: checkmarkView.trailingAnchor, constant: 8),
            textView.trailingAnchor.constraint(equalTo: trailingAnchor),
            textView.topAnchor.constraint(equalTo: topAnchor),
            textView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }

    private func setupGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(checkmarkTapped))
        addGestureRecognizer(tapGesture)
        isUserInteractionEnabled = true
    }

    @objc private func checkmarkTapped() {
        isChecked = !isChecked
        switch type {
        case .all:
            delegate?.changeAllMarck()
        case .rate:
            delegate?.changeRateMarck()
        case .time:
            delegate?.changeTimeMarck()
        case .date:
            delegate?.changeDateMark()
        }
    }

    private func updateCheckmark() {
        checkmarkView.backgroundColor = isChecked ? .green : .secondarySystemBackground
        indicatorView.isHidden = !isChecked
    }
}

