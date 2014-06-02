//
//  Ground.m
//  FirstGame
//
//  Created by yasutomo on 2014/06/02.
//  Copyright (c) 2014年 sacrew. All rights reserved.
//

#import "Ground.h"

@implementation Ground


+(SKSpriteNode *)getGround{
    return ground;
}

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

+(void)moveGroundToX:(float)x duration:(float)duration{
    
    [ground runAction:[SKAction repeatActionForever:
                        [SKAction sequence:@[[SKAction moveToX:x duration:duration],
                                             [SKAction removeFromParent]]]]];

    
}


@end
