//
//  Drink.swift
//  DrinksOrder
//
//  Created by doriswlc on 2022/10/12.
//

import Foundation

struct DrinkMenu: Codable {
    let records: [Record]
}
struct Record: Codable {
    let fields: Fields
}
struct Fields: Codable {
    let drinkname: String
    let size: [String]
    let ih: [String]
    let type: String
    let price: [String]
    let picture: [Picture]
}
struct Picture: Codable {
    let url: URL
}
