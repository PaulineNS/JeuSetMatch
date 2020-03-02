//
//  FilterTableViewCell.swift
//  JeuSetMatch
//
//  Created by Pauline Nomballais on 15/01/2020.
//  Copyright © 2020 PaulineNomballais. All rights reserved.
//

import UIKit

final class FilterTableViewCell: UITableViewCell {

    // MARK: - Outlets

    @IBOutlet private weak var categorieLabel: UILabel!
    @IBOutlet weak var filterValueTxtField: UITextField!
    @IBOutlet private weak var arrow: UILabel!
    
    // MARK: - Variables
    
    var genderPicker: UIPickerView?
    var levelPicker: UIPickerView?
//    var agePicker: UIPickerView?
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
    }
}

// MARK: - Picker View Delegate and Data Source

extension FilterTableViewCell: UIPickerViewDelegate, UIPickerViewDataSource {
    
    ///Number of component in the pickerView
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    ///Number of rows in the pickerView
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case pickerView where pickerView == levelPicker:
            return Constants.Arrays.levelsPickerFilterUser.count
        case pickerView where pickerView == genderPicker:
            return Constants.Arrays.gendersPickerFilterUser.count
        default:
            return 0
        }
    }
    
    ///Rows titles in the pickerView
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView {
        case pickerView where pickerView == levelPicker:
            return Constants.Arrays.levelsPickerFilterUser[row]
        case pickerView where pickerView == genderPicker:
            return Constants.Arrays.gendersPickerFilterUser[row]
        default:
            return ""
        }
    }
    
    ///Action after selecting a  pickerView row
    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView {
        case pickerView where pickerView == levelPicker:
            filterValueTxtField.text = Constants.Arrays.levelsPickerFilterUser[row]
            UserDefaults.standard.set(filterValueTxtField.text, forKey: Constants.UDefault.savedFilterLevel)
        case pickerView where pickerView == genderPicker:
            filterValueTxtField.text = Constants.Arrays.gendersPickerFilterUser[row]
            UserDefaults.standard.set(filterValueTxtField.text, forKey: Constants.UDefault.savedFilterGender)
        default:
            break
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
