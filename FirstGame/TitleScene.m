//
//  MyScene.m
//  FirstGame
//
//  Created by 新井脩司 on 2014/05/20.
//  Copyright (c) 2014年 sacrew. All rights reserved.
//

#import "TitleScene.h"
#import "GameView.h"


//スタートボタン
SKSpriteNode *start;
//チュートリアルボタン
SKSpriteNode *tutorial;
//ランキングボタン
SKSpriteNode *ranking;
//チュートリアルのネクストボタン
SKSpriteNode *next;
//チュートリアルのバックボタン
SKSpriteNode *previous;
//チュートリアルの解説テキスト枠
SKLabelNode  *tutorialLabel;
//チュートリアルの背景
SKSpriteNode *tutorialBackGround;
//チュートリアルの画像
SKSpriteNode *tutorialImage;
//ハイスコア
float score;
//チュートリアルフラグ
bool tutorialFlag;
//チュートリアルのページ
int tutorialPage;

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
        start.position = CGPointMake(440, 130);
        [self addChild:start];
        
        tutorial = [SKSpriteNode spriteNodeWithImageNamed:@"tutorial.png"];
        tutorial.size = CGSizeMake(tutorial.size.width, tutorial.size.height);
        tutorial.position = CGPointMake(440, 90);
        [self addChild:tutorial];
        
        ranking = [SKSpriteNode spriteNodeWithImageNamed:@"ranking.png"];
        ranking.size = CGSizeMake(ranking.size.width, ranking.size.height);
        ranking.position = CGPointMake(440, 50);
        [self addChild:ranking];
        
        
        //灯籠流し
        
        SKSpriteNode *penguin = [SKSpriteNode spriteNodeWithImageNamed:@"pengin6"];
        penguin.size = CGSizeMake(penguin.size.width, penguin.size.height);
        penguin.position = CGPointMake(CGRectGetMaxX(self.frame) + penguin.size.width, CGRectGetMidY(self.frame));
        penguin.zPosition = 0;
        
        [self addChild:penguin];
        
        [penguin
         runAction:[SKAction sequence:@[[SKAction moveToX: -200 duration:12.0],[SKAction removeFromParent]]]];
        
        
        
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
        
        //チュートリアルのページを0にする
        tutorialPage = 0;
        
        
        
        
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
        //チュートリアル表示時は反応しない
        if(tutorialFlag == NO){
            //タップされた画像に変更
            start = [SKSpriteNode spriteNodeWithImageNamed:@"start_taped.png"];
            if ([_delegate respondsToSelector:@selector(sceneEscape:identifier:)]) {
                [_delegate sceneEscape:self identifier:nil];
                
                return;
                
            }
        }
    }
    
    /**
     *  チュートリアルの作成ページ
     *  チュートリアルのフラグNOでかつページが0ページの時に処理が行われる
     */
    if ([tutorial containsPoint:location]) {
        
        if(tutorialFlag == NO){
            
            [self showTutorial];
            return;
            
        }
    }
    
    //ネクストボタンの動き
    if ([next containsPoint:location]) {
        
        if(tutorialFlag == YES){

            //1ページ目から2ページに変更
            if (tutorialPage == 1) {
                
                [self showSecondPage];
                return;
                
            }
            
            //2ページ目から3ページに変更(未実装)
        }
        
    }
    
    //バックボタンの動き
    if([previous containsPoint:location]){
        
        if(tutorialFlag == YES){
            
            //1ページ目からの変更は処理を行わない
            if(tutorialPage == 1){
                //処理なし
                return;
            }
            
            //2ページ目から1ページに変更
            if(tutorialPage == 2){
                [self showFirstPage];
                return;
            }
            
            
        }
        
    }
    
    
    //チュートリアルがONであり、どこにも該当しない場合はチュートリアル画面を消す
    if(tutorialFlag == YES){
        //チュートリアルのノードを破棄する
        [self hiddenTutorial];
        return;
        
    }
}

//チュートリアルの作成メソッド
-(void)showTutorial{
    
    //イメージ枠の追加
    tutorialBackGround = [SKSpriteNode spriteNodeWithImageNamed:@"image.png"];
    tutorialBackGround.size = CGSizeMake(tutorialBackGround.size.width/1.5, tutorialBackGround.size.height/1.5);
    tutorialBackGround.position = CGPointMake(CGRectGetMidX(self.frame), 50);
    [self addChild:tutorialBackGround];
    
    
    //テキスト枠の追加
    tutorialLabel = [SKLabelNode labelNodeWithFontNamed:@"Arial"];
    tutorialLabel.fontSize = 18;
    tutorialLabel.fontColor = [SKColor blackColor];
    tutorialLabel.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame)-25);
    [self addChild:tutorialLabel];

    //ネクストボタンの追加
    next = [SKSpriteNode spriteNodeWithImageNamed:@"next.png"];
    next.size = CGSizeMake(next.size.width/2, next.size.height/2);
    next.position = CGPointMake(CGRectGetMaxX(self.frame)*3/4-30, CGRectGetMidY(self.frame)+40);
    [self addChild:next];
    
    //バックボタンの追加
    previous = [SKSpriteNode spriteNodeWithImageNamed:@"previous.png"];
    previous.size = CGSizeMake(next.size.width/2, next.size.height/2);
    previous.position = CGPointMake(CGRectGetMaxX(self.frame)*1/4+30, CGRectGetMidY(self.frame)+40);
    [self addChild:previous];

    //1ページ目を作成
    [self showFirstPage];

    
    //チュートリアルフラグをONに変更
    tutorialFlag = YES;
}

//チュートリアルページの削除メソッド
-(void)hiddenTutorial{
    
    [tutorialBackGround removeFromParent];
    [tutorialLabel removeFromParent];
    [next removeFromParent];
    [previous removeFromParent];
    [tutorialImage removeFromParent];
    tutorialBackGround = nil;
    tutorialLabel = nil;
    next = nil;
    previous = nil;
    tutorialImage= nil;

    //チュートリアルのフラグをNOにする
    tutorialFlag = NO;
    
    //ページを0ページに戻す
    tutorialPage = 0;


    
}


//1ページ目の作成メソッド

-(void)showFirstPage{
    
    [tutorialImage removeFromParent];
    tutorialImage = nil;
    tutorialImage = [SKSpriteNode spriteNodeWithImageNamed:@"tutorial1.jpg"];
    tutorialImage.size = CGSizeMake(tutorialImage.size.width/6, tutorialImage.size.height/6);
    tutorialImage.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)+50);
    [self addChild:tutorialImage];

    //テキストの差し替え
    tutorialLabel.text = @"画面をタップすると・・・";
    
    //ページを1に変更
    tutorialPage = 1;
    
    return;
    
}

//2ページ目の作成メソッド

-(void)showSecondPage{

    //画像の差し替え
    [tutorialImage removeFromParent];
    tutorialImage = nil;
    tutorialImage = [SKSpriteNode spriteNodeWithImageNamed:@"tutorial2.png"];
    tutorialImage.size = CGSizeMake(tutorialImage.size.width/2, tutorialImage.size.height/2);
    tutorialImage.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)+45);
    [self addChild:tutorialImage];

    
    //テキストの差し替え
    tutorialLabel.text =@"ジャンプします！";
    
    //ページを2に変更
    tutorialPage = 2;
    
    return;

}


-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end