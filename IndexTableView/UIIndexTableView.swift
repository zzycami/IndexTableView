//
//  UIIndexTableView.swift
//  IndexTableView
//
//  Created by 周泽勇 on 15/8/12.
//  Copyright (c) 2015年 studyinhand. All rights reserved.
//

import UIKit

public protocol UIIndexTableViewDelegate: UITableViewDataSource, UITableViewDelegate {
    func sectionIndexTitlesForIndexTableView(tableView:UIIndexTableView)->[String]
    
    func titleString(section:Int)->String
}

public class UIIndexTableView: UIView, UIIndexViewDelegate {
    public var tableView:UITableView = UITableView(frame: CGRectZero, style: UITableViewStyle.Plain)
    public var delegate:UIIndexTableViewDelegate? {
        didSet {
            if let delegate = self.delegate {
                self.tableView.delegate = delegate
                self.tableView.dataSource = delegate
                
                self.indexView.indexes = delegate.sectionIndexTitlesForIndexTableView(self)
                self.indexView.reloadLayout(tableView.contentInset)
                indexView.delegate = self
            }
        }
    }
    
    private var flotageLabel:UILabel = UILabel(frame: CGRectZero)
    private var indexView:UIIndexView = UIIndexView(frame: CGRectZero)
    
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupIndexTableView()
    }
    
    public required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupIndexTableView()
    }
    
    private func setupIndexTableView() {
        addSubview(tableView)
        tableView.snp_makeConstraints { (make) -> Void in
            make.edges.equalTo(self)
        }
        
        addSubview(indexView)
        indexView.snp_makeConstraints { (make) -> Void in
            make.trailing.equalTo(self)
            make.top.bottom.equalTo(self)
            make.width.equalTo(20)
        }
        
        self.addSubview(flotageLabel)
        flotageLabel.snp_makeConstraints { (make) -> Void in
            make.width.height.equalTo(64)
            make.center.equalTo(self)
        }
        
        println("x:\(frame.origin.x), y:\(frame.origin.y), width:\(frame.width), height:\(frame.height)")
        indexView.frame = CGRectMake(0, 0, 20, bounds.height)
        
        flotageLabel.hidden = true
        flotageLabel.backgroundColor = UIColor(red: 18/255.0, green: 29/255.0, blue: 45/255.0, alpha: 0.5)
        flotageLabel.textColor = UIColor.whiteColor()
        flotageLabel.font = UIFont.boldSystemFontOfSize(23)
        flotageLabel.layer.cornerRadius = 8
        flotageLabel.layer.masksToBounds = true
        flotageLabel.textAlignment = NSTextAlignment.Center
    }
    
    public override func layoutSubviews() {
        println("x:\(frame.origin.x), y:\(frame.origin.y), width:\(frame.width), height:\(frame.height)")
        super.layoutSubviews()
        indexView.layoutSubviews()
    }
    
    
    public func reloadData() {
        tableView.reloadData()
        if let delegate = self.delegate {
            indexView.indexes = delegate.sectionIndexTitlesForIndexTableView(self)
            indexView.reloadLayout(tableView.contentInset)
            indexView.delegate = self
        }
    }
    
    public func hideFlotage() {
        flotageLabel.hidden = true
    }
    
    public func didSelectSectionAtIndex(indexView: UIIndexView, index: Int, title: String) {
        if index > -1 {
            if let delegate = self.delegate {
                var count = delegate.numberOfSectionsInTableView!(self.tableView)
                for i in 0..<count {
                    println("index:\(index), title:\(title), count:\(count)")
                    if delegate.titleString(i) == title {
                        tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: i), atScrollPosition: UITableViewScrollPosition.Top, animated: false)
                        break
                    }
                }
            }
            flotageLabel.text = title
        }
    }
    
    public func indexTouchesBegan(indexView: UIIndexView) {
        flotageLabel.hidden = false
    }
    
    public func indexTouchesEnd(indexView: UIIndexView) {
        UIView.animateWithDuration(0.4, animations: { () -> Void in
            self.flotageLabel.alpha = 0
        }) { (finished:Bool) -> Void in
            self.flotageLabel.alpha = 1
            self.flotageLabel.hidden = true
        }
    }
    
    public func indexTitle(indexView: UIIndexView) -> [String] {
        if let delegate = self.delegate {
            return delegate.sectionIndexTitlesForIndexTableView(self)
        }else {
            return []
        }
    }
}

public protocol UIIndexViewDelegate:NSObjectProtocol {
    /**
    *  触摸到索引时触发
    *
    *  @param tableViewIndex 触发didSelectSectionAtIndex对象
    *  @param index          索引下标
    *  @param title          索引文字
    */
    func didSelectSectionAtIndex(indexView:UIIndexView, index:Int, title:String)
    
    /**
    开始触摸索引
    
    :param: indexView 触发对象
    */
    func indexTouchesBegan(indexView:UIIndexView)
    
    /**
    触摸索引结束
    
    :param: indexView 触发对象
    */
    func indexTouchesEnd(indexView:UIIndexView)
    
    /**
    TableView中右边右边索引title
    
    :param: indexView 触发indexTitle对象
    
    :returns: 索引title数组
    */
    func indexTitle(indexView:UIIndexView)->[String]
    
}

public class UIIndexView:UIView {
    public var indexes:[String] = []
    public var delegate:UIIndexViewDelegate? {
        didSet {
            if let delegate = self.delegate {
                self.letters = delegate.indexTitle(self)
                self.isLayout = false
                self.layoutIfNeeded()
            }
        }
    }
    
    private var isLayout:Bool = false
    private var shapeLayer:CAShapeLayer = CAShapeLayer()
    private var fontSize:CGFloat = 0
    private var letters:[String] = []
    private var letterHeight:CGFloat = 0
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required public init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        shapeLayer.lineWidth = 1
        shapeLayer.fillColor = UIColor.clearColor().CGColor
        shapeLayer.lineJoin = kCALineCapSquare
        shapeLayer.strokeColor = UIColor.clearColor().CGColor
        shapeLayer.strokeEnd = 1
        layer.masksToBounds = false
        
        backgroundColor = UIColor.clearColor()
        if frame.height > 480 {
            fontSize = 12
        }else {
            fontSize = 11
        }
        if self.letters.count > 0 {
            letterHeight = self.frame.height / CGFloat(self.letters.count)
        }else {
            letterHeight = 0
        }
    }
    
    public func reloadLayout(edgeInsets:UIEdgeInsets) {
        var rect = self.frame
        rect.size.height = CGFloat(indexes.count) * letterHeight
        rect.origin.y = edgeInsets.top + (superview!.bounds.height - edgeInsets.top - edgeInsets.bottom - rect.height)/2
        self.frame = rect
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        setup()
        
        //if !isLayout {
            if layer.sublayers != nil {
                for sublayer in layer.sublayers {
                    sublayer.removeFromSuperlayer()
                }
            }
            
            println("x:\(frame.origin.x), y:\(frame.origin.y), width:\(frame.width), height:\(frame.height)")
            
            shapeLayer.frame = CGRectMake(0, 0, self.layer.frame.width, self.layer.frame.height)
            var bezierPath = UIBezierPath()
            bezierPath.moveToPoint(CGPointZero)
            bezierPath.addLineToPoint(CGPointMake(0, frame.size.height))
            
            for (index, letter) in enumerate(letters) {
                var originY = CGFloat(index) * letterHeight
                var ctl = textLayerWithSize(fontSize, text: letter, frame: CGRectMake(0, originY, frame.width, letterHeight))
                layer.addSublayer(ctl)
                bezierPath.moveToPoint(CGPointMake(0, originY))
                bezierPath.addLineToPoint(CGPointMake(ctl.frame.width, originY))
            }
            
            shapeLayer.path = bezierPath.CGPath
            layer.addSublayer(shapeLayer)
            isLayout = true
        //}
    }
    
    public func textLayerWithSize(size:CGFloat, text:String, frame:CGRect)->CATextLayer {
        var textLayer = CATextLayer()
        textLayer.font = "ArialMT"
        textLayer.fontSize = size
        textLayer.frame = frame
        textLayer.alignmentMode = kCAAlignmentCenter
        textLayer.contentsScale = UIScreen.mainScreen().scale
        textLayer.foregroundColor = UIColor(red: 166/255.0, green: 168/255.0, blue: 168/255.0, alpha: 1).CGColor
        textLayer.string = text
        return textLayer
    }
    
    public override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        super.touchesBegan(touches, withEvent: event)
        sendEventToDelegate(event)
        delegate?.indexTouchesBegan(self)
        self.backgroundColor = UIColor(red: 18/255.0, green: 29/255.0, blue: 45/255.0, alpha: 0.5)
    }
    
    public override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        super.touchesMoved(touches, withEvent: event)
        sendEventToDelegate(event)
    }
    
    public override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        delegate?.indexTouchesEnd(self)
        UIView.animateWithDuration(0.4, animations: { () -> Void in
            self.backgroundColor = UIColor.clearColor()
        })
    }
    
    private func sendEventToDelegate(event:UIEvent) {
        if let touch = event.allTouches()?.first as? UITouch {
            var point = touch.locationInView(self)
            var index = Int(floorf(Float(point.y)) / Float(self.letterHeight))
            if index < 0 || index > letters.count - 1 {
                return
            }
            delegate?.didSelectSectionAtIndex(self, index: index, title: letters[index])
        }
    }
}