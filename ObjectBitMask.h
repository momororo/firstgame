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
static const uint32_t fishCategory   = 0x1 << 5;

@interface ObjectBitMask : NSObject
//プレイヤーと地面の衝突判定をする
+(BOOL)playerAndGround:(SKPhysicsContact *)contact;
//プレイヤーと壁の衝突判定をする
+(BOOL)playerAndWall:(SKPhysicsContact *)contact;
//プレイヤーと魚の衝突判定をする
+(BOOL)playerAndFish:(SKPhysicsContact *)contact;
//スマッシュプレイヤーと地面の衝突判定をする
+(BOOL)flyingPlayerAndGround:(SKPhysicsContact *)contact;
//スマッシュプレイヤーと壁の衝突判定をする
+(BOOL)flyingPlayerAndWall:(SKPhysicsContact *)contact;
//センサーと地面の衝突判定をする
+(BOOL)sensorAndGround:(SKPhysicsContact *)contact;
//受け取ったコンタクトからプレイヤーのノードを返す
+(SKNode *)getPlayerFromContact:(SKPhysicsContact *)contact;
//受け取ったコンタクトからスマッシュプレイヤーのノードを返す
+(SKNode *)getFlyingPlayerFromContact:(SKPhysicsContact *)contact;
//受け取ったコンタクトから地面のノードを返す
+(SKNode *)getGroundFromContact:(SKPhysicsContact *)contact;
//受け取ったコンタクトから壁のノードを返す
+(SKNode *)getWallFromContact:(SKPhysicsContact *)contact;
//受け取ったコンタクトからセンサーのノードを返す
+(SKNode *)getSensorFromContact:(SKPhysicsContact *)contact;
//受け取ったコンタクトから魚のノードを返す
+(SKNode *)getFishFromContact:(SKPhysicsContact *)contact;

@end
