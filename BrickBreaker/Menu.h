//
//  Menu.h
//  BrickBreaker
//
//  Created by Iyad Horani on 25/05/2015.
//  Copyright (c) 2015 IRONIC3D. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface Menu : SKNode

@property (nonatomic) int levelNumber;

-(void)hide;
-(void)show;

@end
