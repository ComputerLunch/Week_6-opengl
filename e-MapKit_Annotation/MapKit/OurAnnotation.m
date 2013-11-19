#import "OurAnnotation.h"

@implementation OurAnnotation

- (id)initWithTitle:(NSString *)ttl andCoordinate:(CLLocationCoordinate2D)c2d {

	_title = ttl;
	_coordinate = c2d;
  
	return self;
}


@end
