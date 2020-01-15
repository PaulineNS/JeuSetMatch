//
//  FilterTableViewCell.swift
//  JeuSetMatch
//
//  Created by Pauline Nomballais on 15/01/2020.
//  Copyright © 2020 PaulineNomballais. All rights reserved.
//

import UIKit

class FilterTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var categorieLabel: UILabel!
    @IBOutlet weak var filterValueTxtField: UITextField!
    @IBOutlet weak var arrow: UILabel!
    
    private var genderPicker: UIPickerView?
    private var datePicker: UIDatePicker?
    private var levelPicker: UIPickerView?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        filterValueTxtField.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    var filter: Filters? {
        didSet {
            categorieLabel.text = filter?.denomination
            filterValueTxtField.text = filter?.value
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
        }
}
