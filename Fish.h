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

//魚のノード配列
NSMutableArray *fishes;

//登録した魚の数を返す
int fishQuantity;

@interface Fish : NSObject

//fishのノード配列を返す
+(NSMutableArray *)getFishes;

//追加した魚の数量を返す
+(int)getFishQuantity;

//fish配列を作る
+(void)setFishPositionX:(float)positionX PositionY:(float)positionY;

//fishの動きを設定する
+(void)moveFish;

//画面外のfishノードの削除
+(void)removeFish;

//食べられた魚の削除
+(void)removeEatenFish:(SKNode *)EatenFish;

@end
