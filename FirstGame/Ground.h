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

//ネクストグラウンド(配列)
NSMutableArray *nextGrounds;
//グラウンドのアトラス
NSMutableArray *nextGroundTexture;


@interface Ground : NSObject

//nextGroundのノードを返す
+(SKSpriteNode *)getNextGround;
//nextGroundを作る。
+(void)setNextGroundPositionX:(float)positionX;
//Groundを作る
+(void)setGroundFrame:(CGRect)frame;
//Groundの動作を行う
+(void)moveGroundToX:(float)x duration:(float)duration;
//nextGroundの動作を行う
+(void)moveNextGroundDuration:(float)duration;
//アクションを終えたネクストグラウンドの削除
+(void)removeOldNextGround;
//グラウンドのアトラスを生成
+(void)initGroundTexture;
//壁の位置が規定のx座標を下回っているか判定する
+(BOOL)judgeXpointer:(float)xPointer;



@end
