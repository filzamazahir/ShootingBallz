//
//  SocketDelegate.swift
//  Shooting Ballz
//
//  Created by Filza Mazahir on 1/20/16.
//  Copyright © 2016 Filza Mazahir. All rights reserved.
//

import Foundation
protocol SocketDelegate: class {
    var socket: SocketIOClient? {get set}
}
