//
//  Player.m
//  FirstGame
//
//  Created by yasutomo on 2014/06/02.
//  Copyright (c) 2014年 sacrew. All rights reserved.
//

#import "Player.h"

@implementation Player

//プレイヤーのノードを返す
+(SKSpriteNode *)getPlayer{
    return player;
}

//フライングフラグを返す
+(BOOL)getFlyFlag{
    return flyFlag;
}

+(BOOL)getSmashFlag{
    return smashFlag;
}

//プレイヤーのテクスチャを生成する
+(void)initTexture{
    
    //歩行アトラスの設定
    walkPenguins = [NSMutableArray new];
    SKTextureAtlas *walkPenguin =[SKTextureAtlas atlasNamed:@"walkPenguin"];
    SKTexture *walkPenguin1 = [walkPenguin textureNamed:@"pengin1"];
    SKTexture *walkPenguin2 = [walkPenguin textureNamed:@"pengin2"];
    [walkPenguins addObject:walkPenguin1];
    [walkPenguins addObject:walkPenguin2];
    
    
    
    //飛行アトラスの設定
    flyPenguins = [NSMutableArray new];
    SKTextureAtlas *flyPenguin =[SKTextureAtlas atlasNamed:@"flyPenguin"];
    SKTexture *flyPenguin1 = [flyPenguin textureNamed:@"pengin3"];
    SKTexture *flyPenguin2 = [flyPenguin textureNamed:@"pengin4"];
    [flyPenguins addObject:flyPenguin1];
    [flyPenguins addObject:flyPenguin2];
    
    //スマッシュテクスチャの設定
    smashPenguin = [SKTexture textureWithImageNamed:@"pengin5"];


    
}

//プレイヤーの初期配置
+(void)setPlayerPositionX:(float)positionX positionY:(float)positionY{
    //プレイキャラの設定
    player = [SKSpriteNode spriteNodeWithTexture:walkPenguins[0]];
    player.size = CGSizeMake(player.size.width/6, player.size.height/6);
    player.name = @"kPlayer";
    player.position = CGPointMake(positionX, positionY);
    player.zPosition = 50;
    [self setNormalPhysicsBody];
    
    //フラグ等の初期化
    [self initPlayer];
    
    
    
    //効果音の初期設定
    jumpSE = [SKAction playSoundFileNamed:@"jump.wav" waitForCompletion:NO];

    
}

//歩行動作
+(void)walkAction{
    
    if(jumpFlag == NO){

    //歩行モーション
    SKAction *walkPengin = [SKAction animateWithTextures:@[walkPenguins[0],walkPenguins[1]] timePerFrame:0.1];
    [player runAction:[SKAction repeatActionForever:walkPengin]];
    
    //ジャンプ可能フラグをオンに
        jumpFlag = YES;
        
    //PhysicsBodyを通常時に
        [self setNormalPhysicsBody];
    }
    
}

//ジャンプ(スマッシュ)アクション(フラグで分岐)
+(void)jumpOrSmashAction{
    
    if(jumpFlag == YES){
        
        //ジャンプ処理
        player.physicsBody.velocity = CGVectorMake(0, 500);
        
        //ジャンプモーション
        SKAction *jumpPengin = [SKAction animateWithTextures:@[flyPenguins[0],flyPenguins[1]] timePerFrame:0.1];
        [player runAction:[SKAction repeatActionForever:jumpPengin]];
        
        [player runAction:jumpSE];
        
        
        //スマッシュフラグがオフのとき
        if(flyFlag == NO){
        //ジャンプ可能フラグをNOにする
            jumpFlag = NO;
        //突進可能フラグをYESにする
            smashFlag = YES;
            
        return;

        }
        
        //スマッシュフラグがオンのとき
        //フライング時はスマッシュできないようにフラグを調整する。
        if(smashFlag == YES){
            //ジャンプ可能フラグをNOにする
            jumpFlag = NO;
            //突進可能フラグをNOにする
            smashFlag = NO;
            
            return;
        }
        
        
        
    }
    
    if (jumpFlag == NO && smashFlag == YES) {
        
        //突進処理
        player.physicsBody.velocity = CGVectorMake(0, -500);
        [player runAction:[SKAction repeatActionForever:[SKAction animateWithTextures:@[smashPenguin] timePerFrame:0.1]]];
        
        smashFlag = NO;
        
        //突進用のビットマスクに変更
        [self setSmashPhysicsBody];
        
        //炎のパーティクルを出す
        //処理が重いため保留
        //[self makeFireParticle:sprite.position];
        
        return;
    }
    
    //フライングモード
    if(flyFlag == YES && jumpFlag == NO && smashFlag == NO){
        //氷を壊すことがあるので都度都度通常状態に戻す
        //この処理をvelocity設定の後に行うと、velocityが初期化され、飛べなくなる。
        [self setNormalPhysicsBody];
        
        player.physicsBody.velocity = CGVectorMake(0, 500);
        
        SKAction *jumpPengin = [SKAction animateWithTextures:@[flyPenguins[0],flyPenguins[1]] timePerFrame:0.1];
        [player runAction:[SKAction repeatActionForever:jumpPengin]];
        
    }

    
}

//physicsBodyを通常状態にする
+(void)setNormalPhysicsBody{
    player.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:player.size];
    player.physicsBody.allowsRotation = NO;
    player.physicsBody.affectedByGravity = YES;
    player.physicsBody.restitution = 0;
    player.physicsBody.categoryBitMask = playerCategory;
    player.physicsBody.collisionBitMask = groundCategory | wallCategory;
    player.physicsBody.contactTestBitMask = groundCategory | fishCategory;
    
}

//physicsBodyをスマッシュ状態にする
+(void)setSmashPhysicsBody{
    player.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:player.size];
    player.physicsBody.allowsRotation = NO;
    player.physicsBody.affectedByGravity = YES;
    player.physicsBody.restitution = 0;
    player.physicsBody.categoryBitMask = flyingPlayerCategory;
    player.physicsBody.collisionBitMask = groundCategory;
    player.physicsBody.contactTestBitMask = groundCategory;

    
}

//プレイヤーのポジションを返す
+(CGPoint)getPlayerPosition{
    return player.position;
}

//ジャンプフラグをオフにする
+(void)setJumpFlagOff{
    jumpFlag = NO;
}

//フライポイントをカウントアップにする
+(void)countUpFlyPoint{
    
    //飛んでいないときのみカウントアップ
    if(flyFlag == NO){
        flyPoint = flyPoint + 100;
    }

    if (flyPoint == 500) {
        flyFlag = YES;
        jumpFlag = NO;
        smashFlag = NO;
    }
    
}

//フライポイントの減算を行う(0になった場合はYESを返す)
+(BOOL)countDownFlyPoint{
    
    flyPoint--;
    
    
    if(flyPoint == 0){
        flyFlag = NO;
        smashFlag = YES;
        return YES;
    }
    
    return NO;
}

//フライポイントを返す
+(int)getFlyPoint{
    return flyPoint;
    
}

//フライフラグを返す
+(BOOL)getFlylag{
    return flyFlag;
}

//プレイヤーの初期化
+(void)initPlayer{
    
    jumpFlag = NO;
    smashFlag = NO;
    flyPoint = NO;
    flyFlag = 0;
}

@end
