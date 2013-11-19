//
//  ColorUIButton.m
//  PookieBook
//
//  Created by Andrew Garrahan on 4/25/12.
//  Copyright (c) 2012 Gutpela. All rights reserved.
//

#import "ColorUIButton.h"

@implementation ColorUIButton

@synthesize size, color, isSelected;

- (id)initWithFrame:(CGRect)frame brushSize:(float)tempSize color:(UIColor *)tempColor
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // tempSize
        isSelected = NO;
        color = tempColor;
        size = tempSize * 0.9;
        
       
        
        
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    NSLog(@"Call draw");
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //if(isSelected){
        
    float spacer = 12;
    float size2 = size + spacer; 
    
    float spacer2 = 3;
    float size3 = size + spacer2;
    
    int offset = 10;
   
    if(isSelected){
        
        
        
        CGContextSetFillColorWithColor(context, [UIColor blackColor].CGColor);
        CGRect rectangleHighLight = CGRectMake( -spacer/2 + offset,  (size2/2 - spacer) +offset, size2 ,size2);
        
        CGContextAddEllipseInRect(context, rectangleHighLight);
        CGContextFillPath(context);
        
        if(color == [UIColor blackColor]){
            
            CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
            CGRect rectangleHighLight2 = CGRectMake( -spacer2/2 + offset,  (size3/2 - spacer2 ) + offset, size3 ,size3);
            
            CGContextAddEllipseInRect(context, rectangleHighLight2);
            CGContextFillPath(context);
        }

       
        
    } else {
        
        CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
        CGRect rectangleHighLight = CGRectMake( -spacer/2 + offset,  (size2/2 - spacer) +offset, size2 ,size2);
        
        CGContextAddEllipseInRect(context, rectangleHighLight);
        CGContextFillPath(context);
    }
    
    
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGRect rectangle = CGRectMake( offset,  size/2 + offset,size ,size);
    
    CGContextAddEllipseInRect(context, rectangle);
    CGContextFillPath(context);

}

@end
