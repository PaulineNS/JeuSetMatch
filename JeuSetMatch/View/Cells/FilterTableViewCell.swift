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

//    private var levelsArray = ["-30 - Pro","-15 - Pro","-4/6 - Pro","-2/6 - Pro","0 - Semi-pro","1/6 - Semi-pro","2/6 - Semi-pro","3/6 - Expert avancé","4/6 - Expert avancé","5/6 - Expert avancé","15 - Expert avancé","15/1 - Expert","15/2 - Expert","15/3 - Expert","15/4 - Compétiteur avancé","15/5 - Compétiteur avancé","30 - Compétiteur","30/1 - Compétiteur","30/2 - Intermédiaire avancé","30/3 - Intermédiaire","30/4 - Intermédiaire","30/5 - Amateur avancé","40 - Amateur","Débutant","Tout"]
//    private var gendersArray = ["Tout", "Femme", "Homme"]
//    private var agesArray = ["Entre 10 et 20 ans","Entre 20 et 30 ans","Entre 30 et 40 ans","Entre 40 et 50 ans","Entre 50 et 60 ans","Entre 60 et 70 ans","Entre 70 et 80 ans","Entre 80 et 90 ans"]
    
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
