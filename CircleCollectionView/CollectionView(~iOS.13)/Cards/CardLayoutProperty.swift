//
//  CardLayoutProperty.swift
//  CircleCollectionView
//
//  Created by kohei yoshida on 2020/10/10.
//

import Foundation
import UIKit

struct CardLayoutProperty{
    var center: CGPoint
    var itemSize: CGSize
    var radius: CGFloat
    var numberOfItems: Int
    
    init(){
        center = CGPoint()
        itemSize = CGSize()
        radius = 0
        numberOfItems = 0
    }
}
