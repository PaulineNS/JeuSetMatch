//
//  CitiesViewController.swift
//  JeuSetMatch
//
//  Created by Pauline Nomballais on 31/12/2019.
//  Copyright © 2019 PaulineNomballais. All rights reserved.
//

import UIKit

final class CitiesViewController: UIViewController {
    
    // MARK: - Instensiation
    
    private let googlePlacesService = GooglePlacesService()
    
    // MARK: - Variables
    
    private var citySelected: String?
    var didSelectCityDelegate: DidSelectCityDelegate?
    var didDismissCityVcDelegate: DidDismissCityVcDelegate?

    // MARK: - Outlets
    
    @IBOutlet private weak var citiesTextField: UITextField!
    @IBOutlet private weak var citiesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBarCustom()
        self.navigationController?.navigationBar.tintColor = UIColor.black
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        didDismissCityVcDelegate?.didDismissCity()
    }
}

// MARK: - TableView

extension CitiesViewController: UITableViewDataSource, UITableViewDelegate {
    
    /// Number of cells in tableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return googlePlacesService.arrayCities.count
    }
    
    /// Define tableView cells
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Cell.cityCellIdentifier, for: indexPath) 
        cell.textLabel?.attributedText = googlePlacesService.arrayCities[indexPath.row].attributedFullText
        cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
        return cell
    }
    
    /// Actions after a cell selection
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        citySelected = googlePlacesService.arrayCities[indexPath.row].attributedFullText.string
        guard let indexPath = tableView.indexPathForSelectedRow else {return}
        guard let currentCell = tableView.cellForRow(at: indexPath) else {return}
        citySelected = currentCell.textLabel?.text ?? ""
        guard let citySelected = citySelected else {return}
        didSelectCityDelegate?.rowTapped(with: citySelected)
        navigationController?.popViewController(animated: true)
    }
}

// MARK: - TextField Delegate

extension CitiesViewController: UITextFieldDelegate {
    /// Change characters textField according the search result 
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let searchString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        googlePlacesService.searchCity(searchString: searchString)
        self.citiesTableView.reloadData()
        return true
    }
}
