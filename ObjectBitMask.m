//
//  objectBitMask.m
//  FirstGame
//
//  Created by yasutomo on 2014/06/02.
//  Copyright (c) 2014年 sacrew. All rights reserved.
//

#import "ObjectBitMask.h"

@implementation ObjectBitMask


+(BOOL)playerAndGround:(SKPhysicsContact *)contact{
    
    if((playerCategory == contact.bodyA.categoryBitMask || playerCategory == contact.bodyB.categoryBitMask) && (groundCategory == contact.bodyA.categoryBitMask || groundCategory == contact.bodyB.categoryBitMask)){
        return YES;
    }
    
    return NO;
    
    
}
+(BOOL)playerAndWall:(SKPhysicsContact *)contact{
    
    if((playerCategory == contact.bodyA.categoryBitMask || playerCategory == contact.bodyB.categoryBitMask) && (wallCategory == contact.bodyA.categoryBitMask || wallCategory == contact.bodyB.categoryBitMask)){
        return YES;
    }
    
    return NO;
    
    
}
+(BOOL)flyingPlayerAndGround:(SKPhysicsContact *)contact{
    
    if((flyingPlayerCategory == contact.bodyA.categoryBitMask || flyingPlayerCategory == contact.bodyB.categoryBitMask) && (groundCategory == contact.bodyA.categoryBitMask || groundCategory == contact.bodyB.categoryBitMask)){
        return YES;
    }
    
    return NO;
    
    
}

+(BOOL)flyingPlayerAndWall:(SKPhysicsContact *)contact{
    
    if((flyingPlayerCategory == contact.bodyA.categoryBitMask || flyingPlayerCategory == contact.bodyB.categoryBitMask) && (wallCategory == contact.bodyA.categoryBitMask || wallCategory == contact.bodyB.categoryBitMask)){
        return YES;
    }
    
    return NO;
    
    
}
+(BOOL)sensorAndGround:(SKPhysicsContact *)contact{
    
    if((sensorCategory == contact.bodyA.categoryBitMask || sensorCategory == contact.bodyB.categoryBitMask) && (groundCategory == contact.bodyA.categoryBitMask || groundCategory == contact.bodyB.categoryBitMask)){
        return YES;
    }
    
    return NO;
    
    
}

@end
