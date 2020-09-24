//
//  GetArtistCategoryModel.swift
//  SurpriseMe User
//
//  Created by Pankaj Mac on 18/09/20.
//  Copyright © 2020 Pankaj Mac. All rights reserved.
//

import Foundation
import SwiftyJSON

class GetArtistCategoryModel: NSObject {
    
    var id: Int?
    var name: String?
  
    convenience init(resposne : [String:Any]) {
        self.init()
        let json = JSON(resposne)
        id = json[ManageAddressModelKey.id].intValue
        name = json[ManageAddressModelKey.name].stringValue
     
    }
    
    struct ManageAddressModelKey {
        static let id = "id"
        static let name = "name"
    }
    
}
