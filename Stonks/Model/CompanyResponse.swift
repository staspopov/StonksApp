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
        let decoder = JSONDecoder()
        do {
            let company = try decoder.decode(CompanyResponse.self, from: jsonData)
            return company
        } catch {
            return nil
        }
    }
    static func initWith(jsonArray: Data) -> [CompanyResponse] {
        let decoder = JSONDecoder()
        do {
            let companies = try decoder.decode([CompanyResponse].self, from: jsonArray)
            return companies
        } catch {
            return []
        }
    }
    
}

struct LogoUrl: Decodable {
    let url: String
    
    static func initWith(jsonData: Data) -> LogoUrl? {
        let decoder = JSONDecoder()
        do {
            let url = try decoder.decode(LogoUrl.self, from: jsonData)
            return url
        } catch {
            return nil
        }
    }
}
