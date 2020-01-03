//
//  CitiesViewController.swift
//  JeuSetMatch
//
//  Created by Pauline Nomballais on 31/12/2019.
//  Copyright © 2019 PaulineNomballais. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces

protocol DidSelectCityDelegate {
    func rowTapped(with city: String)
}

class CitiesViewController: UIViewController {

    var arrayCities = [GMSAutocompletePrediction]()
    var citySelected = ""
    var didSelectCityDelegate: DidSelectCityDelegate?
    
    lazy var filter: GMSAutocompleteFilter = {
        let filter = GMSAutocompleteFilter()
        filter.type = .city
        filter.country = "FR"
        return filter
    }()
    
    @IBOutlet weak var citiesTextField: UITextField!
    @IBOutlet weak var citiesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        citiesTableView.dataSource = self
        citiesTableView.delegate = self
        citiesTextField.delegate = self
    }
}

extension CitiesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayCities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cityCellIdentifier, for: indexPath) 
        cell.textLabel?.attributedText = arrayCities[indexPath.row].attributedFullText
        cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        citySelected = arrayCities[indexPath.row].attributedFullText.string
        guard let indexPath = tableView.indexPathForSelectedRow else {return}
        guard let currentCell = tableView.cellForRow(at: indexPath) else {return}
        citySelected = currentCell.textLabel?.text ?? ""
        didSelectCityDelegate?.rowTapped(with: citySelected)
        print(citySelected)
        navigationController?.popViewController(animated: true)
    }
}

extension CitiesViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let searchString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        if searchString == "" {
            self.arrayCities = [GMSAutocompletePrediction]()
        } else {
            GMSPlacesClient.shared().autocompleteQuery(searchString, bounds: nil, filter: filter) { (result, error) in
                if error == nil && result != nil {
                    self.arrayCities = result ?? [GMSAutocompletePrediction]()
                }
            }
        }
        self.citiesTableView.reloadData()
        return true
    }
}

