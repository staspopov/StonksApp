//
//  Company.swift
//  Stonks
//
//  Created by Stanislav Popov on 30.01.2021.
//

import Foundation

struct Company {
    let companyName: String
    let companySymbol: String
    let price: Double
    let priceChange: Double
    
    var priceString: String {
        String(price)
    }
    
    var priceChangeString: String {
        String(priceChange)
    }
    
    static func initWith(_ stonkData: Data) -> Company? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(StonkData.self, from: stonkData)
            let name = decodedData.companyName
            let symbol = decodedData.symbol
            let price = decodedData.latestPrice
            let change = decodedData.change
            
            let stonk = Company(companyName: name, companySymbol: symbol, price: price, priceChange: change)
            return stonk
        } catch {

            return nil
        }
    }
    
//    static func initWith(_ stonkData: Data) -> [StonkModel]
}
