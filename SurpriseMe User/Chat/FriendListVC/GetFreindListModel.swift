//
//  GetFreindListModel.swift
//  SurpriseMe User
//
//  Created by Pankaj Mac on 24/09/20.
//  Copyright © 2020 Pankaj Mac. All rights reserved.
//


import Foundation
import SwiftyJSON

class GetFreindListModel: NSObject {
    
    var message           : String?
    var sender_id         : Int?
    var sender_name       : String?
    var sender_image      : String?
    var receiver_id         : Int?
    var receiver_name       : String?
    var receiver_image      : String?
    var created_at        : String?
       var is_read         : Int?
    var reply_count         : Int?

    
    convenience init(resposne : [String:Any]) {
        self.init()
        let json = JSON(resposne)
        receiver_id     = json[userModelKey.receiver_id].intValue
        message         = json[userModelKey.message].stringValue
        receiver_name   = json[userModelKey.receiver_name].stringValue
        receiver_image  = json[userModelKey.receiver_image].stringValue
        
        sender_id     = json[userModelKey.sender_id].intValue
        
        is_read     = json[userModelKey.is_read].intValue
        reply_count     = json[userModelKey.reply_count].intValue


        
        sender_name   = json[userModelKey.sender_name].stringValue
        sender_image  = json[userModelKey.sender_image].stringValue
        
        created_at      = json[userModelKey.created_at].stringValue
    }
    
    struct userModelKey {
        static let receiver_id        = "receiver_id"
        static let message            = "message"
        static let receiver_name      = "receiver_name"
        static let receiver_image     = "receiver_image"
        static let sender_id          = "sender_id"
        static let sender_name        = "sender_name"
        static let sender_image       = "sender_image"
        static let is_read       = "is_read"

        static let reply_count       = "reply_count"

        
        static let created_at         = "created_at"
    }
}
