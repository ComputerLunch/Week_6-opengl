#import "ViewController.h"
// IMPORT SQLite
#import "sqlite3.h" 

@interface ViewController (){
    
    NSMutableArray * names;    
}

@end

@implementation ViewController

// Get the array of names back and places them in our names array
static int MyCallback(void * context, int count, char **values, char ** columns)
{    
    NSMutableArray * pointerToNames = (__bridge NSMutableArray * ) context;
    for(int i=0; i < count; i++){
        
        const char *nameCString = values[i];
        [pointerToNames addObject:[NSString stringWithUTF8String:nameCString]];
        NSLog(@"NAME: %@", [NSString stringWithUTF8String:nameCString]);
    }
    return SQLITE_OK;
}
                       
-(void)loadNamesFromDatabase{
    NSString * file = [[NSBundle mainBundle]pathForResource:@"names" ofType:@"db"];
    sqlite3 * database = NULL;
    
    // open database check if returns ok
    if(sqlite3_open([file UTF8String], &database)==SQLITE_OK){
        // execute SQL call on database return array of names
        sqlite3_exec(database, "select name from person", MyCallback, (__bridge void * )names, NULL);
    }
    // Close database
    sqlite3_close(database);
}

- (void)viewDidLoad
{
    [self loadNamesFromDatabase];
    
    [super viewDidLoad];
}

@end
