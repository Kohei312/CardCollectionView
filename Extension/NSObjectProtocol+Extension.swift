//
//  NSObjectProtocol+Extension.swift
//  CircleCollectionView
//
//  Created by kohei yoshida on 2020/10/10.
//

import Foundation
import UIKit

extension NSObjectProtocol{
    
    static var className: String{
        return String(describing: self)
    }
    
}
