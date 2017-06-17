//
//  APIIntraDelegate.swift
//  rush00
//
//  Created by Eren Ozdek on 17/06/2017.
//  Copyright © 2017 Eren Ozdek. All rights reserved.
//

import Foundation

protocol APIIntraDelegate: class {
    func treatPost(_ post: [Msg])
    func msgError(_ msg: String)
}
