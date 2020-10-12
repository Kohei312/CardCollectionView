//
//  Identifier+Extension.swift
//  CircleCollectionView
//
//  Created by kohei yoshida on 2020/10/10.
//

import Foundation

protocol IdentifiableType:Hashable {
  associatedtype IdentifierRawValueType : Hashable
  var id: Identifier<Self, IdentifierRawValueType> { get }
  typealias ID<T: Hashable> = Identifier<Self, T>
}

struct Identifier<TargetType, RawValueType : Hashable> : Hashable {
  static func ==(lhs: Identifier<TargetType, RawValueType>, rhs: Identifier<TargetType, RawValueType>) -> Bool {
    return lhs.rawValue == rhs.rawValue
  }
  let rawValue: RawValueType
  init(_ rawValue: RawValueType) {
    self.rawValue = rawValue
  }
}
