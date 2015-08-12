//
//  UIIndexTableView.swift
//  IndexTableView
//
//  Created by 周泽勇 on 15/8/12.
//  Copyright (c) 2015年 studyinhand. All rights reserved.
//

import UIKit

public protocol IndexTableViewDelegate: UITableViewDataSource, UITableViewDelegate {
    func sectionIndexTitlesForIndexTableView(tableView:UIIndexTableView)->[String]
    
    func titleString(section:Int)->String
}

public class UIIndexTableView: UIView {
    

}
