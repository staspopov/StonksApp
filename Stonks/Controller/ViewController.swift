//
//  ViewController.swift
//  Stonks
//
//  Created by Stanislav Popov on 30.01.2021.
//

import UIKit

class ViewController: UIViewController {
    
    // UI
    
    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var companySymbolLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var priceChangeLabel: UILabel!
    
    @IBOutlet weak var companyPickerView: UIPickerView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var companyImage: UIImageView!
    
    var stonksManager = StonksManager()
    var model: CompaniesModel = CompaniesModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stonksManager.delegate = self
        
        companyPickerView.dataSource = self
        companyPickerView.delegate = self

        activityIndicator.hidesWhenStopped = true
        stonksManager.getCompanies()
    }

    private func updateUI() {
        activityIndicator.startAnimating()
        
        let selectedRow = companyPickerView.selectedRow(inComponent: 0)
        let selectedSymbol = model.companies[selectedRow].symbol
        
        stonksManager.getCompanyData(for: selectedSymbol)
        stonksManager.getLogoLink(for: selectedSymbol)
    }
    
    private func update(with companyInfo: Company) {
        self.companyNameLabel.text = companyInfo.name
        self.companySymbolLabel.text = companyInfo.symbol
        self.priceLabel.text = companyInfo.priceString
        self.priceChangeLabel.text = companyInfo.priceChangeString
        
        priceChangeLabel.textColor = companyInfo.priceChange > 0 ? UIColor.green : UIColor.red
    }

}

//MARK: - UIPickerViewDataSource

extension ViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        model.companies.count
    }
}

//MARK: - UIPickerViewDelegate

extension ViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        model.companies[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        activityIndicator.startAnimating()
        
        self.companyNameLabel.text = "-"
        self.companySymbolLabel.text = "-"
        self.priceLabel.text = "-"
        self.priceChangeLabel.text = "-"
        self.priceChangeLabel.textColor = UIColor.black
        
        let selectedSymbol = model.companies[row].symbol
        stonksManager.getCompanyData(for: selectedSymbol)
        stonksManager.getLogoLink(for: selectedSymbol)
    }
}

//MARK: - StonksManagerDelegate

extension ViewController: StonksManagerDelegate {
    func setCompanies(_ companies: [Company]) {
        DispatchQueue.main.async {
            self.model.companies = companies
            self.companyPickerView.reloadAllComponents()
            self.updateUI()
        }
    }
    
    
    func didUpdateCompany(_ company: Company) {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.update(with: company)
        }
    }
    
    func setLogoWith(data: Data) {
        DispatchQueue.main.async {
            let image = UIImage(data: data)
            self.companyImage.image = image
        }
    }
    
    func didFailWithError(error: Error) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}

