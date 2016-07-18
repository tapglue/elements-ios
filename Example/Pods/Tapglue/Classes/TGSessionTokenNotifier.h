#import <Foundation/Foundation.h>

@protocol TGSessionTokenNotifier <NSObject>

-(void)sessionTokenSet:(NSString*)token;

@end