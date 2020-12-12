//
//  BookingDetailsModel.swift
//  SurpriseMe User
//
//  Created by Pankaj Mac on 06/10/20.
//  Copyright © 2020 Pankaj Mac. All rights reserved.
//




import Foundation
import SwiftyJSON


class BookingDetailsModel: NSObject {
    var name: String?
    var from_time: String?
    var to_time: String?
    var image: String?
    var id: Int?
    var address: String?
    var otp: Int?
    var dateInString: String?
    var type: String?
    var status: String?
    var price: Double?

    var artist_detail  : ArtistBookingDetailsData?
    var rate_detail  : RatedDetailsData?
    var reportReason  : ReportResonsArtist?
    var customer_currency : String?


  convenience init(resposne : [String:Any]) {
        self.init()
        let json = JSON(resposne)
        name = json[GetBookingListModelModelModelKey.name].stringValue
        from_time = json[GetBookingListModelModelModelKey.from_time].stringValue
        to_time = json[GetBookingListModelModelModelKey.to_time].stringValue
        dateInString = json[GetBookingListModelModelModelKey.date].stringValue
        image = json[GetBookingListModelModelModelKey.image].stringValue
        type = json[GetBookingListModelModelModelKey.type].stringValue
        status = json[GetBookingListModelModelModelKey.status].stringValue
    address = json[GetBookingListModelModelModelKey.address].stringValue
    customer_currency = json[GetBookingListModelModelModelKey.customer_currency].stringValue

    
    
    price = json[GetBookingListModelModelModelKey.price].doubleValue

    
        id = json[GetBookingListModelModelModelKey.id].intValue
    otp = json[GetBookingListModelModelModelKey.otp].intValue

    artist_detail = ArtistBookingDetailsData.init(resposne: json["artist_detail"].dictionaryObject ?? [:])
    
    reportReason = ReportResonsArtist.init(resposne: json["params"].dictionaryObject ?? [:])
    
    rate_detail = RatedDetailsData.init(resposne: json["rate_detail"].dictionaryObject ?? [String:Any]())

    }
    
    struct GetBookingListModelModelModelKey {
        static let name = "name"
        static let from_time = "from_time"
        static let to_time = "to_time"
        static let image = "image"
        static let date = "date"
        static let type = "type"
        static let id = "id"
        static let status = "status"
        static let address = "address"
        static let otp = "otp"
        static let price = "price"
        static let customer_currency = "customer_currency"

  }
}


class ReportResonsArtist: NSObject {
    
    var report                      : String?
  
    
    
    convenience init(resposne : [String:Any]) {
        self.init()
        let json = JSON(resposne)
        report                = json[userModelKey.report].stringValue
        
    }
    
    struct userModelKey {
        
        static let report                    = "report"
     
    }
}


class ArtistBookingDetailsData: NSObject {
    
    var ID                      : Int?
    var name                    : String?
    var imageProfile            : String?
    var currency            : String?
    var converted_currency : String?
    var converted_digital_price: Int?
    var converted_live_price: Int?
    
    
    convenience init(resposne : [String:Any]) {
        self.init()
        let json = JSON(resposne)
        ID                  = json[userModelKey.ID].intValue
        name                = json[userModelKey.name].stringValue
        imageProfile        = json[userModelKey.imageProfile].stringValue
        currency = json[userModelKey.currency].stringValue
        converted_digital_price = json[userModelKey.converted_digital_price].intValue
        converted_live_price = json[userModelKey.converted_live_price].intValue
        converted_currency = json[userModelKey.converted_currency].stringValue
    }
    
    struct userModelKey {
        
        static let ID                    = "id"
        static let name                  = "name"
        static let imageProfile          = "image"
        static let currency          = "currency"
        static let converted_digital_price = "converted_digital_price"
        static let converted_live_price = "converted_live_price"
        static let converted_currency = "converted_currency"
        
    }
}

class RatedDetailsData: NSObject {
    
    var rate                      : Int?
    var review                    : String?
    var imageProfile            : String?
    
    
    convenience init(resposne : [String:Any]) {
        self.init()
        let json = JSON(resposne)
        rate                  = json[userModelKey.rate].intValue
        review                = json[userModelKey.review].stringValue
        
    }
    
    struct userModelKey {
        
        static let rate                    = "rate"
        static let review                  = "review"
    }
}
