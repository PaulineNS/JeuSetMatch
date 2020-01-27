//
//  CitiesViewController.swift
//  JeuSetMatch
//
//  Created by Pauline Nomballais on 31/12/2019.
//  Copyright © 2019 PaulineNomballais. All rights reserved.
//

import UIKit

protocol DidSelectCityDelegate {
    func rowTapped(with city: String)
}

final class CitiesViewController: UIViewController {
    
    // MARK: - Variables
    let googlePlacesService = GooglePlacesService()
    var didSelectCityDelegate: DidSelectCityDelegate?
    private var citySelected = ""
    
    
    // MARK: - Outlets
    
    @IBOutlet private weak var citiesTextField: UITextField!
    @IBOutlet private weak var citiesTableView: UITableView!
    
    // MARK: - Controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        citiesTableView.dataSource = self
        citiesTableView.delegate = self
        citiesTextField.delegate = self
    }
}

// MARK: - TableView

extension CitiesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return googlePlacesService.arrayCities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cityCellIdentifier, for: indexPath) 
        cell.textLabel?.attributedText = googlePlacesService.arrayCities[indexPath.row].attributedFullText
        cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        citySelected = googlePlacesService.arrayCities[indexPath.row].attributedFullText.string
        guard let indexPath = tableView.indexPathForSelectedRow else {return}
        guard let currentCell = tableView.cellForRow(at: indexPath) else {return}
        citySelected = currentCell.textLabel?.text ?? ""
        didSelectCityDelegate?.rowTapped(with: citySelected)
        print(citySelected)
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - TextField

extension CitiesViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let searchString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        googlePlacesService.x(searchString: searchString)
        self.citiesTableView.reloadData()
        return true
        
    }
}

