//
//  Constants.swift
//  JeuSetMatch
//
//  Created by Pauline Nomballais on 23/12/2019.
//  Copyright © 2019 PaulineNomballais. All rights reserved.
//

struct K {
    static let messageCellIdentifier = "MessageCell"
    static let messageCellNibName = "MessageTableViewCell"
    static let userCellIdentifier = "UserCell"
    static let userCellNibName = "UserTableViewCell"
    static let cityCellIdentifier = "CityCell"
    static let appName = "🎾Jeu Set & Match"
    static let registerSegue = "FromRegisterToSearch"
    static let loginSegue = "FromLoginToSearch"
    static let BirthDateSegue = "BirthDatetoCity"
    
    struct FStore {
        static let messagesCollectionName = "messages"
        static let userCollectionName = "users"
        static let userNameField = "userName"
        static let userAgeField = "userAge"
        static let userLevelField = "userLevel"
        static let userCityField = "userCity"
        static let userGenderField = "UserGender"
        static let userPictureField = "userPicture"
        static let userUidField = "userUid"
        static let senderField = "sender"
        static let bodyField = "body"
        static let dateField = "date"
    }
}
