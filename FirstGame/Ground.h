//
//  Ground.h
//  FirstGame
//
//  Created by yasutomo on 2014/06/02.
//  Copyright (c) 2014年 sacrew. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>
#import "ObjectBitMask.h"

//グラウンドノード
SKSpriteNode *ground;
//ネクストグラウンド(配列)
NSMutableArray *nextGrounds;


@interface Ground : NSObject

+(SKSpriteNode *)getGround;
+(SKSpriteNode *)getNextGround;
+(void)setNextGroundPositionX:(float)positionX;
+(void)setGroundSizeX:(float)sizeX sizeY:(float)sizeY;
+(void)moveGroundToX:(float)x duration:(float)duration;
+(void)moveNextGroundDuration:(float)duration;
@end
