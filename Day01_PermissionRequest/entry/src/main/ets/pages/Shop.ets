//商店页面
import RequestUtil from '../util/RequestUtil'
import {ShopInfo} from '../model/ShopInfo'
import { ShopComp } from '../compoenets/ShopComp'

@Entry
@Component
struct Shop {
  //状态：    list:Array<ShopInfo> = []
  @State list:ShopInfo[] = []
  aboutToAppear(){
    RequestUtil.request('/lab-d3/harmonyOS/meituan/shop.json').then(response =>{
      //接口返回的是一个json文件
      //文件中，都是字符，归为，换行：ASCII码10,13,转义符号：\r,\n,\t
      //先把文件变字符串，然后转json对象
      //最后可以as匹配类型转换：可以缺省
      console.log('hm-->response.result'+response.result.toString())
      this.list = JSON.parse(response.result.toString()) as ShopInfo[]
    })
  }
  build() {
    List({space:20}) {
      ListItem(){
        Text('喜茶')
          .fontSize(30)
          .fontWeight(700)
          .fontColor('#fcc')
          .width('100%')
          .textAlign(TextAlign.Center)
      }
       .width('100%')
      ForEach(this.list,(item:ShopInfo,index)=>{
        ListItem(){
          ShopComp({item})
        }
        .width('100%')
      })
    }
    .width('100%')
    .height('100%')


  }
}