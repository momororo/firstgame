//
//  Fish.h
//  FirstGame
//
//  Created by 新井脩司 on 2014/06/07.
//  Copyright (c) 2014年 sacrew. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>
#import "ObjectBitMask.h"
#import "Player.h"

//魚のノード
SKSpriteNode *fish;

@interface Fish : NSObject

//fishのノードを返す
+(SKSpriteNode *)getFish;

//fishを作る
+(void)setFishPositionX:(float)positionX PositionY:(float)positionY;

+(void)removeFish:(SKNode *)goodbyFish;


@end
