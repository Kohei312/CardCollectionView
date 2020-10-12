//
//  HogeList.swift
//  CircleCollectionView
//
//  Created by kohei yoshida on 2020/10/10.
//

import Foundation

struct HogeList:Hashable{
    var hogeList:[Hoge] = []
    init(){
        hogeList =  (0..<5).enumerated().map({
            let data = "hoge No.\($0.offset)"
            return Hoge(data:data)
        })
    }
}
