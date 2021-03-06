//
//  GameScene.m
//  BrickBreaker
//
//  Created by Iyad Horani on 22/05/2015.
//  Copyright (c) 2015 IRONIC3D. All rights reserved.
//

#import "GameScene.h"
#import "Brick.h"
#import "Menu.h"

@interface GameScene()

@property (nonatomic) int lives;
@property (nonatomic) int currentLevel;

@end


@implementation GameScene {
    SKSpriteNode *_paddle;
    CGPoint _touchLocation;
    CGFloat _ballSpeed;
    SKNode *_brickLayer;
    BOOL _ballReleased;
    BOOL _positionBall;
    NSArray *_hearts;
    SKLabelNode *_levelDisplay;
    Menu *_menu;
    
    SKAction *_ballBounceSound;
    SKAction *_paddleBounceSound;
    SKAction *_levelUpSound;
    SKAction *_loseLifeSound;
}

#pragma mark -
#pragma mark Category Bit Masks

static const int kFinalLevelNumber = 3;

static const uint32_t kBallCategory         = 0x1 << 0;
static const uint32_t kPaddleCategory       = 0x1 << 1;
static const uint32_t kEdgeCategory       = 0x1 << 3;

#pragma mark -
#pragma mark SK Methods

-(instancetype)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        self.backgroundColor = [SKColor whiteColor];
        
        // Setup world physics properties
        self.physicsWorld.gravity = CGVectorMake(0.0, 0.0);
        self.physicsWorld.contactDelegate = self;
        
        // Setup edge
        self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:CGRectMake(0, -128, size.width, size.height + 100)];
        self.physicsBody.categoryBitMask = kEdgeCategory;
        
        // Setup paddle
        _paddle = [SKSpriteNode spriteNodeWithImageNamed:@"Paddle"];
        _paddle.position = CGPointMake(CGRectGetMidX(self.frame), 90);
        _paddle.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:_paddle.size];
        _paddle.physicsBody.dynamic = NO;
        _paddle.physicsBody.categoryBitMask = kPaddleCategory;
        [self addChild:_paddle];
        
        // Setup brick layer
        _brickLayer = [SKNode node];
        _brickLayer.position = CGPointMake(0, self.size.height - 28);
        [self addChild:_brickLayer];
        
        // Add HUD bar
        SKSpriteNode *hud = [SKSpriteNode spriteNodeWithColor:[SKColor colorWithRed:0.94
                                                                              green:0.94
                                                                               blue:0.94
                                                                              alpha:1]
                                                         size:CGSizeMake(size.width, 28)];
        hud.position = CGPointMake(0, size.height);
        hud.anchorPoint = CGPointMake(0, 1);
        [self addChild:hud];
        
        // Setup level display
        _levelDisplay = [SKLabelNode labelNodeWithFontNamed:@"Futura"];
        _levelDisplay.fontColor = [SKColor colorWithRed:0.05 green:0.25 blue:0.44 alpha:1];
        _levelDisplay.fontSize = 15.0;
        _levelDisplay.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
        _levelDisplay.verticalAlignmentMode = SKLabelVerticalAlignmentModeTop;
        _levelDisplay.position = CGPointMake(10, -10);
        [hud addChild:_levelDisplay];
        
        // Setup sounds
        _ballBounceSound = [SKAction playSoundFileNamed:@"BallBounce.caf" waitForCompletion:NO];
        _paddleBounceSound = [SKAction playSoundFileNamed:@"PaddleBounce.caf" waitForCompletion:NO];
        _levelUpSound = [SKAction playSoundFileNamed:@"LevelUp.caf" waitForCompletion:NO];
        _loseLifeSound = [SKAction playSoundFileNamed:@"LoseLife.caf" waitForCompletion:NO];
        
        // Setup hearts 26x22
        _hearts = @[[SKSpriteNode spriteNodeWithImageNamed:@"HeartFull"],
                    [SKSpriteNode spriteNodeWithImageNamed:@"HeartFull"]];
        
        for (NSUInteger i = 0; i < _hearts.count; i++) {
            SKSpriteNode *heart = (SKSpriteNode*)[_hearts objectAtIndex:i];
            heart.position = CGPointMake(self.size.width - (16 + (29 * i)), self.size.height - 14);
            [self addChild:heart];
        }
        
        // Setup menu
        _menu = [[Menu alloc] init];
        _menu.position = CGPointMake(self.size.width * 0.5, self.size.height * 0.5);
        [self addChild:_menu];
        
        // Set initial values
        _ballSpeed = 250.0;
        _ballReleased = NO;
        self.currentLevel = 1;
        self.lives = 2;
        
        // Start a new level
        [self loadLevel:self.currentLevel];
        [self newBall];
    }
    
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        if (_menu.hidden) {
            if (!_ballReleased) {
                _positionBall = YES;
            }
            _touchLocation = [touch locationInNode:self];
        }
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    if (_menu.hidden) {
        for (UITouch *touch in touches) {
            // Calculating how far touch moved on x axis
            CGFloat xMovement = [touch locationInNode:self].x - _touchLocation.x;
            
            // Move paddle distance of touch
            _paddle.position = CGPointMake(_paddle.position.x + xMovement, _paddle.position.y);
            
            CGFloat paddleMinX = -_paddle.size.width * 0.25;
            CGFloat paddleMaxX = self.size.width + (_paddle.size.width * 0.25);
            
            if (_positionBall) {
                paddleMinX = _paddle.size.width * 0.5;
                paddleMaxX = self.size.width - (_paddle.size.width * 0.5);
            }
            
            // Cap paddles position so it remains on screen
            if (_paddle.position.x < paddleMinX) {
                _paddle.position = CGPointMake(paddleMinX, _paddle.position.y);
            } else if (_paddle.position.x > paddleMaxX) {
                _paddle.position = CGPointMake(paddleMaxX, _paddle.position.y);
            }
            
            _touchLocation = [touch locationInNode:self];
    }
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (_menu.hidden) {
        if (_positionBall) {
            _positionBall = NO;
            _ballReleased = YES;
            
            [_paddle removeAllChildren];
            
            [self createBallWithLocation:CGPointMake(_paddle.position.x, _paddle.position.y + _paddle.size.height) andVelocity:CGVectorMake(0, _ballSpeed)];
        }
    } else {
        for (UITouch *touch in touches) {
            if ([[_menu nodeAtPoint:[touch locationInNode:_menu]].name isEqualToString:@"Play Button"]) {
                [_menu hide];
            }
            
        }
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
    
    if ([self isLevelComplete]) {
        self.currentLevel++;
        if (self.currentLevel > kFinalLevelNumber) {
            self.currentLevel = 1;
            self.lives = 2;
        }
        [self loadLevel:self.currentLevel];
        [self newBall];
        [_menu show];
        [self runAction:_levelUpSound];
    } else if (_ballReleased && !_positionBall && ![self childNodeWithName:@"ball"]) {
        // Lost all balls.
        self.lives--;
        if (self.lives < 0) {
            // Game over
            self.lives = 2;
            self.currentLevel = 1;
            [self loadLevel:self.currentLevel];
            [_menu show];
        }
        [self newBall];
        [self runAction:_loseLifeSound];
    }
}

-(void)didSimulatePhysics {
    [self enumerateChildNodesWithName:@"ball" usingBlock:^(SKNode *node, BOOL *stop) {
        if (node.frame.origin.y + node.frame.size.height < 0) {
            // Lost ball.
            [node removeFromParent];
        }
    }];
}

#pragma mark -
#pragma mark Overide Methods

-(void)setLives:(int)lives {
    _lives = lives;
    
    for (NSUInteger i = 0; i < _hearts.count; i++) {
        SKSpriteNode *heart = (SKSpriteNode*)[_hearts objectAtIndex:i];
        if (lives > i) {
            heart.texture = [SKTexture textureWithImageNamed:@"HeartFull"];
        } else {
            heart.texture = [SKTexture textureWithImageNamed:@"HeartEmpty"];
        }
    }
}

-(void)setCurrentLevel:(int)currentLevel {
    _currentLevel = currentLevel;
    _levelDisplay.text = [NSString stringWithFormat:@"LEVEL %d", currentLevel];
    _menu.levelNumber = _currentLevel;
}

#pragma mark -
#pragma mark User Methods

-(void)newBall {
    [self enumerateChildNodesWithName:@"ball" usingBlock:^(SKNode *node, BOOL *stop) {
        [node removeFromParent];
    }];
    
    SKSpriteNode *ball = [SKSpriteNode spriteNodeWithImageNamed:@"BallBlue"];
    ball.position = CGPointMake(0, _paddle.size.height);
    [_paddle addChild:ball];
    _ballReleased = NO;
    _paddle.position = CGPointMake(self.size.width * 0.5, _paddle.position.y);
    
}

-(SKSpriteNode *)createBallWithLocation:(CGPoint)position andVelocity:(CGVector)velocity {
    SKSpriteNode *ball = [SKSpriteNode spriteNodeWithImageNamed:@"BallBlue"];
    ball.name = @"ball";
    ball.position = position;
    ball.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:ball.size.width * 0.5];
    ball.physicsBody.friction = 0.0;
    ball.physicsBody.linearDamping = 0.0;
    ball.physicsBody.restitution = 1.0;
    ball.physicsBody.velocity = velocity;
    ball.physicsBody.categoryBitMask = kBallCategory;
    ball.physicsBody.contactTestBitMask = kPaddleCategory | kBrickCategory | kEdgeCategory;
    ball.physicsBody.collisionBitMask = kPaddleCategory | kBrickCategory | kEdgeCategory;
    [self addChild:ball];
    
    return ball;
}

-(void)loadLevel:(int)LevelNumber {
    
    // Clean _BrickLayer
    [_brickLayer removeAllChildren];
    
    NSArray *level = nil;
    
    switch (LevelNumber) {
        case 1:
            level = @[@[@1, @1, @1, @1, @1, @1],
                      @[@0, @1, @1, @1, @1, @0],
                      @[@0, @0, @0, @0, @0, @0],
                      @[@0, @0, @0, @0, @0, @0],
                      @[@0, @2, @2, @2, @2, @0]];
            break;
            
        case 2:
            level = @[@[@1, @1, @2, @2, @1, @1],
                      @[@2, @2, @0, @0, @2, @2],
                      @[@2, @0, @0, @0, @0, @2],
                      @[@0, @0, @1, @1, @0, @0],
                      @[@1, @0, @1, @1, @0, @1],
                      @[@1, @1, @3, @3, @1, @1]];
            break;
            
        case 3:
            level = @[@[@1, @0, @1, @1, @0, @1],
                      @[@1, @2, @1, @1, @0, @1],
                      @[@4, @0, @3, @3, @0, @4],
                      @[@2, @0, @0, @0, @0, @2],
                      @[@0, @0, @1, @1, @0, @0],
                      @[@3, @2, @1, @1, @2, @3]];
            break;
            
        default:
            break;
    }
    
    int row = 0;
    int col = 0;
    
    for (NSArray *rowBricks in level) {
        // Reset the column number
        col = 0;
        
        for (NSNumber *brickType in rowBricks) {
            if ([brickType intValue] > 0) {
                Brick *brick = [[Brick alloc] initWithType:(BrickType)[brickType intValue]];
                if (brick) {
                    brick.position = CGPointMake(2 + (brick.size.width * 0.5) + ((brick.size.width + 3) * col),
                                                 -(2 + (brick.size.height * 0.5) + (brick.size.height + 3) * row));
                    [_brickLayer addChild:brick];
                }
            }
            col++;
        }
        row++;
    }
}

-(BOOL)isLevelComplete {
    
    // Looking for bricks that are not indestructible.
    for (SKNode *node in _brickLayer.children) {
        if ([node isKindOfClass:[Brick class]]) {
            if (!((Brick*)node).indestructible) {
                return NO;
            }
        }
    }
    
    // Couldn't find any non-indestructible bricks
    return YES;
}

-(void)spawnExtraBall:(CGPoint)position {
    CGVector direction;
    if (arc4random_uniform(2) == 0) {
        direction = CGVectorMake(cosf(M_PI_4), sinf(M_PI_4));
    } else {
        direction = CGVectorMake(cosf(M_PI * 0.75), sinf(M_PI * 0.75));
    }
    
    [self createBallWithLocation:position andVelocity:CGVectorMake(direction.dx * _ballSpeed, direction.dy * _ballSpeed)];
}

#pragma mark -
#pragma mark SKPhysics Delegate Method

-(void)didBeginContact:(SKPhysicsContact *)contact {
    SKPhysicsBody *firstBody;
    SKPhysicsBody *secondBody;
    
    if (contact.bodyA.categoryBitMask > contact.bodyB.categoryBitMask) {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    } else {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    }
    
    if (firstBody.categoryBitMask == kBallCategory && secondBody.categoryBitMask == kPaddleCategory) {
        if (firstBody.node.position.y > secondBody.node.position.y) {
            // Get contact point in paddle coordinates
            CGPoint pointInPaddle = [secondBody.node convertPoint:contact.contactPoint fromNode:self];
            // Get the contact poisition as a percentage of the paddle's width
            CGFloat x = (pointInPaddle.x + secondBody.node.frame.size.width * 0.5) / secondBody.node.frame.size.width;
            // Cap percentage and flip it
            CGFloat multiplier = 1.0 - fmaxf(fminf(x, 1.0), 0.0);
            // Calculate angle based on ball position in paddle.
            CGFloat angle = (M_PI_2 * multiplier) + M_PI_4;
            // Convert angle into a vector
            CGVector direction = CGVectorMake(cosf(angle), sinf(angle));
            // Set ball's velocity based on direction and speed.
            firstBody.velocity = CGVectorMake(direction.dx * _ballSpeed, direction.dy * _ballSpeed);
        }
        [self runAction:_paddleBounceSound];
    }
    
    if (firstBody.categoryBitMask == kBallCategory && secondBody.categoryBitMask == kBrickCategory) {
        if ([secondBody.node respondsToSelector:@selector(hit)]) {
            [secondBody.node performSelector:@selector(hit)];
            if (((Brick*)secondBody.node).spawnsExtraBall) {
                [self spawnExtraBall:[_brickLayer convertPoint:secondBody.node.position toNode:self]];
            }
        }
        [self runAction:_ballBounceSound];
    }
    
    if (firstBody.categoryBitMask == kBallCategory && secondBody.categoryBitMask == kEdgeCategory) {
        [self runAction:_ballBounceSound];
    }
}

@end
