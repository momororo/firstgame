//
//  Fish.m
//  FirstGame
//
//  Created by 新井脩司 on 2014/06/07.
//  Copyright (c) 2014年 sacrew. All rights reserved.
//

#import "Fish.h"

//SKTexture *_fishTexture;

@implementation Fish

//魚のノードを返す
+(NSMutableArray *)getFishes{
    return fishes;
}

//追加した魚の数量を返す
+(int)getFishQuantity{
    
    return fishQuantity;
}

//魚のテクスチャを生成
+(void)initTexture{
    
    fishTexture = [SKTexture textureWithImageNamed:@"Fish"];

}



+(void)setFishPositionX:(float)positionX PositionY:(float)positionY{
    
    
    //おまじない
    if(fishes == nil){
        fishes = [NSMutableArray new];
    }
    
    
    //乱数で生成する数を決める。0が出たらどうなるかわからないので1プラスしてます。
    fishQuantity = arc4random_uniform(100) + 50;
    
    for(int tmp = 0 ; tmp < fishQuantity ; tmp++){
       SKSpriteNode *fish = [SKSpriteNode spriteNodeWithTexture:fishTexture];
        //出現位置を乱数で少しずらす
        fish.position = CGPointMake(positionX + arc4random_uniform(300),positionY + arc4random_uniform(100));
        
        fish.name = @"kFish";
        
        //物理シュミレーション
        fish.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:fish.size];
        
        //接触設定
        //カテゴリー(魚)
        fish.physicsBody.categoryBitMask = fishCategory;
        //ヒットテストするオブジェクト(プレイヤー)
        fish.physicsBody.contactTestBitMask = playerCategory | flyingPlayerCategory;
        //接触できるオブジェクト
        fish.physicsBody.collisionBitMask = 0;
        
        //配列に追加
        [fishes addObject:fish];
        

        
/*
        //下方向に回転させて発射
        fish.physicsBody.velocity = CGVectorMake(-800,500);
        [fish.physicsBody applyTorque:0.04];      //回転
*/
        
    }

}

+(void)moveFish{
    
    for(int tmp = 0; tmp < fishQuantity;tmp++){
        SKSpriteNode *fish = fishes[fishes.count - tmp - 1];
        fish.physicsBody.velocity = CGVectorMake(-1000,arc4random_uniform(400)+500);
        [fish.physicsBody applyTorque:0.04];      //回転
    }
    
}

//食べられた魚の削除
+(void)removeEatenFish:(SKNode *)EatenFish{
    
    //食べられた魚と配列の中にある魚のマッチング
    for (int i = 0; i < fishes.count; i++) {
        
        if(EatenFish == fishes[i]){
            //親ノードから削除
            [fishes[i] removeFromParent];
            //配列から削除
            [fishes removeObjectAtIndex:i];
            //配列が0になった場合、一旦nilにしないと次の壁の追加で落ちるらしい。
            if(fishes.count == 0){
                fishes = nil;
            }
            return;
        }
    }
}


//画面外の魚を削除
+(void)removeFish{
    
    //配列がnilの場合は何もせず終了
    if(fishes == nil){
        return;
    }
    
    SKSpriteNode *fish = fishes[0];
    //値は仮うち
    if(fish.position.x <= -30 && fish.position.y <= -50){
        [fish removeFromParent];
        [fishes removeObjectAtIndex:0];
        
        //おまじない
        if(fishes.count == 0){
            fishes = nil;
        }
        
    }

}

@end
