//
//  HYGiftContainerView.swift
//  LIveSkillsSearch
//
//  Created by tianshu wei on 2017/5/11.
//  Copyright © 2017年 idlebook. All rights reserved.
//

import UIKit

private let kChannelCount = 2
private let kChannelViewH : CGFloat = 40
private let kChannelMargin : CGFloat = 10


class BSGiftContainerView: UIView {
    // MARK:- 定义属性
    fileprivate lazy var channelViews : [BSGiftChannelView] = [BSGiftChannelView]()
    fileprivate lazy var cacheGiftModels : [BSGiftModel] = [BSGiftModel]()
    
    // MARK: 构造函数
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    // 重写构造函数必须实现
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK:- 设置界面
extension BSGiftContainerView{
    fileprivate func setupUI(){
        let w : CGFloat = frame.width
        let h : CGFloat = kChannelViewH
        let x : CGFloat = 0
        for i in 0..<kChannelCount{
            let y : CGFloat = (h + kChannelMargin) * CGFloat(i)
            let channelView = BSGiftChannelView.loadFromNib()
            channelView.frame = CGRect(x: x, y: y, width: w, height: h)
            channelView.alpha = 0.0
            addSubview(channelView)
            channelViews.append(channelView)
        }
    }
}

// MARK:- 对外方法
extension BSGiftContainerView{
    func showGiftModel(_ giftModel: BSGiftModel){
        // 1.判断正在忙的ChanelView和赠送的新礼物的(username/giftname)
        if let channelView = checkUsingChanelView(giftModel){
            channelView.addOnceToCache()
            return
        }
        
        // 2.判断有没有闲置的ChanelView
        if  let channelView = checkIdleChannelView() {
            channelView.complectionCallback = { channelView in
                // 没有缓存直接retrun 
                guard self.cacheGiftModels.count != 0 else{
                    return
                }
                
                // 取出缓存第一个
                let firstGiftModel = self.cacheGiftModels.first
                self.cacheGiftModels.remove(at: 0)
                
                // 让闲置的channelView执行动画(这个时候视图View肯定是闲置了)
                channelView.giftModel = firstGiftModel
                
                // 边遍历,边删除缓存(需要反向遍历)
                //将数组中剩余有和firstGiftModel相同的模型放入到ChanelView缓存中
                for i in (0..<self.cacheGiftModels.count).reversed(){
                    let giftModel = self.cacheGiftModels[i]
                    if giftModel.isEqual(firstGiftModel){
                        channelView.addOnceToCache()
                        self.cacheGiftModels.remove(at: i)
                    }
                }
                
            }
            channelView.giftModel = giftModel
            return
        }

        // 3.将数据放入缓存中
        cacheGiftModels.append(giftModel)

    }
    
    private func checkUsingChanelView(_ giftModel: BSGiftModel) -> BSGiftChannelView?{
        for channelView in channelViews{
            if giftModel.isEqual(channelView.giftModel) && channelView.state != .endAnimating{
                return channelView
            }
            
        }
        return nil
        
    }
    
    private func checkIdleChannelView() -> BSGiftChannelView? {
        for channelView in channelViews {
            if channelView.state == .idle {
                return channelView
            }
        }
        
        return nil
    }

}


