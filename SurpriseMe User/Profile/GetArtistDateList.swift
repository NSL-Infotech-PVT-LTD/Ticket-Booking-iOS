//
//  GetArtistDateList.swift
//  SurpriseMe User
//
//  Created by NetScape Labs on 11/9/20.
//  Copyright © 2020 Pankaj Mac. All rights reserved.
//

import Foundation


import UIKit
import SwiftyJSON
class GetArtistDateList: NSObject {
    
    var date               : String?
    
    convenience init(resposne : [String:Any]) {
        self.init()
        let json = JSON(resposne)
      
        date    = json[userModelKey.date].stringValue
    }
    
    struct userModelKey {
        
        static let date                    = "date"
      
    }
}


