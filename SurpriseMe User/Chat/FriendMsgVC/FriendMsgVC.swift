//
//  FriendMsgVC.swift
//  SurpriseMe_Artist
//
//  Created by Loveleen Kaur Atwal on 27/08/20.
//  Copyright © 2020 Loveleen Kaur. All rights reserved.
//

import UIKit
import IQKeyboardManager
import SDWebImage
import SafariServices


class FriendMsgVC: UIViewController {
    
    //MARK:- Outlets -
    @IBOutlet weak var msgTableView: UITableView!
    @IBOutlet weak var bottomConstant: NSLayoutConstraint!
    @IBOutlet weak var txtMssg: UITextView!
    @IBOutlet weak var picUserReciever: UIImageView!
    @IBOutlet weak var lblRecierverName: UILabel!
    @IBOutlet weak var firstTimeView: UIView!
    @IBOutlet weak var lblMsgChatWith: UILabel!
    @IBOutlet weak var lblDateCurrent: UILabel!
    @IBOutlet weak var reciverImage: UIImageView!
    @IBOutlet weak var myImage: UIImageView!
    @IBOutlet weak var textViewBackView: UIView!
    @IBOutlet weak var topView: UIView!
    
    @IBOutlet weak var img2NoData: UIImageView!
    @IBOutlet weak var img1NoData: UIImageView!
    @IBOutlet weak var noDataLblChat: UILabel!
    @IBOutlet weak var nodataView: UIView!
    
    //MARK:- Variables -
    var chatdetail = SocketConnectionManager.shared.self
    var chatVMObject = ChatHistoryViewModel()
    var chatHistoryData = [ChatHistoryModel]()
    var reciverData  = GetFreindListModel()
    var name = String()
    var userImage = String()
    var comingFrom = String()
    var recieverIDHistoryList = Int()
    var arrayDateString = [String]()
    var freindName = String()
    var freindNameImage = String()
    var current_page = 1
    var dateForHeader = [String]()
    var sendMessageValue = String()
    
    
    @IBOutlet weak var viewImgTappedView: UIView!
    
    
    //MARK:- View's Life Cycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        msgTableView.delegate = self
        msgTableView.dataSource = self
        msgTableView.rowHeight = UITableView.automaticDimension
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        isChatNotification = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        isChatNotification = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        chatdetail.chatDelegate = self
        
        chatHistoryApi(boolValue: false, pageCounting: 1) //Call api here
        chatVMObject.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(FriendMsgVC.handleKeyboardNotification), name: UIResponder.keyboardWillShowNotification, object: nil)
        IQKeyboardManager.shared().isEnabled = false
        IQKeyboardManager.shared().shouldResignOnTouchOutside = false
        IQKeyboardManager.shared().isEnableAutoToolbar = false
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapEdit))
        msgTableView.addGestureRecognizer(tapGesture)
        
        let tapValue = UITapGestureRecognizer(target: self, action: #selector(viewImgTappedViewAction))
        
        //        let tap12 = UITapGestureRecognizer(target: self, action: #selector(viewImgTappedView))
        self.viewImgTappedView.isUserInteractionEnabled = true
        self.viewImgTappedView.addGestureRecognizer(tapValue)
        
        let useriD = UserDefaults.standard.integer(forKey: UserdefaultKeys.userID)
        print("the user id is \(useriD  )")
        SocketConnectionManager.shared.socket.connect()
        
    }
    
    
    func getdate() {
        
        if chatHistoryData.count > 0 {
            for dateIn in 0...chatHistoryData.count - 1 {
                let indexData = chatHistoryData.reversed()[dateIn]
                if let date = chatHistoryData[dateIn].created_at {
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd HH:mm:SS"
                    formatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
                    let dateIDate = formatter.date(from: date)
                    formatter.dateFormat = "YYYY/MM/dd"
                    // again convert your date to string
                    let myStringafd = formatter.string(from: dateIDate ?? Date())
                    dateForHeader.append(myStringafd)
                }
            }
            let filterArrayDate = Set(dateForHeader)
            dateForHeader = filterArrayDate.map({$0})
            print("the filter date is \(dateForHeader)")
        }
    }
    
    
    
    public func htmlStyleAttributeText(text: String) -> NSMutableAttributedString? {
        if let htmlData = text.data(using: .utf8) {
            let options: [NSAttributedString.DocumentReadingOptionKey: Any] = [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html, NSAttributedString.DocumentReadingOptionKey.characterEncoding: String.Encoding.utf8.rawValue]
            let attributedString = try? NSMutableAttributedString(data: htmlData, options: options, documentAttributes: nil)
            return attributedString
        }
        return nil
    }
    
    
    
    @IBAction func btnSeeProfileAction(_ sender: UIButton) {
        
        if comingFrom == "NotificationTabs"{
            userArtistID = recieverIDHistoryList
        }else{
            if reciverData.receiver_id ?? 0 == 0{
                
                var userID = userArtistID
                userArtistID = userID
            }else{
                
                let useriD = UserDefaults.standard.integer(forKey: UserdefaultKeys.userID)
                print("the user id is \(useriD  )")
                
                if useriD == reciverData.sender_id{
                    userArtistID = reciverData.receiver_id ?? 0
                    
                }else{
                    userArtistID = reciverData.sender_id ?? 0
                    
                }
                
                //                let userName = UserDefaults.standard.string(forKey: UserdefaultKeys.userName)
                //                if userName == reciverData.receiver_name ?? ""{
                //                    userArtistID = reciverData.sender_id ?? 0
                //
                //                }else{
                //                    userArtistID = reciverData.receiver_id ?? 0
                //                }
            }
        }
        let storyboard = UIStoryboard(name: "Dashboard", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ViewProfileVC") as! ViewProfileVC
        navigationController?.pushViewController(controller, animated: false)
        
        
    }
    
    
    func changeTimeFormate(date: String)-> String {
        if date == "" || date == nil {
            return ""
        } else {
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:SS"
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
            if let dt = dateFormatter.date(from: date) {
                dateFormatter.locale = Locale.current
                dateFormatter.timeZone = TimeZone.current
                dateFormatter.dateFormat = "HH:mm"
                return dateFormatter.string(from: dt)
            } else {
                return "Unknown date"
            }
        }
    }
    
    
    @IBAction func btnBookAction(_ sender: UIButton) {
        if reciverData.receiver_id ?? 0 == 0{
        }else{
            let useriD = UserDefaults.standard.integer(forKey: UserdefaultKeys.userID)
            print("the user id is \(useriD  )")
            
            if useriD == reciverData.sender_id{
                userArtistID =  reciverData.receiver_id ?? 0
            }else{
                userArtistID =  reciverData.sender_id ?? 0
                
            }
            
            
            //            let userName = UserDefaults.standard.string(forKey: UserdefaultKeys.userName)
//            if userName == reciverData.receiver_name ?? ""{
//                userArtistID =  reciverData.sender_id ?? 0
//            }else{
//                userArtistID =  reciverData.receiver_id ?? 0
//            }
        }
        self.pushWithAnimateDirectly(StoryName: Storyboard.DashBoard, Controller: ViewControllers.ScheduleBookingVC)
    }
    
    
    //Pagination
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        let height = scrollView.frame.size.height
               let contentYoffset = scrollView.contentOffset.y
        let distanceFromBottom = height - contentYoffset
               if distanceFromBottom > height {
                   if nextPageUrlCount.isEmpty == false{
                       current_page = current_page + 1
                        print("currnt page == \(current_page)")
                    chatHistoryApi(boolValue: true, pageCounting: current_page)
                   }
               }
    }
    
    func chatHistoryApi(boolValue: Bool, pageCounting: Int) {
        if comingFrom == "NotificationTabs"{
            let param = ["receiver_id": recieverIDHistoryList , "limit": "20", "page": "\(current_page)"] as [String: Any]
            chatVMObject.getParamForChatHistory(param: param, checkLoader: boolValue, pageCount: pageCounting)
        }else if comingFrom ==  "NotificationTabsTouch"{
            let param = ["receiver_id": userChatIDNoti ?? 0 , "limit": "20", "page": "\(current_page)"] as [String: Any]
            chatVMObject.getParamForChatHistory(param: param, checkLoader: boolValue, pageCount: pageCounting)
        }
        else{
            if reciverData.receiver_id ?? 0 == 0{
                let param = ["receiver_id": userArtistID , "limit": "20", "page": "\(current_page)"] as [String: Any]
                chatVMObject.getParamForChatHistory(param: param, checkLoader: boolValue, pageCount: pageCounting)
                self.lblRecierverName.text = name
                let urlSting : String = "\(Api.imageURLArtist)\(userImage)"
                let urlStringaa = urlSting.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "" //This will fill the spaces with the %20
                print(urlStringaa)
                let urlImage = URL(string: urlStringaa)!
                picUserReciever.sd_imageIndicator = SDWebImageActivityIndicator.gray
                picUserReciever.sd_setImage(with: urlImage, placeholderImage: UIImage(named: "user (1)"))
            }else{
                let userName = UserDefaults.standard.string(forKey: UserdefaultKeys.userName)
                
                let useriD = UserDefaults.standard.integer(forKey: UserdefaultKeys.userID)
                print("the user id is \(useriD  )")
                
                if useriD == reciverData.sender_id{
                    let param = ["receiver_id": reciverData.receiver_id ?? 0 , "limit": "20", "page": "\(current_page)"] as [String: Any]
                    chatVMObject.getParamForChatHistory(param: param, checkLoader: boolValue, pageCount: pageCounting)
                    self.lblRecierverName.text = reciverData.receiver_name ?? ""
                    let urlSting : String = "\(Api.imageURLArtist)\(reciverData.receiver_image ?? "")"
                    let urlStringaa = urlSting.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "" //This will fill the spaces with the %20
                    print(urlStringaa)
                    let urlImage = URL(string: urlStringaa)!
                    picUserReciever.sd_imageIndicator = SDWebImageActivityIndicator.gray
                    picUserReciever.sd_setImage(with: urlImage, placeholderImage: UIImage(named: "user (1)"))
                }else{
                    let param = ["receiver_id": reciverData.sender_id ?? 0 , "limit": "20", "page": "\(current_page)"] as [String: Any]
                    chatVMObject.getParamForChatHistory(param: param, checkLoader: boolValue, pageCount: pageCounting)
                    self.lblRecierverName.text = reciverData.sender_name ?? ""
                    let urlSting : String = "\(Api.imageURLArtist)\(reciverData.sender_image ?? "")"
                    let urlStringaa = urlSting.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "" //This will fill the spaces with the %20
                    print(urlStringaa)
                    let urlImage = URL(string: urlStringaa)!
                    picUserReciever.sd_imageIndicator = SDWebImageActivityIndicator.gray
                    picUserReciever.sd_setImage(with: urlImage, placeholderImage: UIImage(named: "user (1)"))
                }
                
                
//                if userName == reciverData.receiver_name ?? ""{
//                    let param = ["receiver_id": reciverData.sender_id ?? 0 , "limit": "20", "page": "\(current_page)"] as [String: Any]
//                    chatVMObject.getParamForChatHistory(param: param, checkLoader: boolValue, pageCount: pageCounting)
//                    self.lblRecierverName.text = reciverData.sender_name ?? ""
//                    let urlSting : String = "\(Api.imageURLArtist)\(reciverData.sender_image ?? "")"
//                    let urlStringaa = urlSting.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "" //This will fill the spaces with the %20
//                    print(urlStringaa)
//                    let urlImage = URL(string: urlStringaa)!
//                    picUserReciever.sd_imageIndicator = SDWebImageActivityIndicator.gray
//                    picUserReciever.sd_setImage(with: urlImage, placeholderImage: UIImage(named: "user (1)"))
//                }else{
//                    let param = ["receiver_id": reciverData.receiver_id ?? 0 , "limit": "20", "page": "\(current_page)"] as [String: Any]
//                    chatVMObject.getParamForChatHistory(param: param, checkLoader: boolValue, pageCount: pageCounting)
//                    self.lblRecierverName.text = reciverData.receiver_name ?? ""
//                    let urlSting : String = "\(Api.imageURLArtist)\(reciverData.receiver_image ?? "")"
//                    let urlStringaa = urlSting.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "" //This will fill the spaces with the %20
//                    print(urlStringaa)
//                    let urlImage = URL(string: urlStringaa)!
//                    picUserReciever.sd_imageIndicator = SDWebImageActivityIndicator.gray
//                    picUserReciever.sd_setImage(with: urlImage, placeholderImage: UIImage(named: "user (1)"))
//                }
            }
        }
    }
    
    func convertTimeInto24(timeData : String) -> String {
        let dateAsString = timeData
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        let date = dateFormatter.date(from: dateAsString)
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = "h:mm a"
        return dateFormatter.string(from: date ?? Date())
    }
    
    
    func utcToLocal(dateStr: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        if let date = dateFormatter.date(from: dateStr) {
            dateFormatter.timeZone = TimeZone.current
            dateFormatter.dateFormat = "h:mm a"
            
            return dateFormatter.string(from: date)
        }
        return nil
    }
    
    
    @objc func tapEdit(gesture: UITapGestureRecognizer) {
        
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            self.bottomConstant?.constant = 0
            self.view.layoutIfNeeded()
            self.view.endEditing(true)
            
        })
    }
    
    
    @objc func viewImgTappedViewAction(gesture: UITapGestureRecognizer) {
        
        if comingFrom == "NotificationTabs"{
            userArtistID = recieverIDHistoryList
        }else if comingFrom ==  "NotificationTabsTouch"{
            userArtistID = userChatIDNoti as? Int ?? 0
        }
        else{
            if reciverData.receiver_id ?? 0 == 0{
                var userID = userArtistID
                userArtistID = userID
            }else{
//                let userName = UserDefaults.standard.string(forKey: UserdefaultKeys.userName)
//                if userName == reciverData.receiver_name ?? ""{
//                    userArtistID = reciverData.sender_id ?? 0
//
//                }else{
//                    userArtistID = reciverData.receiver_id ?? 0
//                }
//
                let useriD = UserDefaults.standard.integer(forKey: UserdefaultKeys.userID)
                print("the user id is \(useriD  )")
                
                if useriD == reciverData.sender_id{
                    userArtistID = reciverData.receiver_id ?? 0

                }else{
                    userArtistID = reciverData.sender_id ?? 0

                }
             }
        }
        let storyboard = UIStoryboard(name: "Dashboard", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ViewProfileVC") as! ViewProfileVC
        navigationController?.pushViewController(controller, animated: false)
    }
    
    @objc func handleKeyboardNotification(_ notification: Notification) {
                if let userInfo = notification.userInfo {
            let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
            scrollToBottom()
            let isKeyboardShowing = notification.name == UIResponder.keyboardWillShowNotification
            bottomConstant?.constant = isKeyboardShowing ? -keyboardFrame!.height : 0
            UIView.animate(withDuration: 0.5, animations: { () -> Void in
                self.view.layoutIfNeeded()
            })
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        IQKeyboardManager.shared().isEnabled = true
        IQKeyboardManager.shared().shouldResignOnTouchOutside = true
        IQKeyboardManager.shared().isEnableAutoToolbar = true
    }
    
    func changeDateFormate(date: String)-> String {
        if date == "" || date == nil {
            return ""
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let val_Date = dateFormatter.date(from: date)
            dateFormatter.dateFormat = "yyyy-MM-dd"
            if val_Date != nil {
                return dateFormatter.string(from: val_Date!)
            }
            return ""
        }
    }
    
    
      func filterReceivedMessageDataAccordingDate() {
        var filterReceivedMessageData = [ChatHistoryModel]()
        var date = ""
        filterReceivedMessageData.removeAll()
        for val in chatHistoryData {
            let date_Formate = self.changeDateFormate(date: val.created_at ?? "")
            print("the created time is \(val.created_at ?? "")")
            if date == date_Formate {
                val.customValue! = ""
            } else {
                date = date_Formate
                val.customValue = date_Formate
            }
            filterReceivedMessageData.append(val)
        }
        self.chatHistoryData = filterReceivedMessageData
    }
    
    
    func setData(param : [String:Any])  {
        self.lblRecierverName.text = param["name"]  as?  String
        let urlSting : String = "\(Api.imageURLArtist)\(param["image"]  as?  String ?? "")"
        let urlStringaa = urlSting.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "" //This will fill the spaces with the %20
        print(urlStringaa)
        let urlImage = URL(string: urlStringaa)!
        picUserReciever.sd_imageIndicator = SDWebImageActivityIndicator.gray
        picUserReciever.sd_setImage(with: urlImage, placeholderImage: UIImage(named: "user (1)"))
    }
   
    
    func scrollToBottom(){
        if self.chatHistoryData.count > 0{
            DispatchQueue.main.async {
                let indexPath = NSIndexPath.init(row: self.chatHistoryData.count - 1, section: 0)
                self.msgTableView.scrollToRow(at: indexPath as IndexPath, at: .bottom, animated: true)
            }
        }
    }
    
    @IBAction func btnSendmessageAction(_ sender: UIButton) {
        var message = txtMssg.text ?? ""
        sendMessageValue = message
        message = message.trimmingCharacters(in: .whitespacesAndNewlines)
//        message = message.replacingOccurrences(of: "\r", with: "\\r")
        message = message.replacingOccurrences(of: "\r", with: "\\r")
        if message.count == 0 || txtMssg.text == "Type your message"{
            return
        }
        else {
            let localTime = Int64(Date().timeIntervalSince1970*1000)
            let useriD = UserDefaults.standard.integer(forKey: UserdefaultKeys.userID)
            if comingFrom == "NotificationTabs"{
                let data1 = "{\"sender_id\" :\"\(useriD)\",\"attachment\" :\"\("text")\",\"receiver_id\":\"\(recieverIDHistoryList)\",\"message\":\"\(message.replacingOccurrences(of: "\n", with: "\\n"))\",\"type\":\"\("text")\",\"device_type\":\"\("ios")\",\"local_message_id\":\"\(localTime)\", \"thumbnail\": \"\("")\"}"
                let data = Data(data1.utf8)
                if SocketConnectionManager.shared.socket.isConnected {
                    SocketConnectionManager.shared.socket.write(data: data)
                    let dataValue = String(decoding: data, as: UTF8.self)
print("the value is \(dataValue)")
                    txtMssg.text = ""
                }else{
                    SocketConnectionManager.shared.socket.connect()
                }
            }else if  comingFrom == "NotificationTabsTouch"{
                let data1 = "{\"sender_id\" :\"\(useriD)\",\"attachment\" :\"\("text")\",\"receiver_id\":\"\(userChatIDNoti ?? 0)\",\"message\":\"\(message.replacingOccurrences(of: "\n", with: "\\n"))\",\"type\":\"\("text")\",\"device_type\":\"\("ios")\",\"local_message_id\":\"\(localTime)\", \"thumbnail\": \"\("")\"}"
                let data = Data(data1.utf8)
                if SocketConnectionManager.shared.socket.isConnected {
                    SocketConnectionManager.shared.socket.write(data: data)
                    let dataValue = String(decoding: data, as: UTF8.self)
print("the value is \(dataValue)")
                    
                    
                    
                    txtMssg.text = ""
                }else{
                    SocketConnectionManager.shared.socket.connect()
                }
            }
            else{
                if reciverData.receiver_id ?? 0 != 0{
                    
                    
                    let useriD = UserDefaults.standard.integer(forKey: UserdefaultKeys.userID)
                    print("the user id is \(useriD  )")
                    
                    if useriD == reciverData.sender_id{
                        let data1 = "{\"sender_id\" :\"\(useriD)\",\"attachment\" :\"\("text")\",\"receiver_id\":\"\(reciverData.receiver_id ?? 0)\",\"message\":\"\(message.replacingOccurrences(of: "\n", with: "\\n"))\",\"type\":\"\("text")\",\"device_type\":\"\("ios")\",\"local_message_id\":\"\(localTime)\", \"thumbnail\": \"\("")\"}"
                        let data = Data(data1.utf8)
                        if SocketConnectionManager.shared.socket.isConnected {
                            SocketConnectionManager.shared.socket.write(data: data)
                            let dataValue = String(decoding: data, as: UTF8.self)
print("the value is \(dataValue)")
                            txtMssg.text = ""
                        }else{
                            SocketConnectionManager.shared.socket.connect()
                        }
                    }else{
                        let data1 = "{\"sender_id\" :\"\(useriD)\",\"attachment\" :\"\("text")\",\"receiver_id\":\"\(reciverData.sender_id ?? 0)\",\"message\":\"\(message.replacingOccurrences(of: "\n", with: "\\n"))\",\"type\":\"\("text")\",\"device_type\":\"\("ios")\",\"local_message_id\":\"\(localTime)\", \"thumbnail\": \"\("")\"}"
                        let data = Data(data1.utf8)
                        if SocketConnectionManager.shared.socket.isConnected {
                            SocketConnectionManager.shared.socket.write(data: data)
                            let dataValue = String(decoding: data, as: UTF8.self)
print("the value is \(dataValue)")

                            txtMssg.text = ""
                        }else{
                            SocketConnectionManager.shared.socket.connect()
                        }
                    }
                    
                    
//
//                    let userName = UserDefaults.standard.string(forKey: UserdefaultKeys.userName)
//                    if userName == reciverData.receiver_name ?? ""{
//                        let data1 = "{\"sender_id\" :\"\(useriD)\",\"attachment\" :\"\("text")\",\"receiver_id\":\"\(reciverData.sender_id ?? 0)\",\"message\":\"\(message.replacingOccurrences(of: "\n", with: "\\n"))\",\"type\":\"\("text")\",\"device_type\":\"\("ios")\",\"local_message_id\":\"\(localTime)\", \"thumbnail\": \"\("")\"}"
//                        let data = Data(data1.utf8)
//                        if SocketConnectionManager.shared.socket.isConnected {
//                            SocketConnectionManager.shared.socket.write(data: data)
//                            txtMssg.text = ""
//                        }else{
//                            SocketConnectionManager.shared.socket.connect()
//                        }
//                    }else{
//                        let data1 = "{\"sender_id\" :\"\(useriD)\",\"attachment\" :\"\("text")\",\"receiver_id\":\"\(reciverData.receiver_id ?? 0)\",\"message\":\"\(message.replacingOccurrences(of: "\n", with: "\\n"))\",\"type\":\"\("text")\",\"device_type\":\"\("ios")\",\"local_message_id\":\"\(localTime)\", \"thumbnail\": \"\("")\"}"
//                        let data = Data(data1.utf8)
//                        if SocketConnectionManager.shared.socket.isConnected {
//                            SocketConnectionManager.shared.socket.write(data: data)
//                            txtMssg.text = ""
//                        }else{
//                            SocketConnectionManager.shared.socket.connect()
//                        }
//                    }
                }else{
                    let data1 = "{\"sender_id\" :\"\(useriD)\",\"attachment\" :\"\("text")\",\"receiver_id\":\"\(userArtistID)\",\"message\":\"\(message.replacingOccurrences(of: "\n", with: "\\n"))\",\"type\":\"\("text")\",\"device_type\":\"\("ios")\",\"local_message_id\":\"\(localTime)\", \"thumbnail\": \"\("")\"}"
                    let data = Data(data1.utf8)
                    if SocketConnectionManager.shared.socket.isConnected {
                        SocketConnectionManager.shared.socket.write(data: data)
                        txtMssg.text = ""
                    }else{
                        SocketConnectionManager.shared.socket.connect()
                    }
                }
            }
        }
    }
    
    
    
    
    func convertDateIntoTodaysYesterday(somedate : String) -> String {
        print(somedate)
        let todayDate = Date()
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "yyyy-MM-dd"
        let today = dateFormat.string(from: todayDate)
        print("today is \(today)")
        let yesterdayDate = todayDate.addingTimeInterval(-86400.0)
        let yesterday = dateFormat.string(from: yesterdayDate)
        print("yesterday was \(yesterday)")
        let yourDate = somedate
        if yourDate == yesterday {
            print("yesterday")
            return "Yesterday"
        } else if yourDate == today {
            print("today")
            return "Today"
        } else {
            print("the date is \(yourDate)")
            return yourDate
        }
        return ""
    }
    
    
    func localToUTC(dateStr: String) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd h:mm:ss"
        dateFormatter.calendar = Calendar.current
        dateFormatter.timeZone = TimeZone.current
        if let date = dateFormatter.date(from: dateStr) {
            dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
            dateFormatter.dateFormat = "yyyy-MM-dd h:mm:ss"
            return dateFormatter.string(from: date)
        }
        return nil
    }
   
    
    
    @IBAction func btnBackOnPress(_ sender: UIButton) {
        if comingFrom == "NotificationTabsTouch"{
            cameFromChat = true
            let vc = UIStoryboard(name: "Main", bundle: nil)
            let vc1 = vc.instantiateViewController(withIdentifier: "DashboardTabBarController")
            whicShowTypeDigital = false
            let navigationController = UINavigationController(rootViewController: vc1)
            navigationController.isNavigationBarHidden = true
            UIApplication.shared.windows.first?.rootViewController = navigationController
            UIApplication.shared.windows.first?.makeKeyAndVisible()
        }else{
            self.navigationController?.popViewController(animated: true)
        }
    }
    @objc func normalTapReviewver(_ sender: UIGestureRecognizer){
        if sender.state == UIGestureRecognizer.State.ended {
            let tapLocation = sender.location(in: self.msgTableView)
            if let tapIndexPath = self.msgTableView.indexPathForRow(at: tapLocation) {
                let input = chatHistoryData[tapIndexPath.row].message
                let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
                let matches = detector.matches(in: input ?? "", options: [], range: NSRange(location: 0, length: input?.utf16.count ?? 0))
                for match in matches {
                    guard let range = Range(match.range, in: input ?? "") else { continue }
                    let url = input?[range]
                    print(url)
                    var string = url
                    if string?.range(of:"https://") != nil {
                        print("exists")
                        if let url = URL(string: String(url ?? "")) {
                            UIApplication.shared.open(url)
                        }
                    }else{
                        if let url = URL(string: "https://" + String(url ?? "")) {
                            UIApplication.shared.open(url)
                        }
                    }
                }
            }
        }
    }
    
    @objc func normalTap(_ sender: UIGestureRecognizer){
        if sender.state == UIGestureRecognizer.State.ended {
            let tapLocation = sender.location(in: self.msgTableView)
            if let tapIndexPath = self.msgTableView.indexPathForRow(at: tapLocation) {
                print("Normal tap \(tapIndexPath.row)")
                let input = chatHistoryData[tapIndexPath.row].message
                let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
                let matches = detector.matches(in: input ?? "", options: [], range: NSRange(location: 0, length: input?.utf16.count ?? 0))
                for match in matches {
                    guard let range = Range(match.range, in: input ?? "") else { continue }
                    let url = input?[range]
                    print(url)
                    var string = url
                    if string?.range(of:"https://") != nil {
                        print("exists")
                        if let url = URL(string: String(url ?? "")) {
                            UIApplication.shared.open(url)
                        }
                    }else{
                        if let url = URL(string: "https://" + String(url ?? "")) {
                            UIApplication.shared.open(url)
                        }
                    }
                }
            }
        }
    }
}
extension FriendMsgVC : UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatHistoryData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let useriD = UserDefaults.standard.integer(forKey: UserdefaultKeys.userID)
        if chatHistoryData[indexPath.row].sender_id ?? 0 == useriD {
            guard let SendCell = tableView.dequeueReusableCell(withIdentifier: "sendTableViewCell", for: indexPath) as? sendTableViewCell else  {
                return UITableViewCell()
            }
            
            SendCell.selectionStyle = .none
            let myString = chatHistoryData[indexPath.row].message ?? ""
            
            
            //SendCell.lblSendMsg.enabledTypes = [.mention, .hashtag, .url, .email]
            SendCell.lblSendMsg.text = myString
//            SendCell.lblSendMsg.handleHashtagTap { hashtag in
//                print("Success. You just tapped the \(hashtag) hashtag")
//            }
            
//            SendCell.lblSendMsg.text = myString
            let timeStamp = self.convertTimeInto24(timeData: chatHistoryData[indexPath.row].created_at ?? "")
            let date = self.changeDateFormate(date: chatHistoryData[indexPath.row].created_at ?? "")
            
            
            let dateValue = self.convertDateIntoTodaysYesterday(somedate: date)
            print("the date value is \(dateValue)")
            
            SendCell.lblSenderTime.text = dateValue
            print("the created at is \(chatHistoryData[indexPath.row].created_at ?? "")")
            if chatHistoryData[indexPath.row].customValue != "" {
                print("hello")
                SendCell.lblSenderTime.isHidden = false
                SendCell.senderHeight.constant = 30
            } else {
                print("not hello")
                SendCell.lblSenderTime.isHidden = true
                SendCell.senderHeight.constant = 0
            }
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(normalTap))
            SendCell.addGestureRecognizer(tapGesture)
            SendCell.lblTime.text =  timeStamp
            
            
            //MARK: UNDERLINE
//            let input = chatHistoryData[indexPath.row].message ?? ""
//            let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
//            let matches = detector.matches(in: input ?? "", options: [], range: NSRange(location: 0, length: input.utf16.count ?? 0))
//            for match in matches {
//                guard let range = Range(match.range, in: input ?? "") else { continue }
//                let url = input[range]
//                print(url)
//                SendCell.lblSendMsg.underline(text: String(url ?? ""))
//            }
            return SendCell
        
        }else{
            guard let ReceiveCell = tableView.dequeueReusableCell(withIdentifier: "recievedTableViewCell", for: indexPath) as? recievedTableViewCell else {
                return UITableViewCell()
            }
            ReceiveCell.selectionStyle = .none
            ReceiveCell.lblReceiveMsg.text = chatHistoryData[indexPath.row].message
            let timeStamp = self.convertTimeInto24(timeData: chatHistoryData[indexPath.row].created_at ?? "")
            let date = self.changeDateFormate(date: chatHistoryData[indexPath.row].created_at ?? "")
            ReceiveCell.lblReceiverTime.text = date
            if chatHistoryData[indexPath.row].customValue != "" {
                ReceiveCell.lblReceiverTime.isHidden = false
            } else {
                ReceiveCell.lblReceiverTime.isHidden = true
            }
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(normalTapReviewver))
            ReceiveCell.addGestureRecognizer(tapGesture)
            ReceiveCell.lblTime.text =  timeStamp
            let urlSting : String = "\(Api.imageURLArtist)\(chatHistoryData[indexPath.row].sender_image ?? "")"
            let urlStringaa = urlSting.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "" //This will fill the spaces with the %20
            print(urlStringaa)
            let urlImage = URL(string: urlStringaa)!
            ReceiveCell.receiverImg.sd_imageIndicator = SDWebImageActivityIndicator.gray
            ReceiveCell.receiverImg.sd_setImage(with: urlImage, placeholderImage: UIImage(named: "image_placeholder"))
            
            //MARK: UNDERLINE
//            let input = chatHistoryData[indexPath.row].message ?? ""
//            let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue)
//            let matches = detector.matches(in: input ?? "", options: [], range: NSRange(location: 0, length: input.utf16.count ?? 0))
//            for match in matches {
//                guard let range = Range(match.range, in: input ?? "") else { continue }
//                let url = input[range]
//                print(url)
//                ReceiveCell.lblReceiveMsg.underline(text: String(url ?? ""))
//            }
            
            return ReceiveCell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension FriendMsgVC : UITextViewDelegate{
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Type your message"{
            textView.text = ""
        }}
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == ""{
            textView.text = "Type your message"
        } }
}

extension FriendMsgVC: chatDetailForChatVCProtocol {
    func cDetail(receiver_name: String, sender_id: Int, reply_id: Int, id: Int, receiver_image: String, sender_name: String, type: String, message: String, receiver_id: Int, message_id: Int, sender_image: String, is_read: Int, attachment: String, thumbnailImage: String) {
        
        var reciverID = Int()
        var senderID = Int()
        let useriD = UserDefaults.standard.integer(forKey: UserdefaultKeys.userID)
        if comingFrom == "NotificationTabs"{
            let param = ["receiver_id": recieverIDHistoryList ] as [String: Any]
            reciverID = recieverIDHistoryList
        }else if comingFrom == "NotificationTabsTouch"{
            reciverID = Int(userChatIDNoti as! String) ?? 0
        }
        else{
            if reciverData.receiver_id ?? 0 == 0{
                let param = ["receiver_id": userArtistID ] as [String: Any]
                reciverID = userArtistID
            }else{
                let useriD = UserDefaults.standard.integer(forKey: UserdefaultKeys.userID)
                print("the user id is \(useriD  )")
                if useriD == reciverData.sender_id{
                    let param = ["receiver_id": reciverData.receiver_id ?? 0 ] as [String: Any]
                    reciverID = reciverData.receiver_id ?? 0
                }else{
                    let param = ["receiver_id": reciverData.sender_id ?? 0 ] as [String: Any]
                    reciverID = reciverData.sender_id ?? 0
                }
            }
        }
        
        let date = Date()
        let formatter = DateFormatter()

        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"

        let result = formatter.string(from: date)

        
        
        
        
        
        print("the time in utc is \(result)")
        
        
        let dateString = result
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let s = dateFormatter.date(from: dateString)
        print(s)
        let utcTime = self.localToUTC(dateStr: formatter.string(from: s ?? Date()))

        print("the time in utc is \(utcTime)")

        
//        if reciverID == receiver_id && useriD == sender_id || useriD == receiver_id  {
            
            
            if(sender_id == reciverID || receiver_id == reciverID) {
                chatHistoryData.append(ChatHistoryModel.init(response: ["receiver_name": receiver_name, "sender_id": sender_id, "reply_id": reply_id, "id": id, "receiver_image": receiver_image, "sender_name": sender_name, "type": type, "message": message, "receiver_id": receiver_id, "message_id": message_id, "sender_image": sender_image, "is_read": is_read, "attachment": attachment, "thumbnail": thumbnailImage , "created_at" : utcTime]))

            }
            
//            chatHistoryData.append(ChatHistoryModel.init(response: ["receiver_name": receiver_name, "sender_id": sender_id, "reply_id": reply_id, "id": id, "receiver_image": receiver_image, "sender_name": sender_name, "type": type, "message": message, "receiver_id": receiver_id, "message_id": message_id, "sender_image": sender_image, "is_read": is_read, "attachment": attachment, "thumbnail": thumbnailImage , "created_at" : utcTime]))
//        }else{
////            chatHistoryData.append(ChatHistoryModel.init(response: ["receiver_name": receiver_name, "sender_id": sender_id, "reply_id": reply_id, "id": id, "receiver_image": receiver_image, "sender_name": sender_name, "type": type, "message": sendMessageValue, "receiver_id": receiver_id, "message_id": message_id, "sender_image": sender_image, "is_read": is_read, "attachment": attachment, "thumbnail": thumbnailImage , "created_at" : utcTime]))
//        }
            DispatchQueue.main.async {
                
               if self.chatHistoryData.count == 0 {
                    let date = Date()
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "d MMM YYYY hh:mm a"
                    let nameOfMonth = dateFormatter.string(from: date)
                    self.lblDateCurrent.text = nameOfMonth
                    self.firstTimeView.isHidden = false
                    self.msgTableView.isHidden = true
                    self.lblMsgChatWith.text = "Start chat with \(self.lblRecierverName.text ?? "")"
                    self.reciverImage.image = self.picUserReciever.image
                    self.myImage.sd_setImage(with: URL(string: SelfImage), placeholderImage: UIImage(named: "user (1)"))
                }else{
                    self.firstTimeView.isHidden = true
                    self.msgTableView.isHidden = false
                    self.getdate()
                    self.scrollToBottom()
                    self.filterReceivedMessageDataAccordingDate()
                    print("the message is \(self.chatHistoryData.map({$0.created_at}))")
                    print("the message is \(self.chatHistoryData.map({$0.message}))")
                    self.msgTableView.reloadData()
                }
                self.msgTableView.reloadData()

            }
        
    }
}

extension FriendMsgVC : SocketConnectionManagerDelegate {
    func onDataReceive(str: String){
        Helper.showOKAlertWithCompletion(onVC: self, title: "Error", message: "Chat is disable Right now.Please contact admin", btnOkTitle: "Done") {
        }
    }
}

extension FriendMsgVC: chatHistoryViewModelProtocol {
    func chatHistoryApiResponse(message: String, response: [ChatHistoryModel], receiverDetails: [String : Any], isError: Bool) {
        if message == "success" {
            chatHistoryData = response.map({$0}).reversed()
            self.scrollToBottom()
            if chatHistoryData.count == 0 {
                self.firstTimeView.isHidden = false
                let date = Date()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "d MMM YYYY hh:mm a"
                let nameOfMonth = dateFormatter.string(from: date)
                self.lblDateCurrent.text = nameOfMonth
                self.msgTableView.isHidden = true
                lblMsgChatWith.text = "Start chat with \(self.lblRecierverName.text ?? "")"
                reciverImage.image = picUserReciever.image
                self.myImage.sd_setImage(with: URL(string: SelfImage), placeholderImage: UIImage(named: "user (1)"))
            }else{
                self.firstTimeView.isHidden = true
                self.msgTableView.isHidden = false
                
                if current_page == 1 {
                    self.scrollToBottom()
                }
                getdate()
                filterReceivedMessageDataAccordingDate()
                msgTableView.reloadData()
                
            }
            msgTableView.reloadData()
            if comingFrom == "NotificationTabs" || comingFrom == "NotificationTabsTouch"{
                self.setData(param: receiverDetails)
            }
        }
    }
    
    func errorAlert(errorTitle: String, errorMessage: String) {
        showSimpleAlert(Title: errorTitle, message: errorMessage, inClass: self)
    }
    
}

extension UILabel {
    func underline(text: String ) {
        if let textString = self.text {
          let attributedString = NSMutableAttributedString(string: textString)
            attributedString.addAttribute(NSAttributedString.Key.underlineStyle,
                                          value: NSUnderlineStyle.single.rawValue,
                                          range: NSRange(location: 0, length: attributedString.length))
          attributedText = attributedString
        }
    }
}
