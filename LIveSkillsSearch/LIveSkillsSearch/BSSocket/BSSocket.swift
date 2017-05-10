//
//  BSSocket.swift
//  LIveSkillsSearch
//
//  Created by tianshu wei on 2017/5/11.
//  Copyright © 2017年 idlebook. All rights reserved.
//

import UIKit

protocol BSSocketDelegate : class {
    func socket(_ socket : BSSocket, joinRoom user : UserInfo)
    func socket(_ socket : BSSocket, leaveRoom user : UserInfo)
    func socket(_ socket : BSSocket, chatMsg : ChatMessage)
    func socket(_ socket : BSSocket, giftMsg : GiftMessage)
}


class BSSocket: NSObject {
    weak var delegate : BSSocketDelegate?
    fileprivate var tcpClient : TCPClient
    fileprivate lazy var userInfo: UserInfo.Builder = {
        let userInfo = UserInfo.Builder()
        userInfo.name = "xxy\(arc4random_uniform(10))"
        userInfo.level = 10
        userInfo.iconUrl = "icon\(arc4random_uniform(10))"
        return userInfo
    }()
    
    init(addr: String, port: Int) {
        tcpClient = TCPClient(addr: addr, port: port)
    }
    
    
}

// MARK:- 接受到服务器信息
extension BSSocket{
    // 是否连接
    func connectServer() -> Bool{
        return tcpClient.connect(timeout: 5).0
    }
    
    // 等待服务器读取消息,堵塞式
    func startReadMsg() {
        DispatchQueue.global().async {
            while true {
                // 确保读取头部消息
                guard let lMsg = self.tcpClient.read(4) else {
                    continue
                }
                
                // 1.读取长度的data
                let headData = Data(bytes: lMsg, count: 4)
                var length : Int = 0
                //  解析数据到length
                (headData as NSData).getBytes(&length, length: 4)
                
                // 2.读取类型
                guard let typeMsg = self.tcpClient.read(2) else {
                    return
                }
                let typeData = Data(bytes: typeMsg, count: 2)
                var type : Int = 0
                // 解析数据到type
                (typeData as NSData).getBytes(&type, length: 2)
                print(type)
                
                // 2.根据长度, 读取真实消息
                guard let msg = self.tcpClient.read(length) else {
                    return
                }
                let data = Data(bytes: msg, count: length)
                
                // 3.处理消息,回到主线程
                DispatchQueue.main.async {
                    self.handleMsg(type: type, data: data)

                }
                
            }
        }
    }
    
    fileprivate func handleMsg(type: Int, data: Data){
        switch type {
        // 进入/离开房间
        case 0, 1:
            let userInfo = try! UserInfo.parseFrom(data: data)
            type == 0 ? delegate?.socket(self, joinRoom: userInfo) : delegate?.socket(self, leaveRoom: userInfo)
        // 聊天信息
        case 2:
            let chatMsg = try! ChatMessage.parseFrom(data: data)
            delegate?.socket(self, chatMsg: chatMsg)
        case 3:
            let giftMsg = try! GiftMessage.parseFrom(data: data)
            delegate?.socket(self, giftMsg: giftMsg)
        default:
            print("未知类型........")
        }
    }
}

// MARK:- 对外方法,发送服务器信息
extension BSSocket{
    
    func sendJoinRoom() {
        // 1.获取消息的长度
        let msgData = (try! userInfo.build()).data()
        
        // 2.发送消息
        sendMsg(data: msgData, type: 0)
    }
    
    func sendLeaveRoom() {
        // 1.获取消息的长度
        let msgData = (try! userInfo.build()).data()
        
        // 2.发送消息
        sendMsg(data: msgData, type: 1)
    }
    
    func sendTextMsg(message : String) {
        // 1.创建TextMessage类型
        let chatMsg = ChatMessage.Builder()
        chatMsg.user = try! userInfo.build()
        chatMsg.text = message
        
        // 2.获取对应的data
        let chatData = (try! chatMsg.build()).data()
        
        // 3.发送消息到服务器
        sendMsg(data: chatData, type: 2)
    }
    
    func sendGiftMsg(giftName : String, giftURL : String, giftCount : Int) {
        // 1.创建GiftMessage
        let giftMsg = GiftMessage.Builder()
        giftMsg.user = try! userInfo.build()
        giftMsg.giftname = giftName
        giftMsg.giftUrl = giftURL
        giftMsg.giftcount = Int32(giftCount)
        
        // 2.获取对应的data
        let giftData = (try! giftMsg.build()).data()
        
        // 3.发送礼物消息
        sendMsg(data: giftData, type: 3)
    }
    
    // 发送心跳包
    func sendHeartBeat(){
        // 获取心跳包的数据
        let heartString = "I am is heart beat"
        guard let heartData = heartString.data(using: .utf8) else {return}
        
        // 发送数据
        sendMsg(data: heartData, type: 100)
    }

    func sendMsg(data: Data, type: Int){
        
        // 将消息长度写入Data,此处的length就是内容
        var length = data.count
        let headerData = Data(bytes: &length, count: 4)
        
        // 消息类型
        var tempType = type
        let typeData = Data(bytes: &tempType, count: 2)
        
        // 发送消息
        let totalData = headerData + typeData + data
        tcpClient.send(data: totalData)

        
    }
}
















