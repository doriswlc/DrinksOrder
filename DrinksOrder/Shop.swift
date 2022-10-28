//
//  Shop.swift
//  DrinksOrder
//
//  Created by doriswlc on 2022/10/27.
//

import Foundation

struct ShopList: Decodable {
    let records: [ShopRecord]
}

struct ShopRecord: Decodable {
    let fields: ShopField
}

struct ShopField: Decodable {
    var shopName: String
    var county: String
    var phone: String
    var address: String
}
