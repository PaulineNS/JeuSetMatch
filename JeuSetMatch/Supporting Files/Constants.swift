//
//  Constants.swift
//  JeuSetMatch
//
//  Created by Pauline Nomballais on 23/12/2019.
//  Copyright © 2019 PaulineNomballais. All rights reserved.
//

struct Constants {
    static let appName = "Jeu Set & Match"

    struct Cell {
        static let chatCellIdentifier = "ChatCell"
        static let chatCellNibName = "ChatTableViewCell"
        static let userCellIdentifier = "UserCell"
        static let userCellNibName = "UserTableViewCell"
        static let messagesCellIdentifier = "MessagesCell"
        static let messagesCellNibName = "MessagesTableViewCell"
        static let cityCellIdentifier = "CityCell"
        static let filterCellIdentifier = "FilterCell"
        static let filterCellNibName = "FilterTableViewCell"
    }
    
    struct Segue {
        static let genderToBirthDate = "GenderToBirthDate"
        static let birthDatetoLevel = "BirthDatetoLevel"
        static let leveltoCitiesSegue = "LevelToCities"
        static let levelToCity = "LevelToCity"
        static let cityToPicture = "CityToPicture"
        static let pictureToPseudo = "PictureToPseudo"
        static let pseudoToMail = "PseudoToMail"
        static let registerSegue = "RegisterToSearch"
        static let loginSegue = "LoginToSearch"
        static let searchToProfileSegue = "SearchToProfile"
        static let searchToFilterSegue = "SearchToFilter"
        static let profileToChatSegue = "ProfileToChat"
        static let messagesToChatSegue = "MessagesToChat"
        static let profileToCitiesSegue = "ProfileToCities"
        static let filterToCitiesSegue = "FilterToCities"
    }
    
    struct FStore {
        static let userMessagesCollectionName = "user-messages"
        static let messagesCollectionName = "messages"
        static let userCollectionName = "users"
        static let userPseudoField = "userName"
        static let userAgeField = "userAge"
        static let userLevelField = "userLevel"
        static let userCityField = "userCity"
        static let userGenderField = "userGender"
        static let userPictureField = "userImage"
        static let userUidField = "userUid"
        static let fromIdMessage = "fromId"
        static let toIdMessage = "toId"
        static let textMessage = "text"
        static let timestampMessage = "timestamp"
    }
    
    struct UDefault {
        static let savedProvisionalUserInformations = "savedProvisionalUserInformations"
        static let savedProvisionaluserPicture = "savedProvisionaluserPicture"
        static let savedUserInformations = "savedUserInformations"
        static let savedUserPicture = "savedUserPicture"
        static let savedFilterCity = "savedCity"
        static let savedFilterLevel = "savedLevel"
        static let savedFilterGender = "savedGender"
    }
    
    struct Arrays {
        static let levelsPickerRegister = ["-30 - Pro","-15 - Pro","-4/6 - Pro","-2/6 - Pro","0 - Semi-pro","1/6 - Semi-pro","2/6 - Semi-pro","3/6 - Expert avancé","4/6 - Expert avancé","5/6 - Expert avancé","15 - Expert avancé","15/1 - Expert","15/2 - Expert","15/3 - Expert","15/4 - Compétiteur avancé","15/5 - Compétiteur avancé","30 - Compétiteur","30/1 - Compétiteur","30/2 - Intermédiaire avancé","30/3 - Intermédiaire","30/4 - Intermédiaire","30/5 - Amateur avancé","40 - Amateur","Débutant","Choisir"]
        static let levelsPickerUpdateProfil = ["-30 - Pro","-15 - Pro","-4/6 - Pro","-2/6 - Pro","0 - Semi-pro","1/6 - Semi-pro","2/6 - Semi-pro","3/6 - Expert avancé","4/6 - Expert avancé","5/6 - Expert avancé","15 - Expert avancé","15/1 - Expert","15/2 - Expert","15/3 - Expert","15/4 - Compétiteur avancé","15/5 - Compétiteur avancé","30 - Compétiteur","30/1 - Compétiteur","30/2 - Intermédiaire avancé","30/3 - Intermédiaire","30/4 - Intermédiaire","30/5 - Amateur avancé","40 - Amateur","Débutant"]
        static let levelsPickerFilterUser = ["-30 - Pro","-15 - Pro","-4/6 - Pro","-2/6 - Pro","0 - Semi-pro","1/6 - Semi-pro","2/6 - Semi-pro","3/6 - Expert avancé","4/6 - Expert avancé","5/6 - Expert avancé","15 - Expert avancé","15/1 - Expert","15/2 - Expert","15/3 - Expert","15/4 - Compétiteur avancé","15/5 - Compétiteur avancé","30 - Compétiteur","30/1 - Compétiteur","30/2 - Intermédiaire avancé","30/3 - Intermédiaire","30/4 - Intermédiaire","30/5 - Amateur avancé","40 - Amateur","Débutant","Tout"]
        static let gendersPickerUpdateProfil = ["Femme","Homme"]
        static let gendersPickerFilterUser = ["Tout", "Femme", "Homme"]
        static let agePickerFilterUser = ["Entre 10 et 20 ans","Entre 20 et 30 ans","Entre 30 et 40 ans","Entre 40 et 50 ans","Entre 50 et 60 ans","Entre 60 et 70 ans","Entre 70 et 80 ans","Entre 80 et 90 ans"]
    }
}
