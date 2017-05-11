//
//  GiftAnimationViewController.swift
//  LIveSkillsSearch
//
//  Created by tianshu wei on 2017/5/11.
//  Copyright © 2017年 idlebook. All rights reserved.
//

import UIKit

class GiftAnimationViewController: UIViewController {

    
    fileprivate lazy var giftContainerView : BSGiftContainerView = BSGiftContainerView()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        giftContainerView.frame = CGRect(x: 0, y: 100, width: 250, height: 90)
        giftContainerView.backgroundColor = UIColor.lightGray
        view.addSubview(giftContainerView)
    }

    @IBAction func sentGift(_ sender: Any) {
        print("发送礼物1")
        let gift1 = BSGiftModel(senderName: "coderwBS", senderURL: "icon4", giftName: "火箭", giftURL: "prop_b")
        giftContainerView.showGiftModel(gift1)
    }
    
    
    @IBAction func sentGift2(_ sender: Any) {
        print("发送礼物2")
        let gift2 = BSGiftModel(senderName: "coder", senderURL: "icon2", giftName: "飞机", giftURL: "prop_f")
        giftContainerView.showGiftModel(gift2)

    }

    @IBAction func sentGift3(_ sender: Any) {
        print("发送礼物3")
        let gift3 = BSGiftModel(senderName: "wBS", senderURL: "icon3", giftName: "跑车", giftURL: "prop_g")
        giftContainerView.showGiftModel(gift3)


    }
}
