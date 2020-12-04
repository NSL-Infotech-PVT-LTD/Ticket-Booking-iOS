//
//  Extension + Date.swift
//  WeKonnect
//
//  Created by Jujhar Singh on 07/09/20.
//  Copyright © 2020 Jujhar Singh. All rights reserved.
//

import Foundation
import UIKit

class dateTimeCommenMethod {
    
    static let sharesDateTime = dateTimeCommenMethod()
    
    func date(dateSet: String) {
        
        
        
      
        
        
//        let formatter = DateFormatter()
//        // initially set the format based on your datepicker date / server String
//        formatter.dateFormat = "yyyy-MM-dd HH:mm:SS"
//        formatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
//
//        //        let myString = formatter.string(from: Date()) // string purpose I add here
//        // convert your string to date
//        let yourDate = formatter.date(from: dateSet)
//        //then again set the date format whhich type of output you need
//        formatter.dateFormat = "dd-MM-yyyy"
//        // again convert your date to string
//        let myStringafd = formatter.string(from: yourDate ?? Date())
//        print(myStringafd)
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:SS"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        if let dt = dateFormatter.date(from: dateSet) {
            dateFormatter.locale = Locale.current
            dateFormatter.timeZone = TimeZone.current
            dateFormatter.dateFormat = "dd-MM-yyyy"
            let date = self.getDate(currentTime: dateFormatter.string(from: dt))
            
            
            print("the date is on freind screen is \(date)")
                    getPastTime(for: date ?? Date())

//            return dateFormatter.string(from: dt)
        } else {
//            return "Unknown date"
        }
 }
    
    
    func getDate(currentTime : String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
        return dateFormatter.date(from: "2015-04-01T11:42:00") // replace Date String
    }
    
    
    func getPastTime(for date : Date) -> String {
        
        var secondsAgo = Int(Date().timeIntervalSince(date))
        if secondsAgo < 0 {
            secondsAgo = secondsAgo * (-1)
        }
        
        let minute = 60
        let hour = 60 * minute
        let day = 24 * hour
        let week = 7 * day
        
        if secondsAgo < minute  {
            if secondsAgo < 15{
                sendReceiveTime = "just now"
                return "just now"
            }
            else{
                sendReceiveTime = "\(secondsAgo) secs ago"
                return "\(secondsAgo) secs ago"
            }
        } else if secondsAgo < hour {
            let min = secondsAgo/minute
            if min == 1{
                sendReceiveTime = "\(min) min ago"
                return "\(min) min ago"
            }else{
                sendReceiveTime = "\(min) mins ago"
                return "\(min) mins ago"
            }
        } else if secondsAgo < day {
            let hr = secondsAgo/hour
            if hr == 1{
                sendReceiveTime = "\(hr) hr ago"
                return "\(hr) hr ago"
            } else {
                sendReceiveTime = "\(hr) hrs ago"
                return "\(hr) hrs ago"
            }
        } else if secondsAgo < week {
            let day = secondsAgo/day
            if day == 1{
                sendReceiveTime = "\(day) day ago"
                return "\(day) day ago"
            }else{
                sendReceiveTime = "\(day) days ago"
                return "\(day) days ago"
            }
        } else {
            let formatter = DateFormatter()
            formatter.dateFormat = "MMM dd, hh:mm a"
            formatter.locale = Locale(identifier: "en_US")
            let strDate: String = formatter.string(from: date)
            sendReceiveTime = strDate
            return strDate
        }
    }
}
