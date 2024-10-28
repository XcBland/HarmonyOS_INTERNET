//【封装：鸿蒙内置的http请求功能】
//【module.json5,申请：'ohos.permission.INTERNET'】

//导入依赖
import http from '@ohos.net.http'
import { UserInfo } from '../entity/UserInfo'

class RequestUtil {
  //请求的域名
  private static readonly URL: string =
    'https://jsonplaceholder.typicode.com'

  //静态方法
  static async request(
    path: string , //请求路径
    method: http.RequestMethod = http.RequestMethod.GET, //请求方法: GET, POST, PUT, DELETE
    data?: object
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

export {RequestUtil as Request}