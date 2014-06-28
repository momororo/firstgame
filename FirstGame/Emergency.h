//
//  Emergency.h
//  FirstGame
//
//  Created by 新井脩司 on 2014/06/28.
//  Copyright (c) 2014年 sacrew. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>
#import "ObjectBitMask.h"

SKSpriteNode *emergency;

@interface Emergency : NSObject

//プレイヤー固定ボックスのノードを返す
+(SKSpriteNode *)getEmergency;
//プレイヤー固定ボックスの作成
+(void)setEmergencyFrame:(CGRect)frame;

@end
