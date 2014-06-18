//
//  Player.h
//  FirstGame
//
//  Created by yasutomo on 2014/06/02.
//  Copyright (c) 2014年 sacrew. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SpriteKit/SpriteKit.h>
#import "ObjectBitMask.h"


//プレイヤーnode
SKSpriteNode *player;
//通常時のPhysicsBody
SKPhysicsBody *normalPhysicsBody;
//スマッシュ時のphysicsBody
SKPhysicsBody *smashPhyicsBody;
//ジャンプフラグ
BOOL jumpFlag;
//スマッシュフラグ
BOOL smashFlag;
//flyポイント
int flyPoint;
//flyフラグ
BOOL flyFlag;
//歩行モーションのアトラス
NSMutableArray *walkPenguins;
//飛行モーションのアトラス
NSMutableArray *flyPenguins;
//スマッシュのテクスチャ
SKTexture *smashPenguin;



//ジャンプ音
SKAction *jumpSE;


@interface Player : NSObject

//プレイヤーのノードを返す
+(SKSpriteNode *)getPlayer;
//プレイヤーを生成する
+(void)setPlayerPositionX:(float)positionX positionY:(float)positionY;
//歩く動作を行う
+(void)walkAction;
//ジャンプ(ジャンプ中はスマッシュ)動作を行う
+(void)jumpOrSmashAction;
//physicsBodyを通常時に設定する
+(void)setNormalPhysicsBody;
//physicsBodyをスマッシュ時に設定する
+(void)setSmashPhysicsBody;
//プレイヤーの位置情報を取得する
+(CGPoint)getPlayerPosition;
//ジャンプフラグをオフに(床からジャンプしなかった場合の処理)
+(void)setJumpFlagOff;
//フライトポイントを100ずつ足し算
+(void)countUpFlyPoint;
//フライポイントの減算を行う(0になった場合はYESを返す)
+(BOOL)countDownFlyPoint;
//フライポイントを返す
+(int)getFlyPoint;
//フライフラグを返す
+(BOOL)getFlyFlag;
//プレイヤーの初期化
+(void)initPlayer;
//プレイヤーのテクスチャーを作成
+(void)initTexture;


@end
