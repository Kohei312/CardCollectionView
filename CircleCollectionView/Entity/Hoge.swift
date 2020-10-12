//
//  Hoge.swift
//  CircleCollectionView
//
//  Created by kohei yoshida on 2020/10/12.
//

import Foundation

struct Hoge:IdentifiableType{
    typealias IdentifierRawValueType = NSString
    
    var id: Identifier<Hoge, NSString>
    var data:String
    
    init(data:String){
        self.data = data
        self.id = Identifier(NSString(string:String(describing: UUID())))
    }
}
