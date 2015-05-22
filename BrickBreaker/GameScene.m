//
//  GameScene.m
//  BrickBreaker
//
//  Created by Iyad Horani on 22/05/2015.
//  Copyright (c) 2015 IRONIC3D. All rights reserved.
//

#import "GameScene.h"

@implementation GameScene

-(instancetype)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        self.backgroundColor = [SKColor whiteColor];
    }
    
    return self;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
