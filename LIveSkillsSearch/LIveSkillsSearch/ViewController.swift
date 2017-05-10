//
//  ViewController.swift
//  LIveSkillsSearch
//
//  Created by tianshu wei on 2017/5/10.
//  Copyright © 2017年 idlebook. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    fileprivate lazy var socket : BSSocket = BSSocket(addr: "0.0.0.0", port: 7878)
    
    fileprivate var timer: Timer!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        if socket.connectServer(){
            print("连接成功")
            
            socket.startReadMsg()
            
            timer = Timer(fireAt: Date(), interval: 9, target: self, selector: #selector(sendHeartBeat), userInfo: nil, repeats: true)
            RunLoop.main.add(timer, forMode: .commonModes)
            timer.fire()
        }
    }
    
    
    deinit {
        timer.invalidate()
        timer = nil
    }



}

// MARK:- 控件点击
extension ViewController{
    
    @IBAction func joinRoom() {
        socket.sendJoinRoom()
    }
    
    @IBAction func leaveRoom() {
        socket.sendLeaveRoom()
    }
    
    @IBAction func sendText() {
        socket.sendTextMsg(message: "这是一个文本消息")
    }
    
    @IBAction func sendGift() {
        socket.sendGiftMsg(giftName: "火箭", giftURL: "http://www.baidu.com", giftCount: 1000)
    }

}

extension ViewController {
    @objc fileprivate func sendHeartBeat() {
        socket.sendHeartBeat()
    }
}

