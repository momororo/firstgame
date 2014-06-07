//
//  Fish.m
//  FirstGame
//
//  Created by 新井脩司 on 2014/06/07.
//  Copyright (c) 2014年 sacrew. All rights reserved.
//

#import "Fish.h"

//SKTexture *_fishTexture;

@implementation Fish

+(SKSpriteNode *)getFish{
    return fish;
}

+(void)setFishPositionX:(float)positionX PositionY:(float)positionY{
    
    
 //   _fishTexture = [SKTexture textureWithImageNamed:@"Fish.png"];
    
    fish = [SKSpriteNode spriteNodeWithImageNamed:@"Fish.png"];//spriteNodeWithTexture:_fishTexture];
    fish.position = CGPointMake(positionX,positionY);
    fish.name = @"kFish";
    
    //物理シュミレーション
    fish.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:fish.size];
    
    //接触設定
    //カテゴリー(隕石)
    fish.physicsBody.categoryBitMask = fishCategory;
    //ヒットテストするオブジェクト(宇宙船/ミサイル)
    fish.physicsBody.contactTestBitMask = playerCategory;
    //接触できるオブジェク
    fish.physicsBody.collisionBitMask = 0;
    //下方向に回転させて発射
    fish.physicsBody.velocity = CGVectorMake(-800,500);
    [fish.physicsBody applyTorque:0.04];      //回転
    

}

+(void)removeFish:(SKNode *)goodbyFish{
    [fish removeFromParent];
}

@end
