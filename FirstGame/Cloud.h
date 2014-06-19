//
//  Cloud.h
//  FirstGame
//
//  Created by 新井脩司 on 2014/06/13.
//  Copyright (c) 2014年 sacrew. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>


//雲の配列
NSMutableArray *clouds;
//雲のテクスチャ配列
NSMutableArray *cloudsTexture;

@interface Cloud : NSObject

//初期設定時使用
+(NSMutableArray *)getCloudInit;
//雲のノードを返す
+(SKSpriteNode *)getClouds;
//テクスチャinit
+(void)initTexture;
//初期設定時使用
+(void)setCloudInitFrame:(CGRect)frame;
//雲の配置
+(void)setCloudFrame:(CGRect)frame;
//初期設定時使用
+(void)moveCloudInit;
//雲が動く
+(void)moveCloud;
//不要な雲の削除
+(BOOL)removeCloud;


@end
