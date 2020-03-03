//
//  ProfileViewController.swift
//  JeuSetMatch
//
//  Created by Pauline Nomballais on 03/01/2020.
//  Copyright © 2020 PaulineNomballais. All rights reserved.

import UIKit
import Photos
import AVFoundation

final class ProfileViewController: UIViewController {
    
    // MARK: - Instensiation
    
    private let firestoreUser = FirestoreUserService()
    private let firestoreLogin = FirestoreLogService()
    private let firestoreRegister = FirestoreRegisterService()
    private let customLoader = CustomLoader()
    private let image = UIImagePickerController()
    
    // MARK: - Variables
    
    var userToShow: UserObject?
    var IsSegueFromSearch = false
    lazy private var registerUseCase: RegisterUseCase = RegisterUseCase(client: firestoreRegister)
    lazy private var userUseCase: UserUseCase = UserUseCase(user: firestoreUser)
    lazy private var loginUseCase: LogUseCase = LogUseCase(client: firestoreLogin)
    private var IsUpdateStatus = false
    private var newBirthdate: String?
    private var originalBirthdate: String?
    private var userInformations: [UserObject] = []
    private var genderPicker: UIPickerView?
    private var datePicker: UIDatePicker?
    private var levelPicker: UIPickerView?
    private let minimumAge = Calendar.current.date(byAdding: .year, value: -10, to: Date())
    
    // MARK: - Outlets
    
    @IBOutlet weak var userPseudo: UINavigationItem!
    @IBOutlet var userInformationsTxtField: [UITextField]!
    @IBOutlet weak var userFixPictureImageView: UIImageView!
    @IBOutlet private weak var userPictureImageView: UIImageView!
    @IBOutlet weak var plusImageView: UIImageView!
    @IBOutlet private weak var logOutBarButtonItem: UIBarButtonItem!
    @IBOutlet private weak var updateProfileButton: UIButton!
    @IBOutlet private weak var validateButton: UIButton!
    @IBOutlet private weak var cancelButton: UIButton!
    @IBOutlet weak var deleteProfilButton: UIButton!
    @IBOutlet weak var alertDateLbl: UILabel!
    @IBOutlet weak var alertView: UIView!
    
    // MARK: - Controller life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationBarCustom()
        managePickers()
        manageButtonVisibility(updatePosition: true, fixPosition: false)
        managePictureVisibility(updatePicture: true, userPicture: false)
        userFixPictureImageView.makeRounded()
        userPictureImageView.makeRounded()
        let singleTap = UITapGestureRecognizer(target: self, action: #selector(didTapProfilPicture))
        userPictureImageView.isUserInteractionEnabled = true
        userPictureImageView.addGestureRecognizer(singleTap)
        manageTxtField(status: false, backgroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0), textColour: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), border: .none)
        image.delegate = self
        alertDateLbl.isHidden = true
        alertView.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.navigationItem.hidesBackButton = true
        self.tabBarController?.navigationItem.rightBarButtonItem = logOutBarButtonItem
        guard IsSegueFromSearch == true else {
            guard IsUpdateStatus == true else {
                managePictureVisibility(updatePicture: true, userPicture: false)
                guard let currentUserUid = firestoreUser.currentUserUid else {return}
                fetchUserInformations(userUid: currentUserUid )
                updateProfileButton.setTitle("Modifier mon profil", for: .normal)
                return
            }
            managePictureVisibility(updatePicture: false, userPicture: true)
            displayUserDefaultsOnTextField(userInformations: Constants.UDefault.savedProvisionalUserInformations, userPicture: Constants.UDefault.savedProvisionaluserPicture)
            return
        }
        guard let partnerUid = userToShow?.uid else {return}
        fetchUserInformations(userUid: partnerUid)
        updateProfileButton.setTitle("Contacter", for: .normal)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        selectPickerViewRows()
    }
    
    // MARK: - Segue
    
    /// Prepare segue to ChatVc or CitiesVc
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.Segue.profileToChatSegue {
            guard let chatVc = segue.destination as? ChatViewController else {return}
            chatVc.receiverUser = UserObject(pseudo: userToShow?.pseudo, image: userToShow?.image, sexe: userToShow?.sexe, level: userToShow?.level, city: userToShow?.city, birthDate: userToShow?.birthDate, uid: userToShow?.uid)
        }
        if segue.identifier == Constants.Segue.profileToCitiesSegue {
            guard let citiesVc = segue.destination as? CitiesViewController else {return}
            citiesVc.didSelectCityDelegate = self
        }
    }
    
    // MARK: - Actions
    
    /// Manage the action of the buttom screen button
    @IBAction private func buttomButtonPressed(_ sender: UIButton) {
        if sender.currentTitle == "Contacter" {
            performSegue(withIdentifier: Constants.Segue.profileToChatSegue, sender: nil)
        }
        if sender.currentTitle == "Modifier mon profil" {
            managePictureVisibility(updatePicture: false, userPicture: true)
            manageTxtField(status: true, backgroundColor: #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1), textColour: #colorLiteral(red: 0.1190812364, green: 0.2160289288, blue: 0.1939708292, alpha: 1), border: .roundedRect)
            manageButtonVisibility(updatePosition: false, fixPosition: true)
            setInformationsInUserDefault(userInformations: Constants.UDefault.savedUserInformations, userPicture: Constants.UDefault.savedUserPicture)
        }
    }
    
    @IBAction private func logOutPressed(_ sender: UIBarButtonItem) {
        loginUseCase.logOut { isSuccess in
            if !isSuccess {
                // PresentAlert
            }
        }
        dismissTheView()
    }
    
    @objc private func didTapProfilPicture() {
        onPictureClick(image: image)
    }
    
    @objc private func dateChanged(datePicker: UIDatePicker) {
        let isValideAge = validateAge(birthDate: datePicker.date, minimumAge: minimumAge ?? Date())
        newBirthdate = convertDateToString(date: datePicker.date)
        guard isValideAge else {
            alertDateLbl.isHidden = false
            alertView.isHidden = false
            deleteProfilButton.isHidden = true
            return
        }
        alertDateLbl.isHidden = true
        alertView.isHidden = true
        deleteProfilButton.isHidden = false
        userInformationsTxtField[2].text = dateToAge(birthDate: datePicker.date) + " " + "ans"
    }
    
    /// Validate the profile update
    @IBAction private func didPressValidateButton(_ sender: Any) {
        manageTxtField(status: false, backgroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0), textColour: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), border: .none)
        manageButtonVisibility(updatePosition: true, fixPosition: false)
        managePictureVisibility(updatePicture: true, userPicture: false)
        IsUpdateStatus = false
        if newBirthdate == nil {
            newBirthdate = originalBirthdate
        }
        guard let userCity = userInformationsTxtField[0].text, let userGender = userInformationsTxtField[1].text, let userLevel = userInformationsTxtField[3].text, let pictureData = userFixPictureImageView.image?.jpegData(compressionQuality: 0.1), let userBirthDate = newBirthdate else {
            //present Alert
            return}
        userUseCase.updateUserInformation(userAge: userBirthDate, userCity: userCity, userGender: userGender, userLevel: userLevel, userImage: pictureData) { isSuccess in
            if !isSuccess {
                // PresentAlert
            }
        }
    }
    
    /// Cancel the update profil mood
    @IBAction private func didPressCancelButton(_ sender: Any) {
        alertDateLbl.isHidden = true
        alertView.isHidden = true
        IsUpdateStatus = false
        managePictureVisibility(updatePicture: true, userPicture: false)
        manageTxtField(status: false, backgroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0), textColour: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), border: .none)
        manageButtonVisibility(updatePosition: true, fixPosition: false)
        displayUserDefaultsOnTextField(userInformations: Constants.UDefault.savedUserInformations, userPicture: Constants.UDefault.savedUserPicture)
    }
    
    /// Action after tapping the delete button
    @IBAction private func didPressDeleteAccountButton(_ sender: Any) {
        presentAlert(title: "Etes vous sure de supprimer votre compte ?", message: "") { (success) in
            guard success == true else {return}
            self.registerUseCase.deleteAccount {isSuccess in
                guard !isSuccess else {
                    self.dismissTheView()
                    return
                }
                //PresentAlert
            }
        }
    }
    
    // MARK: - Methods
    
    /// Manage pickers displaying
    private func managePickers(){
        userInformationsTxtField[0].delegate = self
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        datePicker?.locale = Locale.init(identifier: "fr_FR")
        userInformationsTxtField[2].inputView = datePicker
        datePicker?.addTarget(self, action: #selector(ProfileViewController.dateChanged(datePicker:)), for: .valueChanged)
        levelPicker = UIPickerView()
        userInformationsTxtField[3].inputView = levelPicker
        genderPicker = UIPickerView()
        userInformationsTxtField[1].inputView = genderPicker
        levelPicker?.delegate = self
        genderPicker?.delegate = self
        genderPicker?.dataSource = self
        levelPicker?.dataSource = self
    }
    
    /// Select a value on pickerviews
    private func selectPickerViewRows() {
        if let levelIndex = find(value: userInformationsTxtField[3].text ?? "", in: Constants.Arrays.levelsPickerUpdateProfil) {
            levelPicker?.selectRow(levelIndex, inComponent: 0, animated: true)
        }
        if let genderIndex = find(value: userInformationsTxtField[1].text ?? "", in: Constants.Arrays.gendersPickerUpdateProfil) {
            genderPicker?.selectRow(genderIndex, inComponent: 0, animated: true)
        }
    }
    
    /// Display the updatable picture or fix one
    private func managePictureVisibility(updatePicture: Bool, userPicture: Bool) {
        userPictureImageView.isHidden = updatePicture
        plusImageView.isHidden = updatePicture
        userFixPictureImageView.isHidden = userPicture
    }
    
    // Manage view element visibility
    private func manageButtonVisibility(updatePosition: Bool, fixPosition: Bool) {
        validateButton.isHidden = updatePosition
        cancelButton.isHidden = updatePosition
        deleteProfilButton.isHidden = updatePosition
        updateProfileButton.isHidden = fixPosition
    }
    
    /// Manage texfield design according mode profil
    private func manageTxtField(status: Bool, backgroundColor: UIColor, textColour: UIColor, border: UITextField.BorderStyle ) {
        for txtField in userInformationsTxtField {
            txtField.isUserInteractionEnabled = status
            txtField.backgroundColor = backgroundColor
            txtField.textColor = textColour
            txtField.borderStyle = border
        }
    }
    
    /// Set current user information in userDefault before passing to update profil mode
    private func setInformationsInUserDefault(userInformations: String, userPicture: String) {
        var index = 0
        for _ in userInformationsTxtField {
            UserDefaults.standard.set(userInformationsTxtField[index].text, forKey: userInformations + "\(index)")
            index += 1
        }
        UserDefaults.standard.set(userFixPictureImageView.image?.jpegData(compressionQuality: 0.1), forKey: userPicture)
    }
    
    /// Display back user information from userDefault
    private func displayUserDefaultsOnTextField(userInformations: String, userPicture: String) {
        var index = 0
        for _ in userInformationsTxtField {
            userInformationsTxtField[index].text = UserDefaults.standard.string(forKey: userInformations + "\(index)")
            index += 1
        }
        guard let imageData = UserDefaults.standard.data(forKey: userPicture)
            else {return}
        userPictureImageView.image = UIImage(data: imageData)
        userFixPictureImageView.image = UIImage(data: imageData)
    }
    
    /// Fetch all the user informations on screen
    private func fetchUserInformations(userUid: String) {
        self.userInformations = []
        customLoader.showLoaderView()
        userUseCase.fetchUserInformationsDependingOneFilter(field1: Constants.FStore.userUidField, field1value: userUid, completion: { (result) in
            self.customLoader.hideLoaderView()
            switch result {
            case .success(let user) :
                self.userInformations.append(user)
                guard let userBirthdate = user.birthDate, let userPseudo = user.pseudo, let userGender = user.sexe, let userCity = user.city, let userLevel = user.level, let userPicture = user.image else {return}
                self.originalBirthdate = userBirthdate
                let stringDate = self.convertStringToDate(dateString: userBirthdate)
                let userAge = self.dateToAge(birthDate: stringDate)
                DispatchQueue.main.async {
                    self.userPseudo.title = userPseudo
                    self.tabBarController?.navigationItem.title = userPseudo
                    self.userInformationsTxtField[1].text = userGender
                    self.userInformationsTxtField[0].text = userCity
                    self.userInformationsTxtField[3].text = userLevel
                    self.userPictureImageView.image = UIImage(data: userPicture)
                    self.userFixPictureImageView.image = UIImage(data: userPicture)
                    self.userInformationsTxtField[2].text = userAge + " " + "ans"
                }
            case .failure(let error) :
                print(error.localizedDescription)
            case .none:
                return
            }
        })
    }
    
    /// Dismiss the view after logout or account delete
    private func dismissTheView() {
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let logInViewController = mainStoryBoard.instantiateViewController(withIdentifier: "loginViewController")
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = logInViewController
        navigationController?.popToRootViewController(animated: true)
    }
}

// MARK: - TextField Delegate

extension ProfileViewController: UITextFieldDelegate {
    
    /// Action while text field did begin editing 
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
        setInformationsInUserDefault(userInformations: Constants.UDefault.savedProvisionalUserInformations, userPicture: Constants.UDefault.savedProvisionaluserPicture)
        performSegue(withIdentifier: Constants.Segue.profileToCitiesSegue, sender: nil)
    }
}

// MARK: - PickerView

extension ProfileViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    /// Number of components in pickerView
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    /// Number of rows in pickerView
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView {
        case pickerView where pickerView == levelPicker:
            return Constants.Arrays.levelsPickerUpdateProfil.count
        case pickerView where pickerView == genderPicker:
            return Constants.Arrays.gendersPickerUpdateProfil.count
        default:
            return 0
        }
    }
    
    /// Rows title
    func pickerView( _ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView {
        case pickerView where pickerView == levelPicker:
            return Constants.Arrays.levelsPickerUpdateProfil[row]
        case pickerView where pickerView == genderPicker:
            return Constants.Arrays.gendersPickerUpdateProfil[row]
        default:
            return ""
        }
    }
    
    /// Action while selecting a row
    func pickerView( _ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView {
        case pickerView where pickerView == levelPicker:
            userInformationsTxtField[3].text = Constants.Arrays.levelsPickerUpdateProfil[row]
        case pickerView where pickerView == genderPicker:
            userInformationsTxtField[1].text = Constants.Arrays.gendersPickerUpdateProfil[row]
        default:
            break
        }
    }
}

// MARK: - DidSelectCityDelegate

extension ProfileViewController: DidSelectCityDelegate {
    func rowTapped(with city: String) {
        UserDefaults.standard.set(city, forKey: Constants.UDefault.savedProvisionalUserInformations + "0"
        )
        self.userInformationsTxtField[0].text = city
        IsUpdateStatus = true
    }
}

// MARK: - UIImage Picker Controller

extension ProfileViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            if let imageView = userPictureImageView {
                imageView.contentMode = .scaleAspectFill
                imageView.image = pickedImage
                IsUpdateStatus = true
                userPictureImageView.image = pickedImage
                userFixPictureImageView.image = pickedImage
            } else {
                print ("selectedUIImageView is nil")
            }
        } else {
            print ("info[UIImagePickerController.InfoKey.originalImage] isn't an UIImage")
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    //Remove the view when the user click on cancel
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
