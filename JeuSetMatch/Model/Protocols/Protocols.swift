//
//  Protocols.swift
//  JeuSetMatch
//
//  Created by Pauline Nomballais on 30/01/2020.
//  Copyright © 2020 PaulineNomballais. All rights reserved.
//

import Foundation

// MARK: - Protocols

protocol DidSelectCityDelegate {
    func rowTapped(with city: String)
}

protocol DidSearchFiltersDelegate {
    func searchFiltersTapped(users: [UserObject])
}

protocol DidApplyFilterDelegate {
    func didApplyFilter(isResult: Bool)
}

protocol DidDismissCityVcDelegate {
    func didDismissCity()
}
