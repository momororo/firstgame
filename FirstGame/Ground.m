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

    
}

//グラウンドの動作を設定
+(void)moveGroundToX:(float)x duration:(float)duration{

    [ground runAction:[SKAction repeatActionForever:
                        [SKAction sequence:@[[SKAction moveToX:x duration:duration],
                                             [SKAction removeFromParent]]]]];

    
}

//
+(void)setNextGroundPositionX:(float)positionX{

    if(nextGrounds == nil){
        nextGrounds = [NSMutableArray new];
    }
    
    SKSpriteNode *nextGround = [SKSpriteNode spriteNodeWithImageNamed:@"ground2"];
    

    //床の長さ
    nextGround.size = CGSizeMake(300 + arc4random_uniform(551),50+arc4random_uniform(101));
    
    nextGround.position =CGPointMake (positionX + (nextGround.size.width/2),0);
    
    nextGround.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(nextGround.size.width, nextGround.size.height)];
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

+(void)moveNextGroundDuration:(float)duration{
    SKSpriteNode *nextGround = nextGrounds[nextGrounds.count-1];
    [nextGround
     runAction:[SKAction sequence:@[[SKAction moveToX: -800 + (nextGround.size.width/2)duration:duration],[SKAction removeFromParent]]]];
}




@end
