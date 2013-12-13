//
//  BNHtmlPdfKitPageRenderer.h
//  ACTPrinter4
//
//  Created by Pierre Bernard on 6/11/13.
//  Copyright (c) 2013 Houdah Software. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BNHtmlPdfKitPageRenderer : UIPrintPageRenderer

@property (nonatomic, copy)         NSString	*pageTitle;

@property (nonatomic, assign)       BOOL		printHeader;
@property (nonatomic, assign)       BOOL		printFooter;

@property (nonatomic, assign)       CGFloat		topAndBottomMarginSize;
@property (nonatomic, assign)       CGFloat		leftAndRightMarginSize;

@end
