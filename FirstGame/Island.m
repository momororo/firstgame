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
    SKTexture *island1 = [SKTexture textureWithImageNamed:@"island1.png"];
    SKTexture *island2 = [SKTexture textureWithImageNamed:@"island2.png"];
    SKTexture *island3 = [SKTexture textureWithImageNamed:@"island3.png"];
    [islandsTexture addObject:island1];
    [islandsTexture addObject:island2];
    [islandsTexture addObject:island3];
}


+(void)setIslandInitFrame:(CGRect)frame{
    
    
    islands = [NSMutableArray new];
    
    SKSpriteNode *island1 = [SKSpriteNode spriteNodeWithTexture:islandsTexture[0]];
    island1.size = CGSizeMake(island1.size.width/1.5, island1.size.height/1.5);
    island1.position = CGPointMake(CGRectGetMaxX(frame)*1/7,CGRectGetMidY(frame));
    [islands addObject:island1];
    
    SKSpriteNode *island2 = [SKSpriteNode spriteNodeWithTexture:islandsTexture[1]];
    island2.size = CGSizeMake(island2.size.width/1.4, island2.size.height/1.4);
    island2.position = CGPointMake(CGRectGetMaxX(frame)/2,CGRectGetMidY(frame)-20);
    [islands addObject:island2];
    
    SKSpriteNode *island3 = [SKSpriteNode spriteNodeWithTexture:islandsTexture[2]];
    island3.size = CGSizeMake(island3.size.width/2, island3.size.height/2);
    island3.position = CGPointMake(CGRectGetMaxX(frame)*6/7,CGRectGetMidY(frame)+20);
    [islands addObject:island3];

}

+(void)setIslandFrame:(CGRect)frame{
    
    if(islands == nil){
        islands = [NSMutableArray new];
    }

    
    SKSpriteNode *island;
    int randomNumber = arc4random_uniform(3);
    
    if (randomNumber == 0) {
        island = [SKSpriteNode spriteNodeWithTexture:islandsTexture[0]];
        //island.size = CGSizeMake(island.size.width*1.2, island.size.height*1.2);
        island.position = CGPointMake(CGRectGetMaxX(frame) + island.size.width / 2 ,CGRectGetMidY(frame)+arc4random_uniform(60)-30);
    
    }else if(randomNumber == 1){
        
        island = [SKSpriteNode spriteNodeWithTexture:islandsTexture[1]];
        //island.size = CGSizeMake(island.size.width*1.2, island.size.height*1.2);
        island.position = CGPointMake(CGRectGetMaxX(frame) + island.size.width / 2,CGRectGetMidY(frame)+arc4random_uniform(60)-30);
       
    }else{
    
        island = [SKSpriteNode spriteNodeWithTexture:islandsTexture[2]];
        //island.size = CGSizeMake(island.size.width*1.2, island.size.height*1.2);
        island.position = CGPointMake(CGRectGetMaxX(frame) + island.size.width / 2,CGRectGetMidY(frame)+arc4random_uniform(60)-30);
    }
    
    //出現する位置(ｙ軸)によって、ノードの大きさを変更
    //画面中央(CGRectGetMidY(frame))のｙ座標を０として考える
    
    //基準より＋２１〜３０の位置にノードがある時
    if (CGRectGetMidY(frame)+20 < island.position.y && island.position.y <= CGRectGetMidY(frame)+30){
        island.size = CGSizeMake(island.size.width/2, island.size.height/2);
        
        //基準より＋１１〜２０の位置にノードがある時
    }else if(CGRectGetMidY(frame)+10 < island.position.y && island.position.y <= CGRectGetMidY(frame)+20){
        island.size = CGSizeMake(island.size.width/1.8, island.size.height/1.8);
        
        //基準より＋１〜１０の位置にノードがある時
    }else if(CGRectGetMidY(frame) < island.position.y && island.position.y <= CGRectGetMidY(frame)+10){
        island.size = CGSizeMake(island.size.width/1.6, island.size.height/1.6);
        
        //基準と同じ位置にノードがある時
    }else if(island.position.y == CGRectGetMidY(frame)){
        island.size = CGSizeMake(island.size.width/1.5, island.size.height/1.5);
        
        //基準よりー１０〜ー１の位置にノードがある時
    }else if(CGRectGetMidY(frame)-10 <= island.position.y && island.position.y < CGRectGetMidY(frame)){
        island.size = CGSizeMake(island.size.width/1.4, island.size.height/1.4);
        
        //基準よりー２０〜ー１１の位置にノードがある時
    }else if(CGRectGetMidY(frame)-20 <= island.position.y && island.position.y < CGRectGetMidY(frame)-10){
        island.size = CGSizeMake(island.size.width/1.2, island.size.height/1.2);
        //基準よりー３０〜ー２１の位置にノードがある時
    }else if(CGRectGetMidY(frame)-30 <= island.position.y && island.position.y < CGRectGetMidY(frame)-20){
        island.size = CGSizeMake(island.size.width, island.size.height);
    }
    
    [islands addObject:island];
}



+(void)moveIslandInit{
    [islands[islands.count- 3] runAction:[SKAction sequence:@[[SKAction moveToX: -300 duration:20],[SKAction removeFromParent]]]];
    [islands[islands.count- 2] runAction:[SKAction sequence:@[[SKAction moveToX: -300 duration:30],[SKAction removeFromParent]]]];
    [islands[islands.count- 1] runAction:[SKAction sequence:@[[SKAction moveToX: -300 duration:38],[SKAction removeFromParent]]]];
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
