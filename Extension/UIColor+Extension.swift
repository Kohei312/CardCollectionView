//
//  UIColor+Extension.swift
//  CircleCollectionView
//
//  Created by kohei yoshida on 2020/10/11.
//

import Foundation
import UIKit

extension UIColor{
    func cellColor(_ indexPath:IndexPath)->UIColor{
        
        guard var color:UIColor = UIColor(named: "PurpleColors/Lightest_Purple") else {return UIColor()}
        
        switch indexPath.item{
        case 0:
            if let lightest = UIColor(named: "PurpleColors/Lightest_Purple"){
                color = lightest
            }
        case 1:
            if let lighter = UIColor(named: "PurpleColors/Lighter_Purple"){
                color = lighter
            }
        case 2:
            if let middle = UIColor(named: "PurpleColors/Middle_Purple"){
                color = middle
            }
        case 3:
            if let deeper = UIColor(named: "PurpleColors/Deeper_Purple"){
                color = deeper
            }
        case 4:
            if let deepest = UIColor(named: "PurpleColors/Deepest_Purple"){
                color = deepest
            }
        default:
            return color
        }

        
        return color
    }
}
