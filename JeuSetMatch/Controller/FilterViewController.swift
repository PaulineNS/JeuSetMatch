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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        filterTableView.dataSource = self
        filterTableView.delegate = self
        filterTableView.register(UINib(nibName: K.filterCellNibName, bundle: nil), forCellReuseIdentifier: K.filterCellIdentifier)
    }
    
    @IBAction func searchPlayers(_ sender: Any) {
        
    }
}

extension FilterViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }

}
