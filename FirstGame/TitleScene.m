//
//  MyScene.m
//  FirstGame
//
//  Created by 新井脩司 on 2014/05/20.
//  Copyright (c) 2014年 sacrew. All rights reserved.
//

#import "TitleScene.h"
#import "GameView.h"

SKSpriteNode *start;
SKSpriteNode *tutorial;
SKSpriteNode *tutorial1;
SKSpriteNode *ranking;
SKSpriteNode *next;
float score;

@implementation TitleScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
        SKSpriteNode *top = [SKSpriteNode spriteNodeWithImageNamed:@"top.png"];
        top.size = CGSizeMake(self.frame.size.width, self.frame.size.height);
        top.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        [self addChild:top];

        start = [SKSpriteNode spriteNodeWithImageNamed:@"start.png"];
        start.size = CGSizeMake(start.size.width, start.size.height);
        start.position = CGPointMake(426, 160);
        [self addChild:start];
        
        tutorial = [SKSpriteNode spriteNodeWithImageNamed:@"tutorial.png"];
        tutorial.size = CGSizeMake(tutorial.size.width, tutorial.size.height);
        tutorial.position = CGPointMake(426, 110);
        [self addChild:tutorial];
        
        ranking = [SKSpriteNode spriteNodeWithImageNamed:@"ranking.png"];
        ranking.size = CGSizeMake(ranking.size.width, ranking.size.height);
        ranking.position = CGPointMake(426, 60);
        [self addChild:ranking];
        
        
        //点滅アクション
       /* SKLabelNode *start = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        start.fontSize = 20;
        start.text = @"タップでスタート！";
        start.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame));
        [self addChild:start];
        
        
        NSLog(@"%@",NSStringFromCGSize(self.frame.size));
        */
        
        //ハイスコア読込
        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
        score = [userDefaults floatForKey:@"score"];
        
        //スコアをどこかに表示？？
        
        
    }
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    //タップした座標を取得する
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    //スタートノードをタップした時の命令
    if ([start containsPoint:location]) {
        //タップされた画像に変更
        start = [SKSpriteNode spriteNodeWithImageNamed:@"start_taped.png"];
        if ([_delegate respondsToSelector:@selector(sceneEscape:identifier:)]) {
            [_delegate sceneEscape:self identifier:nil];
        }
    }
    
    if ([tutorial containsPoint:location]) {
        SKSpriteNode *image = [SKSpriteNode spriteNodeWithImageNamed:@"image.png"];
        image.size = CGSizeMake(image.size.width*9/10, image.size.height*3/4);
        image.position = CGPointMake(CGRectGetMidX(self.frame)+10, CGRectGetMidY(self.frame)+40);
        [self addChild:image];
        
        tutorial1 = [SKSpriteNode spriteNodeWithImageNamed:@"tutorial1.png"];
        tutorial1.size = CGSizeMake(tutorial1.size.width/2, tutorial1.size.height/2);
        tutorial1.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)+45);
        [self addChild:tutorial1];
        
        SKLabelNode *label1 = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        label1.fontSize = 18;
        label1.fontColor = [SKColor blackColor];
        label1.text = @"画面をタップすると・・・";
        label1.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame)-35);
        [self addChild:label1];
        
        next = [SKSpriteNode spriteNodeWithImageNamed:@"next.png"];
        next.size = CGSizeMake(next.size.width, next.size.height);
        next.position = CGPointMake(CGRectGetMaxX(self.frame)*3/4+20, CGRectGetMidY(self.frame)+40);
        [self addChild:next];
        
        SKSpriteNode *previous = [SKSpriteNode spriteNodeWithImageNamed:@"previous.png"];
        previous.size = CGSizeMake(next.size.width, next.size.height);
        previous.position = CGPointMake(CGRectGetMaxX(self.frame)*1/4-20, CGRectGetMidY(self.frame)+40);
        [self addChild:previous];
        
    }
    
    if ([next containsPoint:location]) {
        [tutorial1 removeFromParent];
        SKSpriteNode *tutorial2 = [SKSpriteNode spriteNodeWithImageNamed:@"tutorial2.png"];
        tutorial2.size = CGSizeMake(tutorial2.size.width, tutorial2.size.height);
        tutorial2.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)+45);
        [self addChild:tutorial2];
        
    }
}


-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
