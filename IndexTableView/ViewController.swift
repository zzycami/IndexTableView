//
//  ViewController.swift
//  IndexTableView
//
//  Created by 周泽勇 on 15/8/12.
//  Copyright (c) 2015年 studyinhand. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIIndexTableViewDelegate {
    private var indexTableView:UIIndexTableView = UIIndexTableView(frame: CGRectZero)

    private var dataSource:[NSDictionary] =  [
        ["indexTitle": "A","data":["adam", "alfred", "ain", "abdul", "anastazja", "angelica"]],
        ["indexTitle": "D","data":["dennis" , "deamon", "destiny", "dragon", "dry", "debug", "drums"]],
        ["indexTitle": "F","data":["Fredric", "France", "friends", "family", "fatish", "funeral"]],
        ["indexTitle": "M","data":["Mark", "Madeline"]],["indexTitle": "N","data":["Nemesis", "nemo", "name"]],
        ["indexTitle": "O","data":["Obama", "Oprah", "Omen", "OMG OMG OMG", "O-Zone", "Ontario"]],
        ["indexTitle": "Z","data":["Zeus", "Zebra", "zed"]]
    ];

    override func viewDidLoad() {
        super.viewDidLoad()
        
        indexTableView.delegate = self
        view.addSubview(indexTableView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func sectionIndexTitlesForIndexTableView(tableView: UIIndexTableView) -> [String] {
        return ["A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P"]
    }
    
    func titleString(section: Int) -> String {
        if let str = dataSource[section]["indexTitle"] as? String {
            return str
        }else {
            return ""
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return dataSource.count
    }

}

