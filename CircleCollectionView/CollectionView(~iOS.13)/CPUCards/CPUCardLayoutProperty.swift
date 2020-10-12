//
//  CPUCardLayoutProperty.swift
//  CircleCollectionView
//
//  Created by kohei yoshida on 2020/10/12.
//

import Foundation
import UIKit

struct CPUCardLayoutProperty{
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
