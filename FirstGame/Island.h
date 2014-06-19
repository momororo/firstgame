//
//  Island.h
//  FirstGame
//
//  Created by 新井脩司 on 2014/06/12.
//  Copyright (c) 2014年 sacrew. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>


//島の配列
NSMutableArray *islands;
//島のテクスチャ配列
NSMutableArray *islandsTexture;


@interface Island : NSObject

//初期設定時使用
+(NSMutableArray *)getIslandInit;
//テクスチャinit
+(void)initTexture;
//島のノードを返す
+(SKSpriteNode *)getIslands;
//初期設定時使用
+(void)setIslandInitFrame:(CGRect)frame;
//島の配置
+(void)setIslandFrame:(CGRect)frame;
//初期設定時使用
+(void)moveIslandInit;
//島が動く
+(void)moveIsland;
//不要な島の削除
+(BOOL)removeIsland;


@end
