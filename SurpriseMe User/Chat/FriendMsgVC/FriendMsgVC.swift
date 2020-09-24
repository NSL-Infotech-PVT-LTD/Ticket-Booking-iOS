////
////  FriendMsgVC.swift
////  SurpriseMe_Artist
////
////  Created by Loveleen Kaur Atwal on 27/08/20.
////  Copyright © 2020 Loveleen Kaur. All rights reserved.
////
//
//import UIKit
//import IQKeyboardManager
//
//
//class FriendMsgVC: UIViewController {
//
//    @IBOutlet weak var msgTableView: UITableView!
//    @IBOutlet weak var bottomConstant: NSLayoutConstraint!
//    @IBOutlet weak var txtMssg: UITextView!
//    
//    var chatdetail = SocketConnectionManager.shared.self
//    
//    var chatVMObject = ChatHistoryViewModel()
//    var chatHistoryData = [ChatHistoryModel]()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        chatVMObject.delegate = self
//
//        //Mark:tableview delegate/datasource
//        msgTableView.delegate = self
//        msgTableView.dataSource = self
//        msgTableView.reloadData()
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        chatdetail.chatDelegate = self
////        chatdetail.chatDelegateSocket = self
//
//        
//
//        NotificationCenter.default.addObserver(self, selector: #selector(FriendMsgVC.handleKeyboardNotification), name: UIResponder.keyboardWillShowNotification, object: nil)
//        IQKeyboardManager.shared().isEnabled = false
//        IQKeyboardManager.shared().shouldResignOnTouchOutside = false
//        IQKeyboardManager.shared().isEnableAutoToolbar = false
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapEdit))
//               msgTableView.addGestureRecognizer(tapGesture)
//    }
//    
//    @objc func tapEdit(gesture: UITapGestureRecognizer) {
//           
//           UIView.animate(withDuration: 0.5, animations: { () -> Void in
//               self.bottomConstant?.constant = 0
//               self.view.layoutIfNeeded()
//           })
//       }
//    
//    @objc func handleKeyboardNotification(_ notification: Notification) {
//        
//        if let userInfo = notification.userInfo {
//            
//            let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
//            
//            let isKeyboardShowing = notification.name == UIResponder.keyboardWillShowNotification
//            bottomConstant?.constant = isKeyboardShowing ? -keyboardFrame!.height : 0
//            UIView.animate(withDuration: 0.5, animations: { () -> Void in
//                //                scroll down tableview
////                if self.messageArr.count > 0 {
////                    self.chatTableView.scrollToBottom()
////                    self.chatTableView.reloadData()
////                }
//                self.view.layoutIfNeeded()
//            })
//        }
//    }
//    
//    override func viewDidDisappear(_ animated: Bool) {
//        IQKeyboardManager.shared().isEnabled = true
//        IQKeyboardManager.shared().shouldResignOnTouchOutside = true
//        IQKeyboardManager.shared().isEnableAutoToolbar = true
//    }
//    
//    
//    
//    @IBAction func btnSendmessageAction(_ sender: UIButton) {
//        
//       var message = txtMssg.text ?? ""
//        message = message.trimmingCharacters(in: .whitespacesAndNewlines)
//        
//        //          message_type = "text"
//        if message.count == 0 || txtMssg.text == "Text Message..."{
//            txtMssg.text = ""
//            // toast with a specific duration and position
//            self.showSimpleAlert(Title: "Alert", message: "Enter Message", inClass: self)
//            
//            return
//        }
//        else {
//            
//            let localTime = Int64(Date().timeIntervalSince1970*1000)
//            let data1 = "{\"sender_id\" :\"\("65")\",\"attachment\" :\"\("text")\",\"receiver_id\":\"\("63")\",\"message\":\"\(message.replacingOccurrences(of: "\n", with: "\\n"))\",\"type\":\"\("text")\",\"device_type\":\"\("ios")\",\"local_message_id\":\"\(localTime)\", \"thumbnail\": \"\("")\"}"
//            let data = Data(data1.utf8)
//            if SocketConnectionManager.shared.socket.isConnected {
//                SocketConnectionManager.shared.socket.write(data: data)
//                txtMssg.text = ""
//                
//            }else{
//                SocketConnectionManager.shared.socket.connect()
//            }
//            msgTableView.reloadData()
//        }
//    }
//    
//    
////    //Send Message counting on button
////    func messageSendCounting(senderTag: Int) {
////
////        var  message = txtMssg.text ?? ""
////        message = message.trimmingCharacters(in: .whitespacesAndNewlines)
////        //          message_type = "text"
////        if message.count == 0 || txtMssg.text == "Text Message..."{
////            txtMssg.text = ""
////            // toast with a specific duration and position
////
////            return
////        }
////
////        else {
////
////            self.sendMessageMethod()
////        }
////    }
//    
//    //Send Message
////    func sendMessageMethod(){
////        let localTime = Int64(Date().timeIntervalSince1970*1000)
////        let data1 = "{\"sender_id\" :\"\("65")\",\"attachment\" :\"\("text")\",\"receiver_id\":\"\("63")\",\"message\":\"\("hello")\",\"type\":\"\("attchmentOrText")\",\"device_type\":\"\("ios")\",\"local_message_id\":\"\(localTime)\", \"thumbnail\": \"\("uploadMediaVMObject.sendMedia.thumbnail ??")\"}"
////        let data = Data(data1.utf8)
////            SocketConnectionManager.shared.socket.write(data: data)
////            txtMssg.text = ""
////    }
//    
//   
//    
//    @IBAction func btnBAckOnPress(_ sender: UIButton) {
//        self.navigationController?.popViewController(animated: true)
//    }
//}
//extension FriendMsgVC : UITableViewDelegate,UITableViewDataSource {
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 2
//    }
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return chatHistoryData.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        
//        
//        if "\(chatHistoryData[indexPath.row].sender_id ?? 0)" == "65" {
//            guard let SendCell = tableView.dequeueReusableCell(withIdentifier: "sendTableViewCell", for: indexPath) as? sendTableViewCell else  {
//                return UITableViewCell()
//            }
//            SendCell.selectionStyle = .none
//            SendCell.lblSendMsg.text = chatHistoryData[indexPath.row].message
//            SendCell.sendView.roundCorners(corners: [.topLeft, .topRight, .bottomLeft], radius: 20)//Common function call
//            return SendCell
//        }
//        else /*if reciverID == messageArr[indexPath.row].receiver_id*/ {
//            
//            guard let ReceiveCell = tableView.dequeueReusableCell(withIdentifier: "recievedTableViewCell", for: indexPath) as? recievedTableViewCell else {
//                return UITableViewCell()
//            }
//            ReceiveCell.selectionStyle = .none
//            ReceiveCell.lblReceiveMsg.text = chatHistoryData[indexPath.row].message
//            ReceiveCell.receiveView.roundCorners(corners: [.topLeft, .topRight, .bottomLeft], radius: 20)//Common function call
//            return ReceiveCell
//        }
//    }
//}
//
//
//extension FriendMsgVC : UITextViewDelegate{
//    
//    func textViewDidBeginEditing(_ textView: UITextView) {
//        if textView.text == "Type your message"{
//            textView.text = ""
//        }
//        
//    }
//
//    func textViewDidEndEditing(_ textView: UITextView) {
//        if textView.text == ""{
//            textView.text = "Type your message"
//        }
//    }
//    
//}
//
//
//extension FriendMsgVC: chatDetailForChatVCProtocol {
//    
//    func cDetail(receiver_name: String, sender_id: Int, reply_id: Int, id: Int, receiver_image: String, sender_name: String, type: String, message: String, receiver_id: Int, message_id: Int, sender_image: String, is_read: Int, attachment: String, thumbnailImage: String) {
//        
//        print("get listner value")
//        
////                ReceiveApi(receiverID: "\(reciverID)")
//        
////        if reciverID == receiver_id && senderID == "\(sender_id)"{
//            chatHistoryData.append(ChatHistoryModel.init(response: ["receiver_name": receiver_name, "sender_id": sender_id, "reply_id": reply_id, "id": id, "receiver_image": receiver_image, "sender_name": sender_name, "type": type, "message": message, "receiver_id": receiver_id, "message_id": message_id, "sender_image": sender_image, "is_read": is_read, "attachment": attachment, "thumbnail": thumbnailImage]))
//        
//        self.msgTableView.reloadData()
////        }
////
////        else if reciverID == sender_id && senderID == "\(receiver_id)"{
////            messageArr.append(ChatHistoryModel.init(response: ["receiver_name": receiver_name, "sender_id": sender_id, "reply_id": reply_id, "id": id, "receiver_image": receiver_image, "sender_name": sender_name, "type": type, "message": message, "receiver_id": receiver_id, "message_id": message_id, "sender_image": sender_image, "is_read": is_read, "attachment": attachment, "thumbnail": thumbnailImage]))
////            if userRoleG == "seeker" {
////                //subtract from remaining koin
////                kkoin -= perMessageFee
////                lblRemainingKoin.text = "\(kkoin)"
////                print(lblRemainingKoin.text)
////
////            }
////            else {
////                //            msgAddition = 1
////                lblSentMsgs.text = "\(receiveMessage + msgAddition)"
////                msgAddition += 1
////                print(lblSentMsgs.text)
////            }
////        }
////        let myId = UserDefaults.standard.string(forKey: UserdefaultKeys.userID)
////        if "\(sender_id)" == myId {
////            self.mesgCountingArr.append(self.msgCountForArr)
////            self.msgCountForArr += 1
////        }
////        else {
////            self.mesgCountingArr.append(0)
////        }
////
////        DispatchQueue.main.async {
////            //scroll down tableview
////            if self.messageArr.count > 0 {
////                self.chatTableView.scrollToBottom()
////                self.chatTableView.reloadData()
////            }
////        }
//    }
//}
//
//extension FriendMsgVC : SocketConnectionManagerDelegate {
//    func onDataReceive(str: String){
//        print("kjndfjfnj")
//    }
//}
//
//
//extension FriendMsgVC: chatHistoryViewModelProtocol {
//    func chatHistoryApiResponse(message: String, response: [ChatHistoryModel], isError: Bool) {
//        
//        if message == "success" {
//            chatHistoryData = response
//        }
//    }
//    
//    func errorAlert(errorTitle: String, errorMessage: String) {
//        showSimpleAlert(Title: errorTitle, message: errorMessage, inClass: self)
//    }
//    
//}
