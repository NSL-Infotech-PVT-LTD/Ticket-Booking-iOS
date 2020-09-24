//
//  GetBookingListModel.swift
//  SurpriseMe User
//
//  Created by Pankaj Mac on 14/09/20.
//  Copyright © 2020 Pankaj Mac. All rights reserved.
//



import Foundation
import SwiftyJSON


class GetBookingListModel: NSObject {
    var name: String?
    var from_time: String?
    var to_time: String?
    var image: String?
    var dateInString: String?
    var type: String?

    var artist_detail           : ArtistDetailModel?

  
    convenience init(resposne : [String:Any]) {
        self.init()
        let json = JSON(resposne)
        name = json[GetBookingListModelModelModelKey.name].stringValue
        from_time = json[GetBookingListModelModelModelKey.from_time].stringValue
        to_time = json[GetBookingListModelModelModelKey.to_time].stringValue
        dateInString = json[GetBookingListModelModelModelKey.date].stringValue
        image = json[GetBookingListModelModelModelKey.image].stringValue
        type = json[GetBookingListModelModelModelKey.type].stringValue
     artist_detail = ArtistDetailModel.init(resposne: json["artist_detail"].dictionaryObject!)
    }
    
    struct GetBookingListModelModelModelKey {
        static let name = "name"
        static let from_time = "from_time"
        static let to_time = "to_time"
        static let image = "image"
        static let date = "date"
        static let type = "type"

    }
    
}

class ArtistDetailModel: NSObject {
    
    var ID                      : Int?
    var name                    : String?
    var category_id_details     : String?
    var imageProfile            : String?
    
    
    convenience init(resposne : [String:Any]) {
        self.init()
        let json = JSON(resposne)
        ID                  = json[userModelKey.ID].intValue
        name                = json[userModelKey.name].stringValue
        imageProfile        = json[userModelKey.imageProfile].stringValue
        category_id_details = json[userModelKey.category_id_details].stringValue
        
    }
    
    struct userModelKey {
        
        static let ID                    = "id"
        static let name                  = "name"
        static let imageProfile          = "image"
        static let category_id_details   = "category_id_details"
    }
}
