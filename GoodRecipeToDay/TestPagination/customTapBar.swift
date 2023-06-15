//
//  customTapBar.swift
//  GoodRecipeToDay
//
//  Created by apple on 14.06.2023.
//

import UIKit
import Foundation

class MyCustomTabBarController : UITabBarController {
    lazy var btnMiddle : UIButton = {
       let btn = UIButton(frame: CGRect(x: 0, y: 0, width: 60, height: 60))
        btn.setTitle("", for: .normal)
        btn.backgroundColor = UIColor(hex: "#fe989b", alpha: 1.0)
        btn.layer.cornerRadius = 30
        btn.layer.shadowColor = UIColor.black.cgColor
        btn.layer.shadowOpacity = 0.2
        btn.layer.shadowOffset = CGSize(width: 4, height: 4)
        btn.addTarget(self, action: #selector(didTapMidleButton), for: .touchUpInside)
        btn.setBackgroundImage(UIImage(named: "ic_camera"), for: .normal)
        return btn
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        addSomeTabItems()
        btnMiddle.frame = CGRect(x: Int(self.tabBar.bounds.width)/2 - 30, y: -20, width: 60, height: 60)
    }
    override func loadView() {
        super.loadView()
        self.tabBar.addSubview(btnMiddle)
        setupCustomTabBar()
    }
    func setupCustomTabBar() {
        let path : UIBezierPath = getPathForTabBar()
        let shape = CAShapeLayer()
        shape.path = path.cgPath
        shape.lineWidth = 3
        shape.strokeColor = UIColor.white.cgColor
        shape.fillColor = UIColor.white.cgColor
        self.tabBar.layer.insertSublayer(shape, at: 0)
        self.tabBar.itemWidth = 40
        self.tabBar.itemPositioning = .centered
        self.tabBar.itemSpacing = 180
        self.tabBar.tintColor = UIColor(hex: "#fe989b", alpha: 1.0)
    }
    
    func addSomeTabItems() {
        let vc1 = UINavigationController(rootViewController: ViewC1())
        let vc2 = UINavigationController(rootViewController: ViewC2())
        let vc3 = UINavigationController(rootViewController: UIViewController())
        vc1.title = "Home"
        vc2.title = "Favorites"
        vc3.view.backgroundColor = .red
        vc3.title = "Test"
        setViewControllers([vc1, vc2, vc3], animated: false)
        guard let items = tabBar.items else { return}
        items[0].image = UIImage(systemName: "house.fill")
        items[1].image = UIImage(systemName: "star.fill")
        items[2].image = nil
    }
    
    func getPathForTabBar() -> UIBezierPath {
        let frameWidth = self.tabBar.bounds.width
        let frameHeight = self.tabBar.bounds.height + 20
        let holeWidth = 150
        let holeHeight = 50
        let leftXUntilHole = Int(frameWidth/2) - Int(holeWidth/2)
        
        let path : UIBezierPath = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: leftXUntilHole , y: 0)) // 1.Line
        path.addCurve(to: CGPoint(x: leftXUntilHole + (holeWidth/3), y: holeHeight/2), controlPoint1: CGPoint(x: leftXUntilHole + ((holeWidth/3)/8)*6,y: 0), controlPoint2: CGPoint(x: leftXUntilHole + ((holeWidth/3)/8)*8, y: holeHeight/2)) // part I
        
        path.addCurve(to: CGPoint(x: leftXUntilHole + (2*holeWidth)/3, y: holeHeight/2), controlPoint1: CGPoint(x: leftXUntilHole + (holeWidth/3) + (holeWidth/3)/3*2/5, y: (holeHeight/2)*6/4), controlPoint2: CGPoint(x: leftXUntilHole + (holeWidth/3) + (holeWidth/3)/3*2 + (holeWidth/3)/3*3/5, y: (holeHeight/2)*6/4)) // part II
        
        path.addCurve(to: CGPoint(x: leftXUntilHole + holeWidth, y: 0), controlPoint1: CGPoint(x: leftXUntilHole + (2*holeWidth)/3,y: holeHeight/2), controlPoint2: CGPoint(x: leftXUntilHole + (2*holeWidth)/3 + (holeWidth/3)*2/8, y: 0)) // part III
        path.addLine(to: CGPoint(x: frameWidth, y: 0)) // 2. Line
        path.addLine(to: CGPoint(x: frameWidth, y: frameHeight)) // 3. Line
        path.addLine(to: CGPoint(x: 0, y: frameHeight)) // 4. Line
        path.addLine(to: CGPoint(x: 0, y: 0)) // 5. Line
        path.close()
        return path
    }
    @objc private func didTapMidleButton() {
        print("button did tapped!")
    }
}

class ViewC1 : UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Home"
        view.backgroundColor = .black
    }
}
class ViewC2 : UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Favorites"
        view.backgroundColor = .systemGray
    }
}

extension UIColor {
    public convenience init?(hex: String, alpha: Double = 1.0) {
        var pureString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if (pureString.hasPrefix("#")) {
            pureString.remove(at: pureString.startIndex)
        }
        if ((pureString.count) != 6) {
            return nil
        }
        let scanner = Scanner(string: pureString)
        var hexNumber: UInt64 = 0
        
        if scanner.scanHexInt64(&hexNumber) {
            self.init(
                red: CGFloat((hexNumber & 0xFF0000) >> 16) / 255.0,
                green: CGFloat((hexNumber & 0x00FF00) >> 8) / 255.0,
                blue: CGFloat(hexNumber & 0x0000FF) / 255.0,
                alpha: CGFloat(1.0))
            return
        }
        return nil
    }
}



class CustomTabBar: UITabBar {
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Set the frame for the custom add button
        let addButtonSize = CGSize(width: self.bounds.width / 5, height: self.bounds.height)
        let addButtonFrame = CGRect(x: (self.bounds.width - addButtonSize.width) / 2, y: 0, width: addButtonSize.width, height: addButtonSize.height)
        
        // Position the regular buttons with spacing
        let regularButtonWidth = self.bounds.width / 5
        var regularButtonIndex = 0
        let spacing: CGFloat = 16 // Adjust the spacing value as needed
        
        // Iterate through all the subviews of the tab bar
        for view in self.subviews {
            // Find the UIButton subviews and position them accordingly
            if let button = view as? UIControl {
                if button != self.subviews[regularButtonIndex] {
                    // Position the add button
                    button.frame = addButtonFrame
                } else {
                    // Position the regular buttons with spacing
                    let regularButtonFrame = CGRect(x: regularButtonWidth * CGFloat(regularButtonIndex) + spacing * CGFloat(regularButtonIndex),
                                                    y: 0,
                                                    width: regularButtonWidth - spacing,
                                                    height: self.bounds.height)
                    button.frame = regularButtonFrame
                    regularButtonIndex += 1
                }
            }
        }
    }
}

