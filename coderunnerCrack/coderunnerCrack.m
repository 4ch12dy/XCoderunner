//
//  coderunnerCrack.m
//  coderunnerCrack
//
//  Created by didi on 2018/10/5.
//  Copyright © 2018年 didi. All rights reserved.
//

#import "coderunnerCrack.h"
#import "substitute/substrate.h"
#import <mach-o/dyld.h>

//AAAAA-AAAAA-AAAAA-AAAAA AEAAA-AGHFF-UEDSB-JNBAQ
// https://coderunnerapp.com/api.php?action=register&key=AEAAA-AGHFF-UEDSB-JNBAQ&token=78fb72d900834fff797ec2d85449b6d1031e8c3c5768430d&mac=88e9fe60fc2d

int (*orig_fun)(const char* key);

int replace_fun(const char* key){
    NSString* keyStr = [NSString stringWithUTF8String:key];

    NSLog(@"===xxx===:hook suc key:%@", keyStr);
    return 0x1;
}

int (*orig_fun2)(int a);
int replace_fun2(int a){
    NSLog(@"hook2");
    
    return 0x0;
}

void (*origin_finishLaunching)(id self,SEL cmd);

void new_finishLaunching(id self,SEL cmd){
    NSLog(@"=============finish=========");
}

//static NSData* (*origin_NSURLConnection)(id self,SEL _cmd,id arg1,id arg2, id arg3);
//
//static NSData* new_NSURLConnection(id self,SEL _cmd,id arg1,id arg2, id arg3){
//    NSData* retData = origin_NSURLConnection(self, _cmd, arg1,arg2,arg3);
//
//    id dic = [NSJSONSerialization JSONObjectWithData:retData options:0 error:0];
//    NSData *myData = [NSKeyedArchiver archivedDataWithRootObject:@{@"abe":@"sad"}];
//    NSLog(@"===xxx===:request:%@ retDic:%@", arg1, dic);
//    return myData;
//}

void disableNetwork(){
    
}

static void __attribute__((constructor)) initialize(void) {
    // last address = 0x01001812b0  0x10017f320
    //    _dyld_get_all_image_infos();
    unsigned long  sub_1001812B0 = _dyld_get_image_vmaddr_slide(0) + 0x1001812B0;
    unsigned long  sub_100180AC0 = _dyld_get_image_vmaddr_slide(0) + 0x100180AC0;
    NSLog(@"=====================inject dylib================================");
    MSHookFunction((void*)sub_1001812B0, (void*)&replace_fun, (void**)orig_fun);
    MSHookFunction((void*)sub_100180AC0, (void*)&replace_fun2, (void**)orig_fun2);
    //Application finishLaunching
//    MSHookMessageEx(objc_getClass("Application"), @selector(finishLaunching), (IMP)new_finishLaunching, (IMP*)origin_finishLaunching);
    disableNetwork();
}

//static void __attribute__((constructor)) initialize2(void) {
//    Method initMethod = class_getClassMethod([NSURLConnection class], @selector(sendSynchronousRequest:returningResponse:error:));
//    IMP imp = method_getImplementation(initMethod);
//    NSLog(@"===xxx===:IMP:%p", imp);
//    method_setImplementation(class_getClassMethod(NSClassFromString(@"NSURLConnection"), @selector(sendSynchronousRequest:returningResponse:error:)), (IMP)&new_NSURLConnection);
//}




