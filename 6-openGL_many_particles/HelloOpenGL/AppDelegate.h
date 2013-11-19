//
//  AppDelegate.h
//  HelloOpenGL
//
//  Created by Andrew Garrahan on 5/15/12.
//  Copyright (c) 2012 Gutpela. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OpenGLView.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    
    OpenGLView* _glView;
}

@property (nonatomic,retain)IBOutlet OpenGLView * glView;
@property (strong, nonatomic) UIWindow *window;

@end
