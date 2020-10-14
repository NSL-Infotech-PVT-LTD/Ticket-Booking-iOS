//
//  ChangeNotificationModel.swift
//  SurpriseMe User
//
//  Created by Pankaj Mac on 09/10/20.
//  Copyright © 2020 Pankaj Mac. All rights reserved.
//




import Foundation
import SwiftyJSON


class ChangeNotificationModel: NSObject {
    var message: String?
    var user  : UserDetails?
    
    convenience init(resposne : [String:Any]) {
        self.init()
        let json = JSON(resposne)
        message = json[GetBookingListModelModelModelKey.message].stringValue
        user = UserDetails.init(resposne: json["user"].dictionaryObject!)
    }
    
    struct GetBookingListModelModelModelKey {
        static let message = "message"
       
   }
}

class UserDetails: NSObject {
    var is_notify : Int?
    
    convenience init(resposne : [String:Any]) {
        self.init()
        let json = JSON(resposne)
        is_notify   = json[userModelKey.is_notify].intValue
   }
    
    struct userModelKey {
        static let is_notify  = "is_notify"
    }
}



