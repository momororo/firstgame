//
//  Sea.m
//  FirstGame
//
//  Created by yasutomo on 2014/06/02.
//  Copyright (c) 2014年 sacrew. All rights reserved.
//

#import "Sea.h"

@implementation Sea

+(NSMutableArray *)getSeaInit{
    return seas;
}

+(SKSpriteNode *)getSeas{
    return seas[seas.count -1];
}

+(void)initTexture{
    seasTexture = [NSMutableArray new];
    
    SKTexture *sea = [SKTexture textureWithImageNamed:@"sea.png"];
    [seasTexture addObject:sea];
}

+(void)setSeasInitFrame:(CGRect)frame{
    
    seas = [NSMutableArray new];
    
    SKSpriteNode *nami1 = [SKSpriteNode spriteNodeWithTexture:seasTexture[0]];
    nami1.size = CGSizeMake(CGRectGetMaxX(frame), CGRectGetMaxY(frame));
    nami1.position = CGPointMake(CGRectGetMidX(frame), CGRectGetMidX(frame));
    [seas addObject:nami1];
    SKSpriteNode *nami2 = [SKSpriteNode spriteNodeWithTexture:seasTexture[0]];
    nami2.position = CGPointMake(CGRectGetMaxX(frame), CGRectGetMaxY(frame));
    nami2.position = CGPointMake(CGRectGetMidY(frame)/2, CGRectGetMidY(frame)/2);
    [seas addObject:nami2];
    
}

+(void)setSeaFrame:(CGRect)frame{
    
    if (seas == nil) {
        seas = [NSMutableArray new];
    }
    
    SKSpriteNode *nami;
    
    if (arc4random_uniform(2) == 0) {
        nami = [SKSpriteNode spriteNodeWithTexture:seasTexture[0]];
        nami.size = CGSizeMake(nami.size.width, nami.size.height);
        nami.position = CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame));
    }else{
        nami = [SKSpriteNode spriteNodeWithTexture:seasTexture[1]];
        nami.size = CGSizeMake(nami.size.width,nami.size.height);
        nami.position = CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame));
    }
    [seas addObject:nami];
}


+(void)moveSeaInit{
    [seas [seas.count - 2]runAction:[SKAction sequence:@[[SKAction moveToY:-50 duration:5]]]];
    [seas [seas.count - 1]runAction:[SKAction sequence:@[[SKAction moveToY:-50 duration:10]]]];
}

+(void)moveSea{
    [seas [seas.count - 1] runAction:[SKAction sequence:@[[SKAction moveToY:-50 duration:10]]]];
}

+(BOOL)removeSea{
    if (seas == nil) {
        return NO;
    }
    
    SKSpriteNode *sea = seas[0];
    
    if (sea.position.y < 0 - sea.size.width) {
        [sea removeFromParent];
        [seas removeObjectAtIndex:0];
        
        if (seas == nil) {
            seas = [NSMutableArray new];
        }
    }
    return NO;
}

@end
