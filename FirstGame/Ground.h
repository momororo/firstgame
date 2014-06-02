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

SKSpriteNode *ground;

@interface Ground : NSObject

+(SKSpriteNode *)getGround;
+(void)setGroundSizeX:(float)sizeX sizeY:(float)sizeY;
+(void)moveGroundToX:(float)x duration:(float)duration;

@end
