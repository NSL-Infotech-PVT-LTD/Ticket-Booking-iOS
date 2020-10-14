//
//  GetFreindListViewModel.swift
//  SurpriseMe User
//
//  Created by Pankaj Mac on 24/09/20.
//  Copyright © 2020 Pankaj Mac. All rights reserved.
//

import Foundation
import SwiftyJSON


class ChatHistoryModel: NSObject {
    
    var id: Int?
    var local_message_id: String?
    var message_id: String?
    var reply_id: Int?
    var sender_id: Int?
    var receiver_id: Int?
    var attachment: String?
    var message: String?
    var type: String?
    var is_read: String?
    var created_at: String?
    var sender_name: String?
    var sender_image: String?
    var receiver_name: String?
    var receiver_image: String?
    var reply_count: Int?
    var status: Int?
//    var thumbnail: String?
    
    
    convenience init(response: [String: Any]) {
        self.init()
    let json = JSON(response)
    
        id = json[Key.id].intValue
        local_message_id = json[Key.local_message_id].stringValue
        message_id = json[Key.message_id].stringValue
        reply_id = json[Key.reply_id].intValue
        sender_id = json[Key.sender_id].intValue
        receiver_id = json[Key.receiver_id].intValue
        attachment = json[Key.attachment].stringValue
        message = json[Key.message].stringValue
        type = json[Key.type].stringValue
        is_read = json[Key.is_read].stringValue
        created_at = json[Key.created_at].stringValue
        sender_name = json[Key.sender_name].stringValue
        sender_image =  json[Key.sender_image].stringValue
        receiver_name = json[Key.receiver_name].stringValue
        receiver_image = json[Key.receiver_image].stringValue
        reply_count = json[Key.reply_count].intValue
        status = json[Key.status].intValue
//        thumbnail = json[Key.thumbnail].stringValue
        
    }
    
    struct Key {
        static let id = "id"
        static let local_message_id = "local_message_id"
        static let message_id = "message_id"
        static let reply_id = "reply_id"
        static let sender_id = "sender_id"
        static let receiver_id = "receiver_id"
        static let attachment = "attachment"
        static let message = "message"
        static let type = "type"
        static let is_read = "is_read"
        static let status = "status"
        static let created_at = "created_at"
        static let sender_name = "sender_name"
        static let sender_image = "sender_image"
        static let receiver_name = "receiver_name"
        static let receiver_image = "receiver_image"
        static let reply_count = "reply_count"
//        static let thumbnail = "thumbnail"
    }
}




