//
//  GameScene.m
//  BrickBreaker
//
//  Created by Iyad Horani on 22/05/2015.
//  Copyright (c) 2015 IRONIC3D. All rights reserved.
//

#import "GameScene.h"

@implementation GameScene {
    SKSpriteNode *_paddle;
    CGPoint _touchLocation;
}

-(instancetype)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        self.backgroundColor = [SKColor whiteColor];
        
        _paddle = [SKSpriteNode spriteNodeWithImageNamed:@"Paddle"];
        _paddle.position = CGPointMake(CGRectGetMidX(self.frame), 90);
        [self addChild:_paddle];
    }
    
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        _touchLocation = [touch locationInNode:self];
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        // Calculating how far touch moved on x axis
        CGFloat xMovement = [touch locationInNode:self].x - _touchLocation.x;
        
        // Move paddle distance of touch
        _paddle.position = CGPointMake(_paddle.position.x + xMovement, _paddle.position.y);
        
        CGFloat paddleMinX = -_paddle.size.width * 0.25;
        CGFloat paddleMaxX = self.size.width + (_paddle.size.width * 0.25);
        
        
        // Cap paddles position so it remains on screen
        if (_paddle.position.x < paddleMinX) {
            _paddle.position = CGPointMake(paddleMinX, _paddle.position.y);
        } else if (_paddle.position.x > paddleMaxX) {
            _paddle.position = CGPointMake(paddleMaxX, _paddle.position.y);
        }
        
        _touchLocation = [touch locationInNode:self];
    }
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
