//
//  objectBitMask.h
//  FirstGame
//
//  Created by yasutomo on 2014/06/02.
//  Copyright (c) 2014年 sacrew. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

static const uint32_t groundCategory = 0x1 << 0;
static const uint32_t playerCategory = 0x1 << 1;
static const uint32_t sensorCategory = 0x1 << 2;
static const uint32_t wallCategory   = 0x1 << 3;
static const uint32_t flyingPlayerCategory   = 0x1 << 4;

@interface ObjectBitMask : NSObject

+(BOOL)playerAndGround:(SKPhysicsContact *)contact;
+(BOOL)playerAndWall:(SKPhysicsContact *)contact;
+(BOOL)flyingPlayerAndGround:(SKPhysicsContact *)contact;
+(BOOL)flyingPlayerAndWall:(SKPhysicsContact *)contact;
+(BOOL)sensorAndGround:(SKPhysicsContact *)contact;



@end
