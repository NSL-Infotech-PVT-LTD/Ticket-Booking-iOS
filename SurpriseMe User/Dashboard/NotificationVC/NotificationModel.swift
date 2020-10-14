//
//  NotificationModel.swift
//  SurpriseMe User
//
//  Created by Pankaj Mac on 06/10/20.
//  Copyright © 2020 Pankaj Mac. All rights reserved.
//





import Foundation
import SwiftyJSON


class NotificationModel: NSObject {
    var body: String?
    var title: String?
    var id: Int?
    var is_read: Int?
    var created_at: String?

    
    var artist_detail  : BookingDetails?
    
    convenience init(resposne : [String:Any]) {
        self.init()
        let json = JSON(resposne)
        body = json[GetBookingListModelModelModelKey.body].stringValue
        title = json[GetBookingListModelModelModelKey.title].stringValue
        created_at = json[GetBookingListModelModelModelKey.created_at].stringValue

        is_read = json[GetBookingListModelModelModelKey.is_read].intValue
        id = json[GetBookingListModelModelModelKey.id].intValue
        artist_detail = BookingDetails.init(resposne: json["booking_detail"].dictionaryObject!)
    }
    
    struct GetBookingListModelModelModelKey {
        static let body = "body"
        static let title = "title"
        static let id = "id"
        static let created_at = "created_at"
        static let is_read = "is_read"
   }
}

class BookingDetails: NSObject {
    
    var booking_id : Int?
    var data_type  : String?
    var status     : String?
    
    convenience init(resposne : [String:Any]) {
        self.init()
        let json = JSON(resposne)
        booking_id   = json[userModelKey.booking_id].intValue
        data_type    = json[userModelKey.data_type].stringValue
        status       = json[userModelKey.status].stringValue
   }
    
    struct userModelKey {
        
        static let booking_id  = "target_id"
        static let data_type   = "data_type"
        static let status      = "status"
    }
}

