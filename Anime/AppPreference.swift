//
//  AppPreference.swift
//  MasterTemplate
//
//  Created by Tanawat Suriyachai on 04/17/2560 BE.
//  Copyright (c) 2560 S-Planet. All rights reserved.
//

import UIKit

class AppPreference {
    
    static let firstTime = "firstTime"
    
    static let isShow = "isShow"
    static let isClosePopUp = "isClosePopUp"
    static let isShowTutorial = "isShowTutorial"
    
    static let language = "language"
    
    static let userId = "userId"
    static let profileId = "profileId"
    static let entityProfileId = "entityProfileId"
    static let memberID = "memberID"
    static let name = "name"
    static let surname = "surname"
    static let email = "email"
    static let birthday = "birthday"
    static let phone = "phone"
    static let phoneCode = "phoneCode"
    static let gender = "gender"
    static let facebookId = "facebookId"
    static let googleId = "googleId"
    static let meritPhone = "meritPhone"
    
    static let isLogin = "isLogin"
    static let isVerify = "isVerify"
    
    static let profileImageUrl = "profileImageUrl"
    static let registerId = "registerId"
    
    static let notificationCount = "notificationCount"
    static let cartCount = "cartCount"
    
    static let grantPermissionLocation = "grantPermissionLocation"
    static let grantPermissionNotification = "grantPermissionNotification"
    static let grantPermissionCamera = "grantPermissionCamera"
    
    static let isGPSAlertShown = "isGPSAlertShown"
    
    static let latitude = "latitude"
    static let longitude = "longitude"
    
    static let mapCategory = "mapCategory"
    static let mapVersion = "mapVersion2"
    
    static let isLoginAdmin = "isLoginAdmin"
    static let isLoginFacebook = "isLoginFacebook"
    static let adminId = "adminId"
    static let username = "username"
    static let password = "password"
    static let organizeBranchId = "organizeBranchId"
    static let organizationId = "organizeId"
    static let organizeName = "organizeName"
    static let organizeCode = "organizeCode"
    static let isAdmin = "isAdmin"
    static let isDeletelCase = "isDeletelCase"
    
    static let helpId = "helpId"
    static let complaintId = "complaintId"
    
    static let quickbloxEntityId = "quickbloxEntityId"
    static let chatReady = "chatReady"
    
    static let giveTakeIsAccept = "giveTakeIsAccept"
    static let timelinePostIsAccept = "timelinePostIsAccept"
    
    static let organizeProfileId = "organizeProfileId"
    static let organizeEntityProfileId = "organizeEntityProfileId"
    static let organizeProfileName = "organizeProfileName"
    static let organizeProfileImage = "organizeProfileImage"
    
    static let shopId = "shopId"

    static let doctorProfileId = "doctorProfileId"
    static let doctorUserName = "doctorUserName"
    static let doctorProfileImage = "doctorProfileImage"
    static let doctorProfileName = "doctorProfileName"
    
    static let durationEndStartcall = "durationEndStartcall"
    static let durationEndCalling = "durationEndCalling"
    
    static let healthService = "healthService"
    static let healthServicePrice = "healthServicePrice"
    
    static let isShowUpload = "isShowUpload"
    
    //  ISchool
    
    static let token = "token"
    static let schoolId = "schoolId"
    static let personId = "personId"
    static let imagePath = "imagePath"
    static let schoolName = "schoolName"
    static let isLoginISchool = "isLoginISchool"
    static let duration = "duration"
    static let sosTo = "sosTo"
    static let sosToTel = "sosToTel"
    
    //  MPrompt
    
    static let mPromptId = "mPromptId"
    static let mPromptName = "mPromptName"
    static let mPromptPhone = "mPromptPhone"
    static let mPromptPassword = "mPromptPassword"
    static let mPromptPhoto = "mPromptPhoto"
    static let mPromptAdvice = "mPromptAdvice"
    static let mPromptCreated = "mPromptCreated"
    static let mPromptV = "mPromptV"
    
    var defaults: UserDefaults
    
    init() {
        defaults = UserDefaults(suiteName: "app")!
    }
    
    func setValueString(_ key: String, value: String) {
        defaults.setValue(value, forKey: key)
    }
    
    func setValueStringArray(_ key: String, value: [String]) {
        defaults.setValue(value, forKey: key)
    }
    
    func setValueInt(_ key: String, value: Int) {
        defaults.setValue(value, forKey: key)
    }
    
    func setValueDouble(_ key: String, value: Double) {
        defaults.setValue(value, forKey: key)
    }
    
    func setValueBoolean(_ key: String, value: Bool) {
        defaults.setValue(value, forKey: key)
    }
    
    func setValueObject(_ key: String, value: Any) {
        let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: value)
        defaults.setValue(encodedData, forKey: key)
    }
    
    func setValueChatArray(_ key: String, value: Data) {
        defaults.setValue(value, forKey: key)
    }
    
    func getValueString(_ key: String) -> String {
        let value = defaults.string(forKey: key)
        return value == nil ? "" : value!
    }
    
    func getValueStringArray(_ key: String) -> [String] {
        let value = defaults.object(forKey: key)
        return value == nil ? [] : value as! [String]
    }
    
    func getValueInt(_ key: String) -> Int {
        let value = defaults.object(forKey: key)
        return value == nil ? 0 : value as! Int
    }
    
    func getValueDouble(_ key: String) -> Double {
        let value = defaults.object(forKey: key)
        return value == nil ? 0 : value as! Double
    }
    
    func getValueBoolean(_ key: String) -> Bool {
        let value = defaults.object(forKey: key)
        return value == nil ? false : value as! Bool
    }
    
    func getValueObject(_ key: String) -> Any? {
        let value = defaults.object(forKey: key)
        if value == nil {
            return nil
        }
        let decoded = NSKeyedUnarchiver.unarchiveObject(with: value as! Data) as Any
        return decoded
    }
    
    func getValueChatArray(_ key: String) -> Data? {
        let value = defaults.object(forKey: key)
        return value == nil ? nil : value as? Data
    }
    
    func synchronize() {
        defaults.synchronize()
    }
    
    func clear() {
        for key in Array(defaults.dictionaryRepresentation().keys) {
            defaults.removeObject(forKey: key)
        }
    }
    
}
