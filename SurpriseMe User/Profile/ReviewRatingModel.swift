//
//  ReviewRatingModel.swift
//  SurpriseMe_Artist
//
//  Created by Loveleen Kaur Atwal on 08/10/20.
//  Copyright © 2020 Loveleen Kaur. All rights reserved.
//

import UIKit
import SwiftyJSON
class ReviewRatingModel: NSObject {
    
    var ID                      : Int?
    var artist_id               : Int?
    var booking_id              : Int?
    var review                  : String?
    var rate                    : Double?
    var avg_rate                : Double?
    var createdAt               : String?
    var customerDetail          : customerDetail_Model?
    
    convenience init(resposne : [String:Any]) {
        self.init()
        let json = JSON(resposne)
        ID                       = json[userModelKey.ID].intValue
        artist_id                = json[userModelKey.artist_id].intValue
        booking_id               = json[userModelKey.booking_id].intValue
        review                   = json[userModelKey.review].stringValue
        rate                     = json[userModelKey.rate].doubleValue
        avg_rate                 = json[userModelKey.avg_rate].doubleValue
        createdAt                = json[userModelKey.createdAt].stringValue
        customerDetail           = customerDetail_Model.init(resposne: json["customer_detail"].dictionaryObject!)
    }
    
    struct userModelKey {
        
        static let ID                    = "id"
        static let artist_id             = "artist_id"
        static let booking_id            = "booking_id"
        static let review                = "review"
        static let rate                  = "rate"
        static let avg_rate              = "avg_rate"
        static let createdAt             = "created_at"
    }
}


class customerDetail_Model: NSObject {
    
    var ID                      : Int?
    var name                    : String?
    var imageProfile            : String?
    
    
    convenience init(resposne : [String:Any]) {
        self.init()
        let json = JSON(resposne)
        ID                  = json[userModelKey.ID].intValue
        name                = json[userModelKey.name].stringValue
        imageProfile        = json[userModelKey.imageProfile].stringValue
        
    }
    
    struct userModelKey {
        
        static let ID                    = "id"
        static let name                  = "name"
        static let imageProfile          = "image"
    }
}
