//
//  Cloud.m
//  FirstGame
//
//  Created by 新井脩司 on 2014/06/13.
//  Copyright (c) 2014年 sacrew. All rights reserved.
//

#import "Cloud.h"
#import "Sea.h"

@implementation Cloud

+(NSMutableArray *)getCloudInit{
    return clouds;
}

+(SKSpriteNode *)getClouds{
    
    return clouds[clouds.count - 1];
    
}


+(void)setCloudInitFrame:(CGRect)frame{
    
    
    clouds = [NSMutableArray new];
    
    SKSpriteNode *cloud1 = [SKSpriteNode spriteNodeWithImageNamed:@"Cloud1.png"];
    cloud1.position = CGPointMake(CGRectGetMidX(frame)/2,sea.size.height*2);
    [clouds addObject:cloud1];
    SKSpriteNode *cloud2 = [SKSpriteNode spriteNodeWithImageNamed:@"Cloud2.png"];
    cloud2.position = CGPointMake(CGRectGetMidX(frame)*3/2,sea.size.height*2);
    [clouds addObject:cloud2];
    
}

+(void)setCloudFrame:(CGRect)frame{
    
    if(clouds == nil){
        clouds = [NSMutableArray new];
    }
    
    
    SKSpriteNode *cloud;
    
    switch(arc4random_uniform(4)) {
        case 0:
            cloud = [SKSpriteNode spriteNodeWithImageNamed:@"Cloud1.png"];
            cloud.position = CGPointMake(CGRectGetMaxX(frame) + cloud.size.width / 2 ,sea.size.height);
            break;
            
        case 1:
            cloud = [SKSpriteNode spriteNodeWithImageNamed:@"Cloud2.png"];
            cloud.position = CGPointMake(CGRectGetMaxX(frame) + cloud.size.width / 2,sea.size.height);
            break;
        case 2:
            cloud = [SKSpriteNode spriteNodeWithImageNamed:@"Cloud3.png"];
            cloud.position = CGPointMake(CGRectGetMaxX(frame) + cloud.size.width / 2,sea.size.height);
            break;
        case 3:
            cloud = [SKSpriteNode spriteNodeWithImageNamed:@"Cloud4.png"];
            cloud.position = CGPointMake(CGRectGetMaxX(frame) + cloud.size.width / 2,sea.size.height);
            break;
            [clouds addObject:cloud];
    }
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
