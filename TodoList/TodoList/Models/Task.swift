//
//  Task.swift
//  TodoList
//
//  Created by Prasad on 5/10/20.
//  Copyright © 2020 Prasad. All rights reserved.
//

import Foundation

enum Priority: Int {
    case high
    case medium
    case low
}

struct Task {
    let title: String
    let priority: Priority
}
