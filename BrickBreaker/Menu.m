//
//  Menu.m
//  BrickBreaker
//
//  Created by Iyad Horani on 25/05/2015.
//  Copyright (c) 2015 IRONIC3D. All rights reserved.
//

#import "Menu.h"

@implementation Menu {
    SKSpriteNode *_menuPanel;
    SKLabelNode *_panelText;
    SKSpriteNode *_playButton;
    SKLabelNode *_buttonText;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _menuPanel = [SKSpriteNode spriteNodeWithImageNamed:@"MenuPanel"];
        _menuPanel.position = CGPointZero;
        [self addChild:_menuPanel];
        
        _panelText = [SKLabelNode labelNodeWithFontNamed:@"Futura"];
        _panelText.fontColor = [SKColor colorWithRed:0.05 green:0.25 blue:0.44 alpha:1];
        _panelText.fontSize = 15.0;
        _panelText.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
        _panelText.text = @"LEVEL 1";
        [_menuPanel addChild:_panelText];
        
        _playButton = [SKSpriteNode spriteNodeWithImageNamed:@"Button"];
        _playButton.position = CGPointMake(0, -((_menuPanel.size.height * 0.5) + (_playButton.size.height * 0.5) + 10));
        [self addChild:_playButton];
        
        _buttonText = [SKLabelNode labelNodeWithFontNamed:@"Futura"];
        _buttonText.fontColor = [SKColor colorWithRed:0.05 green:0.25 blue:0.44 alpha:1];
        _buttonText.fontSize = 15.0;
        _buttonText.verticalAlignmentMode = SKLabelVerticalAlignmentModeCenter;
        _buttonText.position = CGPointMake(0, 2);
        _buttonText.text = @"PLAY";
        [_playButton addChild:_buttonText];
    }
    return self;
}

-(void)show {
    SKAction *slideLeft = [SKAction moveByX:-260 y:0.0 duration:0.5];
    slideLeft.timingMode = SKActionTimingEaseOut;
    
    SKAction *slideRight = [SKAction moveByX:260 y:0.0 duration:0.5];
    slideRight.timingMode = SKActionTimingEaseOut;
    
    _menuPanel.position = CGPointMake(260, _menuPanel.position.y);
    _playButton.position = CGPointMake(-260, _playButton.position.y);
    
    [_menuPanel runAction:slideLeft];
    [_playButton runAction:slideRight];
    
    self.hidden = NO;
}

-(void)hide {
    SKAction *slideLeft = [SKAction moveByX:-260 y:0.0 duration:0.5];
    slideLeft.timingMode = SKActionTimingEaseIn;
    
    SKAction *slideRight = [SKAction moveByX:260 y:0.0 duration:0.5];
    slideRight.timingMode = SKActionTimingEaseIn;
    
    _menuPanel.position = CGPointMake(0, _menuPanel.position.y);
    _playButton.position = CGPointMake(0, _playButton.position.y);
    
    [_menuPanel runAction:slideLeft];
    [_playButton runAction:slideRight completion:^{
        self.hidden = YES;
    }];
}

@end
