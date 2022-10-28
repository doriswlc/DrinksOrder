//
//  Drink.swift
//  DrinksOrder
//
//  Created by doriswlc on 2022/10/12.
//

import Foundation

struct DrinkMenu: Decodable {
    let records: [Record]
}
struct Record: Decodable {
    let fields: Fields
}
struct Fields: Decodable {
    let drinkname: String
    let size: [String]
    let ih: [String]
    let type: String
    let price: [String]
    let picture: [Picture]
}
struct Picture: Decodable {
    let url: URL
}
