//
//  SceneManager.m
//  FirstGame
//
//  Created by 新井脩司 on 2014/05/20.
//  Copyright (c) 2014年 sacrew. All rights reserved.
//

#import "SceneManager.h"

@implementation SceneManager

+(TitleScene *)titleScene:(CGSize)size{
    TitleScene *scene = [[TitleScene alloc] initWithSize:size];
    return scene;
}

+(GameScene *)gameScene:(CGSize)size{
    GameScene *scene = [[GameScene alloc]initWithSize:size];
    return scene;
}

+(ResultScene *)resultScene:(CGSize)size{
    ResultScene *scene = [[ResultScene alloc]initWithSize:size];
    return scene;
}

//シーンの変更
+(void)sceneCange:(SKView *)view
              New:(SKScene *)newScene
         Duration:(NSTimeInterval)sec{
    SKTransition *tr = [SKTransition fadeWithDuration:sec];
    [view presentScene:newScene transition:tr];
}

@end
