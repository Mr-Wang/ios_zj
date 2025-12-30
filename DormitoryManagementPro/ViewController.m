//
//  ViewController.m
//  DormitoryManagementPro
//
//  Created by 王杨 on 2019/9/3.
//  Copyright © 2019 王杨. All rights reserved.
//

#import "ViewController.h"
#import "LicensePlateTextField.h"
#import "LicensePlateAkeyView.h"

@interface ViewController ()
/** LicensePlateTextField */
@property (nonatomic, strong)  LicensePlateTextField *txtLicensePlate;

/** LicensePlateAkeyView */
@property (nonatomic, strong)  LicensePlateAkeyView *keyView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.txtLicensePlate = [[LicensePlateTextField alloc] initWithFrame:CGRectMake(10, JCNew64, kScreenWidth, kHeight(200))];
    self.keyView = [[LicensePlateAkeyView alloc] initWithFrame:CGRectMake(0, kScreenHeight - kHeight(650), kScreenWidth, kHeight(650))];
    [self.keyView initViewKeysBy:lpkProvince];
    __weak __typeof(self) weakSelf = self;
    
    self.txtLicensePlate.selectedButtonAndVerificationBlock = ^(NSInteger buttonIndex,BOOL isVerification) {
        [weakSelf.keyView setHidden:NO];
        if(buttonIndex == 700) {
            [weakSelf.keyView initViewKeysBy:lpkProvince];
        } else {
            [weakSelf.keyView initViewKeysBy:lpkNumber];
        }
        
        [weakSelf.keyView.btnSubmit setEnabled:isVerification];
        if (isVerification) {
            [weakSelf.keyView.btnSubmit setBackgroundColor:MSColor(1, 187, 112)];
        } else {
            [weakSelf.keyView.btnSubmit setBackgroundColor:[UIColor lightGrayColor]];
        }
    };
    [self.view addSubview:self.txtLicensePlate];
    self.keyView.selectedKeyBlock = ^(NSString * _Nonnull keyStr) {
        [weakSelf.txtLicensePlate addKeysStr:keyStr];
    };
    self.keyView.clearBlock = ^{
        [weakSelf.txtLicensePlate clearKeys];
    };
    self.keyView.btnSubmitBlock = ^{
        NSString *licensePlateStr = [weakSelf.txtLicensePlate extractLicensePlate];
        NSLog(@"%@",licensePlateStr);
        
        [SVProgressHUD showInfoWithStatus:licensePlateStr maskType:SVProgressHUDMaskTypeBlack];
    };
    [self.view addSubview:self.keyView];
}


@end
