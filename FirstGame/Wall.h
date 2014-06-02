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

@interface Wall : NSObject

//壁のノードを返す
+(SKSpriteNode *)getWall;
//壁の生成を行う
+(void)setWallFromNextGround:(SKSpriteNode *) nextGround;
//壁の移動を行う
+(void)moveWallGroundDuration:(float)duration;


@end
