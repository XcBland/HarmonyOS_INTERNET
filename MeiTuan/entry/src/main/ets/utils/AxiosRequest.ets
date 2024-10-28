//[第三方：axios封装的工具]
import axios, { AxiosInstance, AxiosResponse } from '@ohos/axios';
import { ValueType } from '@kit.ArkData';

//实例对象可以重复使用

/**
 * axios封装的接口工具类
 */

class AxiosRequest {
  //懒汉模式
  private static instance: AxiosRequest;

  static getInstance(): AxiosRequest {
    if (!AxiosRequest.instance) {
      AxiosRequest.instance = new AxiosRequest();
    }
    return AxiosRequest.instance;
  }

  //私有属性:连接对象
  private ins:AxiosInstance

  //构造函数:初始化连接对象:Next必须为属性初始化，赋值或构造函数初始化
  private constructor() {
    this.ins = axios.create({
      baseURL: 'https://atstudy-1253850831.cos.ap-shanghai.myqcloud.com',
      timeout: 6000,
    })
  }

  /**
   * get请求
   * @param path    请求路径
   * @param params  请求参数:地址栏组合方式 ?a=1&b=2
   * @returns     Promise<AxiosResponse>
   */
  async get(path:string,params:string=''):Promise<AxiosResponse>{
    return await this.ins.get(`${path}?${params}`)
  }

  /**
   * post请求
   * @param path    请求路径
   * @param data    请求参数:字符串格式组合
   * @returns     Promise<AxiosResponse>
   */
  async post(path:string,data:string=''):Promise<AxiosResponse>{
    return await this.ins.post(path,data)
  }

}

export default AxiosRequest;