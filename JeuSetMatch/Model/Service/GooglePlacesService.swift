//
//  GooglePlacesService.swift
//  JeuSetMatch
//
//  Created by Pauline Nomballais on 18/01/2020.
//  Copyright © 2020 PaulineNomballais. All rights reserved.
//

import Foundation
import GoogleMaps
import GooglePlaces

class GooglePlacesService {
    
    var arrayCities = [GMSAutocompletePrediction]()

    lazy private var filter: GMSAutocompleteFilter = {
        let filter = GMSAutocompleteFilter()
        filter.type = .city
        filter.country = "FR"
        return filter
    }()
    
    func x(searchString: String) {
        
        if searchString == "" {
            self.arrayCities = [GMSAutocompletePrediction]()
        } else {
            GMSPlacesClient.shared().autocompleteQuery(searchString, bounds: nil, filter: filter) { (result, error) in
                if error == nil && result != nil {
                    self.arrayCities = result ?? [GMSAutocompletePrediction]()
                }
            }
        }
//        self.citiesTableView.reloadData()
//        return true
        
    }
}
