//
//  StonksManager.swift
//  Stonks
//
//  Created by Stanislav Popov on 30.01.2021.
//

import Foundation

protocol StonksManagerDelegate {
    func didUpdateCompany(_ company: Company)
    func didFailWithError(error: Error)
    func setCompanies(_ companies: [Company])
    func setLogoWith(data: Data)
}

struct StonksManager {
    
    let token = "pk_77f5ae91c2ef455487c90dcc0fa8b103"
    
    let baseURL = "https://cloud.iexapis.com/stable/stock/"
    let companiesURL = "/market/list/gainers/"
    let logoURL = "/logo/"
    
    enum SessionTask {
        case getCompanyData
        case getCompanies
        case getLogoLink
        case getLogoData
    }
    
    var delegate: StonksManagerDelegate?
    
    func getCompanyData(for symbol: String) {
        let task = SessionTask.getCompanyData
        let urlString = baseURL + symbol + "/quote?token=\(token)"
        performRequest(with: task, urlString: urlString)
    }
    
    func getLogoLink(for symbol: String) {
        let task = SessionTask.getLogoLink
        let urlString = baseURL + symbol + logoURL + "quote?token=\(token)"
        performRequest(with: task, urlString: urlString)
    }
    
    func getCompanies() {
        let task = SessionTask.getCompanies
        let urlString = baseURL + companiesURL + "quote?token=\(token)"
        performRequest(with: task, urlString: urlString)
    }
    
    func performRequest(with task: SessionTask, urlString: String) {
        
        if let url = URL(string: urlString) {
            
            let session = URLSession(configuration: .default)
            
            let dataTask = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    
                    switch task {
                    case .getCompanies:
                        let companyResponse = CompanyResponse.initWith(jsonArray: safeData)
                        let companies = companyResponse.map({ Company($0) })
                        delegate?.setCompanies(companies)
                        break
                    case .getCompanyData:
                        if let companyResponse = CompanyResponse.initWith(jsonData: safeData) {
                            let company = Company(companyResponse)
                            delegate?.didUpdateCompany(company)
                        }
                    case .getLogoLink:
                        
                        if let url = LogoUrl.initWith(jsonData: safeData)  {
                            let task = SessionTask.getLogoData
                            
                                self.performRequest(with: task, urlString: url.url)
                            
                            
                        }
                    case .getLogoData:
                        delegate?.setLogoWith(data: safeData)
                    }
                }
            }
            
            dataTask.resume()
        }
    }
}
