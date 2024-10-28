//[美团数据及功能模块]
//这里采用混合定义方式,既有类型约束定义,又有功能模块定义
import { AxiosResponse } from "@ohos/axios"
import { Category } from "../entity/FoodAndCategory"
import AxiosRequest from "../utils/AxiosRequest"

/**
 * 美团的功能模块
 */
export class MeiTuanModel {
  //私有属性
  private static instance: MeiTuanModel
  //构造函数
  private constructor() {}
  static getInstance(): MeiTuanModel {
    if (!MeiTuanModel.instance) {
      MeiTuanModel.instance = new MeiTuanModel()
    }
    return MeiTuanModel.instance
  }
  private axios:AxiosRequest = AxiosRequest.getInstance()

  /**
   * 获取美团分类列表
   * @returns   Category[] 分类列表
   */
  async getCategoryList():Promise<Category[]>{
    //调用接口,获取响应结果
    const res:AxiosResponse = await this.axios.get('/lab-d3/harmonyOS/meituan/foods.json')
    //提取数据:(axios自动识别转换json的,现在对应好类型约束)
    return res.data as Category[]
  }
}