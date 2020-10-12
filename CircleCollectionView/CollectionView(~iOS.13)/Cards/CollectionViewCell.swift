//
//  CollectionViewCell.swift
//  CircleCollectionView
//
//  Created by kohei yoshida on 2020/10/10.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    
    override func prepareForReuse() {
        nameLabel.text = nil
    }
        
    
}
