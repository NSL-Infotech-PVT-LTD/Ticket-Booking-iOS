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
    var id: Int?

    var category : [JSON]?
  
    convenience init(resposne : [String:Any]) {
        self.init()
        let json = JSON(resposne)
        name = json[HomeScreenModelModelKey.name].stringValue
        artistDescription = json[HomeScreenModelModelKey.description].stringValue
        image = json[HomeScreenModelModelKey.image].stringValue
        id = json[HomeScreenModelModelKey.id].intValue
        category = json[HomeScreenModelModelKey.category_id_details].array
     
    }
    
    struct HomeScreenModelModelKey {
        static let name = "name"
        static let description = "description"
        static let image = "image"
        static let id = "id"

        static let category_id_details = "category_id_details"

    }
    
}
