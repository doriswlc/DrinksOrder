//
//  Order.swift
//  DrinksOrder
//
//  Created by doriswlc on 2022/10/20.
//

import Foundation

struct CustomerOrder: Codable {
    var records: [OrderRecord]
}

struct OrderRecord: Codable {
    var fields: DrinkOrdered
    
    static let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    
    static func loadOrders() -> [OrderRecord]? {
        let url = documentDirectory.appendingPathComponent("orders").appendingPathExtension("json")
        guard let data = try? Data(contentsOf: url) else { return nil }
        let decoder = JSONDecoder()
        return try? decoder.decode([OrderRecord].self, from: data)
    }
    
    static func saveOrders(_ orders: [OrderRecord]) {
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(orders) else { return }
        let url = documentDirectory.appendingPathComponent("orders").appendingPathExtension("json")
        try? data.write(to: url)
    }
}

struct DrinkOrdered: Codable {
    var drinkName: String
    var size: String
    var addon: [String]
    var ice: String
    var sugar: String
    var qty: Int
    var price: Int
    var customerName: String
    var customerPhone: String
}

enum Addon: Int , Codable {
    case A = 5  //"珍珠、仙草凍 (+5)"
    case B = 10 //"綠茶凍、小芋圓 (+10)"
    case C = 15 //"杏仁凍、米漿凍、豆漿凍 (+15)"
    case D = 20 //"奶霜 (+20)"
}
