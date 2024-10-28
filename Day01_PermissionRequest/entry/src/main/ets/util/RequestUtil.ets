//【封装：鸿蒙内置的http请求功能】
//【module.json5,申请：'ohos.permission.INTERNET'】

//导入依赖
import http from '@ohos.net.http'

export default class RequestUtil {
  //请求的域名
  private static readonly URL: string =
    'https://atstudy-1253850831.cos.ap-shanghai.myqcloud.com'

  //静态方法
  static async request(
    path: string , //请求路径
    method: http.RequestMethod = http.RequestMethod.GET, //请求方法: GET, POST, PUT, DELETE
    // headers:object,                                    //请求头:json格式,默认为undefined
    data?: object //请求数据:json格式,默认为undefined
  ): Promise<http.HttpResponse> {

    const httpRequest: http.HttpRequest = http.createHttp()
    const res: http.HttpResponse = await httpRequest.request(
      RequestUtil.URL + path,              //请求地址
      {
        method,
        extraData: data
      }
    )
    httpRequest.destroy()
    return res

  }
}