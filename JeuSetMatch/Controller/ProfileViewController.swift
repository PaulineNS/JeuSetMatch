//
//  ProfileViewController.swift
//  JeuSetMatch
//
//  Created by Pauline Nomballais on 03/01/2020.
//  Copyright © 2020 PaulineNomballais. All rights reserved.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    let firestoreService = FirestoreService()
    
    // MARK: - Variables
    
    var currentUser: UserObject?
    var IsSegueFromSearch = false
    
    private var userInformations: [UserObject] = []
    private var genderPicker: UIPickerView?
    private var datePicker: UIDatePicker?
    private var levelPicker: UIPickerView?
    private let genders: [String] = ["Femme","Homme"]
    private let levels: [String] = ["-30 - Pro","-15 - Pro","-4/6 - Pro","-2/6 - Pro","0 - Semi-pro","1/6 - Semi-pro","2/6 - Semi-pro","3/6 - Expert avancé","4/6 - Expert avancé","5/6 - Expert avancé","15 - Expert avancé","15/1 - Expert","15/2 - Expert","15/3 - Expert","15/4 - Compétiteur avancé","15/5 - Compétiteur avancé","30 - Compétiteur","30/1 - Compétiteur","30/2 - Intermédiaire avancé","30/3 - Intermédiaire","30/4 - Intermédiaire","30/5 - Amateur avancé","40 - Amateur","Débutant"]
    
    // MARK: - Outlets
    
    @IBOutlet private var userInformationTxtField: [UITextField]!
    @IBOutlet private weak var userPictureImageView: UIImageView!
    @IBOutlet private weak var logOutBarButtonItem: UIBarButtonItem!
    @IBOutlet private weak var updateProfileButton: UIButton!
    @IBOutlet private weak var validateButton: UIButton!
    @IBOutlet private weak var cancelButton: UIButton!
    
    // MARK: - Controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manageTxtField(status: false, borderStyle: .none)
        validateButton.isHidden = true
        cancelButton.isHidden = true
        managePickers()        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("profilevc", currentUser?.birthDate as Any)
        print("profilevc", currentUser?.city as Any)
        guard IsSegueFromSearch == true else {
            
            guard let currentUserUid = firestoreService.currentUserUid else {return}
            fetchUserInformations(userUid: currentUserUid )
            self.tabBarController?.navigationItem.hidesBackButton = true
            self.tabBarController?.navigationItem.rightBarButtonItem = logOutBarButtonItem
            updateProfileButton.setTitle("Modifier mon profil", for: .normal)
            return
        }
        guard let partnerUid = currentUser?.uid else {return}
        fetchUserInformations(userUid: partnerUid)
        updateProfileButton.setTitle("Contacter", for: .normal)
    }
    
    // MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == K.ProfileToChatSegue else {return}
        guard let chatVc = segue.destination as? ChatViewController else {return}
        chatVc.user = UserObject(pseudo: currentUser?.pseudo, image: currentUser?.image, sexe: currentUser?.sexe, level: currentUser?.level, city: currentUser?.city, birthDate: currentUser?.birthDate, uid: currentUser?.uid)
    }
    
    @objc private func dateChanged(datePicker: UIDatePicker) {
        userInformationTxtField[2].text = dateToAge(birthDate: datePicker.date)
    }
    
    @IBAction private func buttomButtonPressed(_ sender: UIButton) {
        if sender.currentTitle == "Contacter" {
            performSegue(withIdentifier: K.ProfileToChatSegue, sender: nil)
        }
        if sender.currentTitle == "Modifier mon profil" {
            manageTxtField(status: true, borderStyle: .line)
            
            validateButton.isHidden = false
            cancelButton.isHidden = false
            updateProfileButton.isHidden = true
            setTxtFieldInUserDefault()
        }
    }
    
    // MARK: - Actions
    
    @IBAction private func logOutPressed(_ sender: UIBarButtonItem) {
        firestoreService.logOut()
        navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction private func didPressValidateButton(_ sender: Any) {
        manageTxtField(status: false, borderStyle: .none)
        validateButton.isHidden = true
        cancelButton.isHidden = true
        updateProfileButton.isHidden = false
        guard let userCity = userInformationTxtField[3].text, let userGender = userInformationTxtField[1].text, let userLevel = userInformationTxtField[4].text, let userName = userInformationTxtField[0].text else {return}
        firestoreService.updateUserInformation(userCity: userCity, userGender: userGender, userLevel: userLevel, userName: userName)

    }
    
    @IBAction private func didPressCancelButton(_ sender: Any) {
        manageTxtField(status: false, borderStyle: .none)
        validateButton.isHidden = true
        cancelButton.isHidden = true
        updateProfileButton.isHidden = false
        displayUserDefaultsOnTextField()
    }
    
    // MARK: - Methods
    private func managePickers(){
        userInformationTxtField[3].delegate = self
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        datePicker?.locale = Locale.init(identifier: "fr_FR")
        userInformationTxtField[2].inputView = datePicker
        datePicker?.addTarget(self, action: #selector(ProfileViewController.dateChanged(datePicker:)), for: .valueChanged)
        levelPicker = UIPickerView()
        userInformationTxtField[4].inputView = levelPicker
        genderPicker = UIPickerView()
        userInformationTxtField[1].inputView = genderPicker
        levelPicker?.delegate = self
        genderPicker?.delegate = self
        genderPicker?.dataSource = self
        levelPicker?.dataSource = self
    }
    
    private func manageTxtField(status: Bool, borderStyle: UITextField.BorderStyle) {
        for txtField in userInformationTxtField {
            txtField.isUserInteractionEnabled = status
            txtField.borderStyle = borderStyle
        }
    }
    
    private func setTxtFieldInUserDefault() {
        var index = 0
        for _ in userInformationTxtField {
            UserDefaults.standard.set(userInformationTxtField[index].text, forKey: "savedUserInformations\(index)")
            index += 1
        }
    }
    
    private func displayUserDefaultsOnTextField() {
        var index = 0
        for _ in userInformationTxtField {
            userInformationTxtField[index].text = UserDefaults.standard.string(forKey: "savedUserInformations\(index)")
            index += 1
        }
    }
        
    private func stringToDate(dateString : String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let s = dateFormatter.date(from: dateString) ?? Date()
        return s
    }
    
    private func dateToAge(birthDate: Date) -> String {
        let now = Date()
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year], from: birthDate, to: now)
        guard let intAge = ageComponents.year else {return ""}
        let stringAge = String(intAge)
        return stringAge
    }
    
    private func fetchUserInformations(userUid: String) {
        self.userInformations = []
        firestoreService.fetchUserInformationsDependingUid(userUid: userUid) { (result) in
            switch result {
            case .success(let user) :
                self.userInformations.append(user)
                guard let userBirthdate = user.birthDate, let userPseudo = user.pseudo, let userGender = user.sexe, let userCity = user.city, let userLevel = user.level, let userPicture = user.image else {return}
                let stringDate = self.stringToDate(dateString: userBirthdate)
                let userAge = self.dateToAge(birthDate: stringDate)
                DispatchQueue.main.async {
                    self.userInformationTxtField[0].text = userPseudo
                    self.userInformationTxtField[1].text = userGender
                    self.userInformationTxtField[3].text = userCity
                    self.userInformationTxtField[4].text = userLevel
                    self.userPictureImageView.image = UIImage(data: userPicture)
                    self.userInformationTxtField[2].text = userAge + " " + "ans"
                }
            case .failure(let error) :
                print(error.localizedDescription)
            }
        }
    }
}

// MARK: - TextField Delegate

extension ProfileViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
        performSegue(withIdentifier: K.ProfileToCitiesSegue, sender: nil)
    }
}

// MARK: - PickerView

extension ProfileViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == levelPicker {
            return levels.count
        }
        if pickerView == genderPicker {
            return genders.count
        }
        return 0
    }
    
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == levelPicker {
            return levels[row]
        }
        if pickerView == genderPicker {
            return genders[row]
        }
        return ""
    }
    
    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == levelPicker {
            userInformationTxtField[4].text = levels[row]
        }
        if pickerView == genderPicker {
            userInformationTxtField[1].text = genders[row]
        }
    }
}
