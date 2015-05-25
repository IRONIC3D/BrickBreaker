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
    SKSpriteNode *_playButton;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _menuPanel = [SKSpriteNode spriteNodeWithImageNamed:@"MenuPanel"];
        _menuPanel.position = CGPointZero;
        [self addChild:_menuPanel];
        
        _playButton = [SKSpriteNode spriteNodeWithImageNamed:@"Button"];
        _playButton.position = CGPointMake(0, -((_menuPanel.size.height * 0.5) + (_playButton.size.height * 0.5) + 10));
        [self addChild:_playButton];
    }
    return self;
}

-(void)hide {
    
}

-(void)show {
    
}

@end
