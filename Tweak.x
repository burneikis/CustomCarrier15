#import <Foundation/Foundation.h>

BOOL isCarrier(NSString *string) {
	if ([string rangeOfString:@":"].location != NSNotFound) {
		return NO;
	}
	if (string.length <= 2) {
		return NO;
	}
	return YES;
}

%hook _UIStatusBarStringView

-(void)setText:(NSString *)text {
	if (isCarrier(text)) {
		%orig(@"Test");
	} else {
		%orig(text);
	}
}

%end
