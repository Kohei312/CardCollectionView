//
//  CGRect+Extension.swift
//  CircleCollectionView
//
//  Created by kohei yoshida on 2020/10/10.
//

import Foundation
import UIKit

extension CGRect {
    func dividedIntegral(fraction: CGFloat, from fromEdge: CGRectEdge) -> (first: CGRect, second: CGRect) {
        
        // このサイトの例がわかりやすい
        // https://stackoverrun.com/ja/q/6606126
        // http://www.excel-jiqiao.com/subject/eqfchttx.html
        
        // 起点にする位置を決めて、分割する線を引っ張る
        // XEdgeが起点の場合　→ 縦に分割
        // YEdgeが起点の場合　→ 横に分割
        
        // 分割線を引く基底面を決める
        let dimension: CGFloat
        
            switch fromEdge {
            // .minXEdgeの場合、X座標(0)から右に描画する想定で計算
            // .maxXEdgeの場合、X座標(右端)から左に描画する想定で計算
            case .minXEdge, .maxXEdge:
                dimension = self.size.width

            // .minYEdgeの場合、Y座標(0)から下に描画する想定で計算
            // .maxYEdgeの場合、Y座標(右端)から上に描画する想定で計算
            case .minYEdge, .maxYEdge:
                dimension = self.size.height
            }
        
        // 基底面の長さをもとに、分割するポイントを決め（= (dimension * fraction)）,切り上げ整数に変換する (= .rounded(.up))
        // → 座標点を決める ( = distance)
        let distance = (dimension * fraction).rounded(.up)
        
        // 元となるCGRectの標準処理 dividedで
        // fromEdgeから, 座標点 distanceまでを分割する
        /* ex) fraction: 0.5, fromEdge: minXEdgeの場合
            distance = (self.size.width * 0.5).rouded(.up) => 水平軸の長さを0.5倍した点
            self.devided => minXEdgeから水平軸の中点までを残して分割
         */
        var slices = self.divided(atDistance: distance, from: fromEdge)
        
        
        // 分割後、余白を設定
        switch fromEdge {
        case .minXEdge, .maxXEdge:
            slices.remainder.origin.x += 1
            slices.remainder.size.width -= 1
        case .minYEdge, .maxYEdge:
            slices.remainder.origin.y += 1
            slices.remainder.size.height -= 1
        }
        
        return (first: slices.slice, second: slices.remainder)
    }
}
