//
//  Ground.m
//  FirstGame
//
//  Created by yasutomo on 2014/06/02.
//  Copyright (c) 2014年 sacrew. All rights reserved.
//

#import "Ground.h"

@implementation Ground


//グラウンドのNodeを返す
+(SKSpriteNode *)getGround{
    return ground;
}

+(SKSpriteNode *)getNextGround{
    return nextGrounds[nextGrounds.count-1];
}

//グラウンドのテクスチャの生成
+(void)initGroundTexture{
    SKTextureAtlas *grounds = [SKTextureAtlas atlasNamed:@"ground"];
    SKTexture *ground1 = [grounds textureNamed:@"ground1"];
    SKTexture *ground2 = [grounds textureNamed:@"ground2"];
    SKTexture *ground3 = [grounds textureNamed:@"ground3"];
    SKTexture *ground4 = [grounds textureNamed:@"ground4"];
    nextGroundTexture = [NSMutableArray new];
    [nextGroundTexture addObject:ground1];
    [nextGroundTexture addObject:ground2];
    [nextGroundTexture addObject:ground3];
    [nextGroundTexture addObject:ground4];

}

//グラウンドの初期設定
+(void)setGroundSizeX:(float)sizeX sizeY:(float)sizeY{

    
    //ground = [SKSpriteNode spriteNodeWithColor:[SKColor brownColor]
    //                                                    size:CGSizeMake(sizeX,sizeY)];
    ground = [SKSpriteNode spriteNodeWithTexture:nextGroundTexture[3]];
    ground.size = CGSizeMake(ground.size.width/2, ground.size.height/2);
    ground.name = @"kGround";
    ground.position = CGPointMake(ground.size.width/2,ground.size.height/2);
    
    //端の判定を甘くするように+10で調整
    ground.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(ground.size.width + 10, ground.size.height/2)];
    ground.physicsBody.affectedByGravity = NO;
    ground.physicsBody.restitution = 0;
    
    ground.physicsBody.categoryBitMask = groundCategory;
    ground.physicsBody.collisionBitMask = 0;
    ground.physicsBody.contactTestBitMask = 0;
    
    //ネクストグラウンドの初期化
    [self initGounds];

    
}

//グラウンドの動作を設定
+(void)moveGroundToX:(float)x duration:(float)duration{

    [ground runAction:[SKAction repeatActionForever:
                        [SKAction sequence:@[[SKAction moveToX:x duration:duration],
                                             [SKAction removeFromParent]]]]];

    
}

//ネクストグラウンドの設定
+(void)setNextGroundPositionX:(float)positionX{

    if(nextGrounds == nil){
        nextGrounds = [NSMutableArray new];
    }
    
    SKSpriteNode *nextGround;
    
    switch (arc4random_uniform(4)) {
        case 0 :
            nextGround = [SKSpriteNode spriteNodeWithTexture:nextGroundTexture[0]];
            break;
        case 1:
            nextGround = [SKSpriteNode spriteNodeWithTexture:nextGroundTexture[1]];
            break;
        case 2:
            nextGround = [SKSpriteNode spriteNodeWithTexture:nextGroundTexture[2]];
            break;
        case 3:
            nextGround = [SKSpriteNode spriteNodeWithTexture:nextGroundTexture[3]];
            break;
    }
    
    

    //床の長さ
    //nextGround.size = CGSizeMake(300 + arc4random_uniform(551),50+arc4random_uniform(101));
    nextGround.size = CGSizeMake(nextGround.size.width/2,nextGround.size.height/4);
    nextGround.name = @"kGround";

    
    nextGround.position =CGPointMake (positionX + (nextGround.size.width/2),arc4random_uniform(51));
    nextGround.zPosition = 40;
    
    nextGround.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(nextGround.size.width, nextGround.size.height/2)];
    nextGround.physicsBody.restitution = 0;
    nextGround.physicsBody.affectedByGravity = NO;
    
    //カテゴリー
    nextGround.physicsBody.categoryBitMask = groundCategory;
    //接触できるオブジェクト
    nextGround.physicsBody.collisionBitMask =  0;
    //ヒットテストするオブジェクト
    nextGround.physicsBody.contactTestBitMask = 0;
    
    [nextGrounds addObject:nextGround];
    
    
}

//nextGroundを移動する
+(void)moveNextGroundDuration:(float)duration{
    SKSpriteNode *nextGround = nextGrounds[nextGrounds.count-1];
    [nextGround
     runAction:[SKAction sequence:@[[SKAction moveToX: -800 + (nextGround.size.width/2)duration:duration],[SKAction removeFromParent]]]];
}


//グラウンドクラスの初期化
//グラウンド配列のみ
+(void)initGounds{
    nextGrounds = nil;
}

//アクションを終えたネクストグラウンドの削除
+(void)removeOldNextGround{
    
    if([nextGrounds[0] hasActions] == NO){
        [nextGrounds removeObjectAtIndex:0];
        
        //配列が0になった後に床が生成されると落ちる可能性があるため、念のため
        if(nextGrounds.count == 0){
            nextGrounds = nil;
        }
    }
    
}

@end
