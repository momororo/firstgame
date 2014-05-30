//
//  GameScene.m
//  FirstGame
//
//  Created by 新井脩司 on 2014/05/20.
//  Copyright (c) 2014年 sacrew. All rights reserved.
//

#import "GameScene.h"
#import "GameView.h"

@implementation GameScene{
    
//ゲームスタートのフラグ
BOOL gameStart;

//ジャンプ可否フラグ(YESでジャンプ可能)
bool jumpFlag;
    
//ジャンプ中突進するフラグ
    BOOL smashFlag;
//ゲームスタートの時間を記録する変数
    NSDate *startTime;
    
//スタートのラベル
SKLabelNode *startLabel;

//グラウンドID(属性の割り振りに使用するよう)
int groundID;
    
//スコアのラベル
SKLabelNode *scoreLabel;
    
//効果音
SKAction *jumpSE;

/******* パラパラアニメの実験 ******/
SKTexture *_pengin1;
SKTexture *_pengin2;
/******* パラパラアニメの実験 ******/
    
}

-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
                
        /* Setup your scene here */
        
        //メイン画面
        self.backgroundColor = [SKColor greenColor];
        
        startLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        
        startLabel.text = @"GAME START";
        startLabel.fontSize = 30;
        startLabel.name = @"kStartLabel";
        startLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                       CGRectGetMidY(self.frame));
        
        //スコアラベル
        scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        scoreLabel.text = @"SCORE = 0";
        scoreLabel.fontSize = 20;
        scoreLabel.name = @"kScoreLabel";
        scoreLabel.position = CGPointMake(CGRectGetMinX(self.frame), CGRectGetMaxY(self.frame)-(CGRectGetMaxY(self.frame)/10));
        scoreLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
        scoreLabel.verticalAlignmentMode = SKLabelVerticalAlignmentModeTop;
        
        [self addChild:scoreLabel];
        [self addChild:startLabel];
        
        //透明のオブジェクトを生成(センサー)
        SKSpriteNode *sensor = [SKSpriteNode spriteNodeWithColor:[SKColor clearColor] size:CGSizeMake(1,self.frame.size.height)];
        
        sensor.name = @"kSensor";
        sensor.position = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame));
        sensor.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(sensor.size.width,sensor.size.height )];
        
        sensor.physicsBody.affectedByGravity = NO;
        
        sensor.physicsBody.categoryBitMask = sensorCategory;
        sensor.physicsBody.collisionBitMask = 0;
        sensor.physicsBody.contactTestBitMask = groundCategory;
        

        
        [self addChild:sensor];
        
        //地面の設定
        SKSpriteNode *ground = [SKSpriteNode spriteNodeWithColor:[SKColor brownColor]
                                                            size:CGSizeMake(self.frame.size.width, 24)];
        ground.name = kGround;
        ground.position = CGPointMake(ground.size.width/2,ground.size.height/2);
        
        ground.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(ground.size.width, ground.size.height)];
        ground.physicsBody.affectedByGravity = NO;
        ground.physicsBody.restitution = 0;

        ground.physicsBody.categoryBitMask = groundCategory;
        ground.physicsBody.collisionBitMask = 0;
        ground.physicsBody.contactTestBitMask = 0;
    
        
        [self addChild:ground];
        
        //プレイキャラの設定
        SKSpriteNode *player = [SKSpriteNode spriteNodeWithImageNamed:@"pengin1.png"];
        player.size = CGSizeMake(player.size.width/4, player.size.height/4);
        player.name = kPlayer;
        player.position = CGPointMake(CGRectGetMidX(self.frame)/2, 100 );
        [self addChild:player];
        player.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:player.size];
        player.physicsBody.allowsRotation = NO;
        player.physicsBody.affectedByGravity = YES;
        player.physicsBody.restitution = 0;
        //player.physicsBody.mass = 0;
        player.physicsBody.categoryBitMask = playerCategory;
        player.physicsBody.collisionBitMask = groundCategory;
        player.physicsBody.contactTestBitMask = groundCategory;
        
        //いけるかな？
    /*    SKAction *makeGround = [SKAction sequence: @[[SKAction performSelector:@selector(nextGround) onTarget:self],
                                                      [SKAction waitForDuration:1.0 withRange:0.8]]];
        [self runAction: [SKAction repeatActionForever:makeGround]];
      */
        //接触デリゲート
        self.physicsWorld.contactDelegate = self;
        
        //効果音の初期設定
        jumpSE = [SKAction playSoundFileNamed:@"jump.wav" waitForCompletion:NO];
        
    }
    
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    
    //ゲームスタートが押されたらボタンを消去する
    
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    
    //スタートラベルがノードにあるときだけ入る処理
    if([self childNodeWithName:@"kStartLabel"]){
        if ([startLabel containsPoint:location]) {
            //スタートボタンがタップされたら、地面が移動する
            gameStart = YES;
            SKNode *sprite2 = [self childNodeWithName:kGround];
            [sprite2 runAction:[SKAction repeatActionForever:
                                [SKAction sequence:@[[SKAction moveToX:-300 duration:2.0],
                                                     [SKAction removeFromParent]]]]];
            [startLabel removeFromParent];
            
            
            
            
            /******* パラパラアニメの実験 ******/
            SKNode *player = [self childNodeWithName:kPlayer];
            SKTexture *pengin1 = [SKTexture textureWithImageNamed:@"pengin1"];
            SKTexture *pengin2 = [SKTexture textureWithImageNamed:@"pengin2"];
            SKAction *walkPengin = [SKAction animateWithTextures:@[pengin1,pengin2] timePerFrame:0.2];
            SKAction *walkAction = [SKAction repeatActionForever:walkPengin];
            [player runAction:walkAction];
            
            /******* パラパラアニメの実験 ******/
            
            
            
            //ジャンプ可能フラグをオンに
            jumpFlag = YES;
            //秒数を記録
            startTime = [NSDate date];
        
            return;
        }
        return;
    }
    
    //GameOverラベルがノードにあるときだけ入る処理
    if([self childNodeWithName:@"kGameOver"]){
        
        //
            if ([[self childNodeWithName:@"kRetryLabel"] containsPoint:location]) {
                //ゲームシーン画面に飛ぶ
                if ([_delegate respondsToSelector:@selector(sceneEscape:identifier:)]) {
                    [_delegate sceneEscape:self identifier:@"retry"];
                }
            }
           
           if ([[self childNodeWithName:@"kTopLabel"] containsPoint:location]) {
               //ゲームシーン画面に飛ぶ
               if ([_delegate respondsToSelector:@selector(sceneEscape:identifier:)]) {
                [_delegate sceneEscape:self identifier:@"top"];
               }
           }
        return;
    }

    
    
    if(jumpFlag == YES){
        
        //ジャンプ処理
        SKNode *sprite = [self childNodeWithName:kPlayer];
        sprite.physicsBody.velocity = CGVectorMake(0, 600);
        
        /******* パラパラアニメの実験 ******/
        SKTexture *pengin3 = [SKTexture textureWithImageNamed:@"pengin3"];
        SKTexture *pengin4 = [SKTexture textureWithImageNamed:@"pengin4"];
        SKAction *jumpPengin = [SKAction animateWithTextures:@[pengin3,pengin4] timePerFrame:0.1];
        SKAction *jumpAction = [SKAction repeatActionForever:jumpPengin];
        [sprite runAction:jumpAction];
        
        /******* パラパラアニメの実験 ******/
        
        
        
        [self runAction:jumpSE];
        
        //ジャンプ可能フラグをNOにする
        jumpFlag = NO;
        //突進可能フラグをYESにする
        smashFlag = YES;
        return;
    }
    
    if (jumpFlag == NO && smashFlag == YES) {
        
        //突進処理
        SKNode *sprite = [self childNodeWithName:kPlayer];

        sprite.physicsBody.velocity = CGVectorMake(0, -500);
        smashFlag = NO;
        return;
    }

}

//オブジェクト同士が衝突した場合に動く処理
- (void)didBeginContact:(SKPhysicsContact *)contact
{
    //地面を格納する変数
    SKPhysicsBody *ground;
    //プレイヤーを格納する変数
    SKPhysicsBody *player;
    
    //ビットマスクの処理がちょっと微妙、、、、(一旦これで妥協、、、)
	//プレイヤーと地面の衝突を検知
    if((playerCategory == contact.bodyA.categoryBitMask || playerCategory == contact.bodyB.categoryBitMask) && (groundCategory == contact.bodyA.categoryBitMask || groundCategory == contact.bodyB.categoryBitMask)){
            if(contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask){
                ground = contact.bodyA;
                player = contact.bodyB;
            }else{
                ground = contact.bodyB;
                player = contact.bodyA;
        }
        
        //プレイヤーのy座標-プレイヤーの高さ/2→プレイヤーの足元のy座標
        //道路のy座標+道路の高さ/2→道路の表面のy座標
        if((player.node.position.y) - ([player.node calculateAccumulatedFrame].size.height/2) + 2 >= (ground.node.position.y) + ([ground.node calculateAccumulatedFrame].size.height/2) ){
            jumpFlag = YES;
            smashFlag = NO;
            
            /******* パラパラアニメの実験 ******/
            SKNode *player = [self childNodeWithName:kPlayer];
            SKTexture *pengin1 = [SKTexture textureWithImageNamed:@"pengin1"];
            SKTexture *pengin2 = [SKTexture textureWithImageNamed:@"pengin2"];
            SKAction *walkPengin = [SKAction animateWithTextures:@[pengin1,pengin2] timePerFrame:0.2];
            SKAction *walkAction = [SKAction repeatActionForever:walkPengin];
            [player runAction:walkAction];
            
            /******* パラパラアニメの実験 ******/
            return;
        }
    }
    
}


//オブジェクト同士が離れた際の処理
- (void)didEndContact:(SKPhysicsContact *)contact
{


    if(contact.bodyA.categoryBitMask == playerCategory ||contact.bodyB.categoryBitMask == playerCategory){
        jumpFlag = NO;
        smashFlag = YES;
    }
    
    
    //地面とセンサーが離れるのを検知
    if((sensorCategory == contact.bodyA.categoryBitMask || sensorCategory == contact.bodyB.categoryBitMask) && (groundCategory == contact.bodyA.categoryBitMask || groundCategory == contact.bodyB.categoryBitMask)){
        
            SKAction *makeGround = [SKAction sequence: @[[SKAction performSelector:@selector(nextGround) onTarget:self]]];
            [self runAction:makeGround];
        
        
        
    }

    
}

//1フレーム毎に動作するメソッド
-(void)didSimulatePhysics{
    
    
//SCOREの更新
    if(gameStart == YES){
    scoreLabel.text = [NSString stringWithFormat:@"SCORE = %.1fm",(float)[[NSDate date] timeIntervalSinceDate:startTime] * 2];
 
    }

    
//プレイヤーが画面外に落ちた時にゲームオーバーとする処理
	[self enumerateChildNodesWithName:kPlayer usingBlock:^(SKNode *node, BOOL *stop) {
		CGPoint pt = [self convertPoint:node.position toNode:self];
        CGFloat	h = self.size.height;
        CGFloat	w = self.size.width;
       
        //画面外か判定
		if(pt.y < -(h) || pt.x < (-(w)/2)){
			//ゲームスタートのフラグをオフにする
            gameStart = NO;
            
            //ゲームオーバー
            
            SKLabelNode *endLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
            
            endLabel.text = @"GAME OVER";
            endLabel.fontSize = 30;
            endLabel.name = @"kGameOver";
            endLabel.position = CGPointMake(CGRectGetMidX(self.frame),
                                           CGRectGetMidY(self.frame));
            
            //ラベル追加
            [self addChild:endLabel];
            
            //キャラクターの削除
            [node removeFromParent];
            
            
            //地面のスクロールをストップ
            SKNode *sprite = [self childNodeWithName:kGround];
            //アクションを削除
            [sprite removeAllActions];
            
            
            //リトライボタンの追加
            SKLabelNode *retryLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
            retryLabel.text = @"RETRY";
            retryLabel.fontSize = 20;
            retryLabel.name = @"kRetryLabel";
            //位置調整がうまくいかず。。。。
            retryLabel.position = CGPointMake(CGRectGetMinX(self.frame),
                                              CGRectGetMinY(self.frame));
            retryLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
            [self addChild:retryLabel];
            
             
            
            
            //トップ画面の追加
            SKLabelNode *topLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
            
            topLabel.text = @"TOP";
            topLabel.fontSize = 20;
            topLabel.name = @"kTopLabel";
            //位置調整がうまくいかず。。。。
            topLabel.position = CGPointMake(CGRectGetMaxX(self.frame),
                                            CGRectGetMinY(self.frame));
            topLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeRight;

            [self addChild:topLabel];
            
            //SCOREを記録する処理を追記すること
            
            return;
            
             
            

            
        }
        
    }];
    
    
        


    
}

//地面を次々に呼ぶ
-(void)nextGround{
    if (gameStart == YES) {
        
        //NSArray *ground = @[@"ground1",@"ground2",@"groud3"];
        
        //groundID = arc4random()%2;
        SKSpriteNode *nextGround = [SKSpriteNode spriteNodeWithImageNamed:@"ground2"];
        
       // nextGround.userData = [@{@"tekito":@(skRand(400,800))}mutableCopy];
        
        //skRand(50,100));
        nextGround.size = CGSizeMake(100 + arc4random_uniform(151),50+arc4random_uniform(101));
        

        nextGround.position = CGPointMake((self.frame.size.width + (nextGround.size.width/2) ),0);
        
        [self addChild:nextGround];
 
        nextGround.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:CGSizeMake(nextGround.size.width, nextGround.size.height)];
        nextGround.physicsBody.restitution = 0;
        //nextGround.physicsBody.restitution = skRandBound();
        nextGround.physicsBody.affectedByGravity = NO;
        nextGround.physicsBody.friction = 0;
        
        [nextGround runAction:[SKAction sequence:@[[SKAction moveToX: -200 + (nextGround.size.width/2)duration:2.0],[SKAction removeFromParent]]]];

        
        

        //接触設定
        //カテゴリー
        nextGround.physicsBody.categoryBitMask = groundCategory;
        //接触できるオブジェクト
        nextGround.physicsBody.collisionBitMask =  0;
        //ヒットテストするオブジェクト
        nextGround.physicsBody.contactTestBitMask = 0;
        
        
        
    }
}

/*使用していないためコメント化（最終的に消します）
static inline CGFloat skRand(CGFloat low,CGFloat high){
    CGFloat res = skRandf() * ((high - low) + low);
    return  res;
}
*/


/*使用していないためコメント化（最終的に消します）
static inline CGFloat skRandf(){
    return rand() / (CGFloat) RAND_MAX;
}
*/

/*
static inline CGFloat skRandBound()
{
    
    CGFloat rand = (CGFloat)arc4random_uniform(51)/100;
    return rand;
}
*/







@end