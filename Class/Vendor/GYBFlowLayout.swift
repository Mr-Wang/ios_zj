//
//  GYBFlowLayout.swift
//  Health368
//
//  Created by 古玉彬 on 17/4/13.
//  Copyright © 2017年 ms. All rights reserved.
//

import UIKit

@objc public protocol GYBFlowLayoutDelegate: NSObjectProtocol {
    
    
    /// 返回文本
    ///
    /// - Parameters:
    ///   - delegate: <#delegate description#>
    ///   - row: <#row description#>
    /// - Returns: <#return value description#>
   @objc func textFromRow(GYBFlowLayout: GYBFlowLayout, row: Int) -> String
    /// 布局结束
    ///
    /// - Parameter maxY: 最大y坐标
    
    @objc  optional func layoutFinishWithMaxY(flowLayout:GYBFlowLayout, maxY: CGFloat)
}

public class GYBFlowLayout: UICollectionViewLayout {

    
    //存放所有元素的数组
    var attributesElements = [UICollectionViewLayoutAttributes]()
    var screen_hi = UIScreen.main.bounds.height
    @objc(eftMargin)
    var eftMargin:CGFloat = 15
    @objc(itemHeight)
    var itemHeight:CGFloat = 17
    let topMargin:CGFloat = 5
    var maxY:CGFloat = 0
    var lastAttribute: UICollectionViewLayoutAttributes?
    var maxWidth:CGFloat = 0
    var screen_width = UIScreen.main.bounds.width
    @objc(liftdistance)
    var liftdistance:CGFloat = 14
    @objc(rightdistance)
    var rightdistance:CGFloat = 14

    
    lazy var keyLabel: UILabel = {
        let _keyLabel = UILabel.init()
        _keyLabel.font = UIFont.systemFont(ofSize: self.eftMargin)
        return _keyLabel
    }()
    
    
    public weak var delegate: GYBFlowLayoutDelegate?
    
    @objc(initWithDelegate:)
     init(delegate: GYBFlowLayoutDelegate) {
        self.delegate = delegate
        super.init()
        maxWidth = screen_width - self.eftMargin * 2
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func prepare() {
        
        super.prepare()
        maxY = 0
        lastAttribute = nil
        
        self.attributesElements.removeAll()
        
        let elementCount = self.collectionView?.numberOfItems(inSection: 0)
        
        if elementCount == 0 {
            if (self.delegate?.responds(to: #selector(GYBFlowLayoutDelegate.layoutFinishWithMaxY(flowLayout:maxY:))))! {
                self.delegate?.layoutFinishWithMaxY!(flowLayout: self, maxY: 0)
            }
            return;
        }
        
        for index in 0 ..< elementCount! {
            
            let indexPath = IndexPath.init(row: index, section: 0)
            self.attributesElements.append(self.layoutAttributesForItem(at: indexPath)!)
            if (index == elementCount! - 1) {
                if (self.delegate?.responds(to: #selector(GYBFlowLayoutDelegate.layoutFinishWithMaxY(flowLayout:maxY:))))! {
                    self.delegate?.layoutFinishWithMaxY!(flowLayout:self,maxY: maxY)
                }
            }
        }
        
    }
    
    override public var collectionViewContentSize: CGSize {
        
        get {
            return CGSize.init(width: screen_width, height: self.maxY)
        }
    }
    
    override public func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        
        let attribututes = UICollectionViewLayoutAttributes.init(forCellWith: indexPath)
        let itemWidth = self.itemWidthByText(text: (self.delegate?.textFromRow(GYBFlowLayout: self, row: attribututes.indexPath.row))!)
        var itemX:CGFloat = eftMargin
        var itemY:CGFloat = 0
        
        if lastAttribute != nil {
            
            let lastAttr = lastAttribute!.frame
            let currentX = eftMargin + itemWidth + lastAttr.maxX
            if currentX > maxWidth {
                itemX = eftMargin
                itemY = lastAttr.maxY + topMargin
            } else {
                itemX = eftMargin + lastAttr.maxX
                itemY = lastAttr.origin.y
            }
        }
        
//        itemHeight = screen_hi/19.06
            
        attribututes.frame = CGRect.init(x: itemX, y: itemY, width: itemWidth, height: itemHeight)
        self.lastAttribute = attribututes
        maxY = (self.lastAttribute?.frame.maxY)!
        return attribututes
    }
    
    override public func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override public func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        return self.attributesElements
    }

    
    func itemWidthByText(text: String) -> CGFloat {
        
        self.keyLabel.text = text
        self.keyLabel.sizeToFit()
        let stringWidth = self.keyLabel.frame.width+self.liftdistance+self.rightdistance
        
//        let size = CGSize.init(width: 100, height: 14)
//        let dic = NSDictionary(object: UIFont.systemFont(ofSize: 14), forKey: NSFontAttributeName as NSCopying)
//        let stringSize = text.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: dic as? [String : AnyObject], context:nil).size
//        
//        let stringWidth = stringSize.width + 10
        
        if stringWidth > (maxWidth - 12 * 2) {
            return maxWidth - 12 * 2
        }
        return stringWidth
    }
}
