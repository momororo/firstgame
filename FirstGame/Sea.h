//
//  Sea.h
//  FirstGame
//
//  Created by yasutomo on 2014/06/02.
//  Copyright (c) 2014年 sacrew. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

//海のノード
SKSpriteNode *sea;

@interface Sea : NSObject

//海のノードを返す
+(SKSpriteNode *)getSea;
//海の生成
+(void)setSeaFrame:(CGRect)frame;

@end
