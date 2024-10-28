/**
 * @Auhtor DLY
 *
 */
import axios, { AxiosInstance, AxiosResponse } from '@ohos/axios'


@Entry
@Component
struct Axios {
  build() {
    Column({space: 20}) {
      Text('Axios')
        .fontSize(20)
      Button('直接使用')
        .onClick(async ()=>{
          axios.get('http://jsonplaceholder.typicode.com/users')
            .then((response: AxiosResponse<string>) => {
              //响应结果
              console.log('hm-->response:'+JSON.stringify(response.data))
              //响应状态码
              console.log('hm-->status:'+response.status)
              //响应头部信息
              console.log('hm-->headers:'+JSON.stringify(response.headers))
              //配置信息
              console.log('hm-->config:'+JSON.stringify(response.config))
              //状态文本
              console.log('hm-->statusText:'+JSON.stringify(response.statusText))
              //请求对象
              console.log('hm-->request:'+JSON.stringify(response.request))
              AlertDialog.show({message:JSON.stringify(response.data)})
            })
            .catch((error:Error) => {
              console.log('hm-->error:'+error)
            })

          //异步
          const res:AxiosResponse = await axios.get('http://jsonplaceholder.typicode.com/users')
          console.log('hm-->res:'+JSON.stringify(res.data))

        })

      Button('创建对象使用').onClick(()=>{

        //先创建请求对象
        //可以为请求配置基本信息
        const instance:AxiosInstance = axios.create({
          baseURL: 'http://jsonplaceholder.typicode.com', //请求的url，会和后面的请求组合到一起的
          url: '',                    //请求的路径，自动组合baseURL
          headers: {},                //请求头部
          timeout: 60000,             //等待响应超时时间
          transformRequest: ()=>{},   //在发送请求之前，执行的操作
          transformResponse: (data:AxiosInstance)=>{return JSON.stringify(data)}   //在接收到响应结果，返回出来之前执行的操作
        })


        //等会使用
        //第一个参数：会自动组合baseURL的
        //可以提供第二个参数，请求配置
        //有自己特有的，也可以覆盖基本配置
        instance.get('/users', {
          timeout: 1000
        })
          .then((res:AxiosResponse)=>{
            console.info( JSON.stringify(res.data) )      //响应结果
            console.info( JSON.stringify(res.status) )    //状态码
            console.info( JSON.stringify(res.statusText) )//状态文本
            console.info( JSON.stringify(res.config) )    //配置信息
            console.info( JSON.stringify(res.headers) )   //响应头部
          })

      })

      Button('get请求').onClick(()=>{

        const instance = axios.create({
          baseURL: 'http://jsonplaceholder.typicode.com',  //请求地址,会和后面的组合在一起
          timeout: 1000*60,            //请求超时时间
        })

        // instance.get('/comments?_page=2&_limit=2')
        //   .then((res:AxiosResponse)=>{
        //     console.log('hm-->res80:'+JSON.stringify(res.data))
        //   })

        instance.get('/comments',{
          params:{
            _page:4,
            _limit:3
          }
        })
          .then((res:AxiosResponse)=>{
            console.log('hm-->res90:'+JSON.stringify(res.data))
          })
      })

      Button('post请求').onClick(()=>{
        const instance = axios.create({
          baseURL: 'http://jsonplaceholder.typicode.com',  //请求地址,会和后面的组合在一起
          timeout: 1000*60,            //请求超时时间
        })

        instance.post<object>('/users',{postId:4})
          .then((res:AxiosResponse)=>{
            console.log('hm-->res102:'+JSON.stringify(res.data))
          })
      })



    }
    .width('100%')
    .height('100%')


  }
}
