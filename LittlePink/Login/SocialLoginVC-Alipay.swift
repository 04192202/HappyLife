//
//  SocialLoginVC-Alipay.swift
//  LittlePink
//
//  Created by 郝义鹏 on 2023/2/14.
//

//import Alamofire
//extension SocialLoginVC{
//    //真无语搞了我三天，这个阿里真难不给配置。沙箱也是没有功能
//
//    // MARK: 1.支付宝登录大体流程:
//    //https://opendocs.alipay.com/open/218/105329
//    //跳至支付宝App或H5页面--用户点同意--我们获得authCode--用authCode跟支付宝换token--获取后可直接登录或继续获取其他信息并登录
//    //可获取支付宝用户的基本开放信息（用户ID、用户头像、昵称、性别、省份、城市等六个字段）
//
//    // MARK: 2.接入准备
//    //https://opendocs.alipay.com/open/218/105326
//
//    // MARK: 3.集成并配置完整版SDK
//    //https://opendocs.alipay.com/open/204/105295
//
//    // MARK: 4.调用接口
//    //https://opendocs.alipay.com/open/218/105325
//
//    //4-1.运行demo--仅需着眼于授权部分
//    //下载地址:https://opendocs.alipay.com/open/54/104509
//    //参照https://opendocs.alipay.com/open/204/105295/中'针对demo的运行'配置demo(APViewController.m中doAPAuth里放入appID,pid,私钥)
//    //运行--收到result={...}和授权结果authcode=...的成功字样
//    //注1.上述打印触发的是APViewController中的auth_V2WithInfo函数的闭包,appdelegate中的是支付时的回调
//    //注2.若已授权此appid对应的app,不会在支付宝app中出现同意授权或拒绝授权的按钮,会出现'您已授权xxxx'的浮框
//
//    //4-2.准备请求
//    //auth_V2方法,带两个大参数(在4-3和4-4中分别准备)
//    func signInWithAlipay(){
//
//
//        //4-3.大参数1:authInfoStr,由两部分组成:infoStr和signedStr,infoStr是常规key-value参数,signedStr是把infoStr加签后的参数
//        //https://opendocs.alipay.com/open/218/105325
//        //https://opendocs.alipay.com/open/218/105327  --根据上面链接中的'授权参数'及此链接准备大参数1
//
//        //4-3-1.大参数1的前半部分
//        //除AppID,PID,target_id之外都为固定值(只需要登录功能时其实无需这么多参数--参考极简版SDK)
//        let infoStr = "apiname=com.alipay.account.auth&app_id=\(kAliPayAppID)&app_name=mc&auth_type=AUTHACCOUNT&biz_type=openservice&method=alipay.open.auth.sdk.code.get&pid=\(kAliPayPID)&product_id=APP_FAST_LOGIN&scope=kuaijie&sign_type=RSA2&target_id=20210122"
//
//        //4-3-2.大参数1的后半部分
//        //实际开发需在服务端sign(加签)(因privateKey放客户端风险很大),然后传回客户端--这里是为了演示而在客户端搞
//        //参照https://opendocs.alipay.com/open/204/105295/#%E9%92%88%E5%AF%B9Demo%E7%9A%84%E8%BF%90%E8%A1%8C%E6%B3%A8%E6%84%8F
//        //需拖入官方demo中的：
//        //1.Util和openssl两个文件夹
//        //2.libcrypto.a和libssl.a两个静态库
//        //防踩坑：可在项目根目录创建一个文件夹，如AliSDKDemo，然后拖进去，并在target中的“Header Search Paths”增加头文件路径
//        guard let signer = APRSASigner(privateKey: kAlipayPrivateKey),
//              let signedStr = signer.sign(infoStr, withRSA2: true) else { return }
//
//        //4-3-3.拼接成大参数1
//        let authInfoStr = "\(infoStr)&sign=\(signedStr)"
//        //print(authInfoStr)
//
//        //4-4.大参数2:appScheme--授权完可自动跳转回本app
//
//        //4-5.发起支付宝登录请求
//        AlipaySDK.defaultService()?.auth_V2(withInfo: authInfoStr, fromScheme: kAppScheme){ res in
//            guard let res = res else { return }
//
//            //4-6.解析并获取到authCode(授权码)
//            let resStatus = res["resultStatus"] as! String
//            if resStatus == "9000"{
//
//                //"success=true&result_code=200&app_id=2021002125697028&auth_code=38a00948f8054d1ab524d54c295eOE38&scope=kuaijie&alipay_open_id=20881060561109412929791310613838&user_id=2088002401295380&target_id=20210122"
//                let resStr = res["result"] as! String
//
//                //["success=true","result_code=200","auth_code=xxx",...]
//                let resArr = resStr.components(separatedBy: "&")
//
//                for subRes in resArr{
//                    //subRes长这样:"result_code=200","auth_code=xxx",等等
//                    //此处也可用上面的components方法,根据等于号分离成数组,这里使用区间运算符方法
//                    let equalIndex = subRes.firstIndex(of: "=")! //等于号的index
//                    let equalEndIndex = subRes.index(after: equalIndex) //等于号后面一个字符的index
//                    //let prefix = subRes[..<equalIndex] //半开区间-取出等于号前面的内容
//                    let suffix = subRes[equalEndIndex...] //闭区间-取出等于号后面的内容
//                    //print("\(prefix):\(suffix)")
//
//                    //看当前字符串是否有auth_code前缀,若有则取出当前字符串等于号后面的内容,即为authCode
//                    //大家可用此法同样取出result_code,并处理登录失败时候的情况
//                    if subRes.hasPrefix("auth_code"){
//                        print("authCode = \(suffix)")
//
//                        //4-7.拿authCode去和支付宝换token(访问令牌和更新令牌)
//                        //self.getToken(String(suffix))
//                    }
//                }
//            }
//        }
//    }
//}
//// MARK: - 服务端操作 - Demo
//extension SocialLoginVC{
//    private func getToken(_ authCode: String){
//        //https://opendocs.alipay.com/apis/api_9/alipay.system.oauth.token
//        //请求示例:https://openapi.alipay.com/gateway.do?timestamp=2013-01-01 08:08:08&method=alipay.system.oauth.token&app_id=4472&sign_type=RSA2&sign=ERITJKEIJKJHKKKKKKKHJEREEEEEEEEEEE&version=1.0&charset=GBK&grant_type=authorization_code&code=4b203fe6c11548bcabd8da5bb087a83b
//
//        let parameters = [
//            "timestamp": Date().format(with: "yyyy-MM-dd HH:mm:ss"),
//            "method": "alipay.system.oauth.token",
//            "app_id": kAliPayAppID,
//            "sign_type": "RSA2",
//            "version": "1.0",
//            "charset": "utf-8",
//            "grant_type": "authorization_code",
//            "code": authCode
//        ]
//        AF.request("https://openapi.alipay.com/gateway.do", parameters: self.signedParameters(parameters)).responseDecodable(of: TokenResponse.self) { response in
//            if let tokenResponse = response.value{
//                let accessToken = tokenResponse.alipay_system_oauth_token_response.access_token
//                //4-7.拿accessToken去和支付宝换用户信息
//                self.getInfo(accessToken)
//            }
//        }
//    }
//
//    private func getInfo(_ accessToken: String){
//        //https://opendocs.alipay.com/apis/api_2/alipay.user.info.share
//        //请求示例:https://openapi.alipay.com/gateway.do?timestamp=2013-01-01 08:08:08&method=alipay.user.info.share&app_id=18344&sign_type=RSA2&sign=ERITJKEIJKJHKKKKKKKHJEREEEEEEEEEEE&version=1.0&charset=GBK&auth_token=20130319e9b8d53d09034da8998caefa756c4006
//        let parameters = [
//            "timestamp": Date().format(with: "yyyy-MM-dd HH:mm:ss"),
//            "method": "alipay.user.info.share",
//            "app_id": kAliPayAppID,
//            "sign_type": "RSA2",
//            "version": "1.0",
//            "charset": "utf-8",
//            "auth_token": accessToken
//        ]
//        AF.request("https://openapi.alipay.com/gateway.do", parameters: self.signedParameters(parameters)).responseDecodable(of: InfoShareResponse.self){response in
//            if let infoShareResponse = response.value{
//                let info = infoShareResponse.alipay_user_info_share_response
//                print(info.nick_name, info.avatar, info.gender)
//                print(info.province, info.city)
//            }
//        }
//    }
//}
//
//// MARK: - 辅助函数
//extension SocialLoginVC{
//    private func signedParameters(_ parameters: [String: String]) -> [String: String]{
//        var signedParameters = parameters
//
//        //map+sorted后变成:["sign_type=RSA2","version=1.0"]
//        //joined后变成:"sign_type=RSA2&version=1.0"
//        let urlParameters = parameters.map{ "\($0)=\($1)" }.sorted().joined(separator: "&")
//        guard let signer = APRSASigner(privateKey: kAlipayPrivateKey),
//              let signedStr = signer.sign(urlParameters, withRSA2: true) else {
//            fatalError("加签失败")
//        }
//        signedParameters["sign"] = signedStr.removingPercentEncoding ?? signedStr
//
//        return signedParameters
//    }
//}
//
//// MARK: - DataModel
//extension SocialLoginVC{
//    struct TokenResponse: Decodable {
//        let alipay_system_oauth_token_response: TokenResponseInfo
//
//        struct TokenResponseInfo: Decodable{
//            let access_token: String
//        }
//    }
//
//    struct InfoShareResponse: Decodable {
//        let alipay_user_info_share_response: InfoShareResponseInfo
//        struct InfoShareResponseInfo: Decodable {
//            let avatar: String
//            let nick_name: String
//            let gender: String
//            let province: String
//            let city: String
//        }
//    }
//}
//
