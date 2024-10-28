//[module.json5,申请：'ohos.permission.INTERNET']
import http from '@ohos.net.http';
import RequestUtil from '../util/RequestUtil';

@Entry
@Component
struct Index {
  @State message: string = 'Hello World';

  build() {
    Row(){
      Column({space: 20}) {
        Text(this.message)
          .fontSize(30)
          .fontWeight(FontWeight.Bold)
          .textAlign(TextAlign.Center)
          .margin({top: 100})
        Button('请求网络').onClick(async ()=>{
          //创建网络请求对象
          const httpReq:http.HttpRequest = http.createHttp()
          //订阅：头部
          //可以通过回调函数知道请求头部信息
          httpReq.on('headersReceive', (headers)=>{
            console.log('hm-->headers:', JSON.stringify(headers))
          })
          //鸿蒙推荐异步操作，方法默认是异步的
          //路径是必填项，请求参数是可选的，回调函数是可选的
          //httpReq.request('www.atstudy.com',{},()=>{})

          //支持同步
          try{
            const result:http.HttpResponse = await httpReq.request('https://atstudy-1253850831.cos.ap-shanghai.myqcloud.com/lab-d3/harmonyOS/meituan/shop.json',
              {
                method:http.RequestMethod.GET,
                connectTimeout:60*1000,
                // header:{
                //   'Content-Type':'application/json',
                //   'Authorization':'Bearer <KEY>',
                //   'User-Agent':'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/87.0.4280.88 Safari/537.36'
                // }
              })
            AlertDialog.show({message: '请求成功！'+result.result.toString()+' '+result.responseCode.toString()+', '+JSON.stringify(result.header)})
            console.log('hm-->result:', JSON.stringify(result))
            console.log('hm-->result.header:', JSON.stringify(result.header))
            console.log('hm-->result.result:', JSON.stringify(result.result))
            console.log('hm-->result.responseCode:', JSON.stringify(result.responseCode))
            httpReq.destroy()
          }catch(e){
            console.log('hm-->error:', JSON.stringify(e))
          }
        })
        Button('工具请求').onClick(()=>{
          //工具请求
          const res = RequestUtil.request('/lab-d3/harmonyOS/meituan/shop.json')
          console.log('hm-->res:',JSON.stringify(res))
        })
      }.width('100%')
    }
    .height('100%')
    .width('100%')
  }
}