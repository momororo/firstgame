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
    
    SKTexture *cloud1 = [SKTexture textureWithImageNamed:@"cloud1.png"];
    SKTexture *cloud2 = [SKTexture textureWithImageNamed:@"cloud2.png"];
    SKTexture *cloud3 = [SKTexture textureWithImageNamed:@"cloud3.png"];
    SKTexture *cloud4 = [SKTexture textureWithImageNamed:@"cloud4.png"];
    [cloudsTexture addObject:cloud1];
    [cloudsTexture addObject:cloud2];
    [cloudsTexture addObject:cloud3];
    [cloudsTexture addObject:cloud4];
    
}


+(void)setCloudInitFrame:(CGRect)frame{
    
    
    clouds = [NSMutableArray new];
    
    SKSpriteNode *cloud1 = [SKSpriteNode spriteNodeWithTexture:cloudsTexture[0]];
    cloud1.position = CGPointMake(CGRectGetMidX(frame)/2,arc4random_uniform(100)+200);
    [clouds addObject:cloud1];
    SKSpriteNode *cloud2 = [SKSpriteNode spriteNodeWithTexture:cloudsTexture[1]];
    cloud2.position = CGPointMake(CGRectGetMidX(frame)*3/2,arc4random_uniform(100)+200);
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
            cloud.position = CGPointMake(CGRectGetMaxX(frame) + cloud.size.width / 2 ,arc4random_uniform(100)+200);
            break;
            
        case 1:
            cloud = [SKSpriteNode spriteNodeWithTexture:cloudsTexture[1]];
            cloud.position = CGPointMake(CGRectGetMaxX(frame) + cloud.size.width / 2,arc4random_uniform(100)+200);
            break;
        case 2:
            cloud = [SKSpriteNode spriteNodeWithTexture:cloudsTexture[2]];
            cloud.position = CGPointMake(CGRectGetMaxX(frame) + cloud.size.width / 2,arc4random_uniform(100)+200);
            break;
        case 3:
            cloud = [SKSpriteNode spriteNodeWithTexture:cloudsTexture[3]];
            cloud.position = CGPointMake(CGRectGetMaxX(frame) + cloud.size.width / 2,arc4random_uniform(100)+200);
            break;
    }
    
    //出現する位置(ｙ軸)によって、ノードの大きさを変更
    
    //基準より280〜320の位置にノードがある時
    if (280 < cloud.position.y && cloud.position.y <= 320){
        cloud.size = CGSizeMake(cloud.size.width/2, cloud.size.height/2);
        
        //基準より261〜280の位置にノードがある時
    }else if(260 < cloud.position.y && cloud.position.y <= 280){
        cloud.size = CGSizeMake(cloud.size.width/1.8, cloud.size.height/1.8);
        
        //基準より241〜260の位置にノードがある時
    }else if(240 < cloud.position.y && cloud.position.y <= 260){
        cloud.size = CGSizeMake(cloud.size.width/1.6, cloud.size.height/1.6);
        
        //基準より221〜240の位置にノードがある時
    }else if(220 < cloud.position.y && cloud.position.y <= 240){
        cloud.size = CGSizeMake(cloud.size.width/1.4, cloud.size.height/1.4);
        
        //基準より201〜220の位置にノードがある時
    }else if(200 < cloud.position.y && cloud.position.y <=220){
        cloud.size = CGSizeMake(cloud.size.width/1.2, cloud.size.height/1.2);
        //基準より200の位置にノードがある時
    }else if(cloud.position.y == 200){
        cloud.size = CGSizeMake(cloud.size.width, cloud.size.height);
    }
    
    [clouds addObject:cloud];
}



+(void)moveCloudInit{
    [clouds[clouds.count- 2] runAction:[SKAction sequence:@[[SKAction moveToX: -300 duration:30],[SKAction removeFromParent]]]];
    [clouds[clouds.count- 1] runAction:[SKAction sequence:@[[SKAction moveToX: -300 duration:40],[SKAction removeFromParent]]]];
}

+(void)moveCloud{
    [clouds[clouds.count - 1] runAction:[SKAction sequence:@[[SKAction moveToX: -300 duration:40],[SKAction removeFromParent]]]];
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
