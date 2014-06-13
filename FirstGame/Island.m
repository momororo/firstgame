//
//  Island.m
//  FirstGame
//
//  Created by 新井脩司 on 2014/06/12.
//  Copyright (c) 2014年 sacrew. All rights reserved.
//

#import "Island.h"
#import "Sea.h"

@implementation Island

+(SKSpriteNode *)getIsland1{
    
    return island1;
    
}

+(SKSpriteNode *)getIsland2{
    
    return island2;

}

+(void)setIsland1Frame:(CGRect)frame{
    island1 = [SKSpriteNode spriteNodeWithImageNamed:@"Island1.png"];
    island1.position = CGPointMake(CGRectGetMidX(frame)/2,sea.size.height);
}

+(void)setIsland2Frame:(CGRect)frame{
    island2 = [SKSpriteNode spriteNodeWithImageNamed:@"Island2.png"];
    island2.position = CGPointMake(CGRectGetMidX(frame)*3/2,sea.size.height);
}

+(void)moveIsland1{
    SKSpriteNode *island = island1;
    [island runAction:[SKAction sequence:@[[SKAction moveToX: -300 duration:20],[SKAction removeFromParent]]]];
}

+(void)moveIsland2{
    SKSpriteNode *island = island2;
    [island runAction:[SKAction sequence:@[[SKAction moveToX: -300 duration:40],[SKAction removeFromParent]]]];
}


@end
