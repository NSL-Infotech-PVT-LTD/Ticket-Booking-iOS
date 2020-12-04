//
//  SignupModel.swift
//  SurpriseMe User
//
//  Created by Pankaj Mac on 31/08/20.
//  Copyright © 2020 Pankaj Mac. All rights reserved.
//

import Foundation
import SwiftyJSON

class SignupModel: NSObject {
    
    var Otp: Int?
      var Token: String?
      
      convenience init(resposne : [String:Any]) {
          self.init()
          let json = JSON(resposne)
          Otp = json[userModelKey.otp].intValue
          Token = json[userModelKey.token].stringValue
          
      }
      
      struct userModelKey {
          static let otp = "otp"
          static let token = "token"
          
      }
    
}
