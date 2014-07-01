//
//  Emergency.m
//  FirstGame
//
//  Created by 新井脩司 on 2014/06/28.
//  Copyright (c) 2014年 sacrew. All rights reserved.
//

#import "Emergency.h"
#import "Player.h"

@implementation Emergency

+(SKSpriteNode *)getEmergency{
    return emergency;
}

+(void)setEmergencyFrame:(CGRect)frame{
    emergency = [SKSpriteNode spriteNodeWithColor:[SKColor blackColor] size:CGSizeMake(30, 30)];
    emergency.position = CGPointMake(frame.size.width/3, frame.size.height/4);
    emergency.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:emergency.size];
    emergency.physicsBody.affectedByGravity = NO;
    
    emergency.physicsBody.categoryBitMask = emergencyCategory;
    emergency.physicsBody.collisionBitMask = 0;
    emergency.physicsBody.contactTestBitMask = 0;
}

@end
