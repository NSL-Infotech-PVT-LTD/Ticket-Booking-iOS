//
//  SearchArtistModel.swift
//  SurpriseMe User
//
//  Created by Pankaj Mac on 18/09/20.
//  Copyright © 2020 Pankaj Mac. All rights reserved.
//

import Foundation
import SwiftyJSON


class SearchArtistModel: NSObject {
    var name: String?
    var artistDescription: String?
    var image: String?
    var descriptionValue: String?
    var ratingValue: Int?
    var id: Int?
    var rate_detail  = [SearchCategoryIdDetails]()
    var rate_detailValue  : [[String:Any]]?
    var distance : Double?

    var currency: String?
    var digitalPrice: Int?
    var livePrice: Int?
    var converted_currency : String?
    var converted_digital_price: Int?
    var converted_live_price: Int?
    
    
    
//    var category : [JSON]?
  
    convenience init(resposne : [String:Any]) {
        self.init()
        let json = JSON(resposne)
        name = json[HomeScreenModelModelKey.name].stringValue
        artistDescription = json[HomeScreenModelModelKey.description].stringValue
        image = json[HomeScreenModelModelKey.image].stringValue
        descriptionValue = json[HomeScreenModelModelKey.description].stringValue

        currency = json[HomeScreenModelModelKey.currency].stringValue

        
        
//        ratingValue = json[HomeScreenModelModelKey.rating].intValue

        id = json[HomeScreenModelModelKey.id].intValue
        livePrice = json[HomeScreenModelModelKey.live_price_per_hr].intValue

        digitalPrice = json[HomeScreenModelModelKey.digital_price_per_hr].intValue

        
        converted_digital_price = json[HomeScreenModelModelKey.converted_digital_price].intValue
        converted_live_price = json[HomeScreenModelModelKey.converted_live_price].intValue
        converted_currency = json[HomeScreenModelModelKey.converted_currency].stringValue
        ratingValue = json[HomeScreenModelModelKey.rating].intValue
        distance = json[HomeScreenModelModelKey.distance].doubleValue
//        rate_detail =
        let categories = json["category_id_details"].arrayValue
        for indexValue in categories {
            print("the index value is \(indexValue)")
           let dictValue = SearchCategoryIdDetails.init(resposne: indexValue)
            rate_detail.append(dictValue)
            print(rate_detail.count ?? 0)

            
        }
        print(rate_detail.count ?? 0)
        //print("the category name is \(rate_detail[0].category_name ?? "")")

        
        
        
     
    }
    
    struct HomeScreenModelModelKey {
        static let name = "name"
        static let description = "description"
        static let image = "image"
        static let id = "id"
        static let category_id_details = "category_id_details"
        static let distance  = "distance"
        var rate_detailValue  = "category_id_details"
        var description  = "description"
        
        static let rating  = "rating"

        static let currency  = "currency"
        static let live_price_per_hr  = "live_price_per_hr"

        static let digital_price_per_hr  = "digital_price_per_hr"
        static let converted_digital_price = "converted_digital_price"
        static let converted_live_price = "converted_live_price"
        static let converted_currency = "converted_currency"



    }
    
}


class SearchCategoryIdDetails: NSObject {
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
