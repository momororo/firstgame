//
//  objectBitMask.m
//  FirstGame
//
//  Created by yasutomo on 2014/06/02.
//  Copyright (c) 2014年 sacrew. All rights reserved.
//

#import "ObjectBitMask.h"

@implementation ObjectBitMask

//プレイヤーと地面か判定する
+(BOOL)playerAndGround:(SKPhysicsContact *)contact{
    
    if((playerCategory == contact.bodyA.categoryBitMask || playerCategory == contact.bodyB.categoryBitMask) && (groundCategory == contact.bodyA.categoryBitMask || groundCategory == contact.bodyB.categoryBitMask)){
        return YES;
    }
    
    return NO;
    
    
}

//プレイヤーと壁か判定する
+(BOOL)playerAndWall:(SKPhysicsContact *)contact{
    
    if((playerCategory == contact.bodyA.categoryBitMask || playerCategory == contact.bodyB.categoryBitMask) && (wallCategory == contact.bodyA.categoryBitMask || wallCategory == contact.bodyB.categoryBitMask)){
        return YES;
    }
    
    return NO;
    
    
}

//スマッシュプレイヤーと地面か判定する
+(BOOL)flyingPlayerAndGround:(SKPhysicsContact *)contact{
    
    if((flyingPlayerCategory == contact.bodyA.categoryBitMask || flyingPlayerCategory == contact.bodyB.categoryBitMask) && (groundCategory == contact.bodyA.categoryBitMask || groundCategory == contact.bodyB.categoryBitMask)){
        return YES;
    }
    
    return NO;
    
    
}

//スマッシュプレイヤーと壁か判定する
+(BOOL)flyingPlayerAndWall:(SKPhysicsContact *)contact{
    
    if((flyingPlayerCategory == contact.bodyA.categoryBitMask || flyingPlayerCategory == contact.bodyB.categoryBitMask) && (wallCategory == contact.bodyA.categoryBitMask || wallCategory == contact.bodyB.categoryBitMask)){
        return YES;
    }
    
    return NO;
    
    
}

//センサーと地面か判定する
+(BOOL)sensorAndGround:(SKPhysicsContact *)contact{
    
    if((sensorCategory == contact.bodyA.categoryBitMask || sensorCategory == contact.bodyB.categoryBitMask) && (groundCategory == contact.bodyA.categoryBitMask || groundCategory == contact.bodyB.categoryBitMask)){
        return YES;
    }
    
    return NO;
    
    
}

//以下、contactからget○○From部のノードを返すメソッド
+(SKNode *)getPlayerFromContact:(SKPhysicsContact *)contact{
    if(playerCategory == contact.bodyA.categoryBitMask){
        return contact.bodyA.node;
    }else{
        return contact.bodyB.node;
    }
    
}
+(SKNode *)getFlyingPlayerFromContact:(SKPhysicsContact *)contact{
    if(flyingPlayerCategory == contact.bodyA.categoryBitMask){
        return contact.bodyA.node;
    }else{
        return contact.bodyB.node;
    }

    
}
+(SKNode *)getGroundFromContact:(SKPhysicsContact *)contact{
    if(groundCategory == contact.bodyA.categoryBitMask){
        return contact.bodyA.node;
    }else{
        return contact.bodyB.node;
    }

    
}
+(SKNode *)getWallFromContact:(SKPhysicsContact *)contact{
    if(wallCategory == contact.bodyA.categoryBitMask){
        return contact.bodyA.node;
    }else{
        return contact.bodyB.node;
    }

    
}
+(SKNode *)getSensorFromContact:(SKPhysicsContact *)contact{
    if(sensorCategory == contact.bodyA.categoryBitMask){
        return contact.bodyA.node;
    }else{
        return contact.bodyB.node;
    }

    
}


@end
