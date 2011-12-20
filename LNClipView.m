//
//  LNClipView.m
//  LinenClipView
//
//  Created by David Keegan on 10/22/11.
//  Copyright (c) 2011 David Keegan. All rights reserved.
//

#import "LNClipView.h"

static NSImage *LNBackGroundImage = nil;

@implementation LNClipView

+ (void)setBackgroundImage:(NSImage *)image{
    if(LNBackGroundImage == nil){
        LNBackGroundImage = image;
    }
}

+ (void)setupWithScrollView:(NSScrollView *)scrollView{
    id docView = [scrollView documentView];
    LNClipView *clipView = [[LNClipView alloc] initWithFrame:
                            [[scrollView contentView] frame]];
    [scrollView setContentView:clipView];
    [scrollView setDocumentView:docView];
}

- (void)drawRect:(NSRect)dirtyRect{
    [super drawRect:dirtyRect];
    
    [[NSGraphicsContext currentContext] saveGraphicsState];
    [[NSGraphicsContext currentContext] setPatternPhase:
     NSMakePoint(0.0f, NSHeight(self.bounds))];
    
    // pattern
    static NSColor *backgroundColor = nil;   
    if(backgroundColor == nil){
        NSImage *image = LNBackGroundImage;
        if(image == nil){
            image = [NSImage imageNamed:@"Linen"];
        }
        backgroundColor = [NSColor colorWithPatternImage:image];
    }
    [backgroundColor set];
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

//  From http://www.koders.com/objectivec/fidD68502CAF940A73CC1E990AF8A2E3D17ACFCD647.aspx
@implementation LNWebClipView{
    BOOL _haveAdditionalClip;
    NSRect _additionalClip;
}

+ (void)setupWithWebView:(WebView *)webView{
    id docView = [[[webView mainFrame] frameView] documentView];
    NSScrollView *scrollView = (NSScrollView *)[[docView superview] superview];
    LNWebClipView *clipView = [[LNWebClipView alloc] initWithFrame:
                               [[scrollView contentView] frame]];
    [scrollView setContentView:clipView];
    [scrollView setDocumentView:docView];
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

@end
