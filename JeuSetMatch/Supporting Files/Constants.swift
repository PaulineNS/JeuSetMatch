//
//  Constants.swift
//  JeuSetMatch
//
//  Created by Pauline Nomballais on 23/12/2019.
//  Copyright © 2019 PaulineNomballais. All rights reserved.
//

struct K {
    static let appName = "🎾Jeu Set & Match"

    static let chatCellIdentifier = "ChatCell"
    static let chatCellNibName = "ChatTableViewCell"
    static let userCellIdentifier = "UserCell"
    static let userCellNibName = "UserTableViewCell"
    static let messagesCellIdentifier = "MessagesCell"
    static let messagesCellNibName = "MessagesTableViewCell"
    static let cityCellIdentifier = "CityCell"
    static let filterCellIdentifier = "FilterCell"
    static let filterCellNibName = "FilterTableViewCell"
    
    static let registerSegue = "FromRegisterToSearch"
    static let loginSegue = "FromLoginToSearch"
    static let BirthDateSegue = "BirthDatetoLevel"
    static let LeveltoCitiesSegue = "LevelToCities"
    static let LeveltoPseudoSegue = "LevelToPseudo"
    static let PseudoToMailSegue = "PseudoToMail"
    static let SearchToProfileSegue = "SearchToProfile"
    static let ProfileToChatSegue = "ProfileToChat"
    static let MessagesToChatSegue = "MessagesToChat"
    static let SearchToWelcomeSegue = "SearchToWelcome"
    static let ProfileToCitiesSegue = "ProfileToCities"
    
    struct FStore {
        static let messagesCollectionName = "messages"
        static let userCollectionName = "users"
        static let userPseudoField = "userName"
        static let userAgeField = "userAge"
        static let userLevelField = "userLevel"
        static let userCityField = "userCity"
        static let userGenderField = "UserGender"
        static let userPictureField = "userPicture"
        static let userUidField = "userUid"
        static let senderField = "sender"
        static let bodyField = "body"
        static let dateField = "date"
        static let receiverPseudoField = "receiverPseudo"
    }
}
