//
//  StonkData.swift
//  Stonks
//
//  Created by Stanislav Popov on 31.01.2021.
//

import Foundation

struct CompanyResponse: Decodable {
    let companyName: String
    let symbol: String
    let latestPrice: Double
    let change: Double
    
    static func initWith(jsonData: Data) -> CompanyResponse? {
        let data = CompanyResponse(companyName: "", symbol: "", latestPrice: 0, change: 0)
        return data
    }
    static func initWith(jsonArray: Data) -> [CompanyResponse?] {}
    
}
