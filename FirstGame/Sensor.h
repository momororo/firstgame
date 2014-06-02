//
//  Sensor.h
//  FirstGame
//
//  Created by yasutomo on 2014/06/02.
//  Copyright (c) 2014年 sacrew. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>
#import "ObjectBitMask.h"

SKSpriteNode *sensor;

@interface Sensor : NSObject

+(SKSpriteNode *)getSensor;
+(void)setSensoFrame:(CGRect)frame;

@end
