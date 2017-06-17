//
//  Msg.swift
//  rush00
//
//  Created by Eren Ozdek on 17/06/2017.
//  Copyright © 2017 Eren Ozdek. All rights reserved.
//

import Foundation

struct Msg : CustomStringConvertible {
    let login: String
    let msg: String
    let date: String
    let title: String
    
    var description: String {
        return  "login \(login) msg \(msg) title \(title) date \(date)"
    }
}
