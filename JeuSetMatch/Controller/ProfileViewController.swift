//
//  ProfileViewController.swift
//  JeuSetMatch
//
//  Created by Pauline Nomballais on 03/01/2020.
//  Copyright © 2020 PaulineNomballais. All rights reserved.
//

import UIKit
import Firebase

final class ProfileViewController: UIViewController {
    
    // MARK: - Variables
    
    var currentUser: User?
    var IsSegueFromSearch = false
    var userPseudo = ""
    
    private let db = Firestore.firestore()
    private var userInformations: [User] = []
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
            
            loadCurrentUserInformations()
            self.tabBarController?.navigationItem.hidesBackButton = true
            self.tabBarController?.navigationItem.rightBarButtonItem = logOutBarButtonItem
            updateProfileButton.setTitle("Modifier mon profil", for: .normal)
            return
        }
        loadAnotherUserInformations()
        updateProfileButton.setTitle("Contacter", for: .normal)
    }
    
    // MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == K.ProfileToChatSegue else {return}
        guard let chatVc = segue.destination as? ChatViewController else {return}
        chatVc.user = User(pseudo: currentUser?.pseudo, image: currentUser?.image, sexe: currentUser?.sexe, level: currentUser?.level, city: currentUser?.city, birthDate: currentUser?.birthDate, uid: currentUser?.uid)
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
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    @IBAction private func didPressValidateButton(_ sender: Any) {
        manageTxtField(status: false, borderStyle: .none)
        validateButton.isHidden = true
        cancelButton.isHidden = true
        updateProfileButton.isHidden = false
        guard let userCity = userInformationTxtField[3].text, let userGender = userInformationTxtField[1].text, let userLevel = userInformationTxtField[4].text, let userName = userInformationTxtField[0].text else {return}
        updateUserInformation(userCity: userCity, userGender: userGender, userLevel: userLevel, userName: userName)
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
    
    private func updateUserInformation(userCity: String, userGender: String, userLevel: String, userName: String) {
        
        db.collection("users").document(Auth.auth().currentUser?.uid ?? "").updateData([
            //            "userAge": "",
            "userCity": userCity,
            "userGender": userGender,
            //            "userImage": "",
            "userLevel": userLevel,
            "userName": userName
        ]) { error in
            if let error = error {
                print("Error updating document: \(error)")
            } else {
                print("Document successfully updated")
            }
        }
    }
    
    private func loadAnotherUserInformations() {
        db.collection("users").whereField("userName", isEqualTo: userPseudo).addSnapshotListener { (querySnapshot, error) in
            self.userInformations = []
            if let e = error {
                print("There was an issue retrieving data from Firestore. \(e)")
            } else {
                guard let snapshotDocuments = querySnapshot?.documents else {return}
                for doc in snapshotDocuments {
                    let data = doc.data()
                    guard let userPseudo = data["userName"] as? String ,let userGender = data["userGender"] as? String, let userCity = data["userCity"] as? String, let userLevel = data["userLevel"] as? String, let imageData = data["userImage"] as? Data, let userBirthDate = data["userAge"] as? String else {return}
                    let user = User(pseudo: userPseudo, image: imageData, sexe: userGender, level: userLevel, city: userCity, birthDate: userBirthDate, uid: "")
                    self.userInformations.append(user)
                    let stringDate = self.stringToDate(dateString: userBirthDate)
                    let userAge = self.dateToAge(birthDate: stringDate)
                    DispatchQueue.main.async {
                        self.userInformationTxtField[0].text = userPseudo
                        self.userInformationTxtField[1].text = userGender
                        self.userInformationTxtField[3].text = userCity
                        self.userInformationTxtField[4].text = userLevel
                        self.userPictureImageView.image = UIImage(data: imageData)
                        self.userInformationTxtField[2].text = userAge + " " + "ans"
                    }
                }
            }
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
    
    private func loadCurrentUserInformations() {
        db.collection("users").whereField("userUid", isEqualTo: Auth.auth().currentUser?.uid as Any).addSnapshotListener { (querySnapshot, error) in
            self.userInformations = []
            if let e = error {
                print("There was an issue retrieving data from Firestore. \(e)")
            } else {
                guard let snapshotDocuments = querySnapshot?.documents else {return}
                for doc in snapshotDocuments {
                    let data = doc.data()
                    guard let userPseudo = data["userName"] as? String ,let userGender = data["userGender"] as? String, let userCity = data["userCity"] as? String, let userLevel = data["userLevel"] as? String, let userPicture = data["userImage"] as? Data, let userBirthDate = data["userAge"] as? String else {return}
                    let user = User(pseudo: userPseudo, image: userPicture, sexe: userGender, level: userLevel, city: userCity, birthDate: userBirthDate, uid: "")
                    self.userInformations.append(user)
                    let stringDate = self.stringToDate(dateString: userBirthDate)
                    let userAge = self.dateToAge(birthDate: stringDate)
                    DispatchQueue.main.async {
                        self.userInformationTxtField[0].text = userPseudo
                        self.userInformationTxtField[1].text = userGender
                        self.userInformationTxtField[3].text = userCity
                        self.userInformationTxtField[4].text = userLevel
                        self.userPictureImageView.image = UIImage(data: userPicture)
                        self.userInformationTxtField[2].text = userAge + " " + "ans"
                    }
                }
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
