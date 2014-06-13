//
//  Island.h
//  FirstGame
//
//  Created by 新井脩司 on 2014/06/12.
//  Copyright (c) 2014年 sacrew. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

SKSpriteNode *island1;
SKSpriteNode *island2;


@interface Island : NSObject

//島のノードを返す
+(SKSpriteNode *)getIsland1;
+(SKSpriteNode *)getIsland2;

//島の作成
+(void)setIsland1Frame:(CGRect)frame;
+(void)setIsland2Frame:(CGRect)frame;

//島の移動
+(void)moveIsland1;
+(void)moveIsland2;

@end
