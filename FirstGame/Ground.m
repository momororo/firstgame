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

//グラウンドの初期設定
+(void)setGroundSizeX:(float)sizeX sizeY:(float)sizeY{

    
    ground = [SKSpriteNode spriteNodeWithColor:[SKColor brownColor]
                                                        size:CGSizeMake(sizeX,sizeY)];
    ground.name = @"kGround";
    ground.position = CGPointMake(ground.size.width/2,ground.size.height/2);
    
    ground.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(ground.size.width, ground.size.height)];
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
    
    SKSpriteNode *nextGround = [SKSpriteNode spriteNodeWithImageNamed:@"ground2"];
    

    //床の長さ
    //nextGround.size = CGSizeMake(300 + arc4random_uniform(551),50+arc4random_uniform(101));
    nextGround.size = CGSizeMake(nextGround.size.width/2,nextGround.size.height/2);
    
    nextGround.position =CGPointMake (positionX + (nextGround.size.width/2),0);
    
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
