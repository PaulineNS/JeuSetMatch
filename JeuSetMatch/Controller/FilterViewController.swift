//
//  FilterViewController.swift
//  JeuSetMatch
//
//  Created by Pauline Nomballais on 15/01/2020.
//  Copyright © 2020 PaulineNomballais. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController {
    
    
    @IBOutlet weak var filterTableView: UITableView!
    
    private let filtersDictionnary = ["Age": "Tout", "Niveau": "Tout", "Sexe": "Tout", "Ville": "Tout"]
    private var filtersArray = [Filters]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        filterTableView.dataSource = self
        filterTableView.delegate = self
        filterTableView.register(UINib(nibName: K.filterCellNibName, bundle: nil), forCellReuseIdentifier: K.filterCellIdentifier)
        for (key, value) in filtersDictionnary.sorted(by: { $0.0 < $1.0 }) {
            filtersArray.append(Filters(denomination: key, value: value))
        }
    }
    
    @IBAction func searchPlayers(_ sender: Any) {
        
    }
}

extension FilterViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filtersArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: K.filterCellIdentifier, for: indexPath) as? FilterTableViewCell else {return UITableViewCell()}
        
        cell.filter = filtersArray[indexPath.row]
        
        if indexPath.row == 1 {
            cell.filterValueTxtField.inputView = cell.levelPicker
        }
        if indexPath.row == 2 {
            cell.filterValueTxtField.inputView = cell.genderPicker
        }
        return cell
    }
}
