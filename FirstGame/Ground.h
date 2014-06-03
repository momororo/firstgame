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

//グラウンドノード
SKSpriteNode *ground;
//ネクストグラウンド(配列)
NSMutableArray *nextGrounds;


@interface Ground : NSObject

//Groundのノードを返す
+(SKSpriteNode *)getGround;
//nextGroundのノードを返す
+(SKSpriteNode *)getNextGround;
//nextGroundを作る。
+(void)setNextGroundPositionX:(float)positionX;
//Groundを作る
+(void)setGroundSizeX:(float)sizeX sizeY:(float)sizeY;
//Groundの動作を行う
+(void)moveGroundToX:(float)x duration:(float)duration;
//nextGroundの動作を行う
+(void)moveNextGroundDuration:(float)duration;
//グラウンドの初期化
+(void)initGounds;
//アクションを終えたネクストグラウンドの削除
+(void)removeOldNextGround;

@end
