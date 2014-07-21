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
    [islandsTexture addObject:island1];
    [islandsTexture addObject:island2];
}


+(void)setIslandInitFrame:(CGRect)frame{
    
    
    islands = [NSMutableArray new];
    
    SKSpriteNode *island1 = [SKSpriteNode spriteNodeWithTexture:islandsTexture[0]];
    island1.size = CGSizeMake(island1.size.width/1.5, island1.size.height/1.5);
    island1.position = CGPointMake(CGRectGetMidX(frame)/2,CGRectGetMidY(frame));
    [islands addObject:island1];
    SKSpriteNode *island2 = [SKSpriteNode spriteNodeWithTexture:islandsTexture[1]];
    island2.size = CGSizeMake(island2.size.width/1.5, island2.size.height/1.5);
    island2.position = CGPointMake(CGRectGetMidX(frame)*3/2,CGRectGetMidY(frame));
    [islands addObject:island2];

}

+(void)setIslandFrame:(CGRect)frame{
    
    if(islands == nil){
        islands = [NSMutableArray new];
    }

    
    SKSpriteNode *island;
    
    if (arc4random_uniform(2) == 0) {
        island = [SKSpriteNode spriteNodeWithTexture:islandsTexture[0]];
        //island.size = CGSizeMake(island.size.width*1.2, island.size.height*1.2);
        island.position = CGPointMake(CGRectGetMaxX(frame) + island.size.width / 2 ,CGRectGetMidY(frame)+arc4random_uniform(60)-30);
        
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
        
        
        /*
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
        */
        
        
        
        
    }else{
        
        island = [SKSpriteNode spriteNodeWithTexture:islandsTexture[1]];
        //island.size = CGSizeMake(island.size.width*1.2, island.size.height*1.2);
        island.position = CGPointMake(CGRectGetMaxX(frame) + island.size.width / 2,CGRectGetMidY(frame)+arc4random_uniform(60)-30);
        
        //出現する位置(ｙ軸)によって、ノードの大きさを変更
        //画面中央(CGRectGetMidY(frame))のｙ座標を０として考える
        
        //基準より＋２１〜３０の位置にノードがある時
        if (CGRectGetMidY(frame)+20 < island.position.y && island.position.y <= CGRectGetMidY(frame)+30){
            island.size = CGSizeMake(island.size.width/0.3, island.size.height/0.3);
            NSLog(@"20-30=%@",NSStringFromCGPoint(island.position));

            //基準より＋１１〜２０の位置にノードがある時
        }else if(CGRectGetMidY(frame)+10 < island.position.y && island.position.y <= CGRectGetMidY(frame)+20){
            island.size = CGSizeMake(island.size.width/2, island.size.height/2);
            NSLog(@"10-20=%@",NSStringFromCGPoint(island.position));
            //基準より＋１〜１０の位置にノードがある時
        }else if(CGRectGetMidY(frame) < island.position.y && island.position.y <= CGRectGetMidY(frame)+10){
            island.size = CGSizeMake(island.size.width/0.8, island.size.height/0.8);
            NSLog(@"0-10=%@",NSStringFromCGPoint(island.position));
            //基準と同じ位置にノードがある時
        }else if(island.position.y == CGRectGetMidY(frame)){
            island.size = CGSizeMake(island.size.width, island.size.height);
            NSLog(@"0=%@",NSStringFromCGPoint(island.position));
            //基準よりー１０〜ー１の位置にノードがある時
        }else if(CGRectGetMidY(frame)-10 <= island.position.y && island.position.y < CGRectGetMidY(frame)){
            island.size = CGSizeMake(island.size.width/1.1, island.size.height/1.1);
            NSLog(@"-10-0=%@",NSStringFromCGPoint(island.position));
            //基準よりー２０〜ー１１の位置にノードがある時
        }else if(CGRectGetMidY(frame)-20 <= island.position.y && island.position.y < CGRectGetMidY(frame)-10){
            island.size = CGSizeMake(island.size.width/1.2, island.size.height/1.2);
            NSLog(@"-20-10=%@",NSStringFromCGPoint(island.position));
            //基準よりー３０〜ー２１の位置にノードがある時
        }else if(CGRectGetMidY(frame)-30 <= island.position.y && island.position.y < CGRectGetMidY(frame)-20){
            island.size = CGSizeMake(island.size.width/1.3, island.size.height/1.3);
            NSLog(@"-30-20=%@",NSStringFromCGPoint(island.position));
        }
   
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
