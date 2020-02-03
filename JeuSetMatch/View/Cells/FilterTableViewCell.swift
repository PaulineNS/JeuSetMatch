//
//  FilterTableViewCell.swift
//  JeuSetMatch
//
//  Created by Pauline Nomballais on 15/01/2020.
//  Copyright © 2020 PaulineNomballais. All rights reserved.
//

import UIKit

class FilterTableViewCell: UITableViewCell {

    // MARK: - Outlets

    @IBOutlet weak var categorieLabel: UILabel!
    @IBOutlet weak var filterValueTxtField: UITextField!
    @IBOutlet weak var arrow: UILabel!
    
    // MARK: - Variables
    
    var genderPicker: UIPickerView?
    var levelPicker: UIPickerView?
    var agePicker: UIPickerView?
    var filter: Filters? {
        didSet {
            categorieLabel.text = filter?.denomination
            filterValueTxtField.text = filter?.value
        }
    }
        
    override func awakeFromNib() {
        super.awakeFromNib()
        filterValueTxtField.delegate = self
        levelPicker = UIPickerView()
        levelPicker?.delegate = self
        levelPicker?.dataSource = self
        genderPicker = UIPickerView()
        genderPicker?.delegate = self
        genderPicker?.dataSource = self
        agePicker = UIPickerView()
        agePicker?.delegate = self
        agePicker?.dataSource = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

// MARK: - Picker View Delegate and Data Source

// MARK: - TODO ENUM

extension FilterTableViewCell: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == levelPicker {
            return Constants.Arrays.levelsPickerFilterUser.count
        }
        if pickerView == genderPicker {
            return Constants.Arrays.gendersPickerFilterUser.count
        }
        if pickerView == agePicker {
            return Constants.Arrays.agePickerFilterUser.count
        }
        return 0
    }
    
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == levelPicker {
            return Constants.Arrays.levelsPickerFilterUser[row]
        }
        if pickerView == genderPicker {
            return Constants.Arrays.gendersPickerFilterUser[row]
        }
        if pickerView == agePicker {
            return Constants.Arrays.agePickerFilterUser[row]
        }
        return ""
    }
    
    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == levelPicker {
            filterValueTxtField.text = Constants.Arrays.levelsPickerFilterUser[row]
            UserDefaults.standard.set(filterValueTxtField.text, forKey: Constants.UDefault.savedFilterLevel)
        }
        if pickerView == genderPicker {
            filterValueTxtField.text = Constants.Arrays.gendersPickerFilterUser[row]
            UserDefaults.standard.set(filterValueTxtField.text, forKey: Constants.UDefault.savedFilterGender)
        }
        if pickerView == agePicker {
            filterValueTxtField.text = Constants.Arrays.agePickerFilterUser[row]
            UserDefaults.standard.set(filterValueTxtField.text, forKey: "savedAge")
        }
    }
}

// MARK: - Text Field Delegate

extension FilterTableViewCell: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
