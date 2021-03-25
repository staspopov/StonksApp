//
//  Company.swift
//  Stonks
//
//  Created by Stanislav Popov on 30.01.2021.
//

import Foundation

class Company {
    let name: String
    let symbol: String
    let price: Double
    let priceChange: Double
    
    var priceString: String {
        String(price)
    }
    
    var priceChangeString: String {
        String(priceChange)
    }
    
    init(_ response: CompanyResponse){
        name = response.companyName
        symbol = response.symbol
        price = response.latestPrice
        priceChange = response.change
    }
    
//    static func initWith(_ stonkData: Data) -> [StonkModel]
}
