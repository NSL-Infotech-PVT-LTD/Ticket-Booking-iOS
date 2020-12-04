//
//  GetProfileModel.swift
//  SurpriseMe User
//
//  Created by Pankaj Mac on 02/09/20.
//  Copyright © 2020 Pankaj Mac. All rights reserved.
//

import Foundation
import SwiftyJSON

class GetProfileModel: NSObject {
    
    var email: String?
    var name: String?
    var image: String?
  
    convenience init(resposne : [String:Any]) {
        self.init()
        let json = JSON(resposne)
        email = json[ManageAddressModelKey.email].stringValue
        name = json[ManageAddressModelKey.name].stringValue
        image = json[ManageAddressModelKey.image].stringValue
     
    }
    
    struct ManageAddressModelKey {
        static let email = "email"
        static let name = "name"
        static let image = "image"
    }
    
}
