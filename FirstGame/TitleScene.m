//
//  MyScene.m
//  FirstGame
//
//  Created by 新井脩司 on 2014/05/20.
//  Copyright (c) 2014年 sacrew. All rights reserved.
//

#import "TitleScene.h"
#import "GameView.h"

@implementation TitleScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        
        SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        
        myLabel.text = @"タイトル画面";
        myLabel.fontSize = 10;
        myLabel.position = CGPointMake(CGRectGetMinX(self.frame),CGRectGetMinY(self.frame));
        myLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
        
        
        [self addChild:myLabel];

        //点滅アクション
        SKLabelNode *start = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        start.fontSize = 20;
        start.text = @"タップでスタート！";
        start.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame));
        [self addChild:start];
        
        
        
        
        
        
        
        
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    if ([_delegate respondsToSelector:@selector(sceneEscape:identifier:)]) {
        [_delegate sceneEscape:self identifier:nil];
    }
}


-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
