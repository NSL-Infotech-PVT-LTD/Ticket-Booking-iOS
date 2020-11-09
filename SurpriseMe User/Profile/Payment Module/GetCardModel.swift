//
//  GetCardModel.swift
//  SurpriseMe User
//
//  Created by NetScape Labs on 11/6/20.
//  Copyright © 2020 Pankaj Mac. All rights reserved.
//


import Foundation
import SwiftyJSON

class GetCardModel: NSObject {
    
    var name: String?
    var id: String?

    var last4: String?
    var exp_month: Int?
    var exp_year: Int?

  
    convenience init(resposne : [String:Any]) {
        self.init()
        let json = JSON(resposne)
        last4 = json[GetCardModelKey.last4].stringValue
        name = json[GetCardModelKey.name].stringValue
        id = json[GetCardModelKey.id].stringValue
        exp_month = json[GetCardModelKey.exp_month].intValue
        exp_year = json[GetCardModelKey.exp_year].intValue

     
    }
    
    struct GetCardModelKey {
        static let last4 = "last4"
        static let id = "id"

        
        static let name = "name"
        static let exp_year = "exp_year"
        static let exp_month = "exp_month"

    }
    
}
