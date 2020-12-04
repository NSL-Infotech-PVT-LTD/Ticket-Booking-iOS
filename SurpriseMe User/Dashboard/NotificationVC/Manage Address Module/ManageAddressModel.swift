//
//  ManageAddressModel.swift
//  SurpriseMe User
//
//  Created by Pankaj Mac on 01/09/20.
//  Copyright © 2020 Pankaj Mac. All rights reserved.
//

import Foundation
import SwiftyJSON

class ManageAddressModel: NSObject {
    
    var city: String?
    var country: String?
    var name: String?
    var state: String?
    var street_address: String?
    var zip: Int?
    var id: Int?
    var lat : Double?
    var long : Double?
    
    convenience init(resposne : [String:Any]) {
        self.init()
        let json = JSON(resposne)
        city = json[ManageAddressModelKey.city].stringValue
        country = json[ManageAddressModelKey.country].stringValue
        zip = json[ManageAddressModelKey.zip].intValue
        id = json[ManageAddressModelKey.id].intValue
        street_address = json[ManageAddressModelKey.street_address].stringValue
        state = json[ManageAddressModelKey.state].stringValue
        name = json[ManageAddressModelKey.name].stringValue
        long = json[ManageAddressModelKey.longitude].doubleValue
        lat = json[ManageAddressModelKey.latitude].doubleValue
        
    }
    
    struct ManageAddressModelKey {
        static let city = "city"
        static let country = "country"
        static let latitude = "latitude"
        static let longitude = "longitude"
        static let name = "name"
        static let state = "state"
        static let street_address = "street_address"
        static let zip = "zip"
        static let id = "id"
    }
    
}
