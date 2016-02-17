#import "NSFancyPanel.h"

@implementation NSFancyPanel

@synthesize controller = _controller;

// PUBLIC INSTANCE METHODS -- OVERRIDES FROM NSWindow

// NSWindow will refuse to become the main window unless it has a title bar.
// Overriding lets us become the main window anyway.
//
- (BOOL)canBecomeMainWindow {
    return YES;
}

// Much like above method.
- (BOOL)canBecomeKeyWindow {
    return YES;
}

// Ask our delegate if it wants to handle keystroke or mouse events before we route them.
- (void)sendEvent:(NSEvent *)theEvent {
    //	Offer mouse-down events (lefty or righty) to the delegate
    if (([theEvent type] == NSLeftMouseDown) || ([theEvent type] == NSRightMouseDown))
        if (!self.controller)
            if ([self.controller handlesMouseDown:theEvent inWindow:self])
                return;

    //	Delegate wasn’t interested, so do the usual routing.
    [super sendEvent:theEvent];
}

@end