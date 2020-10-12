//
//  CollectionView+Extension.swift
//  CircleCollectionView
//
//  Created by kohei yoshida on 2020/10/10.
//

import Foundation
import UIKit

extension UICollectionReusableView{
    
    static var identifier: String{
        return className
    }
}

extension UICollectionViewLayout{
    
    static var identifier: String{
        return className
    }
}
