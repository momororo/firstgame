//
//  Sea.h
//  FirstGame
//
//  Created by yasutomo on 2014/06/02.
//  Copyright (c) 2014年 sacrew. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>

//海の波の配列
NSMutableArray *seas;
//海の波のテクスチャ配列
NSMutableArray *seasTexture;


@interface Sea : NSObject

//初期設定時使用
+(NSMutableArray *)getSeaInit;
//テクスチャinit
+(void)initTexture;
//海のノードを返す
+(SKSpriteNode *)getSeas;
//初期設定時使用
+(void)setSeasInitFrame:(CGRect)frame;
//海の配置
+(void)setSeaFrame:(CGRect)frame;
//初期設定時使用
+(void)moveSeaInit;
//海が動く
+(void)moveSea;
//不要な海の削除
+(BOOL)removeSea;


@end
