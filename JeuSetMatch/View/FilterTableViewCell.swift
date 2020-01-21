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
    
    private var levelsArray = ["-30 - Pro","-15 - Pro","-4/6 - Pro","-2/6 - Pro","0 - Semi-pro","1/6 - Semi-pro","2/6 - Semi-pro","3/6 - Expert avancé","4/6 - Expert avancé","5/6 - Expert avancé","15 - Expert avancé","15/1 - Expert","15/2 - Expert","15/3 - Expert","15/4 - Compétiteur avancé","15/5 - Compétiteur avancé","30 - Compétiteur","30/1 - Compétiteur","30/2 - Intermédiaire avancé","30/3 - Intermédiaire","30/4 - Intermédiaire","30/5 - Amateur avancé","40 - Amateur","Débutant","Tous les niveaux"]
    private var gendersArray = ["Les Deux", "Femme", "Homme"]
    private var agesArray = ["Entre 10 et 20 ans","Entre 20 et 30 ans","Entre 30 et 40 ans","Entre 40 et 50 ans","Entre 50 et 60 ans","Entre 60 et 70 ans","Entre 70 et 80 ans","Entre 80 et 90 ans"]
    
    var genderPicker: UIPickerView?
    var levelPicker: UIPickerView?
    var agePicker: UIPickerView?
        
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

extension FilterTableViewCell: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == levelPicker {
            return levelsArray.count
        }
        if pickerView == genderPicker {
            return gendersArray.count
        }
        if pickerView == agePicker {
            return agesArray.count
        }
        return 0
    }
    
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == levelPicker {
            return levelsArray[row]
        }
        if pickerView == genderPicker {
            return gendersArray[row]
        }
        if pickerView == agePicker {
            return agesArray[row]
        }
        return ""
    }
    
    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == levelPicker {
            filterValueTxtField.text = levelsArray[row]
        }
        if pickerView == genderPicker {
            filterValueTxtField.text = gendersArray[row]
        }
        if pickerView == agePicker {
            filterValueTxtField.text = agesArray[row]
        }
    }
}
