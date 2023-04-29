//
//  MainRecomendHeaderView.swift
//  GoodRecipeToDay
//
//  Created by apple on 29.04.2023.
//

import UIKit

class MainRecomendHeaderView: UICollectionReusableView {
static let identifier = "MainRecomendHeaderView"
    override init(frame: CGRect) {
        super.init(frame: frame)

        let label = UILabel(frame: CGRect(x: 16, y: 0, width: frame.width - 32, height: frame.height))
        label.text = "Categories"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        addSubview(label)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
