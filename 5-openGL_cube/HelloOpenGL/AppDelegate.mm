#import "AppDelegate.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize glView = _glView;


- (void)dealloc
{
    [_glView release];
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]]autorelease];
    // Override point for customization after application launch.
    
    // Make my openGL Layer and place in window
    CGRect screenBounds = [[UIScreen mainScreen]bounds];
    self.glView = [[[OpenGLView alloc]initWithFrame :screenBounds] autorelease];
    [self.window addSubview:_glView];

    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
  
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
   
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
   
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
  
}

- (void)applicationWillTerminate:(UIApplication *)application
{
   
}

@end
