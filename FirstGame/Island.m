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


+(NSMutableArray *)getIslandInit{
    return islands;
}

+(SKSpriteNode *)getIslands{
    
    return islands[islands.count - 1];
    
}

+(void)initTexture{
    islandsTexture = [NSMutableArray new];
    SKTexture *island1 = [SKTexture textureWithImageNamed:@"Island1.png"];
    SKTexture *island2 = [SKTexture textureWithImageNamed:@"Island2.png"];
    [islandsTexture addObject:island1];
    [islandsTexture addObject:island2];
}


+(void)setIslandInitFrame:(CGRect)frame{
    
    
    islands = [NSMutableArray new];
    
    SKSpriteNode *island1 = [SKSpriteNode spriteNodeWithTexture:islandsTexture[0]];
    island1.size = CGSizeMake(island1.size.width*1.2, island1.size.height*1.2);
    island1.position = CGPointMake(CGRectGetMidX(frame)/2,CGRectGetMidY(frame)-40);
    [islands addObject:island1];
    SKSpriteNode *island2 = [SKSpriteNode spriteNodeWithTexture:islandsTexture[1]];
    island2.size = CGSizeMake(island2.size.width*1.2, island2.size.height*1.2);
    island2.position = CGPointMake(CGRectGetMidX(frame)*3/2,CGRectGetMidY(frame)-40);
    [islands addObject:island2];

}

+(void)setIslandFrame:(CGRect)frame{
    
    if(islands == nil){
        islands = [NSMutableArray new];
    }

    
    SKSpriteNode *island;
    
    if (arc4random_uniform(2) == 0) {
        island = [SKSpriteNode spriteNodeWithTexture:islandsTexture[0]];
        island.size = CGSizeMake(island.size.width*1.2, island.size.height*1.2);
        island.position = CGPointMake(CGRectGetMaxX(frame) + island.size.width / 2 ,CGRectGetMidY(frame)/2+arc4random_uniform(50));
        
    }else{
        
        island = [SKSpriteNode spriteNodeWithTexture:islandsTexture[1]];
        island.size = CGSizeMake(island.size.width*1.2, island.size.height*1.2);
        island.position = CGPointMake(CGRectGetMaxX(frame) + island.size.width / 2,CGRectGetMidY(frame)/2+arc4random_uniform(50));
   
    }
    
    [islands addObject:island];
}



+(void)moveIslandInit{
    [islands[islands.count- 2] runAction:[SKAction sequence:@[[SKAction moveToX: -300 duration:20],[SKAction removeFromParent]]]];
    [islands[islands.count- 1] runAction:[SKAction sequence:@[[SKAction moveToX: -300 duration:30],[SKAction removeFromParent]]]];
}

+(void)moveIsland{
    [islands[islands.count - 1] runAction:[SKAction sequence:@[[SKAction moveToX: -300 duration:30],[SKAction removeFromParent]]]];
}

+(BOOL)removeIsland{
    
    if(islands == nil){
        return NO;
    }
    
    SKSpriteNode *island = islands[0];
    
    if(island.position.x < 0 - island.size.width ){
        [island removeFromParent];
        [islands removeObjectAtIndex:0];
        
        if(islands == nil){
            islands = [NSMutableArray new];
        }

        return YES;

    }
    
    return NO;
    

    

}


@end
