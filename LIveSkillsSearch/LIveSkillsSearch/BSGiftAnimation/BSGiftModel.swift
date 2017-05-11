//
//  BSGiftModelModel.swift
//  LIveSkillsSearch
//
//  Created by tianshu wei on 2017/5/11.
//  Copyright © 2017年 idlebook. All rights reserved.
//

import UIKit

class BSGiftModel: NSObject {
    
    var senderName : String = ""
    var senderURL : String = ""
    var giftName : String = ""
    var giftURL : String = ""
    // 便利构造方法
    init(senderName : String, senderURL : String, giftName : String, giftURL : String) {
        self.senderName = senderName
        self.senderURL = senderURL
        self.giftName = giftName
        self.giftURL = giftURL
    }
    
    // 判断是否本模型,用于连续判断赠送礼物
    override func isEqual(_ object: Any?) -> Bool {
        guard let object = object as? BSGiftModel else {
            return false
        }
        
        guard object.giftName == giftName && object.senderName == senderName else {
            return false
        }
        
        return true
    }
}
