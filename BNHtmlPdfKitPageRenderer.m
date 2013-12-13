//
//  BNHtmlPdfKitPageRenderer.m
//  ACTPrinter4
//
//  Created by Pierre Bernard on 6/11/13.
//  Copyright (c) 2013 Houdah Software. All rights reserved.
//

#import "BNHtmlPdfKitPageRenderer.h"


#define HEADER_LEFT_TEXT_INSET			20
#define HEADER_FOOTER_MARGIN_PADDING	5
#define FOOTER_RIGHT_TEXT_INSET			20


@interface BNHtmlPdfKitPageRenderer ()

@property (nonatomic, strong)       UIFont		*headerFooterFont;
@property (nonatomic, strong)       NSString	*timestampString;
@property (nonatomic, assign)       NSRange		pageRange;

@end


@implementation BNHtmlPdfKitPageRenderer

- (id)init
{
	self = [super init];

	if (self != nil) {
		_printHeader		= YES;
		_printFooter		= YES;
		_headerFooterFont	= [UIFont fontWithName:@"Helvetica" size:12.0f];

		CGSize	headerFooterSize	= [@"Sample" sizeWithFont : _headerFooterFont];
		CGFloat headerFooterHeight	= headerFooterSize.height + HEADER_FOOTER_MARGIN_PADDING;

		self.headerHeight	= headerFooterHeight;
		self.footerHeight	= headerFooterHeight;
	}

	return self;
}

- (CGRect)paperRect
{
	return UIGraphicsGetPDFContextBounds();
}

- (CGRect)printableRect
{
	return CGRectInset([self paperRect], self.leftAndRightMarginSize, self.topAndBottomMarginSize);
}

- (void)prepareForDrawingPages:(NSRange)range
{
	self.pageRange			= range;
	self.timestampString	= [NSDateFormatter localizedStringFromDate:[NSDate date]
														  dateStyle:NSDateFormatterMediumStyle
														  timeStyle:NSDateFormatterMediumStyle];
	[super prepareForDrawingPages:range];
}

- (void)drawHeaderForPageAtIndex:(NSInteger)pageIndex inRect:(CGRect)headerRect
{
	if (self.printHeader) {
		NSString *pageTitle = self.pageTitle;

		if (pageTitle != nil) {
			UIFont	*headerFooterFont	= self.headerFooterFont;

			CGFloat startX				= CGRectGetMinX(headerRect) + HEADER_LEFT_TEXT_INSET;
			CGFloat startY				= self.printableRect.origin.y + HEADER_FOOTER_MARGIN_PADDING;
			CGPoint startPoint			= CGPointMake(startX, startY);

			[pageTitle drawAtPoint:startPoint withFont:headerFooterFont];
		}
	}
}

- (void)drawFooterForPageAtIndex:(NSInteger)pageIndex inRect:(CGRect)footerRect
{
	if (self.printFooter) {
		UIFont		*headerFooterFont	= self.headerFooterFont;

		NSString	*timestampString	= self.timestampString;

		if (timestampString != nil) {
			CGSize	timestampStringSize = [timestampString sizeWithFont:headerFooterFont];

			CGFloat startX				= CGRectGetMinX(footerRect) + HEADER_LEFT_TEXT_INSET;
			CGFloat startY				= CGRectGetMaxY(self.printableRect) - timestampStringSize.height - HEADER_FOOTER_MARGIN_PADDING;
			CGPoint startPoint			= CGPointMake(startX, startY);

			[timestampString drawAtPoint:startPoint withFont:headerFooterFont];
		}

		{
			NSString	*localizedPageNumberString	= NSLocalizedString(@"Page %d of %d", @"BNHtmlPdfKit: Page Count String");
			NSRange		pageRange					= self.pageRange;
			NSString	*pageNumberString			= [NSString stringWithFormat:localizedPageNumberString,
													   pageIndex + 1 - pageRange.location, pageRange.length];

			CGSize		pageNumSize					= [pageNumberString sizeWithFont:headerFooterFont];

			CGFloat		startX						= CGRectGetMaxX(footerRect) - pageNumSize.width - FOOTER_RIGHT_TEXT_INSET;
			CGFloat		startY						= CGRectGetMaxY(self.printableRect) - pageNumSize.height - HEADER_FOOTER_MARGIN_PADDING;
			CGPoint		startPoint					= CGPointMake(startX, startY);

			[pageNumberString drawAtPoint:startPoint withFont:headerFooterFont];
		}
	}
}

@end
