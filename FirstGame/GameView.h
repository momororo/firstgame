//
//  GameView.h
//  FirstGame
//
//  Created by 新井脩司 on 2014/05/20.
//  Copyright (c) 2014年 sacrew. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface GameView : SKView

-(void)setUpGameView;
-(void)switchingTitleScene;
-(void)switchingGameScene;
-(void)switchingResultScene;

@end

@protocol SceneEscapeProtocol <NSObject>

-(void)sceneEscape:(SKScene *)scene;

@end