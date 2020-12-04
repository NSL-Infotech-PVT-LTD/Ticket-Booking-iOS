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


class FriendMsgVC: UIViewController {
    
    //MARK:- Outlets -
    @IBOutlet weak var msgTableView: UITableView!
    @IBOutlet weak var bottomConstant: NSLayoutConstraint!
    @IBOutlet weak var txtMssg: UITextView!
    @IBOutlet weak var picUserReciever: UIImageView!
    @IBOutlet weak var lblRecierverName: UILabel!
    
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
    
    
    //MARK:- View's Life Cycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        msgTableView.delegate = self
        msgTableView.dataSource = self
        msgTableView.rowHeight = UITableView.automaticDimension
    }
    
    override func viewWillAppear(_ animated: Bool) {
        chatdetail.chatDelegate = self
        chatHistoryApi() //Call api here
        chatVMObject.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(FriendMsgVC.handleKeyboardNotification), name: UIResponder.keyboardWillShowNotification, object: nil)
        IQKeyboardManager.shared().isEnabled = false
        IQKeyboardManager.shared().shouldResignOnTouchOutside = false
        IQKeyboardManager.shared().isEnableAutoToolbar = false
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapEdit))
        msgTableView.addGestureRecognizer(tapGesture)
        
        let useriD = UserDefaults.standard.integer(forKey: UserdefaultKeys.userID)
        print("the user id is \(useriD  )")
        
    }
    
    
    @IBAction func btnSeeProfileAction(_ sender: UIButton) {
        
      
        
        if comingFrom == "NotificationTabs"{
            
         
            
            userArtistID = recieverIDHistoryList
            
        }else{
            
            if reciverData.receiver_id ?? 0 == 0{
                
                userArtistID = userArtistID
                
              
            }else{
                
                let userName = UserDefaults.standard.string(forKey: UserdefaultKeys.userName)
                
                
                if userName == reciverData.receiver_name ?? ""{
                    let param = ["receiver_id": reciverData.sender_id ?? 0 ] as [String: Any]
                    chatVMObject.getParamForChatHistory(param: param)
                    self.lblRecierverName.text = reciverData.sender_name ?? ""
                    let urlSting : String = "\(Api.imageURLArtist)\(reciverData.sender_image ?? "")"
                    let urlStringaa = urlSting.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "" //This will fill the spaces with the %20
                    print(urlStringaa)
                    let urlImage = URL(string: urlStringaa)!
                    picUserReciever.sd_imageIndicator = SDWebImageActivityIndicator.gray
                    picUserReciever.sd_setImage(with: urlImage, placeholderImage: UIImage(named: "user (1)"))
                }else{
                    let param = ["receiver_id": reciverData.receiver_id ?? 0 ] as [String: Any]
                    chatVMObject.getParamForChatHistory(param: param)
                    self.lblRecierverName.text = reciverData.receiver_name ?? ""
                    let urlSting : String = "\(Api.imageURLArtist)\(reciverData.receiver_image ?? "")"
                    let urlStringaa = urlSting.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "" //This will fill the spaces with the %20
                    print(urlStringaa)
                    let urlImage = URL(string: urlStringaa)!
                    picUserReciever.sd_imageIndicator = SDWebImageActivityIndicator.gray
                    picUserReciever.sd_setImage(with: urlImage, placeholderImage: UIImage(named: "user (1)"))
                }
        
        
        
        
        
        
            
            
        let storyboard = UIStoryboard(name: "Dashboard", bundle: nil)
        let controller = storyboard.instantiateViewController(withIdentifier: "ManualAddressVC") as! ManualAddressVC
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
            
            let userName = UserDefaults.standard.string(forKey: UserdefaultKeys.userName)
            if userName == reciverData.receiver_name ?? ""{
                userArtistID =  reciverData.sender_id ?? 0
            }else{
                
                userArtistID =  reciverData.receiver_id ?? 0
                
            }
            
            
            
        }
        
        
        
        
        
        self.pushWithAnimateDirectly(StoryName: Storyboard.DashBoard, Controller: ViewControllers.ScheduleBookingVC)
        
    }
    
    func chatHistoryApi() {
        
        
        
        if comingFrom == "NotificationTabs"{
            
            let param = ["receiver_id": recieverIDHistoryList ] as [String: Any]
            chatVMObject.getParamForChatHistory(param: param)
            
        }else{
            
            if reciverData.receiver_id ?? 0 == 0{
                let param = ["receiver_id": userArtistID ] as [String: Any]
                chatVMObject.getParamForChatHistory(param: param)
                self.lblRecierverName.text = name
                let urlSting : String = "\(Api.imageURLArtist)\(userImage)"
                let urlStringaa = urlSting.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "" //This will fill the spaces with the %20
                print(urlStringaa)
                let urlImage = URL(string: urlStringaa)!
                picUserReciever.sd_imageIndicator = SDWebImageActivityIndicator.gray
                picUserReciever.sd_setImage(with: urlImage, placeholderImage: UIImage(named: "user (1)"))
            }else{
                
                let userName = UserDefaults.standard.string(forKey: UserdefaultKeys.userName)
                
                
                if userName == reciverData.receiver_name ?? ""{
                    let param = ["receiver_id": reciverData.sender_id ?? 0 ] as [String: Any]
                    chatVMObject.getParamForChatHistory(param: param)
                    self.lblRecierverName.text = reciverData.sender_name ?? ""
                    let urlSting : String = "\(Api.imageURLArtist)\(reciverData.sender_image ?? "")"
                    let urlStringaa = urlSting.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "" //This will fill the spaces with the %20
                    print(urlStringaa)
                    let urlImage = URL(string: urlStringaa)!
                    picUserReciever.sd_imageIndicator = SDWebImageActivityIndicator.gray
                    picUserReciever.sd_setImage(with: urlImage, placeholderImage: UIImage(named: "user (1)"))
                }else{
                    let param = ["receiver_id": reciverData.receiver_id ?? 0 ] as [String: Any]
                    chatVMObject.getParamForChatHistory(param: param)
                    self.lblRecierverName.text = reciverData.receiver_name ?? ""
                    let urlSting : String = "\(Api.imageURLArtist)\(reciverData.receiver_image ?? "")"
                    let urlStringaa = urlSting.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "" //This will fill the spaces with the %20
                    print(urlStringaa)
                    let urlImage = URL(string: urlStringaa)!
                    picUserReciever.sd_imageIndicator = SDWebImageActivityIndicator.gray
                    picUserReciever.sd_setImage(with: urlImage, placeholderImage: UIImage(named: "user (1)"))
                }
                
                
                
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
        
        
        //           let date = dateFormatter.date(from: dateAsString)
        //           dateFormatter.dateFormat = "h:mm a"
        //           let Date12 = dateFormatter.string(from: date ?? Date())
        //           print("12 hour formatted Date:",Date12)
        //           return Date12
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
    
    
    func setData(param : [String:Any])  {
        self.lblRecierverName.text = param["name"]  as?  String
        let urlSting : String = "\(Api.imageURLArtist)\(param["image"]  as?  String ?? "")"
        let urlStringaa = urlSting.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "" //This will fill the spaces with the %20
        print(urlStringaa)
        let urlImage = URL(string: urlStringaa)!
        picUserReciever.sd_imageIndicator = SDWebImageActivityIndicator.gray
        picUserReciever.sd_setImage(with: urlImage, placeholderImage: UIImage(named: "user (1)"))
    }
    
    
    //Pagination
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if ((msgTableView.contentOffset.y + msgTableView.frame.size.height) >= msgTableView.contentSize.height)
        {
            print("scrollViewDidEndDragging")
            print("scrollViewDidEndDragging page number is ")

        }
        
//        if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height)
//               {
//
//                print("hello i am abhishek")
//               }
//
        
        
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
        message = message.trimmingCharacters(in: .whitespacesAndNewlines)
        
        //          message_type = "text"
        if message.count == 0 || txtMssg.text == "Type your message"{
            //  txtMssg.text = ""
            // toast with a specific duration and position
            //            self.showSimpleAlert(Title: "Alert", message: "Enter Message", inClass: self)
            
            return
        }
        else {
            
            
            //            if SocketConnectionManager.shared.socket.isConnected {
            let localTime = Int64(Date().timeIntervalSince1970*1000)
            
            let useriD = UserDefaults.standard.integer(forKey: UserdefaultKeys.userID)
            
            if comingFrom == "NotificationTabs"{
                
                let data1 = "{\"sender_id\" :\"\(useriD)\",\"attachment\" :\"\("text")\",\"receiver_id\":\"\(recieverIDHistoryList)\",\"message\":\"\(message.replacingOccurrences(of: "\n", with: "\\n"))\",\"type\":\"\("text")\",\"device_type\":\"\("ios")\",\"local_message_id\":\"\(localTime)\", \"thumbnail\": \"\("")\"}"
                let data = Data(data1.utf8)
                if SocketConnectionManager.shared.socket.isConnected {
                    SocketConnectionManager.shared.socket.write(data: data)
                    txtMssg.text = ""
                    
                }else{
                    SocketConnectionManager.shared.socket.connect()
                }
                
            }else{
                if reciverData.receiver_id ?? 0 != 0{
                    
                    
                    let userName = UserDefaults.standard.string(forKey: UserdefaultKeys.userName)
                    
                    
                    if userName == reciverData.receiver_name ?? ""{
                        
                        let data1 = "{\"sender_id\" :\"\(useriD)\",\"attachment\" :\"\("text")\",\"receiver_id\":\"\(reciverData.sender_id ?? 0)\",\"message\":\"\(message.replacingOccurrences(of: "\n", with: "\\n"))\",\"type\":\"\("text")\",\"device_type\":\"\("ios")\",\"local_message_id\":\"\(localTime)\", \"thumbnail\": \"\("")\"}"
                        let data = Data(data1.utf8)
                        if SocketConnectionManager.shared.socket.isConnected {
                            SocketConnectionManager.shared.socket.write(data: data)
                            txtMssg.text = ""
                            
                        }else{
                            SocketConnectionManager.shared.socket.connect()
                        }
                        
                        
                    }else{
                        let data1 = "{\"sender_id\" :\"\(useriD)\",\"attachment\" :\"\("text")\",\"receiver_id\":\"\(reciverData.receiver_id ?? 0)\",\"message\":\"\(message.replacingOccurrences(of: "\n", with: "\\n"))\",\"type\":\"\("text")\",\"device_type\":\"\("ios")\",\"local_message_id\":\"\(localTime)\", \"thumbnail\": \"\("")\"}"
                        let data = Data(data1.utf8)
                        if SocketConnectionManager.shared.socket.isConnected {
                            SocketConnectionManager.shared.socket.write(data: data)
                            txtMssg.text = ""
                            
                        }else{
                            SocketConnectionManager.shared.socket.connect()
                        }
                        
                    }
                    
                    
                    
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
            
            
            
            
            
            //            }else{
            ////                SocketConnectionManager.shared.socket.connect()
            //                Helper.showOKAlertWithCompletion(onVC: self, title: "Error", message: "Chat is disable Right now.Please contact admin", btnOkTitle: "Done") {
            //                      }
            //                self.txtMssg.becomeFirstResponder()
            //            }
            
            
            
            
            
            
        }
    }
    
    
    @IBAction func btnBAckOnPress(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
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
            SendCell.lblSendMsg.text = chatHistoryData[indexPath.row].message
            let timeStamp1 = self.convertTimeInto24(timeData: chatHistoryData[indexPath.row].created_at ?? "")
            
            let timeStamp = self.changeTimeFormate(date: chatHistoryData[indexPath.row].created_at ?? "")
            SendCell.lblTime.text =  timeStamp1
            //            SendCell.sendView.roundCorners(corners: [.topLeft, .topRight, .bottomLeft], radius: 20)//Common function call
            return SendCell
        }
        else /*if reciverID == messageArr[indexPath.row].receiver_id*/ {
            
            guard let ReceiveCell = tableView.dequeueReusableCell(withIdentifier: "recievedTableViewCell", for: indexPath) as? recievedTableViewCell else {
                return UITableViewCell()
            }
            ReceiveCell.selectionStyle = .none
            ReceiveCell.lblReceiveMsg.text = chatHistoryData[indexPath.row].message
            
            
            
            let timeStamp = self.convertTimeInto24(timeData: chatHistoryData[indexPath.row].created_at ?? "")
            ReceiveCell.lblReciveTime.text =  timeStamp
            
            
            if reciverData.receiver_id ?? 0 == 0{
                
                let urlSting : String = "\(Api.imageURLArtist)\(userImage)"
                let urlStringaa = urlSting.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "" //This will fill the spaces with the %20
                print(urlStringaa)
                let urlImage = URL(string: urlStringaa)!
                ReceiveCell.receiverImg.sd_imageIndicator = SDWebImageActivityIndicator.gray
                ReceiveCell.receiverImg.sd_setImage(with: urlImage, placeholderImage: UIImage(named: "user (1)"))
            }else{
                
                let userName = UserDefaults.standard.string(forKey: UserdefaultKeys.userName)
                
                
                if userName == reciverData.receiver_name ?? ""{
                    
                    let urlSting : String = "\(Api.imageURLArtist)\(reciverData.sender_image ?? "")"
                    let urlStringaa = urlSting.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "" //This will fill the spaces with the %20
                    print(urlStringaa)
                    let urlImage = URL(string: urlStringaa)!
                    ReceiveCell.receiverImg.sd_imageIndicator = SDWebImageActivityIndicator.gray
                    ReceiveCell.receiverImg.sd_setImage(with: urlImage, placeholderImage: UIImage(named: "user (1)"))
                }else{
                    
                    let urlSting : String = "\(Api.imageURLArtist)\(reciverData.receiver_image ?? "")"
                    let urlStringaa = urlSting.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "" //This will fill the spaces with the %20
                    print(urlStringaa)
                    let urlImage = URL(string: urlStringaa)!
                    ReceiveCell.receiverImg.sd_imageIndicator = SDWebImageActivityIndicator.gray
                    ReceiveCell.receiverImg.sd_setImage(with: urlImage, placeholderImage: UIImage(named: "user (1)"))
                }
                
                
                
                //            let urlSting : String = "\(Api.imageURLArtist)\(chatHistoryData[indexPath.row].receiver_image ?? "")"
                //                           let urlStringaa = urlSting.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "" //This will fill the spaces with the %20
                //                                              print("the url image of is \(urlSting)")
                //                                              let urlImage = URL(string: urlStringaa)!
                //                                                ReceiveCell.receiverImg.sd_imageIndicator = SDWebImageActivityIndicator.gray
                //            ReceiveCell.receiverImg.sd_setImage(with: urlImage, placeholderImage: UIImage(named: "user (1)"))
                
                
                
                //            ReceiveCell.receiveView.roundCorners(corners: [.topLeft, .topRight, .bottomLeft], radius: 20)//Common function call
            }
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
        
        chatHistoryData.append(ChatHistoryModel.init(response: ["receiver_name": receiver_name, "sender_id": sender_id, "reply_id": reply_id, "id": id, "receiver_image": receiver_image, "sender_name": sender_name, "type": type, "message": message, "receiver_id": receiver_id, "message_id": message_id, "sender_image": sender_image, "is_read": is_read, "attachment": attachment, "thumbnail": thumbnailImage]))
        DispatchQueue.main.async {
            //scroll down tableview
            if self.chatHistoryData.count > 0 {
                self.scrollToBottom()
                self.msgTableView.reloadData()
            } } }
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
            msgTableView.reloadData()
            if comingFrom == "NotificationTabs"{
                self.setData(param: receiverDetails)
            }
        }
        
    }
    
    
    func errorAlert(errorTitle: String, errorMessage: String) {
        showSimpleAlert(Title: errorTitle, message: errorMessage, inClass: self)
    }
    
}
