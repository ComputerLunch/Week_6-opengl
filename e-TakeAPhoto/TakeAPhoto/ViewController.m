#import "ViewController.h"

@interface ViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>{
    
    
    UIImageView *imageView;
    UIButton *takePictureButton;
    UIButton *selectFromCameraRollButton;
    UIButton *saveAPhoto;
}

-(void)getCameraPicture:(id)sender;
-(void)selectExitingPicture;

@end


@implementation ViewController

- (void)viewDidLoad
{
    // add image
    imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    imageView.backgroundColor = [UIColor blueColor];
    [self.view addSubview:imageView];
    
    // Take a photo button
    takePictureButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    takePictureButton.frame = CGRectMake(0, 280, 160, 100);
    [takePictureButton setTitle:@"Take a Photo" forState:UIControlStateNormal];
    [takePictureButton addTarget:nil action:@selector(getCameraPicture:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:takePictureButton];
    
    // Pick a photo from the library
    selectFromCameraRollButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    selectFromCameraRollButton.frame = CGRectMake(160, 280, 160, 100);
    [selectFromCameraRollButton setTitle:@"Pick a Photo" forState:UIControlStateNormal];
    [selectFromCameraRollButton addTarget:nil action:@selector(selectExitingPicture) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:selectFromCameraRollButton];
    
    // Save a Photo
    saveAPhoto = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    saveAPhoto.frame = CGRectMake(0, 380, 320, 80);
    [saveAPhoto setTitle:@"Save Photo" forState:UIControlStateNormal];
    [saveAPhoto addTarget:nil action:@selector(saveAPhoto) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveAPhoto];
}

//------------------------

-(void)getCameraPicture:(id)sender
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    /*picker.sourceType = sender == takePictureButton ?    UIImagePickerControllerSourceTypeCamera :
    UIImagePickerControllerSourceTypeSavedPhotosAlbum; */
    
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentModalViewController: picker animated:YES];
}


-(void)selectExitingPicture
{
    if([UIImagePickerController isSourceTypeAvailable:
UIImagePickerControllerSourceTypePhotoLibrary])
    {
        UIImagePickerController *picker= [[UIImagePickerController alloc]init];
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentModalViewController:picker animated:YES];
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker
      didFinishPickingImage : (UIImage *)image
                 editingInfo:(NSDictionary *)editingInfo
{
    
    imageView.image = image;
    [picker dismissModalViewControllerAnimated:YES];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)  picker
{
    [picker dismissModalViewControllerAnimated:YES];
}

//Save a photo -------------
-(void)saveAPhoto{

    // Request to save the image to camera roll
    UIImageWriteToSavedPhotosAlbum(imageView.image, self, 
                                   @selector(image:didFinishSavingWithError:contextInfo:), nil);

}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error 
  contextInfo:(void *)contextInfo
{
    // Was there an error?
    if (error != NULL)
    {
        // Show error message...
        
    }
    else  // No errors
    {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Photo Saved" 
                                                        message:@"Great Job!" 
                                                       delegate:nil 
                                              cancelButtonTitle:@"OK" otherButtonTitles:nil];    
        [alert show];    
    }
}

@end
