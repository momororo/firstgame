//
//  Fish.h
//  FirstGame
//
//  Created by 新井脩司 on 2014/06/07.
//  Copyright (c) 2014年 sacrew. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

//魚ノード
SKSpriteNode *fish;


@interface Fish : NSObject

//魚ノードを返す
+(SKSpriteNode *)getFish;
//魚を作成する
+(void)setFishPositionX:(float)positionX positionY:(float)positionY;
//跳ねる動作を行う
+(void)hopFish;


@end
