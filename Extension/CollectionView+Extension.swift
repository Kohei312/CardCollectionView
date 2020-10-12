//
//  CollectionViewCell+Extension.swift
//  CircleCollectionView
//
//  Created by kohei yoshida on 2020/10/10.
//

import Foundation
import UIKit

extension UICollectionView{
    
    func registerCell<T:UICollectionViewCell>(_ cell:T.Type){
        self.register(UINib(nibName: T.identifier, bundle: nil),forCellWithReuseIdentifier: T.identifier)
        self.showsHorizontalScrollIndicator = false
    }
    
    func dequeueReusableCell<T:UICollectionViewCell>(with cell:T.Type, indexPath:IndexPath)->T{
        return dequeueReusableCell(withReuseIdentifier: T.identifier, for: indexPath) as! T
        
    }
    
    func registerLayout(layout:UICollectionViewLayout){
        self.collectionViewLayout = layout
    }
    
}
