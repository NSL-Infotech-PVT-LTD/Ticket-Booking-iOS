//
//  GetArtistListHomeModel.swift
//  SurpriseMe User
//
//  Created by Pankaj Mac on 10/09/20.
//  Copyright © 2020 Pankaj Mac. All rights reserved.
//

import Foundation
import SwiftyJSON


class GetArtistListHomeModel: NSObject {
    var name: String?
    var artistDescription: String?
    var image: String?
    var id: Int?
    var rating: Int?
    var ratingValue: String?
    var currencyValue = String()
    var priceLive = Int()
    var priceDigital = Int()
    var categoryArtist = [SearchCategoryHome]()
    var category : [JSON]?
    var converted_currency : String?
    var converted_digital_price: String?
    var converted_live_price: String?
    convenience init(resposne : [String:Any]) {
        self.init()
        let json = JSON(resposne)
        name = json[HomeScreenModelModelKey.name].stringValue
        artistDescription = json[HomeScreenModelModelKey.description].stringValue
        image = json[HomeScreenModelModelKey.image].stringValue
        ratingValue = json[HomeScreenModelModelKey.rating].stringValue
        currencyValue = json[HomeScreenModelModelKey.currency].stringValue

        priceLive = json[HomeScreenModelModelKey.live_price_per_hr].intValue
        priceDigital = json[HomeScreenModelModelKey.digital_price_per_hr].intValue

        rating = json[HomeScreenModelModelKey.rating].intValue
        id = json[HomeScreenModelModelKey.id].intValue
        category = json[HomeScreenModelModelKey.category_id_details].array
        converted_digital_price = json[HomeScreenModelModelKey.converted_digital_price].stringValue
        converted_live_price = json[HomeScreenModelModelKey.converted_live_price].stringValue
        converted_currency = json[HomeScreenModelModelKey.converted_currency].stringValue
        let categories = json["category_id_details"].arrayValue
               for indexValue in categories {
                  let dictValue = SearchCategoryHome.init(resposne: indexValue)
                   categoryArtist.append(dictValue)
               }
     
    }
    
    struct HomeScreenModelModelKey {
        static let name = "name"
        static let description = "description"
        static let image = "image"
        static let id = "id"
        static let rating = "rating"
        
        static let currency = "currency"
        static let digital_price_per_hr = "digital_price_per_hr"

        static let live_price_per_hr = "live_price_per_hr"


        
        static let category_id_details = "category_id_details"
        static let converted_digital_price = "converted_digital_price"
        static let converted_live_price = "converted_live_price"
        static let converted_currency = "converted_currency"
    }
}

class SearchCategoryHome: NSObject {
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
