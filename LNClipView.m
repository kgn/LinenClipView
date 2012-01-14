//
//  LNClipView.m
//  LinenClipView
//
//  Created by David Keegan on 10/22/11.
//  Copyright (c) 2011 David Keegan. All rights reserved.
//

#import "LNClipView.h"

#define LN_RUNNING_LION (floor(NSAppKitVersionNumber) > NSAppKitVersionNumber10_6)

@interface LNClipView : NSClipView
@property (nonatomic, strong) NSColor *pattern;
@end

@implementation LNClipView

@synthesize pattern = _pattern;

- (void)drawRect:(NSRect)dirtyRect{
    [super drawRect:dirtyRect];
    
    [[NSGraphicsContext currentContext] saveGraphicsState];
    [[NSGraphicsContext currentContext] setPatternPhase:
     NSMakePoint(0.0f, NSHeight(self.bounds))];
    
    // pattern
    [self.pattern set];
    NSRectFill(self.bounds);
    
    // shadow
    static NSGradient *gradient = nil;
    if(gradient == nil){
        gradient = [[NSGradient alloc] initWithStartingColor:
                    [NSColor colorWithDeviceWhite:0.0f alpha:0.2f]
                                                 endingColor:[NSColor clearColor]];
    }
    
    NSRect gradientRect = self.bounds;
    gradientRect.size.height = 8.0f;
    if(NSMinY(self.bounds) < 0.0f){
        gradientRect.origin.y += -NSMinY(self.bounds)-NSHeight(gradientRect);
        [gradient drawInRect:gradientRect angle:-90.0f];
    }else if(NSMinY(self.bounds) > 1.0f){
        NSRect docRect = [[(NSScrollView *)[self superview] documentView] frame];
        CGFloat yOffset = NSHeight(self.bounds)-(NSHeight(docRect)-NSMinY(self.bounds));
        gradientRect.origin.y += NSHeight(self.bounds)-yOffset;
        [gradient drawInRect:gradientRect angle:90.0f];
    }
    
    [[NSGraphicsContext currentContext] restoreGraphicsState];
}

@end

@implementation LNScrollView{
    LNClipView *_clipView;
}

- (void)setup{
    if(LN_RUNNING_LION){
        id docView = [self documentView];
        _clipView = [[LNClipView alloc] initWithFrame:
                     [[self contentView] frame]];
        [self setContentView:_clipView];
        [self setDocumentView:docView];
    }
}

- (id)initWithFrame:(NSRect)frameRect{
    if((self = [super initWithFrame:frameRect])){
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder{
    if((self = [super initWithCoder:coder])){
        [self setup];
    }
    return self;
}

// this is the cure to fix the scrollers
// From https://gist.github.com/1608395
- (NSView *)hitTest:(NSPoint)aPoint{
    if(!LN_RUNNING_LION){
        return [super hitTest:aPoint];
    }
    
    NSEvent * currentEvent = [NSApp currentEvent];
    if([currentEvent type] == NSLeftMouseDown){
        // if we have a vertical scroller and it accepts the current hit
        if([self hasVerticalScroller] && [[self verticalScroller] hitTest:aPoint] != nil){
            [[self verticalScroller] mouseDown:currentEvent];
            return nil;
        }
        // if we have a horizontal scroller and it accepts the current hit
        if([self hasVerticalScroller] && [[self horizontalScroller] hitTest:aPoint] != nil){
            [[self horizontalScroller] mouseDown:currentEvent];
            return nil;
        }
    }else if([currentEvent type] == NSLeftMouseUp){
        // if mouse up, just tell both our scrollers we have moused up
        if([self hasVerticalScroller]){
            [[self verticalScroller] mouseUp:currentEvent];
        }
        if([self hasHorizontalScroller]){
            [[self horizontalScroller] mouseUp:currentEvent];
        }
        return self;
    }
    
    return [super hitTest:aPoint];
}

- (void)setPattern:(NSImage *)pattern{
    _clipView.pattern = [NSColor colorWithPatternImage:pattern];
    [_clipView setNeedsDisplay:YES];    
}

@end

//  From http://www.koders.com/objectivec/fid22DEE7EA2343C20D0FEEC2C079245069DF3E32A5.aspx
@interface LNWebClipView : LNClipView
- (void)setAdditionalClip:(NSRect)additionalClip;
- (void)resetAdditionalClip;
- (BOOL)hasAdditionalClip;
- (NSRect)additionalClip;
@end

//  From http://www.koders.com/objectivec/fidD68502CAF940A73CC1E990AF8A2E3D17ACFCD647.aspx
@implementation LNWebClipView{
    BOOL _haveAdditionalClip;
    NSRect _additionalClip;
}

- (id)initWithFrame:(NSRect)frame{
    if(!(self = [super initWithFrame:frame])){
        return nil;
    }
    
    // In WebHTMLView, we set a clip. This is not typical to do in an
    // NSView, and while correct for any one invocation of drawRect:,
    // it causes some bad problems if that clip is cached between calls.
    // The cached graphics state, which clip views keep around, does
    // cache the clip in this undesirable way. Consequently, we want to 
    // release the GState for all clip views for all views contained in 
    // a WebHTMLView. Here we do it for subframes, which use WebClipView.
    // See these bugs for more information:
    // <rdar://problem/3409315>: REGRESSSION (7B58-7B60)?: Safari draws blank frames on macosx.apple.com perf page
    [self releaseGState];
    
    return self;
}

- (void)resetAdditionalClip{
    _haveAdditionalClip = NO;
}

- (void)setAdditionalClip:(NSRect)additionalClip{
    _haveAdditionalClip = YES;
    _additionalClip = additionalClip;
}

- (BOOL)hasAdditionalClip{
    return _haveAdditionalClip;
}

- (NSRect)additionalClip{
    return _additionalClip;
}

//- (NSRect)_focusRingVisibleRect{
//    NSRect rect = [self visibleRect];
//    if (_haveAdditionalClip) {
//        rect = NSIntersectionRect(rect, _additionalClip);
//    }
//    return rect;
//}
//
//- (void)scrollWheel:(NSEvent *)event{
//    NSView *docView = [self documentView];
//    if ([docView respondsToSelector:@selector(_webView)]) {
//        WebView *wv = [docView _webView];
//        if ([wv _dashboardBehavior:WebDashboardBehaviorAllowWheelScrolling]) {
//            [super scrollWheel:event];
//        }
//        return;
//    }
//    [super scrollWheel:event];
//}

// From https://gist.github.com/b6bcb09a9fc0e9557c27
- (NSView *)hitTest:(NSPoint)aPoint{
    if(!LN_RUNNING_LION){
        return [super hitTest:aPoint];
    }
    
    NSEvent *currentEvent = [NSApp currentEvent];
    NSScrollView *scrollView = (NSScrollView *)[self superview];
    if([currentEvent type] == NSLeftMouseDown){
        // if we have a vertical scroller and it accepts the current hit
        if([scrollView hasVerticalScroller] && [[scrollView verticalScroller] hitTest:aPoint] != nil){
            [[scrollView verticalScroller] mouseDown:currentEvent];
        }
        // if we have a horizontal scroller and it accepts the current hit
        if([scrollView hasVerticalScroller] && [[scrollView horizontalScroller] hitTest:aPoint] != nil){
            [[scrollView horizontalScroller] mouseDown:currentEvent];
        }
    }
    
    return [super hitTest:aPoint];
}

@end

@implementation LNWebView{
    LNWebClipView *_clipView;
}

- (void)setup{
    if(LN_RUNNING_LION){    
        id docView = [[[self mainFrame] frameView] documentView];
        NSScrollView *scrollView = (NSScrollView *)[[docView superview] superview];
        _clipView = [[LNWebClipView alloc] initWithFrame:[[scrollView contentView] frame]];
        [scrollView setContentView:_clipView];
        [scrollView setDocumentView:docView];
    }
}

- (id)initWithFrame:(NSRect)frameRect{
    if((self = [super initWithFrame:frameRect])){
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder{
    if((self = [super initWithCoder:coder])){
        [self setup];
    }
    return self;
}

- (void)setPattern:(NSImage *)pattern{
    _clipView.pattern = [NSColor colorWithPatternImage:pattern];
    [_clipView setNeedsDisplay:YES];
}

@end
