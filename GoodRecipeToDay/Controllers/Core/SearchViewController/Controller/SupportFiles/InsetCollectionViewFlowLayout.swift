//
//  InsetCollectionViewFlowLayout.swift
//  GoodRecipeToDay
//
//  Created by apple on 28.05.2023.
//

import UIKit

class InsetCollectionViewFlowLayout: UICollectionViewFlowLayout {
    let sectionInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let layoutAttributes = super.layoutAttributesForElements(in: rect) else {
            return nil
        }

        var updatedLayoutAttributes = [UICollectionViewLayoutAttributes]()
        for attribute in layoutAttributes {
            let updatedAttribute = attribute.copy() as! UICollectionViewLayoutAttributes
            updatedAttribute.frame = updatedAttribute.frame.inset(by: sectionInsets)
            updatedLayoutAttributes.append(updatedAttribute)
        }

        return updatedLayoutAttributes
    }
}
