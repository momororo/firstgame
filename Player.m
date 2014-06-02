//
//  Player.m
//  FirstGame
//
//  Created by yasutomo on 2014/06/02.
//  Copyright (c) 2014年 sacrew. All rights reserved.
//

#import "Player.h"

@implementation Player

+(SKSpriteNode *)getPlayer{
    return player;
}

+(void)setPlayerPositionX:(float)positionX positionY:(float)positionY{
    //プレイキャラの設定
    player = [SKSpriteNode spriteNodeWithImageNamed:@"pengin1.png"];
    player.size = CGSizeMake(player.size.width/4, player.size.height/4);
    player.name = @"kPlayer";
    player.position = CGPointMake(positionX, positionY);
    [self setNormalPhysicsBody];
    
    //効果音の初期設定
    jumpSE = [SKAction playSoundFileNamed:@"jump.wav" waitForCompletion:NO];

    
}
+(void)walkAction{
    
    if(jumpFlag == NO){

    //歩行モーション
    SKTexture *pengin1 = [SKTexture textureWithImageNamed:@"pengin1"];
    SKTexture *pengin2 = [SKTexture textureWithImageNamed:@"pengin2"];
    SKAction *walkPengin = [SKAction animateWithTextures:@[pengin1,pengin2] timePerFrame:0.1];
    [player runAction:[SKAction repeatActionForever:walkPengin]];
    
    //ジャンプ可能フラグをオンに
        jumpFlag = YES;
    }
    
}


+(void)jumpOrSmashAction{
    
    if(jumpFlag == YES){
        
        //ジャンプ処理
        player.physicsBody.velocity = CGVectorMake(0, 700);
        
        //ジャンプモーション
        SKTexture *pengin3 = [SKTexture textureWithImageNamed:@"pengin3"];
        SKTexture *pengin4 = [SKTexture textureWithImageNamed:@"pengin4"];
        SKAction *jumpPengin = [SKAction animateWithTextures:@[pengin3,pengin4] timePerFrame:0.1];
        [player runAction:[SKAction repeatActionForever:jumpPengin]];
        
        [player runAction:jumpSE];
        
        //ジャンプ可能フラグをNOにする
        jumpFlag = NO;
        //突進可能フラグをYESにする
        smashFlag = YES;
        
        return;
    }
    
    if (jumpFlag == NO && smashFlag == YES) {
        
        //突進処理
        player.physicsBody.velocity = CGVectorMake(0, -300);
        
        SKTexture *pengin5 = [SKTexture textureWithImageNamed:@"pengin5"];
        SKAction *smashPengin = [SKAction animateWithTextures:@[pengin5] timePerFrame:0.1];
        [player runAction:[SKAction repeatActionForever:smashPengin]];
        
        smashFlag = NO;
        
        //突進用のビットマスクに変更
        [self setSmashPhysicsBody];
        
        //炎のパーティクルを出す
        //処理が重いため保留
        //[self makeFireParticle:sprite.position];
        
        return;
    }

    
}
+(void)setNormalPhysicsBody{
    player.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:player.size];
    player.physicsBody.allowsRotation = NO;
    player.physicsBody.affectedByGravity = YES;
    player.physicsBody.restitution = 0;
    player.physicsBody.categoryBitMask = playerCategory;
    player.physicsBody.collisionBitMask = groundCategory | wallCategory;
    player.physicsBody.contactTestBitMask = groundCategory;
}
+(void)setSmashPhysicsBody{
    
}

@end
