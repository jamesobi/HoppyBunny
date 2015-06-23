//
//  Obstacle.swift
//  HoppyBunny
//
//  Created by James Sobieski on 6/22/15.
//  Copyright (c) 2015 Apportable. All rights reserved.
//

import UIKit

import Foundation

class Obstacle : CCNode {
    weak var topCarrot : CCNode!
    weak var bottomCarrot : CCNode!
    weak var goal : CCNode!
    
    let topCarrotMinimumPositionY : CGFloat = 128
    let bottomCarrotMaximumPositionY : CGFloat = 440
    let carrotDistance : CGFloat = 142
    
    func setupRandomPosition() {
        let randomPrecision : UInt32 = 100
        let random = CGFloat(arc4random_uniform(randomPrecision)) / CGFloat(randomPrecision)
        let range = bottomCarrotMaximumPositionY - carrotDistance - topCarrotMinimumPositionY
        let theRandomNumber = random*range
        topCarrot.position = ccp(topCarrot.position.x, topCarrotMinimumPositionY + theRandomNumber);
        bottomCarrot.position = ccp(bottomCarrot.position.x, topCarrot.position.y + carrotDistance);
        //goal.position = ccp(topCarrot.position.x, 250 + theRandomNumber)
        //goal.position = ccp(topCarrot.position.x, 250)

        
    }
    
    func didLoadFromCCB(){
        topCarrot.physicsBody.sensor = true
        bottomCarrot.physicsBody.sensor = true
    }
}