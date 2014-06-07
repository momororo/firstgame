//
//  Fish.m
//  FirstGame
//
//  Created by 新井脩司 on 2014/06/07.
//  Copyright (c) 2014年 sacrew. All rights reserved.
//

#import "Fish.h"
#import "Player.h"

@implementation Fish

//魚のノードを返す
+(SKSpriteNode *)getFish{
    return fish;
}

+(void)setFishPositionX:(float)positionX positionY:(float)positionY{
    //魚の設定
    fish = [SKSpriteNode spriteNodeWithImageNamed:@"Fish.png"];
    fish.size = CGSizeMake(fish.size.width, fish.size.height);
    fish.name = @"kFish";
    fish.position = CGPointMake(positionX, positionY);
    //物理処理
    fish.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:fish.size];
    fish.physicsBody.allowsRotation = YES;
    
    fish.physicsBody.categoryBitMask = fishCategory;
    fish.physicsBody.collisionBitMask = 0;
    fish.physicsBody.contactTestBitMask = 0;
    
    SKAction *hopAction = [SKAction sequence: @[[SKAction performSelector:@selector(hopFish) onTarget:self],[SKAction waitForDuration:0.8 withRange:0.6]]];
    [fish runAction:[SKAction repeatActionForever:hopAction]];
    
}

+(void)hopFish{
        fish.physicsBody.velocity = CGVectorMake(-700, 500);
        [fish.physicsBody applyTorque:0.02];
}

@end
