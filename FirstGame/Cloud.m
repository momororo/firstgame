//
//  Cloud.m
//  FirstGame
//
//  Created by 新井脩司 on 2014/06/13.
//  Copyright (c) 2014年 sacrew. All rights reserved.
//

#import "Cloud.h"

@implementation Cloud

+(NSMutableArray *)getCloudInit{
    return clouds;
}

+(SKSpriteNode *)getClouds{
    
    return clouds[clouds.count - 1];
    
}

+(void)initTexture{
    cloudsTexture = [NSMutableArray new];
    
    SKTexture *cloud1 = [SKTexture textureWithImageNamed:@"Cloud1.png"];
    SKTexture *cloud2 = [SKTexture textureWithImageNamed:@"Cloud2.png"];
    SKTexture *cloud3 = [SKTexture textureWithImageNamed:@"Cloud3.png"];
    SKTexture *cloud4 = [SKTexture textureWithImageNamed:@"Cloud4.png"];
    [cloudsTexture addObject:cloud1];
    [cloudsTexture addObject:cloud2];
    [cloudsTexture addObject:cloud3];
    [cloudsTexture addObject:cloud4];
    
}


+(void)setCloudInitFrame:(CGRect)frame{
    
    
    clouds = [NSMutableArray new];
    
    SKSpriteNode *cloud1 = [SKSpriteNode spriteNodeWithTexture:cloudsTexture[0]];
    cloud1.position = CGPointMake(CGRectGetMidX(frame)/2,arc4random_uniform(150)+150);
    [clouds addObject:cloud1];
    SKSpriteNode *cloud2 = [SKSpriteNode spriteNodeWithTexture:cloudsTexture[1]];
    cloud2.position = CGPointMake(CGRectGetMidX(frame)*3/2,arc4random_uniform(150)+150);
    [clouds addObject:cloud2];
    
}

+(void)setCloudFrame:(CGRect)frame{
    
    if(clouds == nil){
        clouds = [NSMutableArray new];
    }
    
    
    SKSpriteNode *cloud;
    
    switch(arc4random_uniform(4)) {
        case 0:
            cloud = [SKSpriteNode spriteNodeWithTexture:cloudsTexture[0]];
            cloud.position = CGPointMake(CGRectGetMaxX(frame) + cloud.size.width / 2 ,arc4random_uniform(150)+150);
            break;
            
        case 1:
            cloud = [SKSpriteNode spriteNodeWithTexture:cloudsTexture[1]];
            cloud.position = CGPointMake(CGRectGetMaxX(frame) + cloud.size.width / 2,arc4random_uniform(150)+150);
            break;
        case 2:
            cloud = [SKSpriteNode spriteNodeWithTexture:cloudsTexture[2]];
            cloud.position = CGPointMake(CGRectGetMaxX(frame) + cloud.size.width / 2,arc4random_uniform(150)+150);
            break;
        case 3:
            cloud = [SKSpriteNode spriteNodeWithTexture:cloudsTexture[3]];
            cloud.position = CGPointMake(CGRectGetMaxX(frame) + cloud.size.width / 2,arc4random_uniform(150)+150);
            break;
    }
    [clouds addObject:cloud];
}



+(void)moveCloudInit{
    [clouds[clouds.count- 2] runAction:[SKAction sequence:@[[SKAction moveToX: -300 duration:20],[SKAction removeFromParent]]]];
    [clouds[clouds.count- 1] runAction:[SKAction sequence:@[[SKAction moveToX: -300 duration:20],[SKAction removeFromParent]]]];
}

+(void)moveCloud{
    [clouds[clouds.count - 1] runAction:[SKAction sequence:@[[SKAction moveToX: -300 duration:20],[SKAction removeFromParent]]]];
}

+(BOOL)removeCloud{
    
    if(clouds == nil){
        return NO;
    }
    
    SKSpriteNode *cloud = clouds[0];
    
    if(cloud.position.x < 0 - cloud.size.width ){
        [cloud removeFromParent];
        [clouds removeObjectAtIndex:0];
        
        if(clouds == nil){
            clouds = [NSMutableArray new];
        }
        
        return YES;
        
    }
    
    return NO;
    
    
    
    
}


@end
