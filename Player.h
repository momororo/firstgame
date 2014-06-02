//
//  Player.h
//  FirstGame
//
//  Created by yasutomo on 2014/06/02.
//  Copyright (c) 2014年 sacrew. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>
#import "ObjectBitMask.h"


//プレイヤーnode
SKSpriteNode *player;
//通常時のPhysicsBody
SKPhysicsBody *normalPhysicsBody;
//スマッシュ時のphysicsBody
SKPhysicsBody *smashPhyicsBody;
//ジャンプフラグ
BOOL jumpFlag;
//スマッシュフラグ
BOOL smashFlag;
//ジャンプ音
SKAction *jumpSE;

@interface Player : NSObject

+(SKSpriteNode *)getPlayer;
+(void)setPlayerPositionX:(float)positionX positionY:(float)positionY;
+(void)walkAction;
+(void)jumpOrSmashAction;
+(void)setNormalPhysicsBody;
+(void)setSmashPhysicsBody;

@end
