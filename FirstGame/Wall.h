//
//  Wall.h
//  FirstGame
//
//  Created by yasutomo on 2014/06/02.
//  Copyright (c) 2014年 sacrew. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>
#import "ObjectBitMask.h"

NSMutableArray *walls;
//効果音
SKAction *bombSE;

@interface Wall : NSObject

//壁のノードを返す
+(SKSpriteNode *)getWall;
//壁の生成を行う
+(void)setWallFromNextGround:(SKSpriteNode *) nextGround;
//壁の移動を行う
+(void)moveWallDuration:(float)duration;
//壁の初期化
+(void)initWalls;
//アクションを終えた壁の削除
+(void)removeOldWall;
//攻撃を受けた壁の削除
+(void)removeAttackedWall:(SKNode *)AttackedWall;
@end
