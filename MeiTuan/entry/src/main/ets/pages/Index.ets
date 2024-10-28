/**
 * 【项目案例：美团+购物车+客服】
 * 1、 组件模式开发，状态管理使用
 * 2、 接口请求：异步的ajax技术，内置http，第三方axios都是用
 * 3、 本地化数据处理
 * 4、 Next版本的类型约束，数据模型，功能等
 * 前置：
 *     1、资源图片放入指定目录：media/
 *     2、安装第三方模块axios：命令或配置文件都可以
 *     >ohpm install @ohos/axios
 * 申请网络权限：
 *     ’ohos.permission.INTERNET‘
 *
 */
import BottomComp from '../components/BottomComp'
import CartComp from '../components/CartComp'

//购物车功能
//    推广阶段:推荐不登陆也可以本地操作,下单后判断是否登录
//    正式阶段:可以强制性先登录
//    依据: Appstorage中是否有用户信息
//我们的案例,属于推广阶段,可以不登陆记录购物车:首选项




import MainComp from '../components/MainComp'
import { CartItem } from '../entity/CartItem'
import { Category } from '../entity/FoodAndCategory'
import { CartModel } from '../model/CartModel'
import { MeiTuanModel } from '../model/MeiTuanModel'



@Entry
@Component
struct Index {

  // 声明状态变量
  @State showCart:boolean = false             //是否显示购物车
  @State categoryList:Category[] = []          //美团分类列表
  @Provide cartList:CartItem[] = []            //购物车商品列表
  //私有属性
  private mtModel:MeiTuanModel = MeiTuanModel.getInstance()    //美团模型
  private cartModel:CartModel = CartModel.getInstance()        //购物车模型


  // 生命周期函数
  aboutToAppear() {
    this.mtModel.getCategoryList()  //获取美团分类列表
      .then((res:Category[]) => {
        this.categoryList = res
      })
      .catch((err:Error) => {
        console.error(JSON.stringify(err))
      })
    this.cartModel.getCartList()    //获取购物车商品列表
      .then((res:CartItem[]) => {
        this.cartList = res
      })
      .catch((err:Error) => {
        console.error(JSON.stringify(err))
      })
  }
  build() {
    Stack({alignContent:Alignment.Bottom}){

      //主体
      MainComp({list:this.categoryList})
        .layoutWeight(1)

      //购物车组件列表
      if(this.showCart){
        CartComp({showCart:this.showCart})
      }
      //底部组件
      BottomComp({showCart:this.showCart})

    }
  }
}