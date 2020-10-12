//
//  CPUCardList.swift
//  CircleCollectionView
//
//  Created by kohei yoshida on 2020/10/12.
//

import Foundation

struct CPUCardList:Hashable{
    var cpuCardList:[Hoge] = []
    init(){
        cpuCardList =  (0..<5).enumerated().map({
            let data = "hoge No.\($0.offset)"
            return Hoge(data:data)
        })
    }

}
