//
//  ViewController.swift
//  IndexTableView
//
//  Created by 周泽勇 on 15/8/12.
//  Copyright (c) 2015年 studyinhand. All rights reserved.
//

import UIKit

class TestViewController: UIViewController, UIIndexTableViewDelegate {
    private var indexTableView:UIIndexTableView = UIIndexTableView(frame: CGRectZero)

    private var dataSource:[NSDictionary] =  [
        ["indexTitle": "A","data":["adam", "alfred", "ain", "abdul", "anastazja", "angelica"]],
        ["indexTitle": "D","data":["dennis" , "deamon", "destiny", "dragon", "dry", "debug", "drums"]],
        ["indexTitle": "F","data":["Fredric", "France", "fr iends", "family", "fatish", "funeral"]],
        ["indexTitle": "M","data":["Mark", "Madeline"]],["indexTitle": "N","data":["Nemesis", "nemo", "name"]],
        ["indexTitle": "O","data":["Obama", "Oprah", "Omen", "OMG OMG OMG", "O-Zone", "Ontario"]],
        ["indexTitle": "Z","data":["Zeus", "Zebra", "zed"]]
    ];

    override func viewDidLoad() {
        super.viewDidLoad()
        
        indexTableView.delegate = self
        view.addSubview(indexTableView)
        indexTableView.snp_makeConstraints { (make) -> Void in
            make.leading.trailing.bottom.equalTo(self.view)
            if let topGuideView = self.topLayoutGuide as? UIView {
                make.top.equalTo(topGuideView.snp_bottom)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func sectionIndexTitlesForIndexTableView(tableView: UIIndexTableView) -> [String] {
        return ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z"]
    }
    
    func titleString(section: Int) -> String {
        if let str = dataSource[section]["indexTitle"] as? String {
            return str
        }else {
            return ""
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        var count = dataSource.count
        return count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let array = dataSource[section]["data"] as? [String] {
            return array.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.titleString(section)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "UITableViewCell"
        var cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? UITableViewCell
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: cellIdentifier)
        }
        if let array = dataSource[indexPath.section]["data"] as? [String] {
            cell?.textLabel?.text = array[indexPath.row]
        }
        return cell!
    }
    
}

