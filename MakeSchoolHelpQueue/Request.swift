//
//  Request.swift
//  MakeSchoolHelpQueue
//
//  Created by Tyler Weitzman on 6/25/15.
//  Copyright (c) 2015 Tyler Weitzman. All rights reserved.
//

import UIKit

class Request: NSObject {
    var name : String?
    var question: String?
    override var description: String {
        return "\(name) : \(question)"
    }
    init(name: String, question: String) {
        self.name = name
        self.question = question
    }
}

func == (lhs: Request, rhs: Request) -> Bool {
    return lhs.name == rhs.name && lhs.question == rhs.question
}