//
//  SocketConnectionManager.swift
//  NewProject
//
//  Created by Jatinder Arora on 22/10/19.
//  Copyright © 2019 osx. All rights reserved.
//

import Foundation
import Starscream

@objc protocol SocketConnectionManagerDelegate {
    func onDataReceive(str: String)
}

protocol chatDetailForChatVCProtocol {
    func cDetail(receiver_name: String, sender_id: Int, reply_id: Int, id: Int, receiver_image: String, sender_name: String, type: String, message: String, receiver_id: Int, message_id: Int, sender_image: String, is_read: Int, attachment: String, thumbnailImage: String)
}

class SocketConnectionManager : WebSocketDelegate {
    var socket = WebSocket(url: URL(string: "ws://23.20.179.178:8080")!)
    var vc: SocketConnectionManagerDelegate?
    var chatDataHold = ChatModel()
    var chatDelegate: chatDetailForChatVCProtocol?
    
    static let shared = SocketConnectionManager ()
    private init() {
        chatDataHold.delegate = self
        socket.delegate = self
        socket.connect()
    }
        
    func websocketDidConnect(socket: WebSocketClient) {
    }
    
    func websocketDidDisconnect(socket: WebSocketClient, error: Error?) {
        if let e = error as? WSError {
        } else if let e = error {
        } else {
        }
    }
    
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
            }
        }
        return nil
    }
    
    func websocketDidReceiveMessage(socket: WebSocketClient, text: String) {
        
        vc?.onDataReceive(str: text)
        let message_data = convertToDictionary(text: text)
        chatDataHold.delegate?.chatDetail(localMessage: message_data ?? [:])
    }
    
    func websocketDidReceiveData(socket: WebSocketClient, data: Data) {
    }
    
    func sendMessage(str: String) {
        let data = Data(str.utf8)
        socket.write(data: data)
    }
}

extension SocketConnectionManager: chatProtocol {

    func chatDetail(localMessage: [String : Any]) {
        let message = localMessage["message"] as? String ?? ""
        let receiver_name = localMessage["receiver_name"] as? String ?? ""
        let sender_id = localMessage["sender_id"] as? Int ?? 0
        let reply_id = localMessage["reply_id"] as? Int ?? 0
        let id = localMessage["id"] as? Int ?? 0
        let receiver_image = localMessage["receiver_image"] as? String ?? ""
        let sender_name = localMessage["sender_name"] as? String ?? ""
        let type = localMessage["type"] as? String ?? ""
        let receiver_id = localMessage["receiver_id"] as? Int ?? 0
        let message_id = localMessage["message_id"] as? Int ?? 0
        let sender_image = localMessage["sender_image"] as? String ?? ""
        let is_read = localMessage["is_read"] as? Int ?? 0
        let attachment = localMessage["attachment"] as? String ?? ""
        let thumbnail = localMessage["thumbnail"] as? String ?? ""
        chatDelegate?.cDetail(receiver_name: receiver_name, sender_id: sender_id, reply_id: reply_id, id: id, receiver_image: receiver_image, sender_name: sender_name, type: type, message: message, receiver_id: receiver_id, message_id: message_id, sender_image: sender_image, is_read: is_read, attachment: attachment, thumbnailImage: thumbnail)
    }
}



class ChatModel {
    var delegate: chatProtocol?
}

protocol chatProtocol {
    func chatDetail(localMessage: [String: Any])
}
