//
//  Goal.swift
//  HoppyBunny
//
//  Created by James Sobieski on 6/23/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import UIKit

class Goal: CCNode {
    func didLoadFromCCB(){
        physicsBody.sensor = true
    }
}
