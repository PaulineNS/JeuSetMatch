//
//  ProfileViewController.swift
//  JeuSetMatch
//
//  Created by Pauline Nomballais on 03/01/2020.
//  Copyright © 2020 PaulineNomballais. All rights reserved.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var userPictureImageView: UIImageView!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var birthDateLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    @IBOutlet weak var pseudoLabel: UILabel!
    @IBOutlet weak var logOutBarButtonItem: UIBarButtonItem!
    @IBOutlet weak var updateProfileButton: UIButton!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        print("profilevc", currentUser?.birthDate as Any)
        print("profilevc", currentUser?.city as Any)
    }
    
    var currentUser: User?

    @IBAction func buttomButtonPressed(_ sender: UIButton) {
        guard sender.currentTitle == "Contacter" else {return}
        performSegue(withIdentifier: K.ProfileToChatSegue, sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == K.ProfileToChatSegue else {return}
        guard let chatVc = segue.destination as? ChatViewController else {return}
        chatVc.user = User(pseudo: currentUser?.pseudo, image: currentUser?.image, sexe: currentUser?.sexe, level: currentUser?.level, city: currentUser?.city, birthDate: currentUser?.birthDate, uid: currentUser?.uid)
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
    
    let db = Firestore.firestore()
    var IsSegueFromSearch = false
    var userPseudo = ""
    var userInformations: [User] = []
    
    func loadAnotherUserInformations() {
        db.collection(K.FStore.userCollectionName).whereField(K.FStore.userPseudoField, isEqualTo: userPseudo).addSnapshotListener { (querySnapshot, error) in
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
                        self.pseudoLabel.text = userPseudo
                        self.genderLabel.text = userGender
                        self.cityLabel.text = userCity
                        self.levelLabel.text = userLevel
                        self.userPictureImageView.image = UIImage(data: imageData)
                        self.birthDateLabel.text = userAge + " " + "ans"
                    }
                }
            }
        }
    }
    
    func stringToDate(dateString : String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let s = dateFormatter.date(from: dateString) ?? Date()
        return s
    }
    
    func dateToAge(birthDate: Date) -> String {
        let now = Date()
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year], from: birthDate, to: now)
        guard let intAge = ageComponents.year else {return ""}
        let stringAge = String(intAge)
        return stringAge
    }
    
    func loadCurrentUserInformations() {
        db.collection(K.FStore.userCollectionName).whereField("userUid", isEqualTo: Auth.auth().currentUser?.uid as Any).addSnapshotListener { (querySnapshot, error) in
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
                        self.pseudoLabel.text = userPseudo
                        self.genderLabel.text = userGender
                        self.cityLabel.text = userCity
                        self.levelLabel.text = userLevel
                        self.userPictureImageView.image = UIImage(data: userPicture)
                        self.birthDateLabel.text = userAge + " " + "ans"
                    }
                }
            }
        }
    }
    
    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
}
