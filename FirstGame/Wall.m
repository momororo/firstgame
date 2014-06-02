//
//  Wall.m
//  FirstGame
//
//  Created by yasutomo on 2014/06/02.
//  Copyright (c) 2014年 sacrew. All rights reserved.
//

#import "Wall.h"

@implementation Wall

+(SKSpriteNode *)getWall{
    
    return walls[walls.count - 1];
    
}

+(void)setWallFromNextGround:(SKSpriteNode *) nextGround{

    if(walls == nil){
        walls = [NSMutableArray new];
    }
    
    SKSpriteNode *wall = [SKSpriteNode spriteNodeWithImageNamed:@"hyouzan"];
    wall.size = CGSizeMake(wall.frame.size.width/2,wall.frame.size.height/2);
    
    int rand;
    rand = arc4random_uniform(nextGround.size.width/2);
    
    wall.position = CGPointMake(nextGround.position.x -(rand), ((nextGround.size.height/2) + (wall.size.height/2)));
    wall.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(wall.size.width/3.5, wall.size.height)];
    wall.physicsBody.restitution = 0;
    
    wall.physicsBody.categoryBitMask = wallCategory;
    wall.physicsBody.collisionBitMask = groundCategory;
    wall.physicsBody.contactTestBitMask = flyingPlayerCategory;
    
    [walls addObject:wall];
    
    
}

+(void)moveWallGroundDuration:(float)duration{
        SKSpriteNode *wall = walls[walls.count-1];
        [wall
         runAction:[SKAction sequence:@[[SKAction moveToX: -800 + (wall.size.width/2)duration:duration],[SKAction removeFromParent]]]];
    
}


@end
