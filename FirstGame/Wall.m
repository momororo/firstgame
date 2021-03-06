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

+(void)initTexture{
    wallTexture = [SKTexture textureWithImageNamed:@"hyouzan"];
}

+(void)setWallFromNextGround:(SKSpriteNode *) nextGround{

    if(walls == nil){
        walls = [NSMutableArray new];
    }
    
    SKSpriteNode *wall = [SKSpriteNode spriteNodeWithTexture:wallTexture];
    wall.size = CGSizeMake(wall.frame.size.width/3,wall.frame.size.height/3);
    
    randam = arc4random_uniform(nextGround.size.width/2.2);
    
    //移動に使う変数に保存
    nextGroundWidth = nextGround.size.width;
    
    wall.position = CGPointMake(nextGround.position.x - (randam), ((nextGround.size.height)/2 + (wall.size.height/2)));
    wall.zPosition = 50;
    
    wall.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(wall.size.width/3.5, wall.size.height)];
    wall.physicsBody.restitution = 0;
    
    wall.physicsBody.categoryBitMask = wallCategory;
    wall.physicsBody.collisionBitMask = groundCategory;
    wall.physicsBody.contactTestBitMask = flyingPlayerCategory;
    
    //効果音の初期設定
    bombSE = [SKAction playSoundFileNamed:@"attackedWall.mp3" waitForCompletion:NO];
    
    [walls addObject:wall];
    
    
}





+(void)set2WallFromNextGround:(SKSpriteNode *) nextGround{
    
    if(walls == nil){
        walls = [NSMutableArray new];
    }
    
    SKSpriteNode *wall = [SKSpriteNode spriteNodeWithTexture:wallTexture];
    wall.size = CGSizeMake(wall.frame.size.width/3,wall.frame.size.height/3);
    
    randam = arc4random_uniform(nextGround.size.width/2.2);
    
    //移動に使う変数に保存
    nextGroundWidth = nextGround.size.width;
    
    //両端に壁が配置されるよう調整
    if (arc4random_uniform(2) == 0) {
        randam = -1 * randam;
    }
    
    wall.position = CGPointMake(nextGround.position.x - (randam), ((nextGround.size.height)/2 + (wall.size.height/2)));
    wall.zPosition = 50;
    wall.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(wall.size.width/3.5, wall.size.height)];
    wall.physicsBody.restitution = 0;
    
    wall.physicsBody.categoryBitMask = wallCategory;
    wall.physicsBody.collisionBitMask = groundCategory;
    wall.physicsBody.contactTestBitMask = flyingPlayerCategory;
    
    //効果音の初期設定
    bombSE = [SKAction playSoundFileNamed:@"attackedWall.mp3" waitForCompletion:NO];
    
    [walls addObject:wall];
    
    
}

+(void)moveWallDuration:(float)duration{
        SKSpriteNode *wall = walls[walls.count-1];
        [wall
         runAction:[SKAction sequence:@[[SKAction moveToX: -1500 + (nextGroundWidth/2) - randam duration:duration],[SKAction removeFromParent]]]];
    
}

//壁の初期化
+(void)initWalls{
    walls = nil;
}

//アクションを終えた壁の削除
+(void)removeOldWall{
    
    if([walls[0] hasActions] == NO){
        
        [walls removeObjectAtIndex:0];

        //配列が0になった後に壁が生成されると落ちる可能性があるため、念のため
        if(walls.count == 0){
            walls = nil;
        }

    }
    
}

//攻撃を受けた壁の削除
+(void)removeAttackedWall:(SKNode *)AttackedWall{
    
    //攻撃を受けた壁と配列の中にある壁のマッチング
    for (int i = 0; i < walls.count; i++) {
        
        if(AttackedWall == walls[i]){
            
            //壁の爆発音
            [walls[i] runAction:bombSE];

            //親ノードから削除
            [walls[i] removeFromParent];
            //配列から削除
            [walls removeObjectAtIndex:i];
            //配列が0になった場合、一旦nilにしないと次の壁の追加で落ちるらしい。
            if(walls.count == 0){
                walls = nil;
            }
            return;
        }
    }
}




@end
