//
//  LaunchScreenView.swift
//  GoodRecipeToDay
//
//  Created by apple on 11.07.2023.
//

import AVFoundation
import UIKit

class LaunchScreenView: UIView {
    //MARK: - Properties
    let recipeImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "recipe-book")
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    let titleApp: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 50)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Sound effect player
    var audioPlayer: AVAudioPlayer?
    
    //MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemBackground
        addSubview(recipeImageView)
        addSubview(titleApp)
        addConstraints()
        shakeRecipeImageView()
        setTitleTextWithAnimation(text: "Good Recipes", duration: 1, color: .systemGreen)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Functions
    private func addConstraints() {
        let recipeImageViewConstraint = [
            recipeImageView.heightAnchor.constraint(equalToConstant: 250),
            recipeImageView.widthAnchor.constraint(equalToConstant: 250),
            recipeImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            recipeImageView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ]
        NSLayoutConstraint.activate(recipeImageViewConstraint)
        
        let titleAppConstraints = [
            titleApp.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 60),
            titleApp.leftAnchor.constraint(equalTo: leftAnchor, constant: 40),
            titleApp.rightAnchor.constraint(equalTo: rightAnchor, constant: 40),
        ]
        NSLayoutConstraint.activate(titleAppConstraints)
    }
    
    private func shakeRecipeImageView() {
        let animation = CAKeyframeAnimation(keyPath: "transform.rotation")
        animation.values = [-0.05, 0.05, -0.03, 0.03, -0.02, 0.02, 0]
        animation.duration = 0.3
        animation.repeatCount = 8
        animation.isRemovedOnCompletion = true

        recipeImageView.layer.add(animation, forKey: "shakeAnimation")
    }
    
    func setTitleTextWithAnimation(text: String, duration: TimeInterval, color: UIColor) {
        titleApp.text = ""
        
        var charIndex = 0
        let timer = Timer.scheduledTimer(withTimeInterval: duration / TimeInterval(text.count), repeats: true) { timer in
            if charIndex < text.count {
                let index = text.index(text.startIndex, offsetBy: charIndex)
                let character = String(text[index])
                self.titleApp.text?.append(character)
                charIndex += 1
                
                // Play sound effect when a letter becomes visible
                self.playSoundEffect()
                
                // Apply color to the entire text
                let attributedString = NSMutableAttributedString(string: self.titleApp.text!)
                attributedString.addAttribute(.foregroundColor, value: color, range: NSRange(location: 0, length: attributedString.length))
                self.titleApp.attributedText = attributedString
            } else {
                timer.invalidate()
            }
        }
        
        timer.fire()
    }






    private func playSoundEffect() {
        guard let soundURL = Bundle.main.url(forResource: "letter_sound", withExtension: "mp3") else {
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
        } catch {
            print("Error playing sound effect: \(error.localizedDescription)")
        }
    }
}

