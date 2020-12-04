//
//  GetArtistModel.swift
//  SurpriseMe User
//
//  Created by Pankaj Mac on 18/09/20.
//  Copyright © 2020 Pankaj Mac. All rights reserved.
//

import Foundation
import SwiftyJSON

class GetArtistModel: NSObject {
    
    var name: String?
    var id: Int?

    var image: String?
    var live_price_per_hr: Int?
    var digital_price_per_hr: Int?
    var ratingValue: Int?

    
    var currency: String?
    var descriptionValue: String?
    var shows_image_1: String?
    var shows_image_2: String?
    var shows_image_3: String?
    var shows_image_4: String?
    var social_link_insta: String?
    var social_link_youtube: String?
    var shows_video: String?

    var categoryArtist = [SearchCategoryHomeProfileDetails]()

    
    var category : [JSON]?



convenience init(resposne : [String:Any]) {
        self.init()
        let json = JSON(resposne)
        name = json[ManageAddressModelKey.name].stringValue
        image = json[ManageAddressModelKey.image].stringValue
    shows_video = json[ManageAddressModelKey.shows_video].stringValue

    
    
        live_price_per_hr = json[ManageAddressModelKey.live_price_per_hr].intValue
    
    id = json[ManageAddressModelKey.id].intValue
    
    ratingValue = json[ManageAddressModelKey.ratingValue].intValue


    
        digital_price_per_hr = json[ManageAddressModelKey.digital_price_per_hr].intValue
        currency = json[ManageAddressModelKey.currency].stringValue
        descriptionValue = json[ManageAddressModelKey.description].stringValue
        shows_image_1 = json[ManageAddressModelKey.shows_image_1].stringValue
        shows_image_2 = json[ManageAddressModelKey.shows_image_2].stringValue
        shows_image_3 = json[ManageAddressModelKey.shows_image_3].stringValue
        shows_image_4 = json[ManageAddressModelKey.shows_image_4].stringValue
        social_link_insta = json[ManageAddressModelKey.social_link_insta].stringValue
        social_link_youtube = json[ManageAddressModelKey.social_link_youtube].stringValue
    category = json[ManageAddressModelKey.category_id_details].array
    
   // categoryArtist = json[HomeScreenModelModelKey.category_id_details].array
    let categories = json["category_id_details"].arrayValue
           for indexValue in categories {
              let dictValue = SearchCategoryHomeProfileDetails.init(resposne: indexValue)
               categoryArtist.append(dictValue)
           }


     
    }
    
    struct ManageAddressModelKey {
        static let name = "name"
        static let image = "image"
        static let live_price_per_hr = "live_price_per_hr"
        static let digital_price_per_hr = "digital_price_per_hr"
        static let currency = "currency"
        static let description = "description"
        static let shows_image_1 = "shows_image_1"
        static let shows_image_2 = "shows_image_2"
        static let shows_image_3 = "shows_image_3"
        static let shows_image_4 = "shows_image_4"
        static let social_link_insta = "social_link_insta"
        static let social_link_youtube = "social_link_youtube"
        static let id = "id"
        static let category_id_details = "category_id_details"
        static let shows_video = "shows_video"
        static let ratingValue = "rating"


        

    }

}


class SearchCategoryHomeProfileDetails: NSObject {
    var category_name = String()
    
   convenience init(resposne : JSON) {
        self.init()
        let json = JSON(resposne)
        category_name = json[HomeScreenModelModelKey.category_name].stringValue
    }
    
    struct HomeScreenModelModelKey {
        static let category_name = "category_name"
    }
    
}
